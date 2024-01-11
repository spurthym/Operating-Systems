/* This file contains code for a generic page fault handler for processes. */
#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "elf.h"

#include "sleeplock.h"
#include "fs.h"
#include "buf.h"

#define MAX_TIME_FOR_WSA 5

int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz);
int flags2perm(int flags);

/* CSE 536: (2.4) read current time. */
uint64 read_current_timestamp() {
  uint64 curticks = 0;
  acquire(&tickslock);
  curticks = ticks;
  wakeup(&ticks);
  release(&tickslock);
  return curticks;
}

bool psa_tracker[PSASIZE];

/* All blocks are free during initialization. */
void init_psa_regions(void)
{
    for (int i = 0; i < PSASIZE; i++) 
        psa_tracker[i] = false;
}

// set the psa block as false
void free_psa_block(int x){
    psa_tracker[x] = false;
}

// find a free psa block
int find_free_block() 
{
    int free_block_index = -1;
    for(int i = 0; i < PSASIZE; i+=4){
        if(!psa_tracker[i]) {
            free_block_index = i;
            break;
        }
    }
    psa_tracker[free_block_index] = true;
    return free_block_index;
}

int find_victim_using_fifo(struct proc* p) {
    uint64 first_loaded_heap_time = 0;
    uint64 current_time = read_current_timestamp();
    int first_loaded_heap_index = -1;

    for(int i = 0; i < MAXHEAP; i++){
        if(p->heap_tracker[i].loaded == true){
            uint64 time_diff = current_time - p->heap_tracker[i].last_load_time;
            if(first_loaded_heap_index == -1 || time_diff > first_loaded_heap_time) {
                first_loaded_heap_index = i;
                first_loaded_heap_time = time_diff;
            }
        }
    }
    return first_loaded_heap_index;
}

/* Evict heap page to disk when resident pages exceed limit */
void evict_page_to_disk(struct proc* p) {
    /* Find free block */
    int blockno = find_free_block();

    /* Find victim page using FIFO. */
    int first_loaded_heap_index = find_victim_using_fifo(p);

    /* Print statement. */
    print_evict_page(p->heap_tracker[first_loaded_heap_index].addr, blockno);

    /* Read memory from the user to kernel memory first. */
    char *kernel_mem = kalloc();
    if(copyin(p->pagetable, kernel_mem, p->heap_tracker[first_loaded_heap_index].addr, PGSIZE) != 0){
        exit(-1);
        return;
    }

    
    /* Write to the disk blocks. Below is a template as to how this works. There is
     * definitely a better way but this works for now. :p */
    struct buf* b;
    for(int i = 0; i < 4; i++){
        b = bread(1, PSASTART+(blockno + i));

        // Copy page contents to b.data using memmove.
        memmove(b->data, (const void*)(kernel_mem + (i * 1024)), 1024);

        bwrite(b);
        brelse(b);
    }
    
    /* Unmap swapped out page */
    uvmunmap(p->pagetable, p->heap_tracker[first_loaded_heap_index].addr, 1, 1);
    kfree(kernel_mem);

    /* Update the resident heap tracker. */
    p->resident_heap_pages--;
    p->heap_tracker[first_loaded_heap_index].loaded = false;
    p->heap_tracker[first_loaded_heap_index].startblock = blockno;
}

/* Retrieve faulted page from disk. */
void retrieve_page_from_disk(struct proc* p, uint64 uvaddr) {
    /* Find where the page is located in disk */
    uint64 page_base_addr = PGROUNDDOWN(uvaddr);
    int heap_index = -1;
    for(int i=0; i < MAXHEAP; i++){
        if(p->heap_tracker[i].addr == page_base_addr){
           heap_index = i;
            break;
        }
    }

    int block_no = p->heap_tracker[heap_index].startblock;
    /* Print statement. */
    print_retrieve_page(page_base_addr, block_no);

    /* Create a kernel page to read memory temporarily into first. */
    char *kernel_mem = kalloc();
    
    /* Read the disk block into temp kernel page. */
    struct buf* b;
    for(int i = 0; i < 4; i++){
        b = bread(1, PSASTART+(block_no + i));

        // Copy b.data to page contents  using memmove.
        memmove((kernel_mem + (i * 1024)), (const void*)(b->data), 1024);
    }

    /* Copy from temp kernel page to uvaddr (use copyout) */
    if(copyout(p->pagetable, page_base_addr, kernel_mem, PGSIZE) != 0){
        exit(-1);
        return;
    }
    kfree(kernel_mem);
    psa_tracker[block_no] = false;
    return;
}


void page_fault_handler(void) 
{
    /* Current process struct */
    struct proc *p = myproc();

    /* Track whether the heap page should be brought back from disk or not. */
    bool load_from_disk = false;

    /* Find faulting address. */
    uint64 faulting_addr = r_stval();
    uint64 page_base_addr = PGROUNDDOWN(faulting_addr);
    print_page_fault(p->name, page_base_addr);

    /* Check if the fault address is a heap page. Use p->heap_tracker */
    bool is_heap_page = false;
    int heappage_index = -1;
    for(int i=0; i < MAXHEAP; i++){
        if(p->heap_tracker[i].addr == page_base_addr){
            is_heap_page = true;
            heappage_index = i;
            if (p->heap_tracker[i].startblock != -1) {
                load_from_disk = true;
            }
            break;
        }
    }
    if (is_heap_page) {
        goto heap_handle;
    }
    // printf("not heap\n");
    /* If it came here, it is a page from the program binary that we must load. */
    // print_load_seg(faulting_addr, 0, 0);

    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    uint64 sz = page_base_addr;
    begin_op();
    if((ip = namei(p->name)) == 0){
        end_op();
        goto bad;
    }

    ilock(ip);
    if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
        goto bad;
    for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
        if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
            goto bad;
        if(ph.type != ELF_PROG_LOAD)
            continue;
        if(ph.vaddr == sz) {
            if(uvmalloc(p->pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags)) == 0)
                goto bad;
            if(loadseg(p->pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
                goto bad;

            print_load_seg(page_base_addr, ph.vaddr + ph.off, ph.memsz);  
        }
          
    }

    iunlockput(ip);
    end_op();

    /* Go to out, since the remainder of this code is for the heap. */
    goto out;

heap_handle:
    /* 2.4: Check if resident pages are more than heap pages. If yes, evict. */
    if (p->resident_heap_pages == MAXRESHEAP) {
        evict_page_to_disk(p);
    }

    /* 2.3: Map a heap page into the process' address space. (Hint: check growproc) */
    if(load_from_disk == false){
        if((uvmalloc(p->pagetable, p->heap_tracker[heappage_index].addr, p->heap_tracker[heappage_index].addr + PGSIZE, PTE_W)) == 0) {
            return;
        }
    }
    
    /* 2.4: Update the last load time for the loaded heap page in p->heap_tracker. */
    p->heap_tracker[heappage_index].loaded = true;
    p->heap_tracker[heappage_index].last_load_time = read_current_timestamp();

    /* 2.4: Heap page was swapped to disk previously. We must load it from disk. */
    if (load_from_disk) {
        retrieve_page_from_disk(p, faulting_addr);
    }

    /* Track that another heap page has been brought into memory. */
    p->resident_heap_pages++;

out:
    /* Flush stale page table entries. This is important to always do. */
    sfence_vma();
    return;

bad:
    setkilled(p);
    exit(-1);
    return;    
}
/* CSE 536: User-Level Threading Library */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include "user/ulthread.h"

/* Standard definitions */
#include <stdbool.h>
#include <stddef.h>
// #include "ulthread.h"

int selected_sch_algo;

struct thrd *current_thread, *scheduler_thread;

int next_tid;

int num_thrds;

struct thrd all_threads[MAXULTHREADS];

struct t_queue *t_head_queue, *current_queue_element;

struct t_queue {
    int t_index;
    struct t_queue* next;
    int priority;
};

/* Get thread ID */
int get_current_tid(void) {
    return current_thread->tid;
}

/* Thread initialization */
void ulthread_init(int schedalgo) {
    next_tid = 0;
    selected_sch_algo = schedalgo;
    num_thrds = 0;
    scheduler_thread = &all_threads[0];
    scheduler_thread->state = RUNNING;
    scheduler_thread->tid = next_tid;
    next_tid += 1;
    for(int i = 1; i < MAXULTHREADS; i++){
        all_threads[i].state = FREE;
    }

    t_head_queue = NULL;
    current_queue_element = NULL;
}

/* Thread creation */
bool ulthread_create(uint64 start, uint64 stack, uint64 args[], int priority) {
    /* Please add thread-id instead of '0' here. */

    int free_thread_index = -1;
    for(int i = 0; i < MAXULTHREADS; i++){
        if(all_threads[i].state == FREE) {
            free_thread_index = i;
            break;
        }
    }

    if(free_thread_index == -1){
        return false;
    }

    struct thrd *new_thrd = &all_threads[free_thread_index];

    uint64 sp = stack;

    new_thrd->state = RUNNABLE;

    memset(&new_thrd->context, 0, sizeof(new_thrd->context));

    for(int i = 0; i < 6; i++){
        if(i==0) new_thrd->context.a0 = args[i];
        else if(i==1) new_thrd->context.a1 = args[i];
        else if(i==2) new_thrd->context.a2 = args[i];
        else if(i==3) new_thrd->context.a3 = args[i];
        else if(i==4) new_thrd->context.a4 = args[i];
        else if(i==5) new_thrd->context.a5 = args[i];
        else if(i==6) new_thrd->context.a6 = args[i];
    }

    if(new_thrd->tid == 0){
        new_thrd->tid = next_tid;
        next_tid += 1;
    }

    new_thrd->t_priority = priority;

    new_thrd->context.ra = start;
    new_thrd->context.sp = stack;

    printf("[*] ultcreate(tid: %d, ra: %p, sp: %p)\n", new_thrd->tid, start, stack);

    num_thrds++;
   
    if(selected_sch_algo == PRIORITY) {
        struct t_queue* new_queue_el_3 = (struct t_queue*)malloc(sizeof(struct t_queue));
        new_queue_el_3->t_index = free_thread_index;
        new_queue_el_3->priority = priority;
        if(t_head_queue == NULL) {
            t_head_queue = new_queue_el_3;
        } else {
            struct t_queue* h = t_head_queue, *t2=NULL;
            while(h != NULL && h->priority >= priority){
                t2=h;
                h=h->next;
            }
            if(t2 == NULL) {
                new_queue_el_3->next = t_head_queue;
                t_head_queue = new_queue_el_3;
            } else {
                t2->next = new_queue_el_3;
                new_queue_el_3->next = h;
            }
        }
    } else {
        struct t_queue* new_queue_el = (struct t_queue*)malloc(sizeof(struct t_queue));
        new_queue_el->t_index = free_thread_index;
        if(t_head_queue == NULL) {
            t_head_queue = new_queue_el;
        } else {
            struct t_queue* h = t_head_queue;
            while(h->next != NULL) h=h->next;
            h->next = new_queue_el;
        }
    }

    return true;
}

/* Thread scheduler */
void ulthread_schedule(void) {
    
    /* Add this statement to denote which thread-id is being scheduled next */
    int next_thread_id;
    while(num_thrds > 0){
        next_thread_id = t_head_queue->t_index;
        current_queue_element = t_head_queue;
        t_head_queue = t_head_queue->next;
        current_queue_element->next = NULL;
        current_thread = &all_threads[next_thread_id];
        printf("[*] ultschedule (next tid: %d)\n", current_thread->tid);
        current_thread->state = RUNNING;
        ulthread_context_switch(&scheduler_thread->context, &current_thread->context);
    }
}

/* Yield CPU time to some other thread. */
void ulthread_yield(void) {
    /* Please add thread-id instead of '0' here. */
    printf("[*] ultyield(tid: %d)\n", current_thread->tid);

    if(selected_sch_algo == PRIORITY) {
        struct t_queue* t1 = t_head_queue, *h=t_head_queue, *t2=t_head_queue;
        if(h != NULL) {
            t1=t1->next;
            while(t1 != NULL && t1->priority >= t_head_queue->priority ){
                t2=t1;
                t1 = t1->next;   
            } 
            t2->next=current_queue_element;
            current_queue_element->next=t1;
        }else{
            t_head_queue = current_queue_element;
        }
    }else if(selected_sch_algo == FCFS){
        current_queue_element->next = t_head_queue;
        t_head_queue = current_queue_element;
    } else {
        struct t_queue* t = t_head_queue, *h = t_head_queue;
        if(h!=NULL){
            while(h->next != NULL ) h = h->next;
            h->next=current_queue_element;
        }else{
            t_head_queue = current_queue_element;
        }
    }

    current_thread->state = YIELD;

    ulthread_context_switch(&current_thread->context, &scheduler_thread->context);
    
}

/* Destroy thread */
void ulthread_destroy(void) {
    num_thrds--;

    printf("[*] ultdestroy(tid: %d)\n", current_thread->tid);

    free(current_queue_element);

    current_thread->state = FREE;

    ulthread_context_switch(&current_thread->context, &scheduler_thread->context);
}

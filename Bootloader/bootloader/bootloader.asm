
bootloader/bootloader:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00001117          	auipc	sp,0x1
    80000004:	84010113          	addi	sp,sp,-1984 # 80000840 <bl_stack>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	18a000ef          	jal	ra,800001a0 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <r_vendor>:
#ifndef __ASSEMBLER__

// CSE 536: Task 2.6
static inline uint64
r_vendor()
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec22                	sd	s0,24(sp)
    80000020:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mvendorid" : "=r" (x) );
    80000022:	f11027f3          	csrr	a5,mvendorid
    80000026:	fef43423          	sd	a5,-24(s0)
  return x;
    8000002a:	fe843783          	ld	a5,-24(s0)
}
    8000002e:	853e                	mv	a0,a5
    80000030:	6462                	ld	s0,24(sp)
    80000032:	6105                	addi	sp,sp,32
    80000034:	8082                	ret

0000000080000036 <r_architecture>:
 
// CSE 536: Task 2.6
static inline uint64
r_architecture()
{
    80000036:	1101                	addi	sp,sp,-32
    80000038:	ec22                	sd	s0,24(sp)
    8000003a:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, marchid" : "=r" (x) );
    8000003c:	f12027f3          	csrr	a5,marchid
    80000040:	fef43423          	sd	a5,-24(s0)
  return x;
    80000044:	fe843783          	ld	a5,-24(s0)
}
    80000048:	853e                	mv	a0,a5
    8000004a:	6462                	ld	s0,24(sp)
    8000004c:	6105                	addi	sp,sp,32
    8000004e:	8082                	ret

0000000080000050 <r_implementation>:
 
// CSE 536: Task 2.6
static inline uint64
r_implementation()
{
    80000050:	1101                	addi	sp,sp,-32
    80000052:	ec22                	sd	s0,24(sp)
    80000054:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mimpid" : "=r" (x) );
    80000056:	f13027f3          	csrr	a5,mimpid
    8000005a:	fef43423          	sd	a5,-24(s0)
  return x;
    8000005e:	fe843783          	ld	a5,-24(s0)
}
    80000062:	853e                	mv	a0,a5
    80000064:	6462                	ld	s0,24(sp)
    80000066:	6105                	addi	sp,sp,32
    80000068:	8082                	ret

000000008000006a <r_mhartid>:

// which hart (core) is this?
static inline uint64
r_mhartid()
{
    8000006a:	1101                	addi	sp,sp,-32
    8000006c:	ec22                	sd	s0,24(sp)
    8000006e:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000070:	f14027f3          	csrr	a5,mhartid
    80000074:	fef43423          	sd	a5,-24(s0)
  return x;
    80000078:	fe843783          	ld	a5,-24(s0)
}
    8000007c:	853e                	mv	a0,a5
    8000007e:	6462                	ld	s0,24(sp)
    80000080:	6105                	addi	sp,sp,32
    80000082:	8082                	ret

0000000080000084 <r_mstatus>:
#define MSTATUS_MPP_U (0L << 11)
#define MSTATUS_MIE (1L << 3)    // machine-mode interrupt enable.

static inline uint64
r_mstatus()
{
    80000084:	1101                	addi	sp,sp,-32
    80000086:	ec22                	sd	s0,24(sp)
    80000088:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008a:	300027f3          	csrr	a5,mstatus
    8000008e:	fef43423          	sd	a5,-24(s0)
  return x;
    80000092:	fe843783          	ld	a5,-24(s0)
}
    80000096:	853e                	mv	a0,a5
    80000098:	6462                	ld	s0,24(sp)
    8000009a:	6105                	addi	sp,sp,32
    8000009c:	8082                	ret

000000008000009e <w_mstatus>:

static inline void 
w_mstatus(uint64 x)
{
    8000009e:	1101                	addi	sp,sp,-32
    800000a0:	ec22                	sd	s0,24(sp)
    800000a2:	1000                	addi	s0,sp,32
    800000a4:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	fe843783          	ld	a5,-24(s0)
    800000ac:	30079073          	csrw	mstatus,a5
}
    800000b0:	0001                	nop
    800000b2:	6462                	ld	s0,24(sp)
    800000b4:	6105                	addi	sp,sp,32
    800000b6:	8082                	ret

00000000800000b8 <w_mepc>:
// machine exception program counter, holds the
// instruction address to which a return from
// exception will go.
static inline void 
w_mepc(uint64 x)
{
    800000b8:	1101                	addi	sp,sp,-32
    800000ba:	ec22                	sd	s0,24(sp)
    800000bc:	1000                	addi	s0,sp,32
    800000be:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000c2:	fe843783          	ld	a5,-24(s0)
    800000c6:	34179073          	csrw	mepc,a5
}
    800000ca:	0001                	nop
    800000cc:	6462                	ld	s0,24(sp)
    800000ce:	6105                	addi	sp,sp,32
    800000d0:	8082                	ret

00000000800000d2 <r_sie>:
#define SIE_SEIE (1L << 9) // external
#define SIE_STIE (1L << 5) // timer
#define SIE_SSIE (1L << 1) // software
static inline uint64
r_sie()
{
    800000d2:	1101                	addi	sp,sp,-32
    800000d4:	ec22                	sd	s0,24(sp)
    800000d6:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000d8:	104027f3          	csrr	a5,sie
    800000dc:	fef43423          	sd	a5,-24(s0)
  return x;
    800000e0:	fe843783          	ld	a5,-24(s0)
}
    800000e4:	853e                	mv	a0,a5
    800000e6:	6462                	ld	s0,24(sp)
    800000e8:	6105                	addi	sp,sp,32
    800000ea:	8082                	ret

00000000800000ec <w_sie>:

static inline void 
w_sie(uint64 x)
{
    800000ec:	1101                	addi	sp,sp,-32
    800000ee:	ec22                	sd	s0,24(sp)
    800000f0:	1000                	addi	s0,sp,32
    800000f2:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sie, %0" : : "r" (x));
    800000f6:	fe843783          	ld	a5,-24(s0)
    800000fa:	10479073          	csrw	sie,a5
}
    800000fe:	0001                	nop
    80000100:	6462                	ld	s0,24(sp)
    80000102:	6105                	addi	sp,sp,32
    80000104:	8082                	ret

0000000080000106 <w_medeleg>:
  return x;
}

static inline void 
w_medeleg(uint64 x)
{
    80000106:	1101                	addi	sp,sp,-32
    80000108:	ec22                	sd	s0,24(sp)
    8000010a:	1000                	addi	s0,sp,32
    8000010c:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000110:	fe843783          	ld	a5,-24(s0)
    80000114:	30279073          	csrw	medeleg,a5
}
    80000118:	0001                	nop
    8000011a:	6462                	ld	s0,24(sp)
    8000011c:	6105                	addi	sp,sp,32
    8000011e:	8082                	ret

0000000080000120 <w_mideleg>:
  return x;
}

static inline void 
w_mideleg(uint64 x)
{
    80000120:	1101                	addi	sp,sp,-32
    80000122:	ec22                	sd	s0,24(sp)
    80000124:	1000                	addi	s0,sp,32
    80000126:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000012a:	fe843783          	ld	a5,-24(s0)
    8000012e:	30379073          	csrw	mideleg,a5
}
    80000132:	0001                	nop
    80000134:	6462                	ld	s0,24(sp)
    80000136:	6105                	addi	sp,sp,32
    80000138:	8082                	ret

000000008000013a <w_pmpcfg0>:
}

// Physical Memory Protection
static inline void
w_pmpcfg0(uint64 x)
{
    8000013a:	1101                	addi	sp,sp,-32
    8000013c:	ec22                	sd	s0,24(sp)
    8000013e:	1000                	addi	s0,sp,32
    80000140:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80000144:	fe843783          	ld	a5,-24(s0)
    80000148:	3a079073          	csrw	pmpcfg0,a5
}
    8000014c:	0001                	nop
    8000014e:	6462                	ld	s0,24(sp)
    80000150:	6105                	addi	sp,sp,32
    80000152:	8082                	ret

0000000080000154 <w_pmpaddr0>:

static inline void
w_pmpaddr0(uint64 x)
{
    80000154:	1101                	addi	sp,sp,-32
    80000156:	ec22                	sd	s0,24(sp)
    80000158:	1000                	addi	s0,sp,32
    8000015a:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000015e:	fe843783          	ld	a5,-24(s0)
    80000162:	3b079073          	csrw	pmpaddr0,a5
}
    80000166:	0001                	nop
    80000168:	6462                	ld	s0,24(sp)
    8000016a:	6105                	addi	sp,sp,32
    8000016c:	8082                	ret

000000008000016e <w_satp>:

// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
    8000016e:	1101                	addi	sp,sp,-32
    80000170:	ec22                	sd	s0,24(sp)
    80000172:	1000                	addi	s0,sp,32
    80000174:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw satp, %0" : : "r" (x));
    80000178:	fe843783          	ld	a5,-24(s0)
    8000017c:	18079073          	csrw	satp,a5
}
    80000180:	0001                	nop
    80000182:	6462                	ld	s0,24(sp)
    80000184:	6105                	addi	sp,sp,32
    80000186:	8082                	ret

0000000080000188 <w_tp>:
  return x;
}

static inline void 
w_tp(uint64 x)
{
    80000188:	1101                	addi	sp,sp,-32
    8000018a:	ec22                	sd	s0,24(sp)
    8000018c:	1000                	addi	s0,sp,32
    8000018e:	fea43423          	sd	a0,-24(s0)
  asm volatile("mv tp, %0" : : "r" (x));
    80000192:	fe843783          	ld	a5,-24(s0)
    80000196:	823e                	mv	tp,a5
}
    80000198:	0001                	nop
    8000019a:	6462                	ld	s0,24(sp)
    8000019c:	6105                	addi	sp,sp,32
    8000019e:	8082                	ret

00000000800001a0 <start>:
extern void _entry(void);

// entry.S jumps here in machine mode on stack0.
void
start()
{
    800001a0:	715d                	addi	sp,sp,-80
    800001a2:	e486                	sd	ra,72(sp)
    800001a4:	e0a2                	sd	s0,64(sp)
    800001a6:	fc26                	sd	s1,56(sp)
    800001a8:	0880                	addi	s0,sp,80
  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
    800001aa:	00000097          	auipc	ra,0x0
    800001ae:	ec0080e7          	jalr	-320(ra) # 8000006a <r_mhartid>
    800001b2:	87aa                	mv	a5,a0
    800001b4:	fcf42e23          	sw	a5,-36(s0)
  w_tp(id);
    800001b8:	fdc42783          	lw	a5,-36(s0)
    800001bc:	853e                	mv	a0,a5
    800001be:	00000097          	auipc	ra,0x0
    800001c2:	fca080e7          	jalr	-54(ra) # 80000188 <w_tp>

  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
    800001c6:	00000097          	auipc	ra,0x0
    800001ca:	ebe080e7          	jalr	-322(ra) # 80000084 <r_mstatus>
    800001ce:	fca43823          	sd	a0,-48(s0)
  x &= ~MSTATUS_MPP_MASK;
    800001d2:	fd043703          	ld	a4,-48(s0)
    800001d6:	77f9                	lui	a5,0xffffe
    800001d8:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <kernel_phdr+0xffffffff7fff5faf>
    800001dc:	8ff9                	and	a5,a5,a4
    800001de:	fcf43823          	sd	a5,-48(s0)
  x |= MSTATUS_MPP_S;
    800001e2:	fd043703          	ld	a4,-48(s0)
    800001e6:	6785                	lui	a5,0x1
    800001e8:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    800001ec:	8fd9                	or	a5,a5,a4
    800001ee:	fcf43823          	sd	a5,-48(s0)
  w_mstatus(x);
    800001f2:	fd043503          	ld	a0,-48(s0)
    800001f6:	00000097          	auipc	ra,0x0
    800001fa:	ea8080e7          	jalr	-344(ra) # 8000009e <w_mstatus>

  // disable paging for now.
  w_satp(0);
    800001fe:	4501                	li	a0,0
    80000200:	00000097          	auipc	ra,0x0
    80000204:	f6e080e7          	jalr	-146(ra) # 8000016e <w_satp>

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
    80000208:	67c1                	lui	a5,0x10
    8000020a:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    8000020e:	00000097          	auipc	ra,0x0
    80000212:	ef8080e7          	jalr	-264(ra) # 80000106 <w_medeleg>
  w_mideleg(0xffff);
    80000216:	67c1                	lui	a5,0x10
    80000218:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    8000021c:	00000097          	auipc	ra,0x0
    80000220:	f04080e7          	jalr	-252(ra) # 80000120 <w_mideleg>
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000224:	00000097          	auipc	ra,0x0
    80000228:	eae080e7          	jalr	-338(ra) # 800000d2 <r_sie>
    8000022c:	87aa                	mv	a5,a0
    8000022e:	2227e793          	ori	a5,a5,546
    80000232:	853e                	mv	a0,a5
    80000234:	00000097          	auipc	ra,0x0
    80000238:	eb8080e7          	jalr	-328(ra) # 800000ec <w_sie>

  // CSE 536: Task 2.4
  //  Enable R/W/X access to all parts of the address space, 
  //  except for the upper 10 MB (0 - 117 MB) using PMP
  w_pmpaddr0(0x21d40000); 
    8000023c:	21d40537          	lui	a0,0x21d40
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f14080e7          	jalr	-236(ra) # 80000154 <w_pmpaddr0>
  w_pmpcfg0(0xf);
    80000248:	453d                	li	a0,15
    8000024a:	00000097          	auipc	ra,0x0
    8000024e:	ef0080e7          	jalr	-272(ra) # 8000013a <w_pmpcfg0>

  // CSE 536: Task 2.5
  // Load the kernel binary to its correct location
  uint64 kernel_entry_addr = 0;
    80000252:	fc043423          	sd	zero,-56(s0)
  uint64 kernel_load_addr  = 0;
    80000256:	fc043023          	sd	zero,-64(s0)
  uint64 kernel_size       = 0;
    8000025a:	fa043c23          	sd	zero,-72(s0)

  // CSE 536: Task 2.5.1
  // Find the loading address of the kernel binary
  kernel_load_addr  = find_kernel_load_addr();
    8000025e:	00000097          	auipc	ra,0x0
    80000262:	520080e7          	jalr	1312(ra) # 8000077e <find_kernel_load_addr>
    80000266:	fca43023          	sd	a0,-64(s0)

  // CSE 536: Task 2.5.2
  // Find the kernel binary size and copy it to the load address
  kernel_size       = find_kernel_size();
    8000026a:	00000097          	auipc	ra,0x0
    8000026e:	56e080e7          	jalr	1390(ra) # 800007d8 <find_kernel_size>
    80000272:	faa43c23          	sd	a0,-72(s0)
  memmove(kernel_load_addr,RAMDISK+4096,kernel_size-4096);
    80000276:	fc043683          	ld	a3,-64(s0)
    8000027a:	fb843783          	ld	a5,-72(s0)
    8000027e:	0007871b          	sext.w	a4,a5
    80000282:	77fd                	lui	a5,0xfffff
    80000284:	9fb9                	addw	a5,a5,a4
    80000286:	2781                	sext.w	a5,a5
    80000288:	863e                	mv	a2,a5
    8000028a:	000847b7          	lui	a5,0x84
    8000028e:	0785                	addi	a5,a5,1 # 84001 <_entry-0x7ff7bfff>
    80000290:	00c79593          	slli	a1,a5,0xc
    80000294:	8536                	mv	a0,a3
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	216080e7          	jalr	534(ra) # 800004ac <memmove>
  // CSE 536: Task 2.5.3
  // Find the entry address and write it to mepc
  kernel_entry_addr = find_kernel_entry_addr();
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	57e080e7          	jalr	1406(ra) # 8000081c <find_kernel_entry_addr>
    800002a6:	fca43423          	sd	a0,-56(s0)


  // CSE 536: Task 2.6
  // Provide system information to the kernel
sys_info_ptr=SYSINFOADDR;
    800002aa:	00008797          	auipc	a5,0x8
    800002ae:	59678793          	addi	a5,a5,1430 # 80008840 <sys_info_ptr>
    800002b2:	01001737          	lui	a4,0x1001
    800002b6:	071e                	slli	a4,a4,0x7
    800002b8:	e398                	sd	a4,0(a5)
  sys_info_ptr->bl_start=0x80000000;
    800002ba:	00008797          	auipc	a5,0x8
    800002be:	58678793          	addi	a5,a5,1414 # 80008840 <sys_info_ptr>
    800002c2:	639c                	ld	a5,0(a5)
    800002c4:	4705                	li	a4,1
    800002c6:	077e                	slli	a4,a4,0x1f
    800002c8:	ef98                	sd	a4,24(a5)
  sys_info_ptr->bl_end=&end;
    800002ca:	00008797          	auipc	a5,0x8
    800002ce:	57678793          	addi	a5,a5,1398 # 80008840 <sys_info_ptr>
    800002d2:	639c                	ld	a5,0(a5)
    800002d4:	00008717          	auipc	a4,0x8
    800002d8:	56c70713          	addi	a4,a4,1388 # 80008840 <sys_info_ptr>
    800002dc:	f398                	sd	a4,32(a5)
  sys_info_ptr->dr_start=0x80000000;
    800002de:	00008797          	auipc	a5,0x8
    800002e2:	56278793          	addi	a5,a5,1378 # 80008840 <sys_info_ptr>
    800002e6:	639c                	ld	a5,0(a5)
    800002e8:	4705                	li	a4,1
    800002ea:	077e                	slli	a4,a4,0x1f
    800002ec:	f798                	sd	a4,40(a5)
  sys_info_ptr->dr_end=0x88000000;
    800002ee:	00008797          	auipc	a5,0x8
    800002f2:	55278793          	addi	a5,a5,1362 # 80008840 <sys_info_ptr>
    800002f6:	639c                	ld	a5,0(a5)
    800002f8:	4745                	li	a4,17
    800002fa:	076e                	slli	a4,a4,0x1b
    800002fc:	fb98                	sd	a4,48(a5)

  sys_info_ptr->vendor=r_vendor();
    800002fe:	00008797          	auipc	a5,0x8
    80000302:	54278793          	addi	a5,a5,1346 # 80008840 <sys_info_ptr>
    80000306:	6384                	ld	s1,0(a5)
    80000308:	00000097          	auipc	ra,0x0
    8000030c:	d14080e7          	jalr	-748(ra) # 8000001c <r_vendor>
    80000310:	87aa                	mv	a5,a0
    80000312:	e09c                	sd	a5,0(s1)
  sys_info_ptr->arch=r_architecture();
    80000314:	00008797          	auipc	a5,0x8
    80000318:	52c78793          	addi	a5,a5,1324 # 80008840 <sys_info_ptr>
    8000031c:	6384                	ld	s1,0(a5)
    8000031e:	00000097          	auipc	ra,0x0
    80000322:	d18080e7          	jalr	-744(ra) # 80000036 <r_architecture>
    80000326:	87aa                	mv	a5,a0
    80000328:	e49c                	sd	a5,8(s1)
  sys_info_ptr->impl=r_implementation();
    8000032a:	00008797          	auipc	a5,0x8
    8000032e:	51678793          	addi	a5,a5,1302 # 80008840 <sys_info_ptr>
    80000332:	6384                	ld	s1,0(a5)
    80000334:	00000097          	auipc	ra,0x0
    80000338:	d1c080e7          	jalr	-740(ra) # 80000050 <r_implementation>
    8000033c:	87aa                	mv	a5,a0
    8000033e:	e89c                	sd	a5,16(s1)
  //CSE 536: Task 2.5.3
  // Jump to the OS kernel codex
  w_mepc(kernel_entry_addr);
    80000340:	fc843503          	ld	a0,-56(s0)
    80000344:	00000097          	auipc	ra,0x0
    80000348:	d74080e7          	jalr	-652(ra) # 800000b8 <w_mepc>
  asm volatile("mret");
    8000034c:	30200073          	mret
    80000350:	0001                	nop
    80000352:	60a6                	ld	ra,72(sp)
    80000354:	6406                	ld	s0,64(sp)
    80000356:	74e2                	ld	s1,56(sp)
    80000358:	6161                	addi	sp,sp,80
    8000035a:	8082                	ret

000000008000035c <kernel_copy>:

// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
kernel_copy(struct buf *b)
{
    8000035c:	7179                	addi	sp,sp,-48
    8000035e:	f406                	sd	ra,40(sp)
    80000360:	f022                	sd	s0,32(sp)
    80000362:	1800                	addi	s0,sp,48
    80000364:	fca43c23          	sd	a0,-40(s0)
  /* Ramdisk is not even reading from the damn file.. */
  if(b->blockno >= FSSIZE)
    80000368:	fd843783          	ld	a5,-40(s0)
    8000036c:	47dc                	lw	a5,12(a5)
    8000036e:	873e                	mv	a4,a5
    80000370:	7cf00793          	li	a5,1999
    80000374:	00e7f663          	bgeu	a5,a4,80000380 <kernel_copy+0x24>
    spin();
    80000378:	00000097          	auipc	ra,0x0
    8000037c:	ca2080e7          	jalr	-862(ra) # 8000001a <spin>

  uint64 diskaddr = b->blockno * BSIZE;
    80000380:	fd843783          	ld	a5,-40(s0)
    80000384:	47dc                	lw	a5,12(a5)
    80000386:	00a7979b          	slliw	a5,a5,0xa
    8000038a:	2781                	sext.w	a5,a5
    8000038c:	1782                	slli	a5,a5,0x20
    8000038e:	9381                	srli	a5,a5,0x20
    80000390:	fef43423          	sd	a5,-24(s0)
  char *addr = (char *)RAMDISK + diskaddr;
    80000394:	fe843703          	ld	a4,-24(s0)
    80000398:	02100793          	li	a5,33
    8000039c:	07ea                	slli	a5,a5,0x1a
    8000039e:	97ba                	add	a5,a5,a4
    800003a0:	fef43023          	sd	a5,-32(s0)

  // read from the location
  memmove(b->data, addr, BSIZE);
    800003a4:	fd843783          	ld	a5,-40(s0)
    800003a8:	02878793          	addi	a5,a5,40
    800003ac:	40000613          	li	a2,1024
    800003b0:	fe043583          	ld	a1,-32(s0)
    800003b4:	853e                	mv	a0,a5
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	0f6080e7          	jalr	246(ra) # 800004ac <memmove>
}
    800003be:	0001                	nop
    800003c0:	70a2                	ld	ra,40(sp)
    800003c2:	7402                	ld	s0,32(sp)
    800003c4:	6145                	addi	sp,sp,48
    800003c6:	8082                	ret

00000000800003c8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800003c8:	7179                	addi	sp,sp,-48
    800003ca:	f422                	sd	s0,40(sp)
    800003cc:	1800                	addi	s0,sp,48
    800003ce:	fca43c23          	sd	a0,-40(s0)
    800003d2:	87ae                	mv	a5,a1
    800003d4:	8732                	mv	a4,a2
    800003d6:	fcf42a23          	sw	a5,-44(s0)
    800003da:	87ba                	mv	a5,a4
    800003dc:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    800003e0:	fd843783          	ld	a5,-40(s0)
    800003e4:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    800003e8:	fe042623          	sw	zero,-20(s0)
    800003ec:	a00d                	j	8000040e <memset+0x46>
    cdst[i] = c;
    800003ee:	fec42783          	lw	a5,-20(s0)
    800003f2:	fe043703          	ld	a4,-32(s0)
    800003f6:	97ba                	add	a5,a5,a4
    800003f8:	fd442703          	lw	a4,-44(s0)
    800003fc:	0ff77713          	zext.b	a4,a4
    80000400:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    80000404:	fec42783          	lw	a5,-20(s0)
    80000408:	2785                	addiw	a5,a5,1
    8000040a:	fef42623          	sw	a5,-20(s0)
    8000040e:	fec42703          	lw	a4,-20(s0)
    80000412:	fd042783          	lw	a5,-48(s0)
    80000416:	2781                	sext.w	a5,a5
    80000418:	fcf76be3          	bltu	a4,a5,800003ee <memset+0x26>
  }
  return dst;
    8000041c:	fd843783          	ld	a5,-40(s0)
}
    80000420:	853e                	mv	a0,a5
    80000422:	7422                	ld	s0,40(sp)
    80000424:	6145                	addi	sp,sp,48
    80000426:	8082                	ret

0000000080000428 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000428:	7139                	addi	sp,sp,-64
    8000042a:	fc22                	sd	s0,56(sp)
    8000042c:	0080                	addi	s0,sp,64
    8000042e:	fca43c23          	sd	a0,-40(s0)
    80000432:	fcb43823          	sd	a1,-48(s0)
    80000436:	87b2                	mv	a5,a2
    80000438:	fcf42623          	sw	a5,-52(s0)
  const uchar *s1, *s2;

  s1 = v1;
    8000043c:	fd843783          	ld	a5,-40(s0)
    80000440:	fef43423          	sd	a5,-24(s0)
  s2 = v2;
    80000444:	fd043783          	ld	a5,-48(s0)
    80000448:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    8000044c:	a0a1                	j	80000494 <memcmp+0x6c>
    if(*s1 != *s2)
    8000044e:	fe843783          	ld	a5,-24(s0)
    80000452:	0007c703          	lbu	a4,0(a5)
    80000456:	fe043783          	ld	a5,-32(s0)
    8000045a:	0007c783          	lbu	a5,0(a5)
    8000045e:	02f70163          	beq	a4,a5,80000480 <memcmp+0x58>
      return *s1 - *s2;
    80000462:	fe843783          	ld	a5,-24(s0)
    80000466:	0007c783          	lbu	a5,0(a5)
    8000046a:	0007871b          	sext.w	a4,a5
    8000046e:	fe043783          	ld	a5,-32(s0)
    80000472:	0007c783          	lbu	a5,0(a5)
    80000476:	2781                	sext.w	a5,a5
    80000478:	40f707bb          	subw	a5,a4,a5
    8000047c:	2781                	sext.w	a5,a5
    8000047e:	a01d                	j	800004a4 <memcmp+0x7c>
    s1++, s2++;
    80000480:	fe843783          	ld	a5,-24(s0)
    80000484:	0785                	addi	a5,a5,1
    80000486:	fef43423          	sd	a5,-24(s0)
    8000048a:	fe043783          	ld	a5,-32(s0)
    8000048e:	0785                	addi	a5,a5,1
    80000490:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    80000494:	fcc42783          	lw	a5,-52(s0)
    80000498:	fff7871b          	addiw	a4,a5,-1
    8000049c:	fce42623          	sw	a4,-52(s0)
    800004a0:	f7dd                	bnez	a5,8000044e <memcmp+0x26>
  }

  return 0;
    800004a2:	4781                	li	a5,0
}
    800004a4:	853e                	mv	a0,a5
    800004a6:	7462                	ld	s0,56(sp)
    800004a8:	6121                	addi	sp,sp,64
    800004aa:	8082                	ret

00000000800004ac <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800004ac:	7139                	addi	sp,sp,-64
    800004ae:	fc22                	sd	s0,56(sp)
    800004b0:	0080                	addi	s0,sp,64
    800004b2:	fca43c23          	sd	a0,-40(s0)
    800004b6:	fcb43823          	sd	a1,-48(s0)
    800004ba:	87b2                	mv	a5,a2
    800004bc:	fcf42623          	sw	a5,-52(s0)
  const char *s;
  char *d;

  if(n == 0)
    800004c0:	fcc42783          	lw	a5,-52(s0)
    800004c4:	2781                	sext.w	a5,a5
    800004c6:	e781                	bnez	a5,800004ce <memmove+0x22>
    return dst;
    800004c8:	fd843783          	ld	a5,-40(s0)
    800004cc:	a855                	j	80000580 <memmove+0xd4>
  
  s = src;
    800004ce:	fd043783          	ld	a5,-48(s0)
    800004d2:	fef43423          	sd	a5,-24(s0)
  d = dst;
    800004d6:	fd843783          	ld	a5,-40(s0)
    800004da:	fef43023          	sd	a5,-32(s0)
  if(s < d && s + n > d){
    800004de:	fe843703          	ld	a4,-24(s0)
    800004e2:	fe043783          	ld	a5,-32(s0)
    800004e6:	08f77463          	bgeu	a4,a5,8000056e <memmove+0xc2>
    800004ea:	fcc46783          	lwu	a5,-52(s0)
    800004ee:	fe843703          	ld	a4,-24(s0)
    800004f2:	97ba                	add	a5,a5,a4
    800004f4:	fe043703          	ld	a4,-32(s0)
    800004f8:	06f77b63          	bgeu	a4,a5,8000056e <memmove+0xc2>
    s += n;
    800004fc:	fcc46783          	lwu	a5,-52(s0)
    80000500:	fe843703          	ld	a4,-24(s0)
    80000504:	97ba                	add	a5,a5,a4
    80000506:	fef43423          	sd	a5,-24(s0)
    d += n;
    8000050a:	fcc46783          	lwu	a5,-52(s0)
    8000050e:	fe043703          	ld	a4,-32(s0)
    80000512:	97ba                	add	a5,a5,a4
    80000514:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    80000518:	a01d                	j	8000053e <memmove+0x92>
      *--d = *--s;
    8000051a:	fe843783          	ld	a5,-24(s0)
    8000051e:	17fd                	addi	a5,a5,-1
    80000520:	fef43423          	sd	a5,-24(s0)
    80000524:	fe043783          	ld	a5,-32(s0)
    80000528:	17fd                	addi	a5,a5,-1
    8000052a:	fef43023          	sd	a5,-32(s0)
    8000052e:	fe843783          	ld	a5,-24(s0)
    80000532:	0007c703          	lbu	a4,0(a5)
    80000536:	fe043783          	ld	a5,-32(s0)
    8000053a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    8000053e:	fcc42783          	lw	a5,-52(s0)
    80000542:	fff7871b          	addiw	a4,a5,-1
    80000546:	fce42623          	sw	a4,-52(s0)
    8000054a:	fbe1                	bnez	a5,8000051a <memmove+0x6e>
  if(s < d && s + n > d){
    8000054c:	a805                	j	8000057c <memmove+0xd0>
  } else
    while(n-- > 0)
      *d++ = *s++;
    8000054e:	fe843703          	ld	a4,-24(s0)
    80000552:	00170793          	addi	a5,a4,1
    80000556:	fef43423          	sd	a5,-24(s0)
    8000055a:	fe043783          	ld	a5,-32(s0)
    8000055e:	00178693          	addi	a3,a5,1
    80000562:	fed43023          	sd	a3,-32(s0)
    80000566:	00074703          	lbu	a4,0(a4)
    8000056a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    8000056e:	fcc42783          	lw	a5,-52(s0)
    80000572:	fff7871b          	addiw	a4,a5,-1
    80000576:	fce42623          	sw	a4,-52(s0)
    8000057a:	fbf1                	bnez	a5,8000054e <memmove+0xa2>

  return dst;
    8000057c:	fd843783          	ld	a5,-40(s0)
}
    80000580:	853e                	mv	a0,a5
    80000582:	7462                	ld	s0,56(sp)
    80000584:	6121                	addi	sp,sp,64
    80000586:	8082                	ret

0000000080000588 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000588:	7179                	addi	sp,sp,-48
    8000058a:	f406                	sd	ra,40(sp)
    8000058c:	f022                	sd	s0,32(sp)
    8000058e:	1800                	addi	s0,sp,48
    80000590:	fea43423          	sd	a0,-24(s0)
    80000594:	feb43023          	sd	a1,-32(s0)
    80000598:	87b2                	mv	a5,a2
    8000059a:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    8000059e:	fdc42783          	lw	a5,-36(s0)
    800005a2:	863e                	mv	a2,a5
    800005a4:	fe043583          	ld	a1,-32(s0)
    800005a8:	fe843503          	ld	a0,-24(s0)
    800005ac:	00000097          	auipc	ra,0x0
    800005b0:	f00080e7          	jalr	-256(ra) # 800004ac <memmove>
    800005b4:	87aa                	mv	a5,a0
}
    800005b6:	853e                	mv	a0,a5
    800005b8:	70a2                	ld	ra,40(sp)
    800005ba:	7402                	ld	s0,32(sp)
    800005bc:	6145                	addi	sp,sp,48
    800005be:	8082                	ret

00000000800005c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800005c0:	7179                	addi	sp,sp,-48
    800005c2:	f422                	sd	s0,40(sp)
    800005c4:	1800                	addi	s0,sp,48
    800005c6:	fea43423          	sd	a0,-24(s0)
    800005ca:	feb43023          	sd	a1,-32(s0)
    800005ce:	87b2                	mv	a5,a2
    800005d0:	fcf42e23          	sw	a5,-36(s0)
  while(n > 0 && *p && *p == *q)
    800005d4:	a005                	j	800005f4 <strncmp+0x34>
    n--, p++, q++;
    800005d6:	fdc42783          	lw	a5,-36(s0)
    800005da:	37fd                	addiw	a5,a5,-1
    800005dc:	fcf42e23          	sw	a5,-36(s0)
    800005e0:	fe843783          	ld	a5,-24(s0)
    800005e4:	0785                	addi	a5,a5,1
    800005e6:	fef43423          	sd	a5,-24(s0)
    800005ea:	fe043783          	ld	a5,-32(s0)
    800005ee:	0785                	addi	a5,a5,1
    800005f0:	fef43023          	sd	a5,-32(s0)
  while(n > 0 && *p && *p == *q)
    800005f4:	fdc42783          	lw	a5,-36(s0)
    800005f8:	2781                	sext.w	a5,a5
    800005fa:	c385                	beqz	a5,8000061a <strncmp+0x5a>
    800005fc:	fe843783          	ld	a5,-24(s0)
    80000600:	0007c783          	lbu	a5,0(a5)
    80000604:	cb99                	beqz	a5,8000061a <strncmp+0x5a>
    80000606:	fe843783          	ld	a5,-24(s0)
    8000060a:	0007c703          	lbu	a4,0(a5)
    8000060e:	fe043783          	ld	a5,-32(s0)
    80000612:	0007c783          	lbu	a5,0(a5)
    80000616:	fcf700e3          	beq	a4,a5,800005d6 <strncmp+0x16>
  if(n == 0)
    8000061a:	fdc42783          	lw	a5,-36(s0)
    8000061e:	2781                	sext.w	a5,a5
    80000620:	e399                	bnez	a5,80000626 <strncmp+0x66>
    return 0;
    80000622:	4781                	li	a5,0
    80000624:	a839                	j	80000642 <strncmp+0x82>
  return (uchar)*p - (uchar)*q;
    80000626:	fe843783          	ld	a5,-24(s0)
    8000062a:	0007c783          	lbu	a5,0(a5)
    8000062e:	0007871b          	sext.w	a4,a5
    80000632:	fe043783          	ld	a5,-32(s0)
    80000636:	0007c783          	lbu	a5,0(a5)
    8000063a:	2781                	sext.w	a5,a5
    8000063c:	40f707bb          	subw	a5,a4,a5
    80000640:	2781                	sext.w	a5,a5
}
    80000642:	853e                	mv	a0,a5
    80000644:	7422                	ld	s0,40(sp)
    80000646:	6145                	addi	sp,sp,48
    80000648:	8082                	ret

000000008000064a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000064a:	7139                	addi	sp,sp,-64
    8000064c:	fc22                	sd	s0,56(sp)
    8000064e:	0080                	addi	s0,sp,64
    80000650:	fca43c23          	sd	a0,-40(s0)
    80000654:	fcb43823          	sd	a1,-48(s0)
    80000658:	87b2                	mv	a5,a2
    8000065a:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    8000065e:	fd843783          	ld	a5,-40(s0)
    80000662:	fef43423          	sd	a5,-24(s0)
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000666:	0001                	nop
    80000668:	fcc42783          	lw	a5,-52(s0)
    8000066c:	fff7871b          	addiw	a4,a5,-1
    80000670:	fce42623          	sw	a4,-52(s0)
    80000674:	02f05e63          	blez	a5,800006b0 <strncpy+0x66>
    80000678:	fd043703          	ld	a4,-48(s0)
    8000067c:	00170793          	addi	a5,a4,1
    80000680:	fcf43823          	sd	a5,-48(s0)
    80000684:	fd843783          	ld	a5,-40(s0)
    80000688:	00178693          	addi	a3,a5,1
    8000068c:	fcd43c23          	sd	a3,-40(s0)
    80000690:	00074703          	lbu	a4,0(a4)
    80000694:	00e78023          	sb	a4,0(a5)
    80000698:	0007c783          	lbu	a5,0(a5)
    8000069c:	f7f1                	bnez	a5,80000668 <strncpy+0x1e>
    ;
  while(n-- > 0)
    8000069e:	a809                	j	800006b0 <strncpy+0x66>
    *s++ = 0;
    800006a0:	fd843783          	ld	a5,-40(s0)
    800006a4:	00178713          	addi	a4,a5,1
    800006a8:	fce43c23          	sd	a4,-40(s0)
    800006ac:	00078023          	sb	zero,0(a5)
  while(n-- > 0)
    800006b0:	fcc42783          	lw	a5,-52(s0)
    800006b4:	fff7871b          	addiw	a4,a5,-1
    800006b8:	fce42623          	sw	a4,-52(s0)
    800006bc:	fef042e3          	bgtz	a5,800006a0 <strncpy+0x56>
  return os;
    800006c0:	fe843783          	ld	a5,-24(s0)
}
    800006c4:	853e                	mv	a0,a5
    800006c6:	7462                	ld	s0,56(sp)
    800006c8:	6121                	addi	sp,sp,64
    800006ca:	8082                	ret

00000000800006cc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800006cc:	7139                	addi	sp,sp,-64
    800006ce:	fc22                	sd	s0,56(sp)
    800006d0:	0080                	addi	s0,sp,64
    800006d2:	fca43c23          	sd	a0,-40(s0)
    800006d6:	fcb43823          	sd	a1,-48(s0)
    800006da:	87b2                	mv	a5,a2
    800006dc:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    800006e0:	fd843783          	ld	a5,-40(s0)
    800006e4:	fef43423          	sd	a5,-24(s0)
  if(n <= 0)
    800006e8:	fcc42783          	lw	a5,-52(s0)
    800006ec:	2781                	sext.w	a5,a5
    800006ee:	00f04563          	bgtz	a5,800006f8 <safestrcpy+0x2c>
    return os;
    800006f2:	fe843783          	ld	a5,-24(s0)
    800006f6:	a0a9                	j	80000740 <safestrcpy+0x74>
  while(--n > 0 && (*s++ = *t++) != 0)
    800006f8:	0001                	nop
    800006fa:	fcc42783          	lw	a5,-52(s0)
    800006fe:	37fd                	addiw	a5,a5,-1
    80000700:	fcf42623          	sw	a5,-52(s0)
    80000704:	fcc42783          	lw	a5,-52(s0)
    80000708:	2781                	sext.w	a5,a5
    8000070a:	02f05563          	blez	a5,80000734 <safestrcpy+0x68>
    8000070e:	fd043703          	ld	a4,-48(s0)
    80000712:	00170793          	addi	a5,a4,1
    80000716:	fcf43823          	sd	a5,-48(s0)
    8000071a:	fd843783          	ld	a5,-40(s0)
    8000071e:	00178693          	addi	a3,a5,1
    80000722:	fcd43c23          	sd	a3,-40(s0)
    80000726:	00074703          	lbu	a4,0(a4)
    8000072a:	00e78023          	sb	a4,0(a5)
    8000072e:	0007c783          	lbu	a5,0(a5)
    80000732:	f7e1                	bnez	a5,800006fa <safestrcpy+0x2e>
    ;
  *s = 0;
    80000734:	fd843783          	ld	a5,-40(s0)
    80000738:	00078023          	sb	zero,0(a5)
  return os;
    8000073c:	fe843783          	ld	a5,-24(s0)
}
    80000740:	853e                	mv	a0,a5
    80000742:	7462                	ld	s0,56(sp)
    80000744:	6121                	addi	sp,sp,64
    80000746:	8082                	ret

0000000080000748 <strlen>:

int
strlen(const char *s)
{
    80000748:	7179                	addi	sp,sp,-48
    8000074a:	f422                	sd	s0,40(sp)
    8000074c:	1800                	addi	s0,sp,48
    8000074e:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    80000752:	fe042623          	sw	zero,-20(s0)
    80000756:	a031                	j	80000762 <strlen+0x1a>
    80000758:	fec42783          	lw	a5,-20(s0)
    8000075c:	2785                	addiw	a5,a5,1
    8000075e:	fef42623          	sw	a5,-20(s0)
    80000762:	fec42783          	lw	a5,-20(s0)
    80000766:	fd843703          	ld	a4,-40(s0)
    8000076a:	97ba                	add	a5,a5,a4
    8000076c:	0007c783          	lbu	a5,0(a5)
    80000770:	f7e5                	bnez	a5,80000758 <strlen+0x10>
    ;
  return n;
    80000772:	fec42783          	lw	a5,-20(s0)
}
    80000776:	853e                	mv	a0,a5
    80000778:	7422                	ld	s0,40(sp)
    8000077a:	6145                	addi	sp,sp,48
    8000077c:	8082                	ret

000000008000077e <find_kernel_load_addr>:

struct elfhdr* kernel_elfhdr;

struct proghdr* kernel_phdr;

uint64 find_kernel_load_addr(void) {
    8000077e:	1141                	addi	sp,sp,-16
    80000780:	e422                	sd	s0,8(sp)
    80000782:	0800                	addi	s0,sp,16
    // CSE 536: task 2.5.1
    kernel_elfhdr=RAMDISK;
    80000784:	00008797          	auipc	a5,0x8
    80000788:	0c478793          	addi	a5,a5,196 # 80008848 <kernel_elfhdr>
    8000078c:	02100713          	li	a4,33
    80000790:	076a                	slli	a4,a4,0x1a
    80000792:	e398                	sd	a4,0(a5)
    kernel_phdr=RAMDISK+kernel_elfhdr->phoff+kernel_elfhdr->phentsize;
    80000794:	00008797          	auipc	a5,0x8
    80000798:	0b478793          	addi	a5,a5,180 # 80008848 <kernel_elfhdr>
    8000079c:	639c                	ld	a5,0(a5)
    8000079e:	739c                	ld	a5,32(a5)
    800007a0:	00008717          	auipc	a4,0x8
    800007a4:	0a870713          	addi	a4,a4,168 # 80008848 <kernel_elfhdr>
    800007a8:	6318                	ld	a4,0(a4)
    800007aa:	03675703          	lhu	a4,54(a4)
    800007ae:	973e                	add	a4,a4,a5
    800007b0:	02100793          	li	a5,33
    800007b4:	07ea                	slli	a5,a5,0x1a
    800007b6:	97ba                	add	a5,a5,a4
    800007b8:	873e                	mv	a4,a5
    800007ba:	00008797          	auipc	a5,0x8
    800007be:	09678793          	addi	a5,a5,150 # 80008850 <kernel_phdr>
    800007c2:	e398                	sd	a4,0(a5)
    return kernel_phdr->vaddr;
    800007c4:	00008797          	auipc	a5,0x8
    800007c8:	08c78793          	addi	a5,a5,140 # 80008850 <kernel_phdr>
    800007cc:	639c                	ld	a5,0(a5)
    800007ce:	6b9c                	ld	a5,16(a5)
}
    800007d0:	853e                	mv	a0,a5
    800007d2:	6422                	ld	s0,8(sp)
    800007d4:	0141                	addi	sp,sp,16
    800007d6:	8082                	ret

00000000800007d8 <find_kernel_size>:

uint64 find_kernel_size(void) {
    800007d8:	1141                	addi	sp,sp,-16
    800007da:	e422                	sd	s0,8(sp)
    800007dc:	0800                	addi	s0,sp,16
    // CSE 536: task 2.5.2



    return kernel_elfhdr->shoff+kernel_elfhdr->shentsize*kernel_elfhdr->shnum;
    800007de:	00008797          	auipc	a5,0x8
    800007e2:	06a78793          	addi	a5,a5,106 # 80008848 <kernel_elfhdr>
    800007e6:	639c                	ld	a5,0(a5)
    800007e8:	779c                	ld	a5,40(a5)
    800007ea:	00008717          	auipc	a4,0x8
    800007ee:	05e70713          	addi	a4,a4,94 # 80008848 <kernel_elfhdr>
    800007f2:	6318                	ld	a4,0(a4)
    800007f4:	03a75703          	lhu	a4,58(a4)
    800007f8:	0007069b          	sext.w	a3,a4
    800007fc:	00008717          	auipc	a4,0x8
    80000800:	04c70713          	addi	a4,a4,76 # 80008848 <kernel_elfhdr>
    80000804:	6318                	ld	a4,0(a4)
    80000806:	03c75703          	lhu	a4,60(a4)
    8000080a:	2701                	sext.w	a4,a4
    8000080c:	02e6873b          	mulw	a4,a3,a4
    80000810:	2701                	sext.w	a4,a4
    80000812:	97ba                	add	a5,a5,a4
}
    80000814:	853e                	mv	a0,a5
    80000816:	6422                	ld	s0,8(sp)
    80000818:	0141                	addi	sp,sp,16
    8000081a:	8082                	ret

000000008000081c <find_kernel_entry_addr>:

uint64 find_kernel_entry_addr(void) {
    8000081c:	1141                	addi	sp,sp,-16
    8000081e:	e422                	sd	s0,8(sp)
    80000820:	0800                	addi	s0,sp,16
    // CSE 536: task 2.5.3
    return kernel_elfhdr->entry;
    80000822:	00008797          	auipc	a5,0x8
    80000826:	02678793          	addi	a5,a5,38 # 80008848 <kernel_elfhdr>
    8000082a:	639c                	ld	a5,0(a5)
    8000082c:	6f9c                	ld	a5,24(a5)
    8000082e:	853e                	mv	a0,a5
    80000830:	6422                	ld	s0,8(sp)
    80000832:	0141                	addi	sp,sp,16
    80000834:	8082                	ret

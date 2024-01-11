
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	bf010113          	addi	sp,sp,-1040 # 80008bf0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	a6070713          	addi	a4,a4,-1440 # 80008ab0 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	cce78793          	addi	a5,a5,-818 # 80005d30 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fe650ef>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dc678793          	addi	a5,a5,-570 # 80000e72 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	4dc080e7          	jalr	1244(ra) # 80002606 <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	780080e7          	jalr	1920(ra) # 800008ba <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	711d                	addi	sp,sp,-96
    80000166:	ec86                	sd	ra,88(sp)
    80000168:	e8a2                	sd	s0,80(sp)
    8000016a:	e4a6                	sd	s1,72(sp)
    8000016c:	e0ca                	sd	s2,64(sp)
    8000016e:	fc4e                	sd	s3,56(sp)
    80000170:	f852                	sd	s4,48(sp)
    80000172:	f456                	sd	s5,40(sp)
    80000174:	f05a                	sd	s6,32(sp)
    80000176:	ec5e                	sd	s7,24(sp)
    80000178:	1080                	addi	s0,sp,96
    8000017a:	8aaa                	mv	s5,a0
    8000017c:	8a2e                	mv	s4,a1
    8000017e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000180:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000184:	00011517          	auipc	a0,0x11
    80000188:	a6c50513          	addi	a0,a0,-1428 # 80010bf0 <cons>
    8000018c:	00001097          	auipc	ra,0x1
    80000190:	a46080e7          	jalr	-1466(ra) # 80000bd2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000194:	00011497          	auipc	s1,0x11
    80000198:	a5c48493          	addi	s1,s1,-1444 # 80010bf0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000019c:	00011917          	auipc	s2,0x11
    800001a0:	aec90913          	addi	s2,s2,-1300 # 80010c88 <cons+0x98>
  while(n > 0){
    800001a4:	09305263          	blez	s3,80000228 <consoleread+0xc4>
    while(cons.r == cons.w){
    800001a8:	0984a783          	lw	a5,152(s1)
    800001ac:	09c4a703          	lw	a4,156(s1)
    800001b0:	02f71763          	bne	a4,a5,800001de <consoleread+0x7a>
      if(killed(myproc())){
    800001b4:	00002097          	auipc	ra,0x2
    800001b8:	82e080e7          	jalr	-2002(ra) # 800019e2 <myproc>
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	298080e7          	jalr	664(ra) # 80002454 <killed>
    800001c4:	ed2d                	bnez	a0,8000023e <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800001c6:	85a6                	mv	a1,s1
    800001c8:	854a                	mv	a0,s2
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	fca080e7          	jalr	-54(ra) # 80002194 <sleep>
    while(cons.r == cons.w){
    800001d2:	0984a783          	lw	a5,152(s1)
    800001d6:	09c4a703          	lw	a4,156(s1)
    800001da:	fcf70de3          	beq	a4,a5,800001b4 <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00011717          	auipc	a4,0x11
    800001e2:	a1270713          	addi	a4,a4,-1518 # 80010bf0 <cons>
    800001e6:	0017869b          	addiw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	andi	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	06db8463          	beq	s7,a3,80000266 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	addi	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	8556                	mv	a0,s5
    80000210:	00002097          	auipc	ra,0x2
    80000214:	3a0080e7          	jalr	928(ra) # 800025b0 <either_copyout>
    80000218:	57fd                	li	a5,-1
    8000021a:	00f50763          	beq	a0,a5,80000228 <consoleread+0xc4>
      break;

    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80000222:	47a9                	li	a5,10
    80000224:	f8fb90e3          	bne	s7,a5,800001a4 <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	9c850513          	addi	a0,a0,-1592 # 80010bf0 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a56080e7          	jalr	-1450(ra) # 80000c86 <release>

  return target - n;
    80000238:	413b053b          	subw	a0,s6,s3
    8000023c:	a811                	j	80000250 <consoleread+0xec>
        release(&cons.lock);
    8000023e:	00011517          	auipc	a0,0x11
    80000242:	9b250513          	addi	a0,a0,-1614 # 80010bf0 <cons>
    80000246:	00001097          	auipc	ra,0x1
    8000024a:	a40080e7          	jalr	-1472(ra) # 80000c86 <release>
        return -1;
    8000024e:	557d                	li	a0,-1
}
    80000250:	60e6                	ld	ra,88(sp)
    80000252:	6446                	ld	s0,80(sp)
    80000254:	64a6                	ld	s1,72(sp)
    80000256:	6906                	ld	s2,64(sp)
    80000258:	79e2                	ld	s3,56(sp)
    8000025a:	7a42                	ld	s4,48(sp)
    8000025c:	7aa2                	ld	s5,40(sp)
    8000025e:	7b02                	ld	s6,32(sp)
    80000260:	6be2                	ld	s7,24(sp)
    80000262:	6125                	addi	sp,sp,96
    80000264:	8082                	ret
      if(n < target){
    80000266:	0009871b          	sext.w	a4,s3
    8000026a:	fb677fe3          	bgeu	a4,s6,80000228 <consoleread+0xc4>
        cons.r--;
    8000026e:	00011717          	auipc	a4,0x11
    80000272:	a0f72d23          	sw	a5,-1510(a4) # 80010c88 <cons+0x98>
    80000276:	bf4d                	j	80000228 <consoleread+0xc4>

0000000080000278 <consputc>:
{
    80000278:	1141                	addi	sp,sp,-16
    8000027a:	e406                	sd	ra,8(sp)
    8000027c:	e022                	sd	s0,0(sp)
    8000027e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000280:	10000793          	li	a5,256
    80000284:	00f50a63          	beq	a0,a5,80000298 <consputc+0x20>
    uartputc_sync(c);
    80000288:	00000097          	auipc	ra,0x0
    8000028c:	560080e7          	jalr	1376(ra) # 800007e8 <uartputc_sync>
}
    80000290:	60a2                	ld	ra,8(sp)
    80000292:	6402                	ld	s0,0(sp)
    80000294:	0141                	addi	sp,sp,16
    80000296:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000298:	4521                	li	a0,8
    8000029a:	00000097          	auipc	ra,0x0
    8000029e:	54e080e7          	jalr	1358(ra) # 800007e8 <uartputc_sync>
    800002a2:	02000513          	li	a0,32
    800002a6:	00000097          	auipc	ra,0x0
    800002aa:	542080e7          	jalr	1346(ra) # 800007e8 <uartputc_sync>
    800002ae:	4521                	li	a0,8
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	538080e7          	jalr	1336(ra) # 800007e8 <uartputc_sync>
    800002b8:	bfe1                	j	80000290 <consputc+0x18>

00000000800002ba <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ba:	1101                	addi	sp,sp,-32
    800002bc:	ec06                	sd	ra,24(sp)
    800002be:	e822                	sd	s0,16(sp)
    800002c0:	e426                	sd	s1,8(sp)
    800002c2:	e04a                	sd	s2,0(sp)
    800002c4:	1000                	addi	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	00011517          	auipc	a0,0x11
    800002cc:	92850513          	addi	a0,a0,-1752 # 80010bf0 <cons>
    800002d0:	00001097          	auipc	ra,0x1
    800002d4:	902080e7          	jalr	-1790(ra) # 80000bd2 <acquire>

  switch(c){
    800002d8:	47d5                	li	a5,21
    800002da:	0af48663          	beq	s1,a5,80000386 <consoleintr+0xcc>
    800002de:	0297ca63          	blt	a5,s1,80000312 <consoleintr+0x58>
    800002e2:	47a1                	li	a5,8
    800002e4:	0ef48763          	beq	s1,a5,800003d2 <consoleintr+0x118>
    800002e8:	47c1                	li	a5,16
    800002ea:	10f49a63          	bne	s1,a5,800003fe <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002ee:	00002097          	auipc	ra,0x2
    800002f2:	36e080e7          	jalr	878(ra) # 8000265c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002f6:	00011517          	auipc	a0,0x11
    800002fa:	8fa50513          	addi	a0,a0,-1798 # 80010bf0 <cons>
    800002fe:	00001097          	auipc	ra,0x1
    80000302:	988080e7          	jalr	-1656(ra) # 80000c86 <release>
}
    80000306:	60e2                	ld	ra,24(sp)
    80000308:	6442                	ld	s0,16(sp)
    8000030a:	64a2                	ld	s1,8(sp)
    8000030c:	6902                	ld	s2,0(sp)
    8000030e:	6105                	addi	sp,sp,32
    80000310:	8082                	ret
  switch(c){
    80000312:	07f00793          	li	a5,127
    80000316:	0af48e63          	beq	s1,a5,800003d2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031a:	00011717          	auipc	a4,0x11
    8000031e:	8d670713          	addi	a4,a4,-1834 # 80010bf0 <cons>
    80000322:	0a072783          	lw	a5,160(a4)
    80000326:	09872703          	lw	a4,152(a4)
    8000032a:	9f99                	subw	a5,a5,a4
    8000032c:	07f00713          	li	a4,127
    80000330:	fcf763e3          	bltu	a4,a5,800002f6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000334:	47b5                	li	a5,13
    80000336:	0cf48763          	beq	s1,a5,80000404 <consoleintr+0x14a>
      consputc(c);
    8000033a:	8526                	mv	a0,s1
    8000033c:	00000097          	auipc	ra,0x0
    80000340:	f3c080e7          	jalr	-196(ra) # 80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000344:	00011797          	auipc	a5,0x11
    80000348:	8ac78793          	addi	a5,a5,-1876 # 80010bf0 <cons>
    8000034c:	0a07a683          	lw	a3,160(a5)
    80000350:	0016871b          	addiw	a4,a3,1
    80000354:	0007061b          	sext.w	a2,a4
    80000358:	0ae7a023          	sw	a4,160(a5)
    8000035c:	07f6f693          	andi	a3,a3,127
    80000360:	97b6                	add	a5,a5,a3
    80000362:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000366:	47a9                	li	a5,10
    80000368:	0cf48563          	beq	s1,a5,80000432 <consoleintr+0x178>
    8000036c:	4791                	li	a5,4
    8000036e:	0cf48263          	beq	s1,a5,80000432 <consoleintr+0x178>
    80000372:	00011797          	auipc	a5,0x11
    80000376:	9167a783          	lw	a5,-1770(a5) # 80010c88 <cons+0x98>
    8000037a:	9f1d                	subw	a4,a4,a5
    8000037c:	08000793          	li	a5,128
    80000380:	f6f71be3          	bne	a4,a5,800002f6 <consoleintr+0x3c>
    80000384:	a07d                	j	80000432 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000386:	00011717          	auipc	a4,0x11
    8000038a:	86a70713          	addi	a4,a4,-1942 # 80010bf0 <cons>
    8000038e:	0a072783          	lw	a5,160(a4)
    80000392:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000396:	00011497          	auipc	s1,0x11
    8000039a:	85a48493          	addi	s1,s1,-1958 # 80010bf0 <cons>
    while(cons.e != cons.w &&
    8000039e:	4929                	li	s2,10
    800003a0:	f4f70be3          	beq	a4,a5,800002f6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a4:	37fd                	addiw	a5,a5,-1
    800003a6:	07f7f713          	andi	a4,a5,127
    800003aa:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ac:	01874703          	lbu	a4,24(a4)
    800003b0:	f52703e3          	beq	a4,s2,800002f6 <consoleintr+0x3c>
      cons.e--;
    800003b4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003b8:	10000513          	li	a0,256
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	ebc080e7          	jalr	-324(ra) # 80000278 <consputc>
    while(cons.e != cons.w &&
    800003c4:	0a04a783          	lw	a5,160(s1)
    800003c8:	09c4a703          	lw	a4,156(s1)
    800003cc:	fcf71ce3          	bne	a4,a5,800003a4 <consoleintr+0xea>
    800003d0:	b71d                	j	800002f6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d2:	00011717          	auipc	a4,0x11
    800003d6:	81e70713          	addi	a4,a4,-2018 # 80010bf0 <cons>
    800003da:	0a072783          	lw	a5,160(a4)
    800003de:	09c72703          	lw	a4,156(a4)
    800003e2:	f0f70ae3          	beq	a4,a5,800002f6 <consoleintr+0x3c>
      cons.e--;
    800003e6:	37fd                	addiw	a5,a5,-1
    800003e8:	00011717          	auipc	a4,0x11
    800003ec:	8af72423          	sw	a5,-1880(a4) # 80010c90 <cons+0xa0>
      consputc(BACKSPACE);
    800003f0:	10000513          	li	a0,256
    800003f4:	00000097          	auipc	ra,0x0
    800003f8:	e84080e7          	jalr	-380(ra) # 80000278 <consputc>
    800003fc:	bded                	j	800002f6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003fe:	ee048ce3          	beqz	s1,800002f6 <consoleintr+0x3c>
    80000402:	bf21                	j	8000031a <consoleintr+0x60>
      consputc(c);
    80000404:	4529                	li	a0,10
    80000406:	00000097          	auipc	ra,0x0
    8000040a:	e72080e7          	jalr	-398(ra) # 80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000040e:	00010797          	auipc	a5,0x10
    80000412:	7e278793          	addi	a5,a5,2018 # 80010bf0 <cons>
    80000416:	0a07a703          	lw	a4,160(a5)
    8000041a:	0017069b          	addiw	a3,a4,1
    8000041e:	0006861b          	sext.w	a2,a3
    80000422:	0ad7a023          	sw	a3,160(a5)
    80000426:	07f77713          	andi	a4,a4,127
    8000042a:	97ba                	add	a5,a5,a4
    8000042c:	4729                	li	a4,10
    8000042e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000432:	00011797          	auipc	a5,0x11
    80000436:	84c7ad23          	sw	a2,-1958(a5) # 80010c8c <cons+0x9c>
        wakeup(&cons.r);
    8000043a:	00011517          	auipc	a0,0x11
    8000043e:	84e50513          	addi	a0,a0,-1970 # 80010c88 <cons+0x98>
    80000442:	00002097          	auipc	ra,0x2
    80000446:	db6080e7          	jalr	-586(ra) # 800021f8 <wakeup>
    8000044a:	b575                	j	800002f6 <consoleintr+0x3c>

000000008000044c <consoleinit>:

void
consoleinit(void)
{
    8000044c:	1141                	addi	sp,sp,-16
    8000044e:	e406                	sd	ra,8(sp)
    80000450:	e022                	sd	s0,0(sp)
    80000452:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000454:	00008597          	auipc	a1,0x8
    80000458:	bbc58593          	addi	a1,a1,-1092 # 80008010 <etext+0x10>
    8000045c:	00010517          	auipc	a0,0x10
    80000460:	79450513          	addi	a0,a0,1940 # 80010bf0 <cons>
    80000464:	00000097          	auipc	ra,0x0
    80000468:	6de080e7          	jalr	1758(ra) # 80000b42 <initlock>

  uartinit();
    8000046c:	00000097          	auipc	ra,0x0
    80000470:	32c080e7          	jalr	812(ra) # 80000798 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000474:	00198797          	auipc	a5,0x198
    80000478:	d1c78793          	addi	a5,a5,-740 # 80198190 <devsw>
    8000047c:	00000717          	auipc	a4,0x0
    80000480:	ce870713          	addi	a4,a4,-792 # 80000164 <consoleread>
    80000484:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000486:	00000717          	auipc	a4,0x0
    8000048a:	c7a70713          	addi	a4,a4,-902 # 80000100 <consolewrite>
    8000048e:	ef98                	sd	a4,24(a5)
}
    80000490:	60a2                	ld	ra,8(sp)
    80000492:	6402                	ld	s0,0(sp)
    80000494:	0141                	addi	sp,sp,16
    80000496:	8082                	ret

0000000080000498 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000498:	7179                	addi	sp,sp,-48
    8000049a:	f406                	sd	ra,40(sp)
    8000049c:	f022                	sd	s0,32(sp)
    8000049e:	ec26                	sd	s1,24(sp)
    800004a0:	e84a                	sd	s2,16(sp)
    800004a2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a4:	c219                	beqz	a2,800004aa <printint+0x12>
    800004a6:	08054763          	bltz	a0,80000534 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004aa:	2501                	sext.w	a0,a0
    800004ac:	4881                	li	a7,0
    800004ae:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b4:	2581                	sext.w	a1,a1
    800004b6:	00008617          	auipc	a2,0x8
    800004ba:	b8a60613          	addi	a2,a2,-1142 # 80008040 <digits>
    800004be:	883a                	mv	a6,a4
    800004c0:	2705                	addiw	a4,a4,1
    800004c2:	02b577bb          	remuw	a5,a0,a1
    800004c6:	1782                	slli	a5,a5,0x20
    800004c8:	9381                	srli	a5,a5,0x20
    800004ca:	97b2                	add	a5,a5,a2
    800004cc:	0007c783          	lbu	a5,0(a5)
    800004d0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d4:	0005079b          	sext.w	a5,a0
    800004d8:	02b5553b          	divuw	a0,a0,a1
    800004dc:	0685                	addi	a3,a3,1
    800004de:	feb7f0e3          	bgeu	a5,a1,800004be <printint+0x26>

  if(sign)
    800004e2:	00088c63          	beqz	a7,800004fa <printint+0x62>
    buf[i++] = '-';
    800004e6:	fe070793          	addi	a5,a4,-32
    800004ea:	00878733          	add	a4,a5,s0
    800004ee:	02d00793          	li	a5,45
    800004f2:	fef70823          	sb	a5,-16(a4)
    800004f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fa:	02e05763          	blez	a4,80000528 <printint+0x90>
    800004fe:	fd040793          	addi	a5,s0,-48
    80000502:	00e784b3          	add	s1,a5,a4
    80000506:	fff78913          	addi	s2,a5,-1
    8000050a:	993a                	add	s2,s2,a4
    8000050c:	377d                	addiw	a4,a4,-1
    8000050e:	1702                	slli	a4,a4,0x20
    80000510:	9301                	srli	a4,a4,0x20
    80000512:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000516:	fff4c503          	lbu	a0,-1(s1)
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	d5e080e7          	jalr	-674(ra) # 80000278 <consputc>
  while(--i >= 0)
    80000522:	14fd                	addi	s1,s1,-1
    80000524:	ff2499e3          	bne	s1,s2,80000516 <printint+0x7e>
}
    80000528:	70a2                	ld	ra,40(sp)
    8000052a:	7402                	ld	s0,32(sp)
    8000052c:	64e2                	ld	s1,24(sp)
    8000052e:	6942                	ld	s2,16(sp)
    80000530:	6145                	addi	sp,sp,48
    80000532:	8082                	ret
    x = -xx;
    80000534:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000538:	4885                	li	a7,1
    x = -xx;
    8000053a:	bf95                	j	800004ae <printint+0x16>

000000008000053c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053c:	1101                	addi	sp,sp,-32
    8000053e:	ec06                	sd	ra,24(sp)
    80000540:	e822                	sd	s0,16(sp)
    80000542:	e426                	sd	s1,8(sp)
    80000544:	1000                	addi	s0,sp,32
    80000546:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000548:	00010797          	auipc	a5,0x10
    8000054c:	7607a423          	sw	zero,1896(a5) # 80010cb0 <pr+0x18>
  printf("panic: ");
    80000550:	00008517          	auipc	a0,0x8
    80000554:	ac850513          	addi	a0,a0,-1336 # 80008018 <etext+0x18>
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	02e080e7          	jalr	46(ra) # 80000586 <printf>
  printf(s);
    80000560:	8526                	mv	a0,s1
    80000562:	00000097          	auipc	ra,0x0
    80000566:	024080e7          	jalr	36(ra) # 80000586 <printf>
  printf("\n");
    8000056a:	00008517          	auipc	a0,0x8
    8000056e:	4ae50513          	addi	a0,a0,1198 # 80008a18 <syscalls+0x5a0>
    80000572:	00000097          	auipc	ra,0x0
    80000576:	014080e7          	jalr	20(ra) # 80000586 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057a:	4785                	li	a5,1
    8000057c:	00008717          	auipc	a4,0x8
    80000580:	4ef72a23          	sw	a5,1268(a4) # 80008a70 <panicked>
  for(;;)
    80000584:	a001                	j	80000584 <panic+0x48>

0000000080000586 <printf>:
{
    80000586:	7131                	addi	sp,sp,-192
    80000588:	fc86                	sd	ra,120(sp)
    8000058a:	f8a2                	sd	s0,112(sp)
    8000058c:	f4a6                	sd	s1,104(sp)
    8000058e:	f0ca                	sd	s2,96(sp)
    80000590:	ecce                	sd	s3,88(sp)
    80000592:	e8d2                	sd	s4,80(sp)
    80000594:	e4d6                	sd	s5,72(sp)
    80000596:	e0da                	sd	s6,64(sp)
    80000598:	fc5e                	sd	s7,56(sp)
    8000059a:	f862                	sd	s8,48(sp)
    8000059c:	f466                	sd	s9,40(sp)
    8000059e:	f06a                	sd	s10,32(sp)
    800005a0:	ec6e                	sd	s11,24(sp)
    800005a2:	0100                	addi	s0,sp,128
    800005a4:	8a2a                	mv	s4,a0
    800005a6:	e40c                	sd	a1,8(s0)
    800005a8:	e810                	sd	a2,16(s0)
    800005aa:	ec14                	sd	a3,24(s0)
    800005ac:	f018                	sd	a4,32(s0)
    800005ae:	f41c                	sd	a5,40(s0)
    800005b0:	03043823          	sd	a6,48(s0)
    800005b4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005b8:	00010d97          	auipc	s11,0x10
    800005bc:	6f8dad83          	lw	s11,1784(s11) # 80010cb0 <pr+0x18>
  if(locking)
    800005c0:	020d9b63          	bnez	s11,800005f6 <printf+0x70>
  if (fmt == 0)
    800005c4:	040a0263          	beqz	s4,80000608 <printf+0x82>
  va_start(ap, fmt);
    800005c8:	00840793          	addi	a5,s0,8
    800005cc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d0:	000a4503          	lbu	a0,0(s4)
    800005d4:	14050f63          	beqz	a0,80000732 <printf+0x1ac>
    800005d8:	4981                	li	s3,0
    if(c != '%'){
    800005da:	02500a93          	li	s5,37
    switch(c){
    800005de:	07000b93          	li	s7,112
  consputc('x');
    800005e2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e4:	00008b17          	auipc	s6,0x8
    800005e8:	a5cb0b13          	addi	s6,s6,-1444 # 80008040 <digits>
    switch(c){
    800005ec:	07300c93          	li	s9,115
    800005f0:	06400c13          	li	s8,100
    800005f4:	a82d                	j	8000062e <printf+0xa8>
    acquire(&pr.lock);
    800005f6:	00010517          	auipc	a0,0x10
    800005fa:	6a250513          	addi	a0,a0,1698 # 80010c98 <pr>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	5d4080e7          	jalr	1492(ra) # 80000bd2 <acquire>
    80000606:	bf7d                	j	800005c4 <printf+0x3e>
    panic("null fmt");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a2050513          	addi	a0,a0,-1504 # 80008028 <etext+0x28>
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2c080e7          	jalr	-212(ra) # 8000053c <panic>
      consputc(c);
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	c60080e7          	jalr	-928(ra) # 80000278 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000620:	2985                	addiw	s3,s3,1
    80000622:	013a07b3          	add	a5,s4,s3
    80000626:	0007c503          	lbu	a0,0(a5)
    8000062a:	10050463          	beqz	a0,80000732 <printf+0x1ac>
    if(c != '%'){
    8000062e:	ff5515e3          	bne	a0,s5,80000618 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000632:	2985                	addiw	s3,s3,1
    80000634:	013a07b3          	add	a5,s4,s3
    80000638:	0007c783          	lbu	a5,0(a5)
    8000063c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000640:	cbed                	beqz	a5,80000732 <printf+0x1ac>
    switch(c){
    80000642:	05778a63          	beq	a5,s7,80000696 <printf+0x110>
    80000646:	02fbf663          	bgeu	s7,a5,80000672 <printf+0xec>
    8000064a:	09978863          	beq	a5,s9,800006da <printf+0x154>
    8000064e:	07800713          	li	a4,120
    80000652:	0ce79563          	bne	a5,a4,8000071c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000656:	f8843783          	ld	a5,-120(s0)
    8000065a:	00878713          	addi	a4,a5,8
    8000065e:	f8e43423          	sd	a4,-120(s0)
    80000662:	4605                	li	a2,1
    80000664:	85ea                	mv	a1,s10
    80000666:	4388                	lw	a0,0(a5)
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	e30080e7          	jalr	-464(ra) # 80000498 <printint>
      break;
    80000670:	bf45                	j	80000620 <printf+0x9a>
    switch(c){
    80000672:	09578f63          	beq	a5,s5,80000710 <printf+0x18a>
    80000676:	0b879363          	bne	a5,s8,8000071c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067a:	f8843783          	ld	a5,-120(s0)
    8000067e:	00878713          	addi	a4,a5,8
    80000682:	f8e43423          	sd	a4,-120(s0)
    80000686:	4605                	li	a2,1
    80000688:	45a9                	li	a1,10
    8000068a:	4388                	lw	a0,0(a5)
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	e0c080e7          	jalr	-500(ra) # 80000498 <printint>
      break;
    80000694:	b771                	j	80000620 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	addi	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a6:	03000513          	li	a0,48
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	bce080e7          	jalr	-1074(ra) # 80000278 <consputc>
  consputc('x');
    800006b2:	07800513          	li	a0,120
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	bc2080e7          	jalr	-1086(ra) # 80000278 <consputc>
    800006be:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c0:	03c95793          	srli	a5,s2,0x3c
    800006c4:	97da                	add	a5,a5,s6
    800006c6:	0007c503          	lbu	a0,0(a5)
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	bae080e7          	jalr	-1106(ra) # 80000278 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d2:	0912                	slli	s2,s2,0x4
    800006d4:	34fd                	addiw	s1,s1,-1
    800006d6:	f4ed                	bnez	s1,800006c0 <printf+0x13a>
    800006d8:	b7a1                	j	80000620 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006da:	f8843783          	ld	a5,-120(s0)
    800006de:	00878713          	addi	a4,a5,8
    800006e2:	f8e43423          	sd	a4,-120(s0)
    800006e6:	6384                	ld	s1,0(a5)
    800006e8:	cc89                	beqz	s1,80000702 <printf+0x17c>
      for(; *s; s++)
    800006ea:	0004c503          	lbu	a0,0(s1)
    800006ee:	d90d                	beqz	a0,80000620 <printf+0x9a>
        consputc(*s);
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	b88080e7          	jalr	-1144(ra) # 80000278 <consputc>
      for(; *s; s++)
    800006f8:	0485                	addi	s1,s1,1
    800006fa:	0004c503          	lbu	a0,0(s1)
    800006fe:	f96d                	bnez	a0,800006f0 <printf+0x16a>
    80000700:	b705                	j	80000620 <printf+0x9a>
        s = "(null)";
    80000702:	00008497          	auipc	s1,0x8
    80000706:	91e48493          	addi	s1,s1,-1762 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070a:	02800513          	li	a0,40
    8000070e:	b7cd                	j	800006f0 <printf+0x16a>
      consputc('%');
    80000710:	8556                	mv	a0,s5
    80000712:	00000097          	auipc	ra,0x0
    80000716:	b66080e7          	jalr	-1178(ra) # 80000278 <consputc>
      break;
    8000071a:	b719                	j	80000620 <printf+0x9a>
      consputc('%');
    8000071c:	8556                	mv	a0,s5
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	b5a080e7          	jalr	-1190(ra) # 80000278 <consputc>
      consputc(c);
    80000726:	8526                	mv	a0,s1
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b50080e7          	jalr	-1200(ra) # 80000278 <consputc>
      break;
    80000730:	bdc5                	j	80000620 <printf+0x9a>
  if(locking)
    80000732:	020d9163          	bnez	s11,80000754 <printf+0x1ce>
}
    80000736:	70e6                	ld	ra,120(sp)
    80000738:	7446                	ld	s0,112(sp)
    8000073a:	74a6                	ld	s1,104(sp)
    8000073c:	7906                	ld	s2,96(sp)
    8000073e:	69e6                	ld	s3,88(sp)
    80000740:	6a46                	ld	s4,80(sp)
    80000742:	6aa6                	ld	s5,72(sp)
    80000744:	6b06                	ld	s6,64(sp)
    80000746:	7be2                	ld	s7,56(sp)
    80000748:	7c42                	ld	s8,48(sp)
    8000074a:	7ca2                	ld	s9,40(sp)
    8000074c:	7d02                	ld	s10,32(sp)
    8000074e:	6de2                	ld	s11,24(sp)
    80000750:	6129                	addi	sp,sp,192
    80000752:	8082                	ret
    release(&pr.lock);
    80000754:	00010517          	auipc	a0,0x10
    80000758:	54450513          	addi	a0,a0,1348 # 80010c98 <pr>
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	52a080e7          	jalr	1322(ra) # 80000c86 <release>
}
    80000764:	bfc9                	j	80000736 <printf+0x1b0>

0000000080000766 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000766:	1101                	addi	sp,sp,-32
    80000768:	ec06                	sd	ra,24(sp)
    8000076a:	e822                	sd	s0,16(sp)
    8000076c:	e426                	sd	s1,8(sp)
    8000076e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000770:	00010497          	auipc	s1,0x10
    80000774:	52848493          	addi	s1,s1,1320 # 80010c98 <pr>
    80000778:	00008597          	auipc	a1,0x8
    8000077c:	8c058593          	addi	a1,a1,-1856 # 80008038 <etext+0x38>
    80000780:	8526                	mv	a0,s1
    80000782:	00000097          	auipc	ra,0x0
    80000786:	3c0080e7          	jalr	960(ra) # 80000b42 <initlock>
  pr.locking = 1;
    8000078a:	4785                	li	a5,1
    8000078c:	cc9c                	sw	a5,24(s1)
}
    8000078e:	60e2                	ld	ra,24(sp)
    80000790:	6442                	ld	s0,16(sp)
    80000792:	64a2                	ld	s1,8(sp)
    80000794:	6105                	addi	sp,sp,32
    80000796:	8082                	ret

0000000080000798 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000798:	1141                	addi	sp,sp,-16
    8000079a:	e406                	sd	ra,8(sp)
    8000079c:	e022                	sd	s0,0(sp)
    8000079e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a0:	100007b7          	lui	a5,0x10000
    800007a4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007a8:	f8000713          	li	a4,-128
    800007ac:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b0:	470d                	li	a4,3
    800007b2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007ba:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007be:	469d                	li	a3,7
    800007c0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007c8:	00008597          	auipc	a1,0x8
    800007cc:	89058593          	addi	a1,a1,-1904 # 80008058 <digits+0x18>
    800007d0:	00010517          	auipc	a0,0x10
    800007d4:	4e850513          	addi	a0,a0,1256 # 80010cb8 <uart_tx_lock>
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	36a080e7          	jalr	874(ra) # 80000b42 <initlock>
}
    800007e0:	60a2                	ld	ra,8(sp)
    800007e2:	6402                	ld	s0,0(sp)
    800007e4:	0141                	addi	sp,sp,16
    800007e6:	8082                	ret

00000000800007e8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007e8:	1101                	addi	sp,sp,-32
    800007ea:	ec06                	sd	ra,24(sp)
    800007ec:	e822                	sd	s0,16(sp)
    800007ee:	e426                	sd	s1,8(sp)
    800007f0:	1000                	addi	s0,sp,32
    800007f2:	84aa                	mv	s1,a0
  push_off();
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	392080e7          	jalr	914(ra) # 80000b86 <push_off>

  if(panicked){
    800007fc:	00008797          	auipc	a5,0x8
    80000800:	2747a783          	lw	a5,628(a5) # 80008a70 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000804:	10000737          	lui	a4,0x10000
  if(panicked){
    80000808:	c391                	beqz	a5,8000080c <uartputc_sync+0x24>
    for(;;)
    8000080a:	a001                	j	8000080a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000810:	0207f793          	andi	a5,a5,32
    80000814:	dfe5                	beqz	a5,8000080c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000816:	0ff4f513          	zext.b	a0,s1
    8000081a:	100007b7          	lui	a5,0x10000
    8000081e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000822:	00000097          	auipc	ra,0x0
    80000826:	404080e7          	jalr	1028(ra) # 80000c26 <pop_off>
}
    8000082a:	60e2                	ld	ra,24(sp)
    8000082c:	6442                	ld	s0,16(sp)
    8000082e:	64a2                	ld	s1,8(sp)
    80000830:	6105                	addi	sp,sp,32
    80000832:	8082                	ret

0000000080000834 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000834:	00008797          	auipc	a5,0x8
    80000838:	2447b783          	ld	a5,580(a5) # 80008a78 <uart_tx_r>
    8000083c:	00008717          	auipc	a4,0x8
    80000840:	24473703          	ld	a4,580(a4) # 80008a80 <uart_tx_w>
    80000844:	06f70a63          	beq	a4,a5,800008b8 <uartstart+0x84>
{
    80000848:	7139                	addi	sp,sp,-64
    8000084a:	fc06                	sd	ra,56(sp)
    8000084c:	f822                	sd	s0,48(sp)
    8000084e:	f426                	sd	s1,40(sp)
    80000850:	f04a                	sd	s2,32(sp)
    80000852:	ec4e                	sd	s3,24(sp)
    80000854:	e852                	sd	s4,16(sp)
    80000856:	e456                	sd	s5,8(sp)
    80000858:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000085e:	00010a17          	auipc	s4,0x10
    80000862:	45aa0a13          	addi	s4,s4,1114 # 80010cb8 <uart_tx_lock>
    uart_tx_r += 1;
    80000866:	00008497          	auipc	s1,0x8
    8000086a:	21248493          	addi	s1,s1,530 # 80008a78 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000086e:	00008997          	auipc	s3,0x8
    80000872:	21298993          	addi	s3,s3,530 # 80008a80 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000876:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087a:	02077713          	andi	a4,a4,32
    8000087e:	c705                	beqz	a4,800008a6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000880:	01f7f713          	andi	a4,a5,31
    80000884:	9752                	add	a4,a4,s4
    80000886:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088a:	0785                	addi	a5,a5,1
    8000088c:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000088e:	8526                	mv	a0,s1
    80000890:	00002097          	auipc	ra,0x2
    80000894:	968080e7          	jalr	-1688(ra) # 800021f8 <wakeup>
    
    WriteReg(THR, c);
    80000898:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089c:	609c                	ld	a5,0(s1)
    8000089e:	0009b703          	ld	a4,0(s3)
    800008a2:	fcf71ae3          	bne	a4,a5,80000876 <uartstart+0x42>
  }
}
    800008a6:	70e2                	ld	ra,56(sp)
    800008a8:	7442                	ld	s0,48(sp)
    800008aa:	74a2                	ld	s1,40(sp)
    800008ac:	7902                	ld	s2,32(sp)
    800008ae:	69e2                	ld	s3,24(sp)
    800008b0:	6a42                	ld	s4,16(sp)
    800008b2:	6aa2                	ld	s5,8(sp)
    800008b4:	6121                	addi	sp,sp,64
    800008b6:	8082                	ret
    800008b8:	8082                	ret

00000000800008ba <uartputc>:
{
    800008ba:	7179                	addi	sp,sp,-48
    800008bc:	f406                	sd	ra,40(sp)
    800008be:	f022                	sd	s0,32(sp)
    800008c0:	ec26                	sd	s1,24(sp)
    800008c2:	e84a                	sd	s2,16(sp)
    800008c4:	e44e                	sd	s3,8(sp)
    800008c6:	e052                	sd	s4,0(sp)
    800008c8:	1800                	addi	s0,sp,48
    800008ca:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008cc:	00010517          	auipc	a0,0x10
    800008d0:	3ec50513          	addi	a0,a0,1004 # 80010cb8 <uart_tx_lock>
    800008d4:	00000097          	auipc	ra,0x0
    800008d8:	2fe080e7          	jalr	766(ra) # 80000bd2 <acquire>
  if(panicked){
    800008dc:	00008797          	auipc	a5,0x8
    800008e0:	1947a783          	lw	a5,404(a5) # 80008a70 <panicked>
    800008e4:	e7c9                	bnez	a5,8000096e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e6:	00008717          	auipc	a4,0x8
    800008ea:	19a73703          	ld	a4,410(a4) # 80008a80 <uart_tx_w>
    800008ee:	00008797          	auipc	a5,0x8
    800008f2:	18a7b783          	ld	a5,394(a5) # 80008a78 <uart_tx_r>
    800008f6:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fa:	00010997          	auipc	s3,0x10
    800008fe:	3be98993          	addi	s3,s3,958 # 80010cb8 <uart_tx_lock>
    80000902:	00008497          	auipc	s1,0x8
    80000906:	17648493          	addi	s1,s1,374 # 80008a78 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090a:	00008917          	auipc	s2,0x8
    8000090e:	17690913          	addi	s2,s2,374 # 80008a80 <uart_tx_w>
    80000912:	00e79f63          	bne	a5,a4,80000930 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000916:	85ce                	mv	a1,s3
    80000918:	8526                	mv	a0,s1
    8000091a:	00002097          	auipc	ra,0x2
    8000091e:	87a080e7          	jalr	-1926(ra) # 80002194 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000922:	00093703          	ld	a4,0(s2)
    80000926:	609c                	ld	a5,0(s1)
    80000928:	02078793          	addi	a5,a5,32
    8000092c:	fee785e3          	beq	a5,a4,80000916 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000930:	00010497          	auipc	s1,0x10
    80000934:	38848493          	addi	s1,s1,904 # 80010cb8 <uart_tx_lock>
    80000938:	01f77793          	andi	a5,a4,31
    8000093c:	97a6                	add	a5,a5,s1
    8000093e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000942:	0705                	addi	a4,a4,1
    80000944:	00008797          	auipc	a5,0x8
    80000948:	12e7be23          	sd	a4,316(a5) # 80008a80 <uart_tx_w>
  uartstart();
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	ee8080e7          	jalr	-280(ra) # 80000834 <uartstart>
  release(&uart_tx_lock);
    80000954:	8526                	mv	a0,s1
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	330080e7          	jalr	816(ra) # 80000c86 <release>
}
    8000095e:	70a2                	ld	ra,40(sp)
    80000960:	7402                	ld	s0,32(sp)
    80000962:	64e2                	ld	s1,24(sp)
    80000964:	6942                	ld	s2,16(sp)
    80000966:	69a2                	ld	s3,8(sp)
    80000968:	6a02                	ld	s4,0(sp)
    8000096a:	6145                	addi	sp,sp,48
    8000096c:	8082                	ret
    for(;;)
    8000096e:	a001                	j	8000096e <uartputc+0xb4>

0000000080000970 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000970:	1141                	addi	sp,sp,-16
    80000972:	e422                	sd	s0,8(sp)
    80000974:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000976:	100007b7          	lui	a5,0x10000
    8000097a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000097e:	8b85                	andi	a5,a5,1
    80000980:	cb81                	beqz	a5,80000990 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000982:	100007b7          	lui	a5,0x10000
    80000986:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098a:	6422                	ld	s0,8(sp)
    8000098c:	0141                	addi	sp,sp,16
    8000098e:	8082                	ret
    return -1;
    80000990:	557d                	li	a0,-1
    80000992:	bfe5                	j	8000098a <uartgetc+0x1a>

0000000080000994 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000994:	1101                	addi	sp,sp,-32
    80000996:	ec06                	sd	ra,24(sp)
    80000998:	e822                	sd	s0,16(sp)
    8000099a:	e426                	sd	s1,8(sp)
    8000099c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000099e:	54fd                	li	s1,-1
    800009a0:	a029                	j	800009aa <uartintr+0x16>
      break;
    consoleintr(c);
    800009a2:	00000097          	auipc	ra,0x0
    800009a6:	918080e7          	jalr	-1768(ra) # 800002ba <consoleintr>
    int c = uartgetc();
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	fc6080e7          	jalr	-58(ra) # 80000970 <uartgetc>
    if(c == -1)
    800009b2:	fe9518e3          	bne	a0,s1,800009a2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009b6:	00010497          	auipc	s1,0x10
    800009ba:	30248493          	addi	s1,s1,770 # 80010cb8 <uart_tx_lock>
    800009be:	8526                	mv	a0,s1
    800009c0:	00000097          	auipc	ra,0x0
    800009c4:	212080e7          	jalr	530(ra) # 80000bd2 <acquire>
  uartstart();
    800009c8:	00000097          	auipc	ra,0x0
    800009cc:	e6c080e7          	jalr	-404(ra) # 80000834 <uartstart>
  release(&uart_tx_lock);
    800009d0:	8526                	mv	a0,s1
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	2b4080e7          	jalr	692(ra) # 80000c86 <release>
}
    800009da:	60e2                	ld	ra,24(sp)
    800009dc:	6442                	ld	s0,16(sp)
    800009de:	64a2                	ld	s1,8(sp)
    800009e0:	6105                	addi	sp,sp,32
    800009e2:	8082                	ret

00000000800009e4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e4:	1101                	addi	sp,sp,-32
    800009e6:	ec06                	sd	ra,24(sp)
    800009e8:	e822                	sd	s0,16(sp)
    800009ea:	e426                	sd	s1,8(sp)
    800009ec:	e04a                	sd	s2,0(sp)
    800009ee:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f0:	03451793          	slli	a5,a0,0x34
    800009f4:	ebb9                	bnez	a5,80000a4a <kfree+0x66>
    800009f6:	84aa                	mv	s1,a0
    800009f8:	00199797          	auipc	a5,0x199
    800009fc:	d1878793          	addi	a5,a5,-744 # 80199710 <end>
    80000a00:	04f56563          	bltu	a0,a5,80000a4a <kfree+0x66>
    80000a04:	47c5                	li	a5,17
    80000a06:	07ee                	slli	a5,a5,0x1b
    80000a08:	04f57163          	bgeu	a0,a5,80000a4a <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a0c:	6605                	lui	a2,0x1
    80000a0e:	4585                	li	a1,1
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	2be080e7          	jalr	702(ra) # 80000cce <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a18:	00010917          	auipc	s2,0x10
    80000a1c:	2d890913          	addi	s2,s2,728 # 80010cf0 <kmem>
    80000a20:	854a                	mv	a0,s2
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	1b0080e7          	jalr	432(ra) # 80000bd2 <acquire>
  r->next = kmem.freelist;
    80000a2a:	01893783          	ld	a5,24(s2)
    80000a2e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a30:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a34:	854a                	mv	a0,s2
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	250080e7          	jalr	592(ra) # 80000c86 <release>
}
    80000a3e:	60e2                	ld	ra,24(sp)
    80000a40:	6442                	ld	s0,16(sp)
    80000a42:	64a2                	ld	s1,8(sp)
    80000a44:	6902                	ld	s2,0(sp)
    80000a46:	6105                	addi	sp,sp,32
    80000a48:	8082                	ret
    panic("kfree");
    80000a4a:	00007517          	auipc	a0,0x7
    80000a4e:	61650513          	addi	a0,a0,1558 # 80008060 <digits+0x20>
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	aea080e7          	jalr	-1302(ra) # 8000053c <panic>

0000000080000a5a <freerange>:
{
    80000a5a:	7179                	addi	sp,sp,-48
    80000a5c:	f406                	sd	ra,40(sp)
    80000a5e:	f022                	sd	s0,32(sp)
    80000a60:	ec26                	sd	s1,24(sp)
    80000a62:	e84a                	sd	s2,16(sp)
    80000a64:	e44e                	sd	s3,8(sp)
    80000a66:	e052                	sd	s4,0(sp)
    80000a68:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a6a:	6785                	lui	a5,0x1
    80000a6c:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a70:	00e504b3          	add	s1,a0,a4
    80000a74:	777d                	lui	a4,0xfffff
    80000a76:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a78:	94be                	add	s1,s1,a5
    80000a7a:	0095ee63          	bltu	a1,s1,80000a96 <freerange+0x3c>
    80000a7e:	892e                	mv	s2,a1
    kfree(p);
    80000a80:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a82:	6985                	lui	s3,0x1
    kfree(p);
    80000a84:	01448533          	add	a0,s1,s4
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	f5c080e7          	jalr	-164(ra) # 800009e4 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a90:	94ce                	add	s1,s1,s3
    80000a92:	fe9979e3          	bgeu	s2,s1,80000a84 <freerange+0x2a>
}
    80000a96:	70a2                	ld	ra,40(sp)
    80000a98:	7402                	ld	s0,32(sp)
    80000a9a:	64e2                	ld	s1,24(sp)
    80000a9c:	6942                	ld	s2,16(sp)
    80000a9e:	69a2                	ld	s3,8(sp)
    80000aa0:	6a02                	ld	s4,0(sp)
    80000aa2:	6145                	addi	sp,sp,48
    80000aa4:	8082                	ret

0000000080000aa6 <kinit>:
{
    80000aa6:	1141                	addi	sp,sp,-16
    80000aa8:	e406                	sd	ra,8(sp)
    80000aaa:	e022                	sd	s0,0(sp)
    80000aac:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aae:	00007597          	auipc	a1,0x7
    80000ab2:	5ba58593          	addi	a1,a1,1466 # 80008068 <digits+0x28>
    80000ab6:	00010517          	auipc	a0,0x10
    80000aba:	23a50513          	addi	a0,a0,570 # 80010cf0 <kmem>
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	084080e7          	jalr	132(ra) # 80000b42 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ac6:	45c5                	li	a1,17
    80000ac8:	05ee                	slli	a1,a1,0x1b
    80000aca:	00199517          	auipc	a0,0x199
    80000ace:	c4650513          	addi	a0,a0,-954 # 80199710 <end>
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	f88080e7          	jalr	-120(ra) # 80000a5a <freerange>
}
    80000ada:	60a2                	ld	ra,8(sp)
    80000adc:	6402                	ld	s0,0(sp)
    80000ade:	0141                	addi	sp,sp,16
    80000ae0:	8082                	ret

0000000080000ae2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae2:	1101                	addi	sp,sp,-32
    80000ae4:	ec06                	sd	ra,24(sp)
    80000ae6:	e822                	sd	s0,16(sp)
    80000ae8:	e426                	sd	s1,8(sp)
    80000aea:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000aec:	00010497          	auipc	s1,0x10
    80000af0:	20448493          	addi	s1,s1,516 # 80010cf0 <kmem>
    80000af4:	8526                	mv	a0,s1
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	0dc080e7          	jalr	220(ra) # 80000bd2 <acquire>
  r = kmem.freelist;
    80000afe:	6c84                	ld	s1,24(s1)
  if(r)
    80000b00:	c885                	beqz	s1,80000b30 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b02:	609c                	ld	a5,0(s1)
    80000b04:	00010517          	auipc	a0,0x10
    80000b08:	1ec50513          	addi	a0,a0,492 # 80010cf0 <kmem>
    80000b0c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	178080e7          	jalr	376(ra) # 80000c86 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b16:	6605                	lui	a2,0x1
    80000b18:	4595                	li	a1,5
    80000b1a:	8526                	mv	a0,s1
    80000b1c:	00000097          	auipc	ra,0x0
    80000b20:	1b2080e7          	jalr	434(ra) # 80000cce <memset>
  return (void*)r;
}
    80000b24:	8526                	mv	a0,s1
    80000b26:	60e2                	ld	ra,24(sp)
    80000b28:	6442                	ld	s0,16(sp)
    80000b2a:	64a2                	ld	s1,8(sp)
    80000b2c:	6105                	addi	sp,sp,32
    80000b2e:	8082                	ret
  release(&kmem.lock);
    80000b30:	00010517          	auipc	a0,0x10
    80000b34:	1c050513          	addi	a0,a0,448 # 80010cf0 <kmem>
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	14e080e7          	jalr	334(ra) # 80000c86 <release>
  if(r)
    80000b40:	b7d5                	j	80000b24 <kalloc+0x42>

0000000080000b42 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b42:	1141                	addi	sp,sp,-16
    80000b44:	e422                	sd	s0,8(sp)
    80000b46:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b48:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b4a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b4e:	00053823          	sd	zero,16(a0)
}
    80000b52:	6422                	ld	s0,8(sp)
    80000b54:	0141                	addi	sp,sp,16
    80000b56:	8082                	ret

0000000080000b58 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b58:	411c                	lw	a5,0(a0)
    80000b5a:	e399                	bnez	a5,80000b60 <holding+0x8>
    80000b5c:	4501                	li	a0,0
  return r;
}
    80000b5e:	8082                	ret
{
    80000b60:	1101                	addi	sp,sp,-32
    80000b62:	ec06                	sd	ra,24(sp)
    80000b64:	e822                	sd	s0,16(sp)
    80000b66:	e426                	sd	s1,8(sp)
    80000b68:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b6a:	6904                	ld	s1,16(a0)
    80000b6c:	00001097          	auipc	ra,0x1
    80000b70:	e5a080e7          	jalr	-422(ra) # 800019c6 <mycpu>
    80000b74:	40a48533          	sub	a0,s1,a0
    80000b78:	00153513          	seqz	a0,a0
}
    80000b7c:	60e2                	ld	ra,24(sp)
    80000b7e:	6442                	ld	s0,16(sp)
    80000b80:	64a2                	ld	s1,8(sp)
    80000b82:	6105                	addi	sp,sp,32
    80000b84:	8082                	ret

0000000080000b86 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b86:	1101                	addi	sp,sp,-32
    80000b88:	ec06                	sd	ra,24(sp)
    80000b8a:	e822                	sd	s0,16(sp)
    80000b8c:	e426                	sd	s1,8(sp)
    80000b8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b90:	100024f3          	csrr	s1,sstatus
    80000b94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b98:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b9a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b9e:	00001097          	auipc	ra,0x1
    80000ba2:	e28080e7          	jalr	-472(ra) # 800019c6 <mycpu>
    80000ba6:	5d3c                	lw	a5,120(a0)
    80000ba8:	cf89                	beqz	a5,80000bc2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000baa:	00001097          	auipc	ra,0x1
    80000bae:	e1c080e7          	jalr	-484(ra) # 800019c6 <mycpu>
    80000bb2:	5d3c                	lw	a5,120(a0)
    80000bb4:	2785                	addiw	a5,a5,1
    80000bb6:	dd3c                	sw	a5,120(a0)
}
    80000bb8:	60e2                	ld	ra,24(sp)
    80000bba:	6442                	ld	s0,16(sp)
    80000bbc:	64a2                	ld	s1,8(sp)
    80000bbe:	6105                	addi	sp,sp,32
    80000bc0:	8082                	ret
    mycpu()->intena = old;
    80000bc2:	00001097          	auipc	ra,0x1
    80000bc6:	e04080e7          	jalr	-508(ra) # 800019c6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bca:	8085                	srli	s1,s1,0x1
    80000bcc:	8885                	andi	s1,s1,1
    80000bce:	dd64                	sw	s1,124(a0)
    80000bd0:	bfe9                	j	80000baa <push_off+0x24>

0000000080000bd2 <acquire>:
{
    80000bd2:	1101                	addi	sp,sp,-32
    80000bd4:	ec06                	sd	ra,24(sp)
    80000bd6:	e822                	sd	s0,16(sp)
    80000bd8:	e426                	sd	s1,8(sp)
    80000bda:	1000                	addi	s0,sp,32
    80000bdc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bde:	00000097          	auipc	ra,0x0
    80000be2:	fa8080e7          	jalr	-88(ra) # 80000b86 <push_off>
  if(holding(lk))
    80000be6:	8526                	mv	a0,s1
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	f70080e7          	jalr	-144(ra) # 80000b58 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf0:	4705                	li	a4,1
  if(holding(lk))
    80000bf2:	e115                	bnez	a0,80000c16 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf4:	87ba                	mv	a5,a4
    80000bf6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfa:	2781                	sext.w	a5,a5
    80000bfc:	ffe5                	bnez	a5,80000bf4 <acquire+0x22>
  __sync_synchronize();
    80000bfe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c02:	00001097          	auipc	ra,0x1
    80000c06:	dc4080e7          	jalr	-572(ra) # 800019c6 <mycpu>
    80000c0a:	e888                	sd	a0,16(s1)
}
    80000c0c:	60e2                	ld	ra,24(sp)
    80000c0e:	6442                	ld	s0,16(sp)
    80000c10:	64a2                	ld	s1,8(sp)
    80000c12:	6105                	addi	sp,sp,32
    80000c14:	8082                	ret
    panic("acquire");
    80000c16:	00007517          	auipc	a0,0x7
    80000c1a:	45a50513          	addi	a0,a0,1114 # 80008070 <digits+0x30>
    80000c1e:	00000097          	auipc	ra,0x0
    80000c22:	91e080e7          	jalr	-1762(ra) # 8000053c <panic>

0000000080000c26 <pop_off>:

void
pop_off(void)
{
    80000c26:	1141                	addi	sp,sp,-16
    80000c28:	e406                	sd	ra,8(sp)
    80000c2a:	e022                	sd	s0,0(sp)
    80000c2c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c2e:	00001097          	auipc	ra,0x1
    80000c32:	d98080e7          	jalr	-616(ra) # 800019c6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c36:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c3a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c3c:	e78d                	bnez	a5,80000c66 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c3e:	5d3c                	lw	a5,120(a0)
    80000c40:	02f05b63          	blez	a5,80000c76 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c44:	37fd                	addiw	a5,a5,-1
    80000c46:	0007871b          	sext.w	a4,a5
    80000c4a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c4c:	eb09                	bnez	a4,80000c5e <pop_off+0x38>
    80000c4e:	5d7c                	lw	a5,124(a0)
    80000c50:	c799                	beqz	a5,80000c5e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c56:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c5a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c5e:	60a2                	ld	ra,8(sp)
    80000c60:	6402                	ld	s0,0(sp)
    80000c62:	0141                	addi	sp,sp,16
    80000c64:	8082                	ret
    panic("pop_off - interruptible");
    80000c66:	00007517          	auipc	a0,0x7
    80000c6a:	41250513          	addi	a0,a0,1042 # 80008078 <digits+0x38>
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	8ce080e7          	jalr	-1842(ra) # 8000053c <panic>
    panic("pop_off");
    80000c76:	00007517          	auipc	a0,0x7
    80000c7a:	41a50513          	addi	a0,a0,1050 # 80008090 <digits+0x50>
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	8be080e7          	jalr	-1858(ra) # 8000053c <panic>

0000000080000c86 <release>:
{
    80000c86:	1101                	addi	sp,sp,-32
    80000c88:	ec06                	sd	ra,24(sp)
    80000c8a:	e822                	sd	s0,16(sp)
    80000c8c:	e426                	sd	s1,8(sp)
    80000c8e:	1000                	addi	s0,sp,32
    80000c90:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c92:	00000097          	auipc	ra,0x0
    80000c96:	ec6080e7          	jalr	-314(ra) # 80000b58 <holding>
    80000c9a:	c115                	beqz	a0,80000cbe <release+0x38>
  lk->cpu = 0;
    80000c9c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca4:	0f50000f          	fence	iorw,ow
    80000ca8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	f7a080e7          	jalr	-134(ra) # 80000c26 <pop_off>
}
    80000cb4:	60e2                	ld	ra,24(sp)
    80000cb6:	6442                	ld	s0,16(sp)
    80000cb8:	64a2                	ld	s1,8(sp)
    80000cba:	6105                	addi	sp,sp,32
    80000cbc:	8082                	ret
    panic("release");
    80000cbe:	00007517          	auipc	a0,0x7
    80000cc2:	3da50513          	addi	a0,a0,986 # 80008098 <digits+0x58>
    80000cc6:	00000097          	auipc	ra,0x0
    80000cca:	876080e7          	jalr	-1930(ra) # 8000053c <panic>

0000000080000cce <memset>:
    80000cce:	1141                	addi	sp,sp,-16
    80000cd0:	e422                	sd	s0,8(sp)
    80000cd2:	0800                	addi	s0,sp,16
    80000cd4:	ca19                	beqz	a2,80000cea <memset+0x1c>
    80000cd6:	87aa                	mv	a5,a0
    80000cd8:	1602                	slli	a2,a2,0x20
    80000cda:	9201                	srli	a2,a2,0x20
    80000cdc:	00a60733          	add	a4,a2,a0
    80000ce0:	00b78023          	sb	a1,0(a5)
    80000ce4:	0785                	addi	a5,a5,1
    80000ce6:	fee79de3          	bne	a5,a4,80000ce0 <memset+0x12>
    80000cea:	6422                	ld	s0,8(sp)
    80000cec:	0141                	addi	sp,sp,16
    80000cee:	8082                	ret

0000000080000cf0 <memcmp>:
    80000cf0:	1141                	addi	sp,sp,-16
    80000cf2:	e422                	sd	s0,8(sp)
    80000cf4:	0800                	addi	s0,sp,16
    80000cf6:	ca05                	beqz	a2,80000d26 <memcmp+0x36>
    80000cf8:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cfc:	1682                	slli	a3,a3,0x20
    80000cfe:	9281                	srli	a3,a3,0x20
    80000d00:	0685                	addi	a3,a3,1
    80000d02:	96aa                	add	a3,a3,a0
    80000d04:	00054783          	lbu	a5,0(a0)
    80000d08:	0005c703          	lbu	a4,0(a1)
    80000d0c:	00e79863          	bne	a5,a4,80000d1c <memcmp+0x2c>
    80000d10:	0505                	addi	a0,a0,1
    80000d12:	0585                	addi	a1,a1,1
    80000d14:	fed518e3          	bne	a0,a3,80000d04 <memcmp+0x14>
    80000d18:	4501                	li	a0,0
    80000d1a:	a019                	j	80000d20 <memcmp+0x30>
    80000d1c:	40e7853b          	subw	a0,a5,a4
    80000d20:	6422                	ld	s0,8(sp)
    80000d22:	0141                	addi	sp,sp,16
    80000d24:	8082                	ret
    80000d26:	4501                	li	a0,0
    80000d28:	bfe5                	j	80000d20 <memcmp+0x30>

0000000080000d2a <memmove>:
    80000d2a:	1141                	addi	sp,sp,-16
    80000d2c:	e422                	sd	s0,8(sp)
    80000d2e:	0800                	addi	s0,sp,16
    80000d30:	c205                	beqz	a2,80000d50 <memmove+0x26>
    80000d32:	02a5e263          	bltu	a1,a0,80000d56 <memmove+0x2c>
    80000d36:	1602                	slli	a2,a2,0x20
    80000d38:	9201                	srli	a2,a2,0x20
    80000d3a:	00c587b3          	add	a5,a1,a2
    80000d3e:	872a                	mv	a4,a0
    80000d40:	0585                	addi	a1,a1,1
    80000d42:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fe658f1>
    80000d44:	fff5c683          	lbu	a3,-1(a1)
    80000d48:	fed70fa3          	sb	a3,-1(a4)
    80000d4c:	fef59ae3          	bne	a1,a5,80000d40 <memmove+0x16>
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	addi	sp,sp,16
    80000d54:	8082                	ret
    80000d56:	02061693          	slli	a3,a2,0x20
    80000d5a:	9281                	srli	a3,a3,0x20
    80000d5c:	00d58733          	add	a4,a1,a3
    80000d60:	fce57be3          	bgeu	a0,a4,80000d36 <memmove+0xc>
    80000d64:	96aa                	add	a3,a3,a0
    80000d66:	fff6079b          	addiw	a5,a2,-1
    80000d6a:	1782                	slli	a5,a5,0x20
    80000d6c:	9381                	srli	a5,a5,0x20
    80000d6e:	fff7c793          	not	a5,a5
    80000d72:	97ba                	add	a5,a5,a4
    80000d74:	177d                	addi	a4,a4,-1
    80000d76:	16fd                	addi	a3,a3,-1
    80000d78:	00074603          	lbu	a2,0(a4)
    80000d7c:	00c68023          	sb	a2,0(a3)
    80000d80:	fee79ae3          	bne	a5,a4,80000d74 <memmove+0x4a>
    80000d84:	b7f1                	j	80000d50 <memmove+0x26>

0000000080000d86 <memcpy>:
    80000d86:	1141                	addi	sp,sp,-16
    80000d88:	e406                	sd	ra,8(sp)
    80000d8a:	e022                	sd	s0,0(sp)
    80000d8c:	0800                	addi	s0,sp,16
    80000d8e:	00000097          	auipc	ra,0x0
    80000d92:	f9c080e7          	jalr	-100(ra) # 80000d2a <memmove>
    80000d96:	60a2                	ld	ra,8(sp)
    80000d98:	6402                	ld	s0,0(sp)
    80000d9a:	0141                	addi	sp,sp,16
    80000d9c:	8082                	ret

0000000080000d9e <strncmp>:
    80000d9e:	1141                	addi	sp,sp,-16
    80000da0:	e422                	sd	s0,8(sp)
    80000da2:	0800                	addi	s0,sp,16
    80000da4:	ce11                	beqz	a2,80000dc0 <strncmp+0x22>
    80000da6:	00054783          	lbu	a5,0(a0)
    80000daa:	cf89                	beqz	a5,80000dc4 <strncmp+0x26>
    80000dac:	0005c703          	lbu	a4,0(a1)
    80000db0:	00f71a63          	bne	a4,a5,80000dc4 <strncmp+0x26>
    80000db4:	367d                	addiw	a2,a2,-1
    80000db6:	0505                	addi	a0,a0,1
    80000db8:	0585                	addi	a1,a1,1
    80000dba:	f675                	bnez	a2,80000da6 <strncmp+0x8>
    80000dbc:	4501                	li	a0,0
    80000dbe:	a809                	j	80000dd0 <strncmp+0x32>
    80000dc0:	4501                	li	a0,0
    80000dc2:	a039                	j	80000dd0 <strncmp+0x32>
    80000dc4:	ca09                	beqz	a2,80000dd6 <strncmp+0x38>
    80000dc6:	00054503          	lbu	a0,0(a0)
    80000dca:	0005c783          	lbu	a5,0(a1)
    80000dce:	9d1d                	subw	a0,a0,a5
    80000dd0:	6422                	ld	s0,8(sp)
    80000dd2:	0141                	addi	sp,sp,16
    80000dd4:	8082                	ret
    80000dd6:	4501                	li	a0,0
    80000dd8:	bfe5                	j	80000dd0 <strncmp+0x32>

0000000080000dda <strncpy>:
    80000dda:	1141                	addi	sp,sp,-16
    80000ddc:	e422                	sd	s0,8(sp)
    80000dde:	0800                	addi	s0,sp,16
    80000de0:	87aa                	mv	a5,a0
    80000de2:	86b2                	mv	a3,a2
    80000de4:	367d                	addiw	a2,a2,-1
    80000de6:	00d05963          	blez	a3,80000df8 <strncpy+0x1e>
    80000dea:	0785                	addi	a5,a5,1
    80000dec:	0005c703          	lbu	a4,0(a1)
    80000df0:	fee78fa3          	sb	a4,-1(a5)
    80000df4:	0585                	addi	a1,a1,1
    80000df6:	f775                	bnez	a4,80000de2 <strncpy+0x8>
    80000df8:	873e                	mv	a4,a5
    80000dfa:	9fb5                	addw	a5,a5,a3
    80000dfc:	37fd                	addiw	a5,a5,-1
    80000dfe:	00c05963          	blez	a2,80000e10 <strncpy+0x36>
    80000e02:	0705                	addi	a4,a4,1
    80000e04:	fe070fa3          	sb	zero,-1(a4)
    80000e08:	40e786bb          	subw	a3,a5,a4
    80000e0c:	fed04be3          	bgtz	a3,80000e02 <strncpy+0x28>
    80000e10:	6422                	ld	s0,8(sp)
    80000e12:	0141                	addi	sp,sp,16
    80000e14:	8082                	ret

0000000080000e16 <safestrcpy>:
    80000e16:	1141                	addi	sp,sp,-16
    80000e18:	e422                	sd	s0,8(sp)
    80000e1a:	0800                	addi	s0,sp,16
    80000e1c:	02c05363          	blez	a2,80000e42 <safestrcpy+0x2c>
    80000e20:	fff6069b          	addiw	a3,a2,-1
    80000e24:	1682                	slli	a3,a3,0x20
    80000e26:	9281                	srli	a3,a3,0x20
    80000e28:	96ae                	add	a3,a3,a1
    80000e2a:	87aa                	mv	a5,a0
    80000e2c:	00d58963          	beq	a1,a3,80000e3e <safestrcpy+0x28>
    80000e30:	0585                	addi	a1,a1,1
    80000e32:	0785                	addi	a5,a5,1
    80000e34:	fff5c703          	lbu	a4,-1(a1)
    80000e38:	fee78fa3          	sb	a4,-1(a5)
    80000e3c:	fb65                	bnez	a4,80000e2c <safestrcpy+0x16>
    80000e3e:	00078023          	sb	zero,0(a5)
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <strlen>:
    80000e48:	1141                	addi	sp,sp,-16
    80000e4a:	e422                	sd	s0,8(sp)
    80000e4c:	0800                	addi	s0,sp,16
    80000e4e:	00054783          	lbu	a5,0(a0)
    80000e52:	cf91                	beqz	a5,80000e6e <strlen+0x26>
    80000e54:	0505                	addi	a0,a0,1
    80000e56:	87aa                	mv	a5,a0
    80000e58:	86be                	mv	a3,a5
    80000e5a:	0785                	addi	a5,a5,1
    80000e5c:	fff7c703          	lbu	a4,-1(a5)
    80000e60:	ff65                	bnez	a4,80000e58 <strlen+0x10>
    80000e62:	40a6853b          	subw	a0,a3,a0
    80000e66:	2505                	addiw	a0,a0,1
    80000e68:	6422                	ld	s0,8(sp)
    80000e6a:	0141                	addi	sp,sp,16
    80000e6c:	8082                	ret
    80000e6e:	4501                	li	a0,0
    80000e70:	bfe5                	j	80000e68 <strlen+0x20>

0000000080000e72 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e72:	1141                	addi	sp,sp,-16
    80000e74:	e406                	sd	ra,8(sp)
    80000e76:	e022                	sd	s0,0(sp)
    80000e78:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e7a:	00001097          	auipc	ra,0x1
    80000e7e:	b3c080e7          	jalr	-1220(ra) # 800019b6 <cpuid>

    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e82:	00008717          	auipc	a4,0x8
    80000e86:	c0670713          	addi	a4,a4,-1018 # 80008a88 <started>
  if(cpuid() == 0){
    80000e8a:	c139                	beqz	a0,80000ed0 <main+0x5e>
    while(started == 0)
    80000e8c:	431c                	lw	a5,0(a4)
    80000e8e:	2781                	sext.w	a5,a5
    80000e90:	dff5                	beqz	a5,80000e8c <main+0x1a>
      ;
    __sync_synchronize();
    80000e92:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e96:	00001097          	auipc	ra,0x1
    80000e9a:	b20080e7          	jalr	-1248(ra) # 800019b6 <cpuid>
    80000e9e:	85aa                	mv	a1,a0
    80000ea0:	00007517          	auipc	a0,0x7
    80000ea4:	21850513          	addi	a0,a0,536 # 800080b8 <digits+0x78>
    80000ea8:	fffff097          	auipc	ra,0xfffff
    80000eac:	6de080e7          	jalr	1758(ra) # 80000586 <printf>
    kvminithart();    // turn on paging
    80000eb0:	00000097          	auipc	ra,0x0
    80000eb4:	0e0080e7          	jalr	224(ra) # 80000f90 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	8ee080e7          	jalr	-1810(ra) # 800027a6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	eb0080e7          	jalr	-336(ra) # 80005d70 <plicinithart>
  }

  scheduler();        
    80000ec8:	00001097          	auipc	ra,0x1
    80000ecc:	114080e7          	jalr	276(ra) # 80001fdc <scheduler>
    consoleinit();
    80000ed0:	fffff097          	auipc	ra,0xfffff
    80000ed4:	57c080e7          	jalr	1404(ra) # 8000044c <consoleinit>
    printfinit();
    80000ed8:	00000097          	auipc	ra,0x0
    80000edc:	88e080e7          	jalr	-1906(ra) # 80000766 <printfinit>
    printf("\n");
    80000ee0:	00008517          	auipc	a0,0x8
    80000ee4:	b3850513          	addi	a0,a0,-1224 # 80008a18 <syscalls+0x5a0>
    80000ee8:	fffff097          	auipc	ra,0xfffff
    80000eec:	69e080e7          	jalr	1694(ra) # 80000586 <printf>
    printf("xv6 kernel is booting\n");
    80000ef0:	00007517          	auipc	a0,0x7
    80000ef4:	1b050513          	addi	a0,a0,432 # 800080a0 <digits+0x60>
    80000ef8:	fffff097          	auipc	ra,0xfffff
    80000efc:	68e080e7          	jalr	1678(ra) # 80000586 <printf>
    printf("\n");
    80000f00:	00008517          	auipc	a0,0x8
    80000f04:	b1850513          	addi	a0,a0,-1256 # 80008a18 <syscalls+0x5a0>
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	67e080e7          	jalr	1662(ra) # 80000586 <printf>
    kinit();         // physical page allocator
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	b96080e7          	jalr	-1130(ra) # 80000aa6 <kinit>
    kvminit();       // create kernel page table
    80000f18:	00000097          	auipc	ra,0x0
    80000f1c:	32e080e7          	jalr	814(ra) # 80001246 <kvminit>
    kvminithart();   // turn on paging
    80000f20:	00000097          	auipc	ra,0x0
    80000f24:	070080e7          	jalr	112(ra) # 80000f90 <kvminithart>
    procinit();      // process table
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	9d2080e7          	jalr	-1582(ra) # 800018fa <procinit>
    trapinit();      // trap vectors
    80000f30:	00002097          	auipc	ra,0x2
    80000f34:	84e080e7          	jalr	-1970(ra) # 8000277e <trapinit>
    trapinithart();  // install kernel trap vector
    80000f38:	00002097          	auipc	ra,0x2
    80000f3c:	86e080e7          	jalr	-1938(ra) # 800027a6 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	e1a080e7          	jalr	-486(ra) # 80005d5a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	e28080e7          	jalr	-472(ra) # 80005d70 <plicinithart>
    binit();         // buffer cache
    80000f50:	00002097          	auipc	ra,0x2
    80000f54:	fb4080e7          	jalr	-76(ra) # 80002f04 <binit>
    iinit();         // inode table
    80000f58:	00002097          	auipc	ra,0x2
    80000f5c:	652080e7          	jalr	1618(ra) # 800035aa <iinit>
    fileinit();      // file table
    80000f60:	00003097          	auipc	ra,0x3
    80000f64:	5c8080e7          	jalr	1480(ra) # 80004528 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f68:	00005097          	auipc	ra,0x5
    80000f6c:	f10080e7          	jalr	-240(ra) # 80005e78 <virtio_disk_init>
    init_psa_regions();
    80000f70:	00005097          	auipc	ra,0x5
    80000f74:	420080e7          	jalr	1056(ra) # 80006390 <init_psa_regions>
    userinit();      // first user process
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	d86080e7          	jalr	-634(ra) # 80001cfe <userinit>
    __sync_synchronize();
    80000f80:	0ff0000f          	fence
    started = 1;
    80000f84:	4785                	li	a5,1
    80000f86:	00008717          	auipc	a4,0x8
    80000f8a:	b0f72123          	sw	a5,-1278(a4) # 80008a88 <started>
    80000f8e:	bf2d                	j	80000ec8 <main+0x56>

0000000080000f90 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f90:	1141                	addi	sp,sp,-16
    80000f92:	e422                	sd	s0,8(sp)
    80000f94:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f96:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f9a:	00008797          	auipc	a5,0x8
    80000f9e:	af67b783          	ld	a5,-1290(a5) # 80008a90 <kernel_pagetable>
    80000fa2:	83b1                	srli	a5,a5,0xc
    80000fa4:	577d                	li	a4,-1
    80000fa6:	177e                	slli	a4,a4,0x3f
    80000fa8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000faa:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000fae:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000fb2:	6422                	ld	s0,8(sp)
    80000fb4:	0141                	addi	sp,sp,16
    80000fb6:	8082                	ret

0000000080000fb8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb8:	7139                	addi	sp,sp,-64
    80000fba:	fc06                	sd	ra,56(sp)
    80000fbc:	f822                	sd	s0,48(sp)
    80000fbe:	f426                	sd	s1,40(sp)
    80000fc0:	f04a                	sd	s2,32(sp)
    80000fc2:	ec4e                	sd	s3,24(sp)
    80000fc4:	e852                	sd	s4,16(sp)
    80000fc6:	e456                	sd	s5,8(sp)
    80000fc8:	e05a                	sd	s6,0(sp)
    80000fca:	0080                	addi	s0,sp,64
    80000fcc:	84aa                	mv	s1,a0
    80000fce:	89ae                	mv	s3,a1
    80000fd0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fd2:	57fd                	li	a5,-1
    80000fd4:	83e9                	srli	a5,a5,0x1a
    80000fd6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd8:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fda:	04b7f263          	bgeu	a5,a1,8000101e <walk+0x66>
    panic("walk");
    80000fde:	00007517          	auipc	a0,0x7
    80000fe2:	0f250513          	addi	a0,a0,242 # 800080d0 <digits+0x90>
    80000fe6:	fffff097          	auipc	ra,0xfffff
    80000fea:	556080e7          	jalr	1366(ra) # 8000053c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fee:	060a8663          	beqz	s5,8000105a <walk+0xa2>
    80000ff2:	00000097          	auipc	ra,0x0
    80000ff6:	af0080e7          	jalr	-1296(ra) # 80000ae2 <kalloc>
    80000ffa:	84aa                	mv	s1,a0
    80000ffc:	c529                	beqz	a0,80001046 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ffe:	6605                	lui	a2,0x1
    80001000:	4581                	li	a1,0
    80001002:	00000097          	auipc	ra,0x0
    80001006:	ccc080e7          	jalr	-820(ra) # 80000cce <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000100a:	00c4d793          	srli	a5,s1,0xc
    8000100e:	07aa                	slli	a5,a5,0xa
    80001010:	0017e793          	ori	a5,a5,1
    80001014:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001018:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7fe658e7>
    8000101a:	036a0063          	beq	s4,s6,8000103a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000101e:	0149d933          	srl	s2,s3,s4
    80001022:	1ff97913          	andi	s2,s2,511
    80001026:	090e                	slli	s2,s2,0x3
    80001028:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000102a:	00093483          	ld	s1,0(s2)
    8000102e:	0014f793          	andi	a5,s1,1
    80001032:	dfd5                	beqz	a5,80000fee <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001034:	80a9                	srli	s1,s1,0xa
    80001036:	04b2                	slli	s1,s1,0xc
    80001038:	b7c5                	j	80001018 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000103a:	00c9d513          	srli	a0,s3,0xc
    8000103e:	1ff57513          	andi	a0,a0,511
    80001042:	050e                	slli	a0,a0,0x3
    80001044:	9526                	add	a0,a0,s1
}
    80001046:	70e2                	ld	ra,56(sp)
    80001048:	7442                	ld	s0,48(sp)
    8000104a:	74a2                	ld	s1,40(sp)
    8000104c:	7902                	ld	s2,32(sp)
    8000104e:	69e2                	ld	s3,24(sp)
    80001050:	6a42                	ld	s4,16(sp)
    80001052:	6aa2                	ld	s5,8(sp)
    80001054:	6b02                	ld	s6,0(sp)
    80001056:	6121                	addi	sp,sp,64
    80001058:	8082                	ret
        return 0;
    8000105a:	4501                	li	a0,0
    8000105c:	b7ed                	j	80001046 <walk+0x8e>

000000008000105e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000105e:	57fd                	li	a5,-1
    80001060:	83e9                	srli	a5,a5,0x1a
    80001062:	00b7f463          	bgeu	a5,a1,8000106a <walkaddr+0xc>
    return 0;
    80001066:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001068:	8082                	ret
{
    8000106a:	1141                	addi	sp,sp,-16
    8000106c:	e406                	sd	ra,8(sp)
    8000106e:	e022                	sd	s0,0(sp)
    80001070:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001072:	4601                	li	a2,0
    80001074:	00000097          	auipc	ra,0x0
    80001078:	f44080e7          	jalr	-188(ra) # 80000fb8 <walk>
  if(pte == 0)
    8000107c:	c105                	beqz	a0,8000109c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000107e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001080:	0117f693          	andi	a3,a5,17
    80001084:	4745                	li	a4,17
    return 0;
    80001086:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001088:	00e68663          	beq	a3,a4,80001094 <walkaddr+0x36>
}
    8000108c:	60a2                	ld	ra,8(sp)
    8000108e:	6402                	ld	s0,0(sp)
    80001090:	0141                	addi	sp,sp,16
    80001092:	8082                	ret
  pa = PTE2PA(*pte);
    80001094:	83a9                	srli	a5,a5,0xa
    80001096:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000109a:	bfcd                	j	8000108c <walkaddr+0x2e>
    return 0;
    8000109c:	4501                	li	a0,0
    8000109e:	b7fd                	j	8000108c <walkaddr+0x2e>

00000000800010a0 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010a0:	715d                	addi	sp,sp,-80
    800010a2:	e486                	sd	ra,72(sp)
    800010a4:	e0a2                	sd	s0,64(sp)
    800010a6:	fc26                	sd	s1,56(sp)
    800010a8:	f84a                	sd	s2,48(sp)
    800010aa:	f44e                	sd	s3,40(sp)
    800010ac:	f052                	sd	s4,32(sp)
    800010ae:	ec56                	sd	s5,24(sp)
    800010b0:	e85a                	sd	s6,16(sp)
    800010b2:	e45e                	sd	s7,8(sp)
    800010b4:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010b6:	c639                	beqz	a2,80001104 <mappages+0x64>
    800010b8:	8aaa                	mv	s5,a0
    800010ba:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010bc:	777d                	lui	a4,0xfffff
    800010be:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010c2:	fff58993          	addi	s3,a1,-1
    800010c6:	99b2                	add	s3,s3,a2
    800010c8:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010cc:	893e                	mv	s2,a5
    800010ce:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010d2:	6b85                	lui	s7,0x1
    800010d4:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d8:	4605                	li	a2,1
    800010da:	85ca                	mv	a1,s2
    800010dc:	8556                	mv	a0,s5
    800010de:	00000097          	auipc	ra,0x0
    800010e2:	eda080e7          	jalr	-294(ra) # 80000fb8 <walk>
    800010e6:	cd1d                	beqz	a0,80001124 <mappages+0x84>
    if(*pte & PTE_V)
    800010e8:	611c                	ld	a5,0(a0)
    800010ea:	8b85                	andi	a5,a5,1
    800010ec:	e785                	bnez	a5,80001114 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010ee:	80b1                	srli	s1,s1,0xc
    800010f0:	04aa                	slli	s1,s1,0xa
    800010f2:	0164e4b3          	or	s1,s1,s6
    800010f6:	0014e493          	ori	s1,s1,1
    800010fa:	e104                	sd	s1,0(a0)
    if(a == last)
    800010fc:	05390063          	beq	s2,s3,8000113c <mappages+0x9c>
    a += PGSIZE;
    80001100:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001102:	bfc9                	j	800010d4 <mappages+0x34>
    panic("mappages: size");
    80001104:	00007517          	auipc	a0,0x7
    80001108:	fd450513          	addi	a0,a0,-44 # 800080d8 <digits+0x98>
    8000110c:	fffff097          	auipc	ra,0xfffff
    80001110:	430080e7          	jalr	1072(ra) # 8000053c <panic>
      panic("mappages: remap");
    80001114:	00007517          	auipc	a0,0x7
    80001118:	fd450513          	addi	a0,a0,-44 # 800080e8 <digits+0xa8>
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	420080e7          	jalr	1056(ra) # 8000053c <panic>
      return -1;
    80001124:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001126:	60a6                	ld	ra,72(sp)
    80001128:	6406                	ld	s0,64(sp)
    8000112a:	74e2                	ld	s1,56(sp)
    8000112c:	7942                	ld	s2,48(sp)
    8000112e:	79a2                	ld	s3,40(sp)
    80001130:	7a02                	ld	s4,32(sp)
    80001132:	6ae2                	ld	s5,24(sp)
    80001134:	6b42                	ld	s6,16(sp)
    80001136:	6ba2                	ld	s7,8(sp)
    80001138:	6161                	addi	sp,sp,80
    8000113a:	8082                	ret
  return 0;
    8000113c:	4501                	li	a0,0
    8000113e:	b7e5                	j	80001126 <mappages+0x86>

0000000080001140 <kvmmap>:
{
    80001140:	1141                	addi	sp,sp,-16
    80001142:	e406                	sd	ra,8(sp)
    80001144:	e022                	sd	s0,0(sp)
    80001146:	0800                	addi	s0,sp,16
    80001148:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000114a:	86b2                	mv	a3,a2
    8000114c:	863e                	mv	a2,a5
    8000114e:	00000097          	auipc	ra,0x0
    80001152:	f52080e7          	jalr	-174(ra) # 800010a0 <mappages>
    80001156:	e509                	bnez	a0,80001160 <kvmmap+0x20>
}
    80001158:	60a2                	ld	ra,8(sp)
    8000115a:	6402                	ld	s0,0(sp)
    8000115c:	0141                	addi	sp,sp,16
    8000115e:	8082                	ret
    panic("kvmmap");
    80001160:	00007517          	auipc	a0,0x7
    80001164:	f9850513          	addi	a0,a0,-104 # 800080f8 <digits+0xb8>
    80001168:	fffff097          	auipc	ra,0xfffff
    8000116c:	3d4080e7          	jalr	980(ra) # 8000053c <panic>

0000000080001170 <kvmmake>:
{
    80001170:	1101                	addi	sp,sp,-32
    80001172:	ec06                	sd	ra,24(sp)
    80001174:	e822                	sd	s0,16(sp)
    80001176:	e426                	sd	s1,8(sp)
    80001178:	e04a                	sd	s2,0(sp)
    8000117a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000117c:	00000097          	auipc	ra,0x0
    80001180:	966080e7          	jalr	-1690(ra) # 80000ae2 <kalloc>
    80001184:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001186:	6605                	lui	a2,0x1
    80001188:	4581                	li	a1,0
    8000118a:	00000097          	auipc	ra,0x0
    8000118e:	b44080e7          	jalr	-1212(ra) # 80000cce <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001192:	4719                	li	a4,6
    80001194:	6685                	lui	a3,0x1
    80001196:	10000637          	lui	a2,0x10000
    8000119a:	100005b7          	lui	a1,0x10000
    8000119e:	8526                	mv	a0,s1
    800011a0:	00000097          	auipc	ra,0x0
    800011a4:	fa0080e7          	jalr	-96(ra) # 80001140 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011a8:	4719                	li	a4,6
    800011aa:	6685                	lui	a3,0x1
    800011ac:	10001637          	lui	a2,0x10001
    800011b0:	100015b7          	lui	a1,0x10001
    800011b4:	8526                	mv	a0,s1
    800011b6:	00000097          	auipc	ra,0x0
    800011ba:	f8a080e7          	jalr	-118(ra) # 80001140 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011be:	4719                	li	a4,6
    800011c0:	004006b7          	lui	a3,0x400
    800011c4:	0c000637          	lui	a2,0xc000
    800011c8:	0c0005b7          	lui	a1,0xc000
    800011cc:	8526                	mv	a0,s1
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	f72080e7          	jalr	-142(ra) # 80001140 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011d6:	00007917          	auipc	s2,0x7
    800011da:	e2a90913          	addi	s2,s2,-470 # 80008000 <etext>
    800011de:	4729                	li	a4,10
    800011e0:	80007697          	auipc	a3,0x80007
    800011e4:	e2068693          	addi	a3,a3,-480 # 8000 <_entry-0x7fff8000>
    800011e8:	4605                	li	a2,1
    800011ea:	067e                	slli	a2,a2,0x1f
    800011ec:	85b2                	mv	a1,a2
    800011ee:	8526                	mv	a0,s1
    800011f0:	00000097          	auipc	ra,0x0
    800011f4:	f50080e7          	jalr	-176(ra) # 80001140 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011f8:	4719                	li	a4,6
    800011fa:	46c5                	li	a3,17
    800011fc:	06ee                	slli	a3,a3,0x1b
    800011fe:	412686b3          	sub	a3,a3,s2
    80001202:	864a                	mv	a2,s2
    80001204:	85ca                	mv	a1,s2
    80001206:	8526                	mv	a0,s1
    80001208:	00000097          	auipc	ra,0x0
    8000120c:	f38080e7          	jalr	-200(ra) # 80001140 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001210:	4729                	li	a4,10
    80001212:	6685                	lui	a3,0x1
    80001214:	00006617          	auipc	a2,0x6
    80001218:	dec60613          	addi	a2,a2,-532 # 80007000 <_trampoline>
    8000121c:	040005b7          	lui	a1,0x4000
    80001220:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001222:	05b2                	slli	a1,a1,0xc
    80001224:	8526                	mv	a0,s1
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	f1a080e7          	jalr	-230(ra) # 80001140 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000122e:	8526                	mv	a0,s1
    80001230:	00000097          	auipc	ra,0x0
    80001234:	62c080e7          	jalr	1580(ra) # 8000185c <proc_mapstacks>
}
    80001238:	8526                	mv	a0,s1
    8000123a:	60e2                	ld	ra,24(sp)
    8000123c:	6442                	ld	s0,16(sp)
    8000123e:	64a2                	ld	s1,8(sp)
    80001240:	6902                	ld	s2,0(sp)
    80001242:	6105                	addi	sp,sp,32
    80001244:	8082                	ret

0000000080001246 <kvminit>:
{
    80001246:	1141                	addi	sp,sp,-16
    80001248:	e406                	sd	ra,8(sp)
    8000124a:	e022                	sd	s0,0(sp)
    8000124c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	f22080e7          	jalr	-222(ra) # 80001170 <kvmmake>
    80001256:	00008797          	auipc	a5,0x8
    8000125a:	82a7bd23          	sd	a0,-1990(a5) # 80008a90 <kernel_pagetable>
}
    8000125e:	60a2                	ld	ra,8(sp)
    80001260:	6402                	ld	s0,0(sp)
    80001262:	0141                	addi	sp,sp,16
    80001264:	8082                	ret

0000000080001266 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001266:	715d                	addi	sp,sp,-80
    80001268:	e486                	sd	ra,72(sp)
    8000126a:	e0a2                	sd	s0,64(sp)
    8000126c:	fc26                	sd	s1,56(sp)
    8000126e:	f84a                	sd	s2,48(sp)
    80001270:	f44e                	sd	s3,40(sp)
    80001272:	f052                	sd	s4,32(sp)
    80001274:	ec56                	sd	s5,24(sp)
    80001276:	e85a                	sd	s6,16(sp)
    80001278:	e45e                	sd	s7,8(sp)
    8000127a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000127c:	03459793          	slli	a5,a1,0x34
    80001280:	e795                	bnez	a5,800012ac <uvmunmap+0x46>
    80001282:	8a2a                	mv	s4,a0
    80001284:	892e                	mv	s2,a1
    80001286:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001288:	0632                	slli	a2,a2,0xc
    8000128a:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      continue;
      /* CSE 536: removed for on-demand allocation. */
      // panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000128e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001290:	6a85                	lui	s5,0x1
    80001292:	0535ea63          	bltu	a1,s3,800012e6 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001296:	60a6                	ld	ra,72(sp)
    80001298:	6406                	ld	s0,64(sp)
    8000129a:	74e2                	ld	s1,56(sp)
    8000129c:	7942                	ld	s2,48(sp)
    8000129e:	79a2                	ld	s3,40(sp)
    800012a0:	7a02                	ld	s4,32(sp)
    800012a2:	6ae2                	ld	s5,24(sp)
    800012a4:	6b42                	ld	s6,16(sp)
    800012a6:	6ba2                	ld	s7,8(sp)
    800012a8:	6161                	addi	sp,sp,80
    800012aa:	8082                	ret
    panic("uvmunmap: not aligned");
    800012ac:	00007517          	auipc	a0,0x7
    800012b0:	e5450513          	addi	a0,a0,-428 # 80008100 <digits+0xc0>
    800012b4:	fffff097          	auipc	ra,0xfffff
    800012b8:	288080e7          	jalr	648(ra) # 8000053c <panic>
      panic("uvmunmap: walk");
    800012bc:	00007517          	auipc	a0,0x7
    800012c0:	e5c50513          	addi	a0,a0,-420 # 80008118 <digits+0xd8>
    800012c4:	fffff097          	auipc	ra,0xfffff
    800012c8:	278080e7          	jalr	632(ra) # 8000053c <panic>
      panic("uvmunmap: not a leaf");
    800012cc:	00007517          	auipc	a0,0x7
    800012d0:	e5c50513          	addi	a0,a0,-420 # 80008128 <digits+0xe8>
    800012d4:	fffff097          	auipc	ra,0xfffff
    800012d8:	268080e7          	jalr	616(ra) # 8000053c <panic>
    *pte = 0;
    800012dc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012e0:	9956                	add	s2,s2,s5
    800012e2:	fb397ae3          	bgeu	s2,s3,80001296 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012e6:	4601                	li	a2,0
    800012e8:	85ca                	mv	a1,s2
    800012ea:	8552                	mv	a0,s4
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	ccc080e7          	jalr	-820(ra) # 80000fb8 <walk>
    800012f4:	84aa                	mv	s1,a0
    800012f6:	d179                	beqz	a0,800012bc <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012f8:	611c                	ld	a5,0(a0)
    800012fa:	0017f713          	andi	a4,a5,1
    800012fe:	d36d                	beqz	a4,800012e0 <uvmunmap+0x7a>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001300:	3ff7f713          	andi	a4,a5,1023
    80001304:	fd7704e3          	beq	a4,s7,800012cc <uvmunmap+0x66>
    if(do_free){
    80001308:	fc0b0ae3          	beqz	s6,800012dc <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    8000130c:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    8000130e:	00c79513          	slli	a0,a5,0xc
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	6d2080e7          	jalr	1746(ra) # 800009e4 <kfree>
    8000131a:	b7c9                	j	800012dc <uvmunmap+0x76>

000000008000131c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000131c:	1101                	addi	sp,sp,-32
    8000131e:	ec06                	sd	ra,24(sp)
    80001320:	e822                	sd	s0,16(sp)
    80001322:	e426                	sd	s1,8(sp)
    80001324:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	7bc080e7          	jalr	1980(ra) # 80000ae2 <kalloc>
    8000132e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001330:	c519                	beqz	a0,8000133e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001332:	6605                	lui	a2,0x1
    80001334:	4581                	li	a1,0
    80001336:	00000097          	auipc	ra,0x0
    8000133a:	998080e7          	jalr	-1640(ra) # 80000cce <memset>
  return pagetable;
}
    8000133e:	8526                	mv	a0,s1
    80001340:	60e2                	ld	ra,24(sp)
    80001342:	6442                	ld	s0,16(sp)
    80001344:	64a2                	ld	s1,8(sp)
    80001346:	6105                	addi	sp,sp,32
    80001348:	8082                	ret

000000008000134a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000134a:	7179                	addi	sp,sp,-48
    8000134c:	f406                	sd	ra,40(sp)
    8000134e:	f022                	sd	s0,32(sp)
    80001350:	ec26                	sd	s1,24(sp)
    80001352:	e84a                	sd	s2,16(sp)
    80001354:	e44e                	sd	s3,8(sp)
    80001356:	e052                	sd	s4,0(sp)
    80001358:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000135a:	6785                	lui	a5,0x1
    8000135c:	04f67863          	bgeu	a2,a5,800013ac <uvmfirst+0x62>
    80001360:	8a2a                	mv	s4,a0
    80001362:	89ae                	mv	s3,a1
    80001364:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001366:	fffff097          	auipc	ra,0xfffff
    8000136a:	77c080e7          	jalr	1916(ra) # 80000ae2 <kalloc>
    8000136e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001370:	6605                	lui	a2,0x1
    80001372:	4581                	li	a1,0
    80001374:	00000097          	auipc	ra,0x0
    80001378:	95a080e7          	jalr	-1702(ra) # 80000cce <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000137c:	4779                	li	a4,30
    8000137e:	86ca                	mv	a3,s2
    80001380:	6605                	lui	a2,0x1
    80001382:	4581                	li	a1,0
    80001384:	8552                	mv	a0,s4
    80001386:	00000097          	auipc	ra,0x0
    8000138a:	d1a080e7          	jalr	-742(ra) # 800010a0 <mappages>
  memmove(mem, src, sz);
    8000138e:	8626                	mv	a2,s1
    80001390:	85ce                	mv	a1,s3
    80001392:	854a                	mv	a0,s2
    80001394:	00000097          	auipc	ra,0x0
    80001398:	996080e7          	jalr	-1642(ra) # 80000d2a <memmove>
}
    8000139c:	70a2                	ld	ra,40(sp)
    8000139e:	7402                	ld	s0,32(sp)
    800013a0:	64e2                	ld	s1,24(sp)
    800013a2:	6942                	ld	s2,16(sp)
    800013a4:	69a2                	ld	s3,8(sp)
    800013a6:	6a02                	ld	s4,0(sp)
    800013a8:	6145                	addi	sp,sp,48
    800013aa:	8082                	ret
    panic("uvmfirst: more than a page");
    800013ac:	00007517          	auipc	a0,0x7
    800013b0:	d9450513          	addi	a0,a0,-620 # 80008140 <digits+0x100>
    800013b4:	fffff097          	auipc	ra,0xfffff
    800013b8:	188080e7          	jalr	392(ra) # 8000053c <panic>

00000000800013bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013bc:	1101                	addi	sp,sp,-32
    800013be:	ec06                	sd	ra,24(sp)
    800013c0:	e822                	sd	s0,16(sp)
    800013c2:	e426                	sd	s1,8(sp)
    800013c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013c8:	00b67d63          	bgeu	a2,a1,800013e2 <uvmdealloc+0x26>
    800013cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013ce:	6785                	lui	a5,0x1
    800013d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013d2:	00f60733          	add	a4,a2,a5
    800013d6:	76fd                	lui	a3,0xfffff
    800013d8:	8f75                	and	a4,a4,a3
    800013da:	97ae                	add	a5,a5,a1
    800013dc:	8ff5                	and	a5,a5,a3
    800013de:	00f76863          	bltu	a4,a5,800013ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013e2:	8526                	mv	a0,s1
    800013e4:	60e2                	ld	ra,24(sp)
    800013e6:	6442                	ld	s0,16(sp)
    800013e8:	64a2                	ld	s1,8(sp)
    800013ea:	6105                	addi	sp,sp,32
    800013ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013ee:	8f99                	sub	a5,a5,a4
    800013f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013f2:	4685                	li	a3,1
    800013f4:	0007861b          	sext.w	a2,a5
    800013f8:	85ba                	mv	a1,a4
    800013fa:	00000097          	auipc	ra,0x0
    800013fe:	e6c080e7          	jalr	-404(ra) # 80001266 <uvmunmap>
    80001402:	b7c5                	j	800013e2 <uvmdealloc+0x26>

0000000080001404 <uvmalloc>:
  if(newsz < oldsz)
    80001404:	0ab66563          	bltu	a2,a1,800014ae <uvmalloc+0xaa>
{
    80001408:	7139                	addi	sp,sp,-64
    8000140a:	fc06                	sd	ra,56(sp)
    8000140c:	f822                	sd	s0,48(sp)
    8000140e:	f426                	sd	s1,40(sp)
    80001410:	f04a                	sd	s2,32(sp)
    80001412:	ec4e                	sd	s3,24(sp)
    80001414:	e852                	sd	s4,16(sp)
    80001416:	e456                	sd	s5,8(sp)
    80001418:	e05a                	sd	s6,0(sp)
    8000141a:	0080                	addi	s0,sp,64
    8000141c:	8aaa                	mv	s5,a0
    8000141e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001420:	6785                	lui	a5,0x1
    80001422:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001424:	95be                	add	a1,a1,a5
    80001426:	77fd                	lui	a5,0xfffff
    80001428:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000142c:	08c9f363          	bgeu	s3,a2,800014b2 <uvmalloc+0xae>
    80001430:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001432:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001436:	fffff097          	auipc	ra,0xfffff
    8000143a:	6ac080e7          	jalr	1708(ra) # 80000ae2 <kalloc>
    8000143e:	84aa                	mv	s1,a0
    if(mem == 0){
    80001440:	c51d                	beqz	a0,8000146e <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001442:	6605                	lui	a2,0x1
    80001444:	4581                	li	a1,0
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	888080e7          	jalr	-1912(ra) # 80000cce <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000144e:	875a                	mv	a4,s6
    80001450:	86a6                	mv	a3,s1
    80001452:	6605                	lui	a2,0x1
    80001454:	85ca                	mv	a1,s2
    80001456:	8556                	mv	a0,s5
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	c48080e7          	jalr	-952(ra) # 800010a0 <mappages>
    80001460:	e90d                	bnez	a0,80001492 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001462:	6785                	lui	a5,0x1
    80001464:	993e                	add	s2,s2,a5
    80001466:	fd4968e3          	bltu	s2,s4,80001436 <uvmalloc+0x32>
  return newsz;
    8000146a:	8552                	mv	a0,s4
    8000146c:	a809                	j	8000147e <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000146e:	864e                	mv	a2,s3
    80001470:	85ca                	mv	a1,s2
    80001472:	8556                	mv	a0,s5
    80001474:	00000097          	auipc	ra,0x0
    80001478:	f48080e7          	jalr	-184(ra) # 800013bc <uvmdealloc>
      return 0;
    8000147c:	4501                	li	a0,0
}
    8000147e:	70e2                	ld	ra,56(sp)
    80001480:	7442                	ld	s0,48(sp)
    80001482:	74a2                	ld	s1,40(sp)
    80001484:	7902                	ld	s2,32(sp)
    80001486:	69e2                	ld	s3,24(sp)
    80001488:	6a42                	ld	s4,16(sp)
    8000148a:	6aa2                	ld	s5,8(sp)
    8000148c:	6b02                	ld	s6,0(sp)
    8000148e:	6121                	addi	sp,sp,64
    80001490:	8082                	ret
      kfree(mem);
    80001492:	8526                	mv	a0,s1
    80001494:	fffff097          	auipc	ra,0xfffff
    80001498:	550080e7          	jalr	1360(ra) # 800009e4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000149c:	864e                	mv	a2,s3
    8000149e:	85ca                	mv	a1,s2
    800014a0:	8556                	mv	a0,s5
    800014a2:	00000097          	auipc	ra,0x0
    800014a6:	f1a080e7          	jalr	-230(ra) # 800013bc <uvmdealloc>
      return 0;
    800014aa:	4501                	li	a0,0
    800014ac:	bfc9                	j	8000147e <uvmalloc+0x7a>
    return oldsz;
    800014ae:	852e                	mv	a0,a1
}
    800014b0:	8082                	ret
  return newsz;
    800014b2:	8532                	mv	a0,a2
    800014b4:	b7e9                	j	8000147e <uvmalloc+0x7a>

00000000800014b6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014b6:	7179                	addi	sp,sp,-48
    800014b8:	f406                	sd	ra,40(sp)
    800014ba:	f022                	sd	s0,32(sp)
    800014bc:	ec26                	sd	s1,24(sp)
    800014be:	e84a                	sd	s2,16(sp)
    800014c0:	e44e                	sd	s3,8(sp)
    800014c2:	e052                	sd	s4,0(sp)
    800014c4:	1800                	addi	s0,sp,48
    800014c6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014c8:	84aa                	mv	s1,a0
    800014ca:	6905                	lui	s2,0x1
    800014cc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014ce:	4985                	li	s3,1
    800014d0:	a829                	j	800014ea <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014d2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014d4:	00c79513          	slli	a0,a5,0xc
    800014d8:	00000097          	auipc	ra,0x0
    800014dc:	fde080e7          	jalr	-34(ra) # 800014b6 <freewalk>
      pagetable[i] = 0;
    800014e0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014e4:	04a1                	addi	s1,s1,8
    800014e6:	03248163          	beq	s1,s2,80001508 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014ea:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014ec:	00f7f713          	andi	a4,a5,15
    800014f0:	ff3701e3          	beq	a4,s3,800014d2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014f4:	8b85                	andi	a5,a5,1
    800014f6:	d7fd                	beqz	a5,800014e4 <freewalk+0x2e>
      panic("freewalk: leaf");
    800014f8:	00007517          	auipc	a0,0x7
    800014fc:	c6850513          	addi	a0,a0,-920 # 80008160 <digits+0x120>
    80001500:	fffff097          	auipc	ra,0xfffff
    80001504:	03c080e7          	jalr	60(ra) # 8000053c <panic>
    }
  }
  kfree((void*)pagetable);
    80001508:	8552                	mv	a0,s4
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	4da080e7          	jalr	1242(ra) # 800009e4 <kfree>
}
    80001512:	70a2                	ld	ra,40(sp)
    80001514:	7402                	ld	s0,32(sp)
    80001516:	64e2                	ld	s1,24(sp)
    80001518:	6942                	ld	s2,16(sp)
    8000151a:	69a2                	ld	s3,8(sp)
    8000151c:	6a02                	ld	s4,0(sp)
    8000151e:	6145                	addi	sp,sp,48
    80001520:	8082                	ret

0000000080001522 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001522:	1101                	addi	sp,sp,-32
    80001524:	ec06                	sd	ra,24(sp)
    80001526:	e822                	sd	s0,16(sp)
    80001528:	e426                	sd	s1,8(sp)
    8000152a:	1000                	addi	s0,sp,32
    8000152c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000152e:	e999                	bnez	a1,80001544 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001530:	8526                	mv	a0,s1
    80001532:	00000097          	auipc	ra,0x0
    80001536:	f84080e7          	jalr	-124(ra) # 800014b6 <freewalk>
}
    8000153a:	60e2                	ld	ra,24(sp)
    8000153c:	6442                	ld	s0,16(sp)
    8000153e:	64a2                	ld	s1,8(sp)
    80001540:	6105                	addi	sp,sp,32
    80001542:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001544:	6785                	lui	a5,0x1
    80001546:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001548:	95be                	add	a1,a1,a5
    8000154a:	4685                	li	a3,1
    8000154c:	00c5d613          	srli	a2,a1,0xc
    80001550:	4581                	li	a1,0
    80001552:	00000097          	auipc	ra,0x0
    80001556:	d14080e7          	jalr	-748(ra) # 80001266 <uvmunmap>
    8000155a:	bfd9                	j	80001530 <uvmfree+0xe>

000000008000155c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000155c:	c679                	beqz	a2,8000162a <uvmcopy+0xce>
{
    8000155e:	715d                	addi	sp,sp,-80
    80001560:	e486                	sd	ra,72(sp)
    80001562:	e0a2                	sd	s0,64(sp)
    80001564:	fc26                	sd	s1,56(sp)
    80001566:	f84a                	sd	s2,48(sp)
    80001568:	f44e                	sd	s3,40(sp)
    8000156a:	f052                	sd	s4,32(sp)
    8000156c:	ec56                	sd	s5,24(sp)
    8000156e:	e85a                	sd	s6,16(sp)
    80001570:	e45e                	sd	s7,8(sp)
    80001572:	0880                	addi	s0,sp,80
    80001574:	8b2a                	mv	s6,a0
    80001576:	8aae                	mv	s5,a1
    80001578:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000157a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000157c:	4601                	li	a2,0
    8000157e:	85ce                	mv	a1,s3
    80001580:	855a                	mv	a0,s6
    80001582:	00000097          	auipc	ra,0x0
    80001586:	a36080e7          	jalr	-1482(ra) # 80000fb8 <walk>
    8000158a:	c531                	beqz	a0,800015d6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000158c:	6118                	ld	a4,0(a0)
    8000158e:	00177793          	andi	a5,a4,1
    80001592:	cbb1                	beqz	a5,800015e6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001594:	00a75593          	srli	a1,a4,0xa
    80001598:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000159c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015a0:	fffff097          	auipc	ra,0xfffff
    800015a4:	542080e7          	jalr	1346(ra) # 80000ae2 <kalloc>
    800015a8:	892a                	mv	s2,a0
    800015aa:	c939                	beqz	a0,80001600 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015ac:	6605                	lui	a2,0x1
    800015ae:	85de                	mv	a1,s7
    800015b0:	fffff097          	auipc	ra,0xfffff
    800015b4:	77a080e7          	jalr	1914(ra) # 80000d2a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015b8:	8726                	mv	a4,s1
    800015ba:	86ca                	mv	a3,s2
    800015bc:	6605                	lui	a2,0x1
    800015be:	85ce                	mv	a1,s3
    800015c0:	8556                	mv	a0,s5
    800015c2:	00000097          	auipc	ra,0x0
    800015c6:	ade080e7          	jalr	-1314(ra) # 800010a0 <mappages>
    800015ca:	e515                	bnez	a0,800015f6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015cc:	6785                	lui	a5,0x1
    800015ce:	99be                	add	s3,s3,a5
    800015d0:	fb49e6e3          	bltu	s3,s4,8000157c <uvmcopy+0x20>
    800015d4:	a081                	j	80001614 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015d6:	00007517          	auipc	a0,0x7
    800015da:	b9a50513          	addi	a0,a0,-1126 # 80008170 <digits+0x130>
    800015de:	fffff097          	auipc	ra,0xfffff
    800015e2:	f5e080e7          	jalr	-162(ra) # 8000053c <panic>
      panic("uvmcopy: page not present");
    800015e6:	00007517          	auipc	a0,0x7
    800015ea:	baa50513          	addi	a0,a0,-1110 # 80008190 <digits+0x150>
    800015ee:	fffff097          	auipc	ra,0xfffff
    800015f2:	f4e080e7          	jalr	-178(ra) # 8000053c <panic>
      kfree(mem);
    800015f6:	854a                	mv	a0,s2
    800015f8:	fffff097          	auipc	ra,0xfffff
    800015fc:	3ec080e7          	jalr	1004(ra) # 800009e4 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001600:	4685                	li	a3,1
    80001602:	00c9d613          	srli	a2,s3,0xc
    80001606:	4581                	li	a1,0
    80001608:	8556                	mv	a0,s5
    8000160a:	00000097          	auipc	ra,0x0
    8000160e:	c5c080e7          	jalr	-932(ra) # 80001266 <uvmunmap>
  return -1;
    80001612:	557d                	li	a0,-1
}
    80001614:	60a6                	ld	ra,72(sp)
    80001616:	6406                	ld	s0,64(sp)
    80001618:	74e2                	ld	s1,56(sp)
    8000161a:	7942                	ld	s2,48(sp)
    8000161c:	79a2                	ld	s3,40(sp)
    8000161e:	7a02                	ld	s4,32(sp)
    80001620:	6ae2                	ld	s5,24(sp)
    80001622:	6b42                	ld	s6,16(sp)
    80001624:	6ba2                	ld	s7,8(sp)
    80001626:	6161                	addi	sp,sp,80
    80001628:	8082                	ret
  return 0;
    8000162a:	4501                	li	a0,0
}
    8000162c:	8082                	ret

000000008000162e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000162e:	1141                	addi	sp,sp,-16
    80001630:	e406                	sd	ra,8(sp)
    80001632:	e022                	sd	s0,0(sp)
    80001634:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001636:	4601                	li	a2,0
    80001638:	00000097          	auipc	ra,0x0
    8000163c:	980080e7          	jalr	-1664(ra) # 80000fb8 <walk>
  if(pte == 0)
    80001640:	c901                	beqz	a0,80001650 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001642:	611c                	ld	a5,0(a0)
    80001644:	9bbd                	andi	a5,a5,-17
    80001646:	e11c                	sd	a5,0(a0)
}
    80001648:	60a2                	ld	ra,8(sp)
    8000164a:	6402                	ld	s0,0(sp)
    8000164c:	0141                	addi	sp,sp,16
    8000164e:	8082                	ret
    panic("uvmclear");
    80001650:	00007517          	auipc	a0,0x7
    80001654:	b6050513          	addi	a0,a0,-1184 # 800081b0 <digits+0x170>
    80001658:	fffff097          	auipc	ra,0xfffff
    8000165c:	ee4080e7          	jalr	-284(ra) # 8000053c <panic>

0000000080001660 <uvminvalid>:

// CSE 536: mark a PTE invalid. For swapping 
// pages in and out of memory.
void
uvminvalid(pagetable_t pagetable, uint64 va)
{
    80001660:	1141                	addi	sp,sp,-16
    80001662:	e406                	sd	ra,8(sp)
    80001664:	e022                	sd	s0,0(sp)
    80001666:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001668:	4601                	li	a2,0
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	94e080e7          	jalr	-1714(ra) # 80000fb8 <walk>
  if(pte == 0)
    80001672:	c901                	beqz	a0,80001682 <uvminvalid+0x22>
    panic("uvminvalid");
  *pte &= ~PTE_V;
    80001674:	611c                	ld	a5,0(a0)
    80001676:	9bf9                	andi	a5,a5,-2
    80001678:	e11c                	sd	a5,0(a0)
}
    8000167a:	60a2                	ld	ra,8(sp)
    8000167c:	6402                	ld	s0,0(sp)
    8000167e:	0141                	addi	sp,sp,16
    80001680:	8082                	ret
    panic("uvminvalid");
    80001682:	00007517          	auipc	a0,0x7
    80001686:	b3e50513          	addi	a0,a0,-1218 # 800081c0 <digits+0x180>
    8000168a:	fffff097          	auipc	ra,0xfffff
    8000168e:	eb2080e7          	jalr	-334(ra) # 8000053c <panic>

0000000080001692 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001692:	c6bd                	beqz	a3,80001700 <copyout+0x6e>
{
    80001694:	715d                	addi	sp,sp,-80
    80001696:	e486                	sd	ra,72(sp)
    80001698:	e0a2                	sd	s0,64(sp)
    8000169a:	fc26                	sd	s1,56(sp)
    8000169c:	f84a                	sd	s2,48(sp)
    8000169e:	f44e                	sd	s3,40(sp)
    800016a0:	f052                	sd	s4,32(sp)
    800016a2:	ec56                	sd	s5,24(sp)
    800016a4:	e85a                	sd	s6,16(sp)
    800016a6:	e45e                	sd	s7,8(sp)
    800016a8:	e062                	sd	s8,0(sp)
    800016aa:	0880                	addi	s0,sp,80
    800016ac:	8b2a                	mv	s6,a0
    800016ae:	8c2e                	mv	s8,a1
    800016b0:	8a32                	mv	s4,a2
    800016b2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016b4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0){
      return -1;
    }
    n = PGSIZE - (dstva - va0);
    800016b6:	6a85                	lui	s5,0x1
    800016b8:	a015                	j	800016dc <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016ba:	9562                	add	a0,a0,s8
    800016bc:	0004861b          	sext.w	a2,s1
    800016c0:	85d2                	mv	a1,s4
    800016c2:	41250533          	sub	a0,a0,s2
    800016c6:	fffff097          	auipc	ra,0xfffff
    800016ca:	664080e7          	jalr	1636(ra) # 80000d2a <memmove>

    len -= n;
    800016ce:	409989b3          	sub	s3,s3,s1
    src += n;
    800016d2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016d4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016d8:	02098263          	beqz	s3,800016fc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016dc:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016e0:	85ca                	mv	a1,s2
    800016e2:	855a                	mv	a0,s6
    800016e4:	00000097          	auipc	ra,0x0
    800016e8:	97a080e7          	jalr	-1670(ra) # 8000105e <walkaddr>
    if (pa0 == 0){
    800016ec:	cd01                	beqz	a0,80001704 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016ee:	418904b3          	sub	s1,s2,s8
    800016f2:	94d6                	add	s1,s1,s5
    800016f4:	fc99f3e3          	bgeu	s3,s1,800016ba <copyout+0x28>
    800016f8:	84ce                	mv	s1,s3
    800016fa:	b7c1                	j	800016ba <copyout+0x28>
  }
  return 0;
    800016fc:	4501                	li	a0,0
    800016fe:	a021                	j	80001706 <copyout+0x74>
    80001700:	4501                	li	a0,0
}
    80001702:	8082                	ret
      return -1;
    80001704:	557d                	li	a0,-1
}
    80001706:	60a6                	ld	ra,72(sp)
    80001708:	6406                	ld	s0,64(sp)
    8000170a:	74e2                	ld	s1,56(sp)
    8000170c:	7942                	ld	s2,48(sp)
    8000170e:	79a2                	ld	s3,40(sp)
    80001710:	7a02                	ld	s4,32(sp)
    80001712:	6ae2                	ld	s5,24(sp)
    80001714:	6b42                	ld	s6,16(sp)
    80001716:	6ba2                	ld	s7,8(sp)
    80001718:	6c02                	ld	s8,0(sp)
    8000171a:	6161                	addi	sp,sp,80
    8000171c:	8082                	ret

000000008000171e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000171e:	caa5                	beqz	a3,8000178e <copyin+0x70>
{
    80001720:	715d                	addi	sp,sp,-80
    80001722:	e486                	sd	ra,72(sp)
    80001724:	e0a2                	sd	s0,64(sp)
    80001726:	fc26                	sd	s1,56(sp)
    80001728:	f84a                	sd	s2,48(sp)
    8000172a:	f44e                	sd	s3,40(sp)
    8000172c:	f052                	sd	s4,32(sp)
    8000172e:	ec56                	sd	s5,24(sp)
    80001730:	e85a                	sd	s6,16(sp)
    80001732:	e45e                	sd	s7,8(sp)
    80001734:	e062                	sd	s8,0(sp)
    80001736:	0880                	addi	s0,sp,80
    80001738:	8b2a                	mv	s6,a0
    8000173a:	8a2e                	mv	s4,a1
    8000173c:	8c32                	mv	s8,a2
    8000173e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001740:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001742:	6a85                	lui	s5,0x1
    80001744:	a01d                	j	8000176a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001746:	018505b3          	add	a1,a0,s8
    8000174a:	0004861b          	sext.w	a2,s1
    8000174e:	412585b3          	sub	a1,a1,s2
    80001752:	8552                	mv	a0,s4
    80001754:	fffff097          	auipc	ra,0xfffff
    80001758:	5d6080e7          	jalr	1494(ra) # 80000d2a <memmove>

    len -= n;
    8000175c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001760:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001762:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001766:	02098263          	beqz	s3,8000178a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000176a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000176e:	85ca                	mv	a1,s2
    80001770:	855a                	mv	a0,s6
    80001772:	00000097          	auipc	ra,0x0
    80001776:	8ec080e7          	jalr	-1812(ra) # 8000105e <walkaddr>
    if(pa0 == 0)
    8000177a:	cd01                	beqz	a0,80001792 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000177c:	418904b3          	sub	s1,s2,s8
    80001780:	94d6                	add	s1,s1,s5
    80001782:	fc99f2e3          	bgeu	s3,s1,80001746 <copyin+0x28>
    80001786:	84ce                	mv	s1,s3
    80001788:	bf7d                	j	80001746 <copyin+0x28>
  }
  return 0;
    8000178a:	4501                	li	a0,0
    8000178c:	a021                	j	80001794 <copyin+0x76>
    8000178e:	4501                	li	a0,0
}
    80001790:	8082                	ret
      return -1;
    80001792:	557d                	li	a0,-1
}
    80001794:	60a6                	ld	ra,72(sp)
    80001796:	6406                	ld	s0,64(sp)
    80001798:	74e2                	ld	s1,56(sp)
    8000179a:	7942                	ld	s2,48(sp)
    8000179c:	79a2                	ld	s3,40(sp)
    8000179e:	7a02                	ld	s4,32(sp)
    800017a0:	6ae2                	ld	s5,24(sp)
    800017a2:	6b42                	ld	s6,16(sp)
    800017a4:	6ba2                	ld	s7,8(sp)
    800017a6:	6c02                	ld	s8,0(sp)
    800017a8:	6161                	addi	sp,sp,80
    800017aa:	8082                	ret

00000000800017ac <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017ac:	c2dd                	beqz	a3,80001852 <copyinstr+0xa6>
{
    800017ae:	715d                	addi	sp,sp,-80
    800017b0:	e486                	sd	ra,72(sp)
    800017b2:	e0a2                	sd	s0,64(sp)
    800017b4:	fc26                	sd	s1,56(sp)
    800017b6:	f84a                	sd	s2,48(sp)
    800017b8:	f44e                	sd	s3,40(sp)
    800017ba:	f052                	sd	s4,32(sp)
    800017bc:	ec56                	sd	s5,24(sp)
    800017be:	e85a                	sd	s6,16(sp)
    800017c0:	e45e                	sd	s7,8(sp)
    800017c2:	0880                	addi	s0,sp,80
    800017c4:	8a2a                	mv	s4,a0
    800017c6:	8b2e                	mv	s6,a1
    800017c8:	8bb2                	mv	s7,a2
    800017ca:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017cc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017ce:	6985                	lui	s3,0x1
    800017d0:	a02d                	j	800017fa <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017d2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017d6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017d8:	37fd                	addiw	a5,a5,-1
    800017da:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017de:	60a6                	ld	ra,72(sp)
    800017e0:	6406                	ld	s0,64(sp)
    800017e2:	74e2                	ld	s1,56(sp)
    800017e4:	7942                	ld	s2,48(sp)
    800017e6:	79a2                	ld	s3,40(sp)
    800017e8:	7a02                	ld	s4,32(sp)
    800017ea:	6ae2                	ld	s5,24(sp)
    800017ec:	6b42                	ld	s6,16(sp)
    800017ee:	6ba2                	ld	s7,8(sp)
    800017f0:	6161                	addi	sp,sp,80
    800017f2:	8082                	ret
    srcva = va0 + PGSIZE;
    800017f4:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017f8:	c8a9                	beqz	s1,8000184a <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017fa:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017fe:	85ca                	mv	a1,s2
    80001800:	8552                	mv	a0,s4
    80001802:	00000097          	auipc	ra,0x0
    80001806:	85c080e7          	jalr	-1956(ra) # 8000105e <walkaddr>
    if(pa0 == 0)
    8000180a:	c131                	beqz	a0,8000184e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000180c:	417906b3          	sub	a3,s2,s7
    80001810:	96ce                	add	a3,a3,s3
    80001812:	00d4f363          	bgeu	s1,a3,80001818 <copyinstr+0x6c>
    80001816:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001818:	955e                	add	a0,a0,s7
    8000181a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    8000181e:	daf9                	beqz	a3,800017f4 <copyinstr+0x48>
    80001820:	87da                	mv	a5,s6
    80001822:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001824:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001828:	96da                	add	a3,a3,s6
    8000182a:	85be                	mv	a1,a5
      if(*p == '\0'){
    8000182c:	00f60733          	add	a4,a2,a5
    80001830:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fe658f0>
    80001834:	df59                	beqz	a4,800017d2 <copyinstr+0x26>
        *dst = *p;
    80001836:	00e78023          	sb	a4,0(a5)
      dst++;
    8000183a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000183c:	fed797e3          	bne	a5,a3,8000182a <copyinstr+0x7e>
    80001840:	14fd                	addi	s1,s1,-1
    80001842:	94c2                	add	s1,s1,a6
      --max;
    80001844:	8c8d                	sub	s1,s1,a1
      dst++;
    80001846:	8b3e                	mv	s6,a5
    80001848:	b775                	j	800017f4 <copyinstr+0x48>
    8000184a:	4781                	li	a5,0
    8000184c:	b771                	j	800017d8 <copyinstr+0x2c>
      return -1;
    8000184e:	557d                	li	a0,-1
    80001850:	b779                	j	800017de <copyinstr+0x32>
  int got_null = 0;
    80001852:	4781                	li	a5,0
  if(got_null){
    80001854:	37fd                	addiw	a5,a5,-1
    80001856:	0007851b          	sext.w	a0,a5
}
    8000185a:	8082                	ret

000000008000185c <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000185c:	715d                	addi	sp,sp,-80
    8000185e:	e486                	sd	ra,72(sp)
    80001860:	e0a2                	sd	s0,64(sp)
    80001862:	fc26                	sd	s1,56(sp)
    80001864:	f84a                	sd	s2,48(sp)
    80001866:	f44e                	sd	s3,40(sp)
    80001868:	f052                	sd	s4,32(sp)
    8000186a:	ec56                	sd	s5,24(sp)
    8000186c:	e85a                	sd	s6,16(sp)
    8000186e:	e45e                	sd	s7,8(sp)
    80001870:	0880                	addi	s0,sp,80
    80001872:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001874:	00010497          	auipc	s1,0x10
    80001878:	8cc48493          	addi	s1,s1,-1844 # 80011140 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000187c:	8ba6                	mv	s7,s1
    8000187e:	00006b17          	auipc	s6,0x6
    80001882:	782b0b13          	addi	s6,s6,1922 # 80008000 <etext>
    80001886:	04000937          	lui	s2,0x4000
    8000188a:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000188c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188e:	6999                	lui	s3,0x6
    80001890:	f3898993          	addi	s3,s3,-200 # 5f38 <_entry-0x7fffa0c8>
    80001894:	0018ca97          	auipc	s5,0x18c
    80001898:	6aca8a93          	addi	s5,s5,1708 # 8018df40 <tickslock>
    char *pa = kalloc();
    8000189c:	fffff097          	auipc	ra,0xfffff
    800018a0:	246080e7          	jalr	582(ra) # 80000ae2 <kalloc>
    800018a4:	862a                	mv	a2,a0
    if(pa == 0)
    800018a6:	c131                	beqz	a0,800018ea <proc_mapstacks+0x8e>
    uint64 va = KSTACK((int) (p - proc));
    800018a8:	417485b3          	sub	a1,s1,s7
    800018ac:	858d                	srai	a1,a1,0x3
    800018ae:	000b3783          	ld	a5,0(s6)
    800018b2:	02f585b3          	mul	a1,a1,a5
    800018b6:	2585                	addiw	a1,a1,1
    800018b8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018bc:	4719                	li	a4,6
    800018be:	6685                	lui	a3,0x1
    800018c0:	40b905b3          	sub	a1,s2,a1
    800018c4:	8552                	mv	a0,s4
    800018c6:	00000097          	auipc	ra,0x0
    800018ca:	87a080e7          	jalr	-1926(ra) # 80001140 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ce:	94ce                	add	s1,s1,s3
    800018d0:	fd5496e3          	bne	s1,s5,8000189c <proc_mapstacks+0x40>
  }
}
    800018d4:	60a6                	ld	ra,72(sp)
    800018d6:	6406                	ld	s0,64(sp)
    800018d8:	74e2                	ld	s1,56(sp)
    800018da:	7942                	ld	s2,48(sp)
    800018dc:	79a2                	ld	s3,40(sp)
    800018de:	7a02                	ld	s4,32(sp)
    800018e0:	6ae2                	ld	s5,24(sp)
    800018e2:	6b42                	ld	s6,16(sp)
    800018e4:	6ba2                	ld	s7,8(sp)
    800018e6:	6161                	addi	sp,sp,80
    800018e8:	8082                	ret
      panic("kalloc");
    800018ea:	00007517          	auipc	a0,0x7
    800018ee:	8e650513          	addi	a0,a0,-1818 # 800081d0 <digits+0x190>
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	c4a080e7          	jalr	-950(ra) # 8000053c <panic>

00000000800018fa <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800018fa:	715d                	addi	sp,sp,-80
    800018fc:	e486                	sd	ra,72(sp)
    800018fe:	e0a2                	sd	s0,64(sp)
    80001900:	fc26                	sd	s1,56(sp)
    80001902:	f84a                	sd	s2,48(sp)
    80001904:	f44e                	sd	s3,40(sp)
    80001906:	f052                	sd	s4,32(sp)
    80001908:	ec56                	sd	s5,24(sp)
    8000190a:	e85a                	sd	s6,16(sp)
    8000190c:	e45e                	sd	s7,8(sp)
    8000190e:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001910:	00007597          	auipc	a1,0x7
    80001914:	8c858593          	addi	a1,a1,-1848 # 800081d8 <digits+0x198>
    80001918:	0000f517          	auipc	a0,0xf
    8000191c:	3f850513          	addi	a0,a0,1016 # 80010d10 <pid_lock>
    80001920:	fffff097          	auipc	ra,0xfffff
    80001924:	222080e7          	jalr	546(ra) # 80000b42 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001928:	00007597          	auipc	a1,0x7
    8000192c:	8b858593          	addi	a1,a1,-1864 # 800081e0 <digits+0x1a0>
    80001930:	0000f517          	auipc	a0,0xf
    80001934:	3f850513          	addi	a0,a0,1016 # 80010d28 <wait_lock>
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	20a080e7          	jalr	522(ra) # 80000b42 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001940:	00010497          	auipc	s1,0x10
    80001944:	80048493          	addi	s1,s1,-2048 # 80011140 <proc>
      initlock(&p->lock, "proc");
    80001948:	00007b97          	auipc	s7,0x7
    8000194c:	8a8b8b93          	addi	s7,s7,-1880 # 800081f0 <digits+0x1b0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001950:	8b26                	mv	s6,s1
    80001952:	00006a97          	auipc	s5,0x6
    80001956:	6aea8a93          	addi	s5,s5,1710 # 80008000 <etext>
    8000195a:	04000937          	lui	s2,0x4000
    8000195e:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001960:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001962:	6999                	lui	s3,0x6
    80001964:	f3898993          	addi	s3,s3,-200 # 5f38 <_entry-0x7fffa0c8>
    80001968:	0018ca17          	auipc	s4,0x18c
    8000196c:	5d8a0a13          	addi	s4,s4,1496 # 8018df40 <tickslock>
      initlock(&p->lock, "proc");
    80001970:	85de                	mv	a1,s7
    80001972:	8526                	mv	a0,s1
    80001974:	fffff097          	auipc	ra,0xfffff
    80001978:	1ce080e7          	jalr	462(ra) # 80000b42 <initlock>
      p->state = UNUSED;
    8000197c:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001980:	416487b3          	sub	a5,s1,s6
    80001984:	878d                	srai	a5,a5,0x3
    80001986:	000ab703          	ld	a4,0(s5)
    8000198a:	02e787b3          	mul	a5,a5,a4
    8000198e:	2785                	addiw	a5,a5,1
    80001990:	00d7979b          	slliw	a5,a5,0xd
    80001994:	40f907b3          	sub	a5,s2,a5
    80001998:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000199a:	94ce                	add	s1,s1,s3
    8000199c:	fd449ae3          	bne	s1,s4,80001970 <procinit+0x76>
  }
}
    800019a0:	60a6                	ld	ra,72(sp)
    800019a2:	6406                	ld	s0,64(sp)
    800019a4:	74e2                	ld	s1,56(sp)
    800019a6:	7942                	ld	s2,48(sp)
    800019a8:	79a2                	ld	s3,40(sp)
    800019aa:	7a02                	ld	s4,32(sp)
    800019ac:	6ae2                	ld	s5,24(sp)
    800019ae:	6b42                	ld	s6,16(sp)
    800019b0:	6ba2                	ld	s7,8(sp)
    800019b2:	6161                	addi	sp,sp,80
    800019b4:	8082                	ret

00000000800019b6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800019b6:	1141                	addi	sp,sp,-16
    800019b8:	e422                	sd	s0,8(sp)
    800019ba:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019bc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800019be:	2501                	sext.w	a0,a0
    800019c0:	6422                	ld	s0,8(sp)
    800019c2:	0141                	addi	sp,sp,16
    800019c4:	8082                	ret

00000000800019c6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800019c6:	1141                	addi	sp,sp,-16
    800019c8:	e422                	sd	s0,8(sp)
    800019ca:	0800                	addi	s0,sp,16
    800019cc:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800019ce:	2781                	sext.w	a5,a5
    800019d0:	079e                	slli	a5,a5,0x7
  return c;
}
    800019d2:	0000f517          	auipc	a0,0xf
    800019d6:	36e50513          	addi	a0,a0,878 # 80010d40 <cpus>
    800019da:	953e                	add	a0,a0,a5
    800019dc:	6422                	ld	s0,8(sp)
    800019de:	0141                	addi	sp,sp,16
    800019e0:	8082                	ret

00000000800019e2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800019e2:	1101                	addi	sp,sp,-32
    800019e4:	ec06                	sd	ra,24(sp)
    800019e6:	e822                	sd	s0,16(sp)
    800019e8:	e426                	sd	s1,8(sp)
    800019ea:	1000                	addi	s0,sp,32
  push_off();
    800019ec:	fffff097          	auipc	ra,0xfffff
    800019f0:	19a080e7          	jalr	410(ra) # 80000b86 <push_off>
    800019f4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019f6:	2781                	sext.w	a5,a5
    800019f8:	079e                	slli	a5,a5,0x7
    800019fa:	0000f717          	auipc	a4,0xf
    800019fe:	31670713          	addi	a4,a4,790 # 80010d10 <pid_lock>
    80001a02:	97ba                	add	a5,a5,a4
    80001a04:	7b84                	ld	s1,48(a5)
  pop_off();
    80001a06:	fffff097          	auipc	ra,0xfffff
    80001a0a:	220080e7          	jalr	544(ra) # 80000c26 <pop_off>
  return p;
}
    80001a0e:	8526                	mv	a0,s1
    80001a10:	60e2                	ld	ra,24(sp)
    80001a12:	6442                	ld	s0,16(sp)
    80001a14:	64a2                	ld	s1,8(sp)
    80001a16:	6105                	addi	sp,sp,32
    80001a18:	8082                	ret

0000000080001a1a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a1a:	1141                	addi	sp,sp,-16
    80001a1c:	e406                	sd	ra,8(sp)
    80001a1e:	e022                	sd	s0,0(sp)
    80001a20:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a22:	00000097          	auipc	ra,0x0
    80001a26:	fc0080e7          	jalr	-64(ra) # 800019e2 <myproc>
    80001a2a:	fffff097          	auipc	ra,0xfffff
    80001a2e:	25c080e7          	jalr	604(ra) # 80000c86 <release>

  if (first) {
    80001a32:	00007797          	auipc	a5,0x7
    80001a36:	fee7a783          	lw	a5,-18(a5) # 80008a20 <first.1>
    80001a3a:	eb89                	bnez	a5,80001a4c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a3c:	00001097          	auipc	ra,0x1
    80001a40:	d82080e7          	jalr	-638(ra) # 800027be <usertrapret>
}
    80001a44:	60a2                	ld	ra,8(sp)
    80001a46:	6402                	ld	s0,0(sp)
    80001a48:	0141                	addi	sp,sp,16
    80001a4a:	8082                	ret
    first = 0;
    80001a4c:	00007797          	auipc	a5,0x7
    80001a50:	fc07aa23          	sw	zero,-44(a5) # 80008a20 <first.1>
    fsinit(ROOTDEV);
    80001a54:	4505                	li	a0,1
    80001a56:	00002097          	auipc	ra,0x2
    80001a5a:	ad4080e7          	jalr	-1324(ra) # 8000352a <fsinit>
    80001a5e:	bff9                	j	80001a3c <forkret+0x22>

0000000080001a60 <allocpid>:
{
    80001a60:	1101                	addi	sp,sp,-32
    80001a62:	ec06                	sd	ra,24(sp)
    80001a64:	e822                	sd	s0,16(sp)
    80001a66:	e426                	sd	s1,8(sp)
    80001a68:	e04a                	sd	s2,0(sp)
    80001a6a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a6c:	0000f917          	auipc	s2,0xf
    80001a70:	2a490913          	addi	s2,s2,676 # 80010d10 <pid_lock>
    80001a74:	854a                	mv	a0,s2
    80001a76:	fffff097          	auipc	ra,0xfffff
    80001a7a:	15c080e7          	jalr	348(ra) # 80000bd2 <acquire>
  pid = nextpid;
    80001a7e:	00007797          	auipc	a5,0x7
    80001a82:	fa678793          	addi	a5,a5,-90 # 80008a24 <nextpid>
    80001a86:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a88:	0014871b          	addiw	a4,s1,1
    80001a8c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a8e:	854a                	mv	a0,s2
    80001a90:	fffff097          	auipc	ra,0xfffff
    80001a94:	1f6080e7          	jalr	502(ra) # 80000c86 <release>
}
    80001a98:	8526                	mv	a0,s1
    80001a9a:	60e2                	ld	ra,24(sp)
    80001a9c:	6442                	ld	s0,16(sp)
    80001a9e:	64a2                	ld	s1,8(sp)
    80001aa0:	6902                	ld	s2,0(sp)
    80001aa2:	6105                	addi	sp,sp,32
    80001aa4:	8082                	ret

0000000080001aa6 <proc_pagetable>:
{
    80001aa6:	1101                	addi	sp,sp,-32
    80001aa8:	ec06                	sd	ra,24(sp)
    80001aaa:	e822                	sd	s0,16(sp)
    80001aac:	e426                	sd	s1,8(sp)
    80001aae:	e04a                	sd	s2,0(sp)
    80001ab0:	1000                	addi	s0,sp,32
    80001ab2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ab4:	00000097          	auipc	ra,0x0
    80001ab8:	868080e7          	jalr	-1944(ra) # 8000131c <uvmcreate>
    80001abc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001abe:	c121                	beqz	a0,80001afe <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ac0:	4729                	li	a4,10
    80001ac2:	00005697          	auipc	a3,0x5
    80001ac6:	53e68693          	addi	a3,a3,1342 # 80007000 <_trampoline>
    80001aca:	6605                	lui	a2,0x1
    80001acc:	040005b7          	lui	a1,0x4000
    80001ad0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ad2:	05b2                	slli	a1,a1,0xc
    80001ad4:	fffff097          	auipc	ra,0xfffff
    80001ad8:	5cc080e7          	jalr	1484(ra) # 800010a0 <mappages>
    80001adc:	02054863          	bltz	a0,80001b0c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001ae0:	4719                	li	a4,6
    80001ae2:	05893683          	ld	a3,88(s2)
    80001ae6:	6605                	lui	a2,0x1
    80001ae8:	020005b7          	lui	a1,0x2000
    80001aec:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aee:	05b6                	slli	a1,a1,0xd
    80001af0:	8526                	mv	a0,s1
    80001af2:	fffff097          	auipc	ra,0xfffff
    80001af6:	5ae080e7          	jalr	1454(ra) # 800010a0 <mappages>
    80001afa:	02054163          	bltz	a0,80001b1c <proc_pagetable+0x76>
}
    80001afe:	8526                	mv	a0,s1
    80001b00:	60e2                	ld	ra,24(sp)
    80001b02:	6442                	ld	s0,16(sp)
    80001b04:	64a2                	ld	s1,8(sp)
    80001b06:	6902                	ld	s2,0(sp)
    80001b08:	6105                	addi	sp,sp,32
    80001b0a:	8082                	ret
    uvmfree(pagetable, 0);
    80001b0c:	4581                	li	a1,0
    80001b0e:	8526                	mv	a0,s1
    80001b10:	00000097          	auipc	ra,0x0
    80001b14:	a12080e7          	jalr	-1518(ra) # 80001522 <uvmfree>
    return 0;
    80001b18:	4481                	li	s1,0
    80001b1a:	b7d5                	j	80001afe <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b1c:	4681                	li	a3,0
    80001b1e:	4605                	li	a2,1
    80001b20:	040005b7          	lui	a1,0x4000
    80001b24:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b26:	05b2                	slli	a1,a1,0xc
    80001b28:	8526                	mv	a0,s1
    80001b2a:	fffff097          	auipc	ra,0xfffff
    80001b2e:	73c080e7          	jalr	1852(ra) # 80001266 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b32:	4581                	li	a1,0
    80001b34:	8526                	mv	a0,s1
    80001b36:	00000097          	auipc	ra,0x0
    80001b3a:	9ec080e7          	jalr	-1556(ra) # 80001522 <uvmfree>
    return 0;
    80001b3e:	4481                	li	s1,0
    80001b40:	bf7d                	j	80001afe <proc_pagetable+0x58>

0000000080001b42 <proc_freepagetable>:
{
    80001b42:	1101                	addi	sp,sp,-32
    80001b44:	ec06                	sd	ra,24(sp)
    80001b46:	e822                	sd	s0,16(sp)
    80001b48:	e426                	sd	s1,8(sp)
    80001b4a:	e04a                	sd	s2,0(sp)
    80001b4c:	1000                	addi	s0,sp,32
    80001b4e:	84aa                	mv	s1,a0
    80001b50:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b52:	4681                	li	a3,0
    80001b54:	4605                	li	a2,1
    80001b56:	040005b7          	lui	a1,0x4000
    80001b5a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b5c:	05b2                	slli	a1,a1,0xc
    80001b5e:	fffff097          	auipc	ra,0xfffff
    80001b62:	708080e7          	jalr	1800(ra) # 80001266 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b66:	4681                	li	a3,0
    80001b68:	4605                	li	a2,1
    80001b6a:	020005b7          	lui	a1,0x2000
    80001b6e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b70:	05b6                	slli	a1,a1,0xd
    80001b72:	8526                	mv	a0,s1
    80001b74:	fffff097          	auipc	ra,0xfffff
    80001b78:	6f2080e7          	jalr	1778(ra) # 80001266 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b7c:	85ca                	mv	a1,s2
    80001b7e:	8526                	mv	a0,s1
    80001b80:	00000097          	auipc	ra,0x0
    80001b84:	9a2080e7          	jalr	-1630(ra) # 80001522 <uvmfree>
}
    80001b88:	60e2                	ld	ra,24(sp)
    80001b8a:	6442                	ld	s0,16(sp)
    80001b8c:	64a2                	ld	s1,8(sp)
    80001b8e:	6902                	ld	s2,0(sp)
    80001b90:	6105                	addi	sp,sp,32
    80001b92:	8082                	ret

0000000080001b94 <freeproc>:
{
    80001b94:	7179                	addi	sp,sp,-48
    80001b96:	f406                	sd	ra,40(sp)
    80001b98:	f022                	sd	s0,32(sp)
    80001b9a:	ec26                	sd	s1,24(sp)
    80001b9c:	e84a                	sd	s2,16(sp)
    80001b9e:	e44e                	sd	s3,8(sp)
    80001ba0:	e052                	sd	s4,0(sp)
    80001ba2:	1800                	addi	s0,sp,48
    80001ba4:	89aa                	mv	s3,a0
  if(p->trapframe)
    80001ba6:	6d28                	ld	a0,88(a0)
    80001ba8:	c509                	beqz	a0,80001bb2 <freeproc+0x1e>
    kfree((void*)p->trapframe);
    80001baa:	fffff097          	auipc	ra,0xfffff
    80001bae:	e3a080e7          	jalr	-454(ra) # 800009e4 <kfree>
  p->trapframe = 0;
    80001bb2:	0409bc23          	sd	zero,88(s3)
  if(p->pagetable)
    80001bb6:	0509b503          	ld	a0,80(s3)
    80001bba:	c519                	beqz	a0,80001bc8 <freeproc+0x34>
    proc_freepagetable(p->pagetable, p->sz);
    80001bbc:	0489b583          	ld	a1,72(s3)
    80001bc0:	00000097          	auipc	ra,0x0
    80001bc4:	f82080e7          	jalr	-126(ra) # 80001b42 <proc_freepagetable>
  p->pagetable = 0;
    80001bc8:	0409b823          	sd	zero,80(s3)
  p->sz = 0;
    80001bcc:	0409b423          	sd	zero,72(s3)
  p->pid = 0;
    80001bd0:	0209a823          	sw	zero,48(s3)
  p->parent = 0;
    80001bd4:	0209bc23          	sd	zero,56(s3)
  p->name[0] = 0;
    80001bd8:	14098c23          	sb	zero,344(s3)
  p->chan = 0;
    80001bdc:	0209b023          	sd	zero,32(s3)
  p->killed = 0;
    80001be0:	0209a423          	sw	zero,40(s3)
  p->xstate = 0;
    80001be4:	0209a623          	sw	zero,44(s3)
  p->state = UNUSED;
    80001be8:	0009ac23          	sw	zero,24(s3)
  for(int i = 0; i < MAXHEAP; i++) {
    80001bec:	18098493          	addi	s1,s3,384
    80001bf0:	6799                	lui	a5,0x6
    80001bf2:	f4078793          	addi	a5,a5,-192 # 5f40 <_entry-0x7fffa0c0>
    80001bf6:	99be                	add	s3,s3,a5
    if(p->heap_tracker[i].startblock != -1){
    80001bf8:	5a7d                	li	s4,-1
    80001bfa:	a031                	j	80001c06 <freeproc+0x72>
    p->heap_tracker[i].loaded = false;
    80001bfc:	00090023          	sb	zero,0(s2)
  for(int i = 0; i < MAXHEAP; i++) {
    80001c00:	04e1                	addi	s1,s1,24
    80001c02:	01348b63          	beq	s1,s3,80001c18 <freeproc+0x84>
    if(p->heap_tracker[i].startblock != -1){
    80001c06:	8926                	mv	s2,s1
    80001c08:	40c8                	lw	a0,4(s1)
    80001c0a:	ff4509e3          	beq	a0,s4,80001bfc <freeproc+0x68>
      free_psa_block(p->heap_tracker[i].startblock);
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	7a8080e7          	jalr	1960(ra) # 800063b6 <free_psa_block>
    80001c16:	b7dd                	j	80001bfc <freeproc+0x68>
}
    80001c18:	70a2                	ld	ra,40(sp)
    80001c1a:	7402                	ld	s0,32(sp)
    80001c1c:	64e2                	ld	s1,24(sp)
    80001c1e:	6942                	ld	s2,16(sp)
    80001c20:	69a2                	ld	s3,8(sp)
    80001c22:	6a02                	ld	s4,0(sp)
    80001c24:	6145                	addi	sp,sp,48
    80001c26:	8082                	ret

0000000080001c28 <allocproc>:
{
    80001c28:	7179                	addi	sp,sp,-48
    80001c2a:	f406                	sd	ra,40(sp)
    80001c2c:	f022                	sd	s0,32(sp)
    80001c2e:	ec26                	sd	s1,24(sp)
    80001c30:	e84a                	sd	s2,16(sp)
    80001c32:	e44e                	sd	s3,8(sp)
    80001c34:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c36:	0000f497          	auipc	s1,0xf
    80001c3a:	50a48493          	addi	s1,s1,1290 # 80011140 <proc>
    80001c3e:	6919                	lui	s2,0x6
    80001c40:	f3890913          	addi	s2,s2,-200 # 5f38 <_entry-0x7fffa0c8>
    80001c44:	0018c997          	auipc	s3,0x18c
    80001c48:	2fc98993          	addi	s3,s3,764 # 8018df40 <tickslock>
    acquire(&p->lock);
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	fffff097          	auipc	ra,0xfffff
    80001c52:	f84080e7          	jalr	-124(ra) # 80000bd2 <acquire>
    if(p->state == UNUSED) {
    80001c56:	4c9c                	lw	a5,24(s1)
    80001c58:	cb99                	beqz	a5,80001c6e <allocproc+0x46>
      release(&p->lock);
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	02a080e7          	jalr	42(ra) # 80000c86 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c64:	94ca                	add	s1,s1,s2
    80001c66:	ff3493e3          	bne	s1,s3,80001c4c <allocproc+0x24>
  return 0;
    80001c6a:	4481                	li	s1,0
    80001c6c:	a889                	j	80001cbe <allocproc+0x96>
  p->pid = allocpid();
    80001c6e:	00000097          	auipc	ra,0x0
    80001c72:	df2080e7          	jalr	-526(ra) # 80001a60 <allocpid>
    80001c76:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c78:	4785                	li	a5,1
    80001c7a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c7c:	fffff097          	auipc	ra,0xfffff
    80001c80:	e66080e7          	jalr	-410(ra) # 80000ae2 <kalloc>
    80001c84:	892a                	mv	s2,a0
    80001c86:	eca8                	sd	a0,88(s1)
    80001c88:	c139                	beqz	a0,80001cce <allocproc+0xa6>
  p->pagetable = proc_pagetable(p);
    80001c8a:	8526                	mv	a0,s1
    80001c8c:	00000097          	auipc	ra,0x0
    80001c90:	e1a080e7          	jalr	-486(ra) # 80001aa6 <proc_pagetable>
    80001c94:	892a                	mv	s2,a0
    80001c96:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c98:	c539                	beqz	a0,80001ce6 <allocproc+0xbe>
  memset(&p->context, 0, sizeof(p->context));
    80001c9a:	07000613          	li	a2,112
    80001c9e:	4581                	li	a1,0
    80001ca0:	06048513          	addi	a0,s1,96
    80001ca4:	fffff097          	auipc	ra,0xfffff
    80001ca8:	02a080e7          	jalr	42(ra) # 80000cce <memset>
  p->context.ra = (uint64)forkret;
    80001cac:	00000797          	auipc	a5,0x0
    80001cb0:	d6e78793          	addi	a5,a5,-658 # 80001a1a <forkret>
    80001cb4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cb6:	60bc                	ld	a5,64(s1)
    80001cb8:	6705                	lui	a4,0x1
    80001cba:	97ba                	add	a5,a5,a4
    80001cbc:	f4bc                	sd	a5,104(s1)
}
    80001cbe:	8526                	mv	a0,s1
    80001cc0:	70a2                	ld	ra,40(sp)
    80001cc2:	7402                	ld	s0,32(sp)
    80001cc4:	64e2                	ld	s1,24(sp)
    80001cc6:	6942                	ld	s2,16(sp)
    80001cc8:	69a2                	ld	s3,8(sp)
    80001cca:	6145                	addi	sp,sp,48
    80001ccc:	8082                	ret
    freeproc(p);
    80001cce:	8526                	mv	a0,s1
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	ec4080e7          	jalr	-316(ra) # 80001b94 <freeproc>
    release(&p->lock);
    80001cd8:	8526                	mv	a0,s1
    80001cda:	fffff097          	auipc	ra,0xfffff
    80001cde:	fac080e7          	jalr	-84(ra) # 80000c86 <release>
    return 0;
    80001ce2:	84ca                	mv	s1,s2
    80001ce4:	bfe9                	j	80001cbe <allocproc+0x96>
    freeproc(p);
    80001ce6:	8526                	mv	a0,s1
    80001ce8:	00000097          	auipc	ra,0x0
    80001cec:	eac080e7          	jalr	-340(ra) # 80001b94 <freeproc>
    release(&p->lock);
    80001cf0:	8526                	mv	a0,s1
    80001cf2:	fffff097          	auipc	ra,0xfffff
    80001cf6:	f94080e7          	jalr	-108(ra) # 80000c86 <release>
    return 0;
    80001cfa:	84ca                	mv	s1,s2
    80001cfc:	b7c9                	j	80001cbe <allocproc+0x96>

0000000080001cfe <userinit>:
{
    80001cfe:	1101                	addi	sp,sp,-32
    80001d00:	ec06                	sd	ra,24(sp)
    80001d02:	e822                	sd	s0,16(sp)
    80001d04:	e426                	sd	s1,8(sp)
    80001d06:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	f20080e7          	jalr	-224(ra) # 80001c28 <allocproc>
    80001d10:	84aa                	mv	s1,a0
  initproc = p;
    80001d12:	00007797          	auipc	a5,0x7
    80001d16:	d8a7b323          	sd	a0,-634(a5) # 80008a98 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001d1a:	03400613          	li	a2,52
    80001d1e:	00007597          	auipc	a1,0x7
    80001d22:	d1258593          	addi	a1,a1,-750 # 80008a30 <initcode>
    80001d26:	6928                	ld	a0,80(a0)
    80001d28:	fffff097          	auipc	ra,0xfffff
    80001d2c:	622080e7          	jalr	1570(ra) # 8000134a <uvmfirst>
  p->sz = PGSIZE;
    80001d30:	6785                	lui	a5,0x1
    80001d32:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d34:	6cb8                	ld	a4,88(s1)
    80001d36:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d3a:	6cb8                	ld	a4,88(s1)
    80001d3c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d3e:	4641                	li	a2,16
    80001d40:	00006597          	auipc	a1,0x6
    80001d44:	4b858593          	addi	a1,a1,1208 # 800081f8 <digits+0x1b8>
    80001d48:	15848513          	addi	a0,s1,344
    80001d4c:	fffff097          	auipc	ra,0xfffff
    80001d50:	0ca080e7          	jalr	202(ra) # 80000e16 <safestrcpy>
  p->cwd = namei("/");
    80001d54:	00006517          	auipc	a0,0x6
    80001d58:	4b450513          	addi	a0,a0,1204 # 80008208 <digits+0x1c8>
    80001d5c:	00002097          	auipc	ra,0x2
    80001d60:	1ec080e7          	jalr	492(ra) # 80003f48 <namei>
    80001d64:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d68:	478d                	li	a5,3
    80001d6a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d6c:	8526                	mv	a0,s1
    80001d6e:	fffff097          	auipc	ra,0xfffff
    80001d72:	f18080e7          	jalr	-232(ra) # 80000c86 <release>
}
    80001d76:	60e2                	ld	ra,24(sp)
    80001d78:	6442                	ld	s0,16(sp)
    80001d7a:	64a2                	ld	s1,8(sp)
    80001d7c:	6105                	addi	sp,sp,32
    80001d7e:	8082                	ret

0000000080001d80 <track_heap>:
  for (int i = 0; i < MAXHEAP; i++) {
    80001d80:	17050793          	addi	a5,a0,368
    80001d84:	6719                	lui	a4,0x6
    80001d86:	f3070713          	addi	a4,a4,-208 # 5f30 <_entry-0x7fffa0d0>
    80001d8a:	953a                	add	a0,a0,a4
    if (p->heap_tracker[i].addr == 0xFFFFFFFFFFFFFFFF) {
    80001d8c:	56fd                	li	a3,-1
  for (int i = 0; i < MAXHEAP; i++) {
    80001d8e:	6805                	lui	a6,0x1
    80001d90:	a029                	j	80001d9a <track_heap+0x1a>
    80001d92:	07e1                	addi	a5,a5,24 # 1018 <_entry-0x7fffefe8>
    80001d94:	95c2                	add	a1,a1,a6
    80001d96:	00a78c63          	beq	a5,a0,80001dae <track_heap+0x2e>
    if (p->heap_tracker[i].addr == 0xFFFFFFFFFFFFFFFF) {
    80001d9a:	6398                	ld	a4,0(a5)
    80001d9c:	fed71be3          	bne	a4,a3,80001d92 <track_heap+0x12>
      p->heap_tracker[i].addr           = start + (i*PGSIZE);
    80001da0:	e38c                	sd	a1,0(a5)
      p->heap_tracker[i].loaded         = 0;   
    80001da2:	00078823          	sb	zero,16(a5)
      p->heap_tracker[i].startblock     = -1;
    80001da6:	cbd4                	sw	a3,20(a5)
      npages--;
    80001da8:	367d                	addiw	a2,a2,-1 # fff <_entry-0x7ffff001>
      if (npages == 0) return;
    80001daa:	f665                	bnez	a2,80001d92 <track_heap+0x12>
    80001dac:	8082                	ret
void track_heap(struct proc* p, uint64 start, int npages) {
    80001dae:	1141                	addi	sp,sp,-16
    80001db0:	e406                	sd	ra,8(sp)
    80001db2:	e022                	sd	s0,0(sp)
    80001db4:	0800                	addi	s0,sp,16
  panic("Error: No more process heap pages allowed.\n");
    80001db6:	00006517          	auipc	a0,0x6
    80001dba:	45a50513          	addi	a0,a0,1114 # 80008210 <digits+0x1d0>
    80001dbe:	ffffe097          	auipc	ra,0xffffe
    80001dc2:	77e080e7          	jalr	1918(ra) # 8000053c <panic>

0000000080001dc6 <growproc>:
{
    80001dc6:	1101                	addi	sp,sp,-32
    80001dc8:	ec06                	sd	ra,24(sp)
    80001dca:	e822                	sd	s0,16(sp)
    80001dcc:	e426                	sd	s1,8(sp)
    80001dce:	e04a                	sd	s2,0(sp)
    80001dd0:	1000                	addi	s0,sp,32
    80001dd2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	c0e080e7          	jalr	-1010(ra) # 800019e2 <myproc>
    80001ddc:	84aa                	mv	s1,a0
  n = PGROUNDUP(n);
    80001dde:	6605                	lui	a2,0x1
    80001de0:	367d                	addiw	a2,a2,-1 # fff <_entry-0x7ffff001>
    80001de2:	0126063b          	addw	a2,a2,s2
    80001de6:	77fd                	lui	a5,0xfffff
    80001de8:	8e7d                	and	a2,a2,a5
  sz = p->sz;
    80001dea:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001dec:	08c05263          	blez	a2,80001e70 <growproc+0xaa>
    if(p->ondemand == true) {
    80001df0:	16854783          	lbu	a5,360(a0)
    80001df4:	c3bd                	beqz	a5,80001e5a <growproc+0x94>
      uint64 a = PGROUNDUP(sz);
    80001df6:	6785                	lui	a5,0x1
    80001df8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001dfa:	95be                	add	a1,a1,a5
    80001dfc:	77fd                	lui	a5,0xfffff
    80001dfe:	8dfd                	and	a1,a1,a5
      uint64 newsz = a + n;
    80001e00:	00b60333          	add	t1,a2,a1
      for(; a < newsz; a += PGSIZE){
    80001e04:	0465f063          	bgeu	a1,t1,80001e44 <growproc+0x7e>
      uint64 a = PGROUNDUP(sz);
    80001e08:	852e                	mv	a0,a1
      int total_pages = 0;
    80001e0a:	4601                	li	a2,0
        for (int i=0; i < MAXHEAP; i++) {
    80001e0c:	4e81                	li	t4,0
          if(p->heap_tracker[i].addr == 0xFFFFFFFFFFFFFFFF){
    80001e0e:	587d                	li	a6,-1
        for (int i=0; i < MAXHEAP; i++) {
    80001e10:	3e800893          	li	a7,1000
      for(; a < newsz; a += PGSIZE){
    80001e14:	6e05                	lui	t3,0x1
    80001e16:	a819                	j	80001e2c <growproc+0x66>
            p->heap_tracker[i].addr = a;
    80001e18:	00179713          	slli	a4,a5,0x1
    80001e1c:	97ba                	add	a5,a5,a4
    80001e1e:	078e                	slli	a5,a5,0x3
    80001e20:	97a6                	add	a5,a5,s1
    80001e22:	16a7b823          	sd	a0,368(a5) # fffffffffffff170 <end+0xffffffff7fe65a60>
      for(; a < newsz; a += PGSIZE){
    80001e26:	9572                	add	a0,a0,t3
    80001e28:	00657f63          	bgeu	a0,t1,80001e46 <growproc+0x80>
        total_pages++;
    80001e2c:	2605                	addiw	a2,a2,1
        for (int i=0; i < MAXHEAP; i++) {
    80001e2e:	17048713          	addi	a4,s1,368
    80001e32:	87f6                	mv	a5,t4
          if(p->heap_tracker[i].addr == 0xFFFFFFFFFFFFFFFF){
    80001e34:	6314                	ld	a3,0(a4)
    80001e36:	ff0681e3          	beq	a3,a6,80001e18 <growproc+0x52>
        for (int i=0; i < MAXHEAP; i++) {
    80001e3a:	2785                	addiw	a5,a5,1
    80001e3c:	0761                	addi	a4,a4,24
    80001e3e:	ff179be3          	bne	a5,a7,80001e34 <growproc+0x6e>
    80001e42:	b7d5                	j	80001e26 <growproc+0x60>
      int total_pages = 0;
    80001e44:	4601                	li	a2,0
      p->sz = newsz;
    80001e46:	0464b423          	sd	t1,72(s1)
      print_skip_heap_region(p->name, start_addr, total_pages);
    80001e4a:	15848513          	addi	a0,s1,344
    80001e4e:	00005097          	auipc	ra,0x5
    80001e52:	b6e080e7          	jalr	-1170(ra) # 800069bc <print_skip_heap_region>
      return 0;
    80001e56:	4501                	li	a0,0
    80001e58:	a005                	j	80001e78 <growproc+0xb2>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001e5a:	4691                	li	a3,4
    80001e5c:	962e                	add	a2,a2,a1
    80001e5e:	6928                	ld	a0,80(a0)
    80001e60:	fffff097          	auipc	ra,0xfffff
    80001e64:	5a4080e7          	jalr	1444(ra) # 80001404 <uvmalloc>
    80001e68:	85aa                	mv	a1,a0
    80001e6a:	e509                	bnez	a0,80001e74 <growproc+0xae>
      return -1;
    80001e6c:	557d                	li	a0,-1
    80001e6e:	a029                	j	80001e78 <growproc+0xb2>
  } else if(n < 0){
    80001e70:	00064a63          	bltz	a2,80001e84 <growproc+0xbe>
  p->sz = sz;
    80001e74:	e4ac                	sd	a1,72(s1)
  return 0;
    80001e76:	4501                	li	a0,0
}
    80001e78:	60e2                	ld	ra,24(sp)
    80001e7a:	6442                	ld	s0,16(sp)
    80001e7c:	64a2                	ld	s1,8(sp)
    80001e7e:	6902                	ld	s2,0(sp)
    80001e80:	6105                	addi	sp,sp,32
    80001e82:	8082                	ret
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e84:	962e                	add	a2,a2,a1
    80001e86:	6928                	ld	a0,80(a0)
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	534080e7          	jalr	1332(ra) # 800013bc <uvmdealloc>
    80001e90:	85aa                	mv	a1,a0
    80001e92:	b7cd                	j	80001e74 <growproc+0xae>

0000000080001e94 <fork>:
{
    80001e94:	7139                	addi	sp,sp,-64
    80001e96:	fc06                	sd	ra,56(sp)
    80001e98:	f822                	sd	s0,48(sp)
    80001e9a:	f426                	sd	s1,40(sp)
    80001e9c:	f04a                	sd	s2,32(sp)
    80001e9e:	ec4e                	sd	s3,24(sp)
    80001ea0:	e852                	sd	s4,16(sp)
    80001ea2:	e456                	sd	s5,8(sp)
    80001ea4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001ea6:	00000097          	auipc	ra,0x0
    80001eaa:	b3c080e7          	jalr	-1220(ra) # 800019e2 <myproc>
    80001eae:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001eb0:	00000097          	auipc	ra,0x0
    80001eb4:	d78080e7          	jalr	-648(ra) # 80001c28 <allocproc>
    80001eb8:	12050063          	beqz	a0,80001fd8 <fork+0x144>
    80001ebc:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001ebe:	048ab603          	ld	a2,72(s5)
    80001ec2:	692c                	ld	a1,80(a0)
    80001ec4:	050ab503          	ld	a0,80(s5)
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	694080e7          	jalr	1684(ra) # 8000155c <uvmcopy>
    80001ed0:	04054863          	bltz	a0,80001f20 <fork+0x8c>
  np->sz = p->sz;
    80001ed4:	048ab783          	ld	a5,72(s5)
    80001ed8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001edc:	058ab683          	ld	a3,88(s5)
    80001ee0:	87b6                	mv	a5,a3
    80001ee2:	0589b703          	ld	a4,88(s3)
    80001ee6:	12068693          	addi	a3,a3,288
    80001eea:	0007b803          	ld	a6,0(a5)
    80001eee:	6788                	ld	a0,8(a5)
    80001ef0:	6b8c                	ld	a1,16(a5)
    80001ef2:	6f90                	ld	a2,24(a5)
    80001ef4:	01073023          	sd	a6,0(a4)
    80001ef8:	e708                	sd	a0,8(a4)
    80001efa:	eb0c                	sd	a1,16(a4)
    80001efc:	ef10                	sd	a2,24(a4)
    80001efe:	02078793          	addi	a5,a5,32
    80001f02:	02070713          	addi	a4,a4,32
    80001f06:	fed792e3          	bne	a5,a3,80001eea <fork+0x56>
  np->trapframe->a0 = 0;
    80001f0a:	0589b783          	ld	a5,88(s3)
    80001f0e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001f12:	0d0a8493          	addi	s1,s5,208
    80001f16:	0d098913          	addi	s2,s3,208
    80001f1a:	150a8a13          	addi	s4,s5,336
    80001f1e:	a00d                	j	80001f40 <fork+0xac>
    freeproc(np);
    80001f20:	854e                	mv	a0,s3
    80001f22:	00000097          	auipc	ra,0x0
    80001f26:	c72080e7          	jalr	-910(ra) # 80001b94 <freeproc>
    release(&np->lock);
    80001f2a:	854e                	mv	a0,s3
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	d5a080e7          	jalr	-678(ra) # 80000c86 <release>
    return -1;
    80001f34:	597d                	li	s2,-1
    80001f36:	a079                	j	80001fc4 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001f38:	04a1                	addi	s1,s1,8
    80001f3a:	0921                	addi	s2,s2,8
    80001f3c:	01448b63          	beq	s1,s4,80001f52 <fork+0xbe>
    if(p->ofile[i])
    80001f40:	6088                	ld	a0,0(s1)
    80001f42:	d97d                	beqz	a0,80001f38 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f44:	00002097          	auipc	ra,0x2
    80001f48:	676080e7          	jalr	1654(ra) # 800045ba <filedup>
    80001f4c:	00a93023          	sd	a0,0(s2)
    80001f50:	b7e5                	j	80001f38 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001f52:	150ab503          	ld	a0,336(s5)
    80001f56:	00002097          	auipc	ra,0x2
    80001f5a:	80e080e7          	jalr	-2034(ra) # 80003764 <idup>
    80001f5e:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f62:	4641                	li	a2,16
    80001f64:	158a8593          	addi	a1,s5,344
    80001f68:	15898513          	addi	a0,s3,344
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	eaa080e7          	jalr	-342(ra) # 80000e16 <safestrcpy>
  np->ondemand = p->ondemand;
    80001f74:	168ac783          	lbu	a5,360(s5)
    80001f78:	16f98423          	sb	a5,360(s3)
  pid = np->pid;
    80001f7c:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001f80:	854e                	mv	a0,s3
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	d04080e7          	jalr	-764(ra) # 80000c86 <release>
  acquire(&wait_lock);
    80001f8a:	0000f497          	auipc	s1,0xf
    80001f8e:	d9e48493          	addi	s1,s1,-610 # 80010d28 <wait_lock>
    80001f92:	8526                	mv	a0,s1
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	c3e080e7          	jalr	-962(ra) # 80000bd2 <acquire>
  np->parent = p;
    80001f9c:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001fa0:	8526                	mv	a0,s1
    80001fa2:	fffff097          	auipc	ra,0xfffff
    80001fa6:	ce4080e7          	jalr	-796(ra) # 80000c86 <release>
  acquire(&np->lock);
    80001faa:	854e                	mv	a0,s3
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	c26080e7          	jalr	-986(ra) # 80000bd2 <acquire>
  np->state = RUNNABLE;
    80001fb4:	478d                	li	a5,3
    80001fb6:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001fba:	854e                	mv	a0,s3
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	cca080e7          	jalr	-822(ra) # 80000c86 <release>
}
    80001fc4:	854a                	mv	a0,s2
    80001fc6:	70e2                	ld	ra,56(sp)
    80001fc8:	7442                	ld	s0,48(sp)
    80001fca:	74a2                	ld	s1,40(sp)
    80001fcc:	7902                	ld	s2,32(sp)
    80001fce:	69e2                	ld	s3,24(sp)
    80001fd0:	6a42                	ld	s4,16(sp)
    80001fd2:	6aa2                	ld	s5,8(sp)
    80001fd4:	6121                	addi	sp,sp,64
    80001fd6:	8082                	ret
    return -1;
    80001fd8:	597d                	li	s2,-1
    80001fda:	b7ed                	j	80001fc4 <fork+0x130>

0000000080001fdc <scheduler>:
{
    80001fdc:	715d                	addi	sp,sp,-80
    80001fde:	e486                	sd	ra,72(sp)
    80001fe0:	e0a2                	sd	s0,64(sp)
    80001fe2:	fc26                	sd	s1,56(sp)
    80001fe4:	f84a                	sd	s2,48(sp)
    80001fe6:	f44e                	sd	s3,40(sp)
    80001fe8:	f052                	sd	s4,32(sp)
    80001fea:	ec56                	sd	s5,24(sp)
    80001fec:	e85a                	sd	s6,16(sp)
    80001fee:	e45e                	sd	s7,8(sp)
    80001ff0:	0880                	addi	s0,sp,80
    80001ff2:	8792                	mv	a5,tp
  int id = r_tp();
    80001ff4:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ff6:	00779b13          	slli	s6,a5,0x7
    80001ffa:	0000f717          	auipc	a4,0xf
    80001ffe:	d1670713          	addi	a4,a4,-746 # 80010d10 <pid_lock>
    80002002:	975a                	add	a4,a4,s6
    80002004:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002008:	0000f717          	auipc	a4,0xf
    8000200c:	d4070713          	addi	a4,a4,-704 # 80010d48 <cpus+0x8>
    80002010:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80002012:	4b91                	li	s7,4
        c->proc = p;
    80002014:	079e                	slli	a5,a5,0x7
    80002016:	0000fa97          	auipc	s5,0xf
    8000201a:	cfaa8a93          	addi	s5,s5,-774 # 80010d10 <pid_lock>
    8000201e:	9abe                	add	s5,s5,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002020:	6999                	lui	s3,0x6
    80002022:	f3898993          	addi	s3,s3,-200 # 5f38 <_entry-0x7fffa0c8>
    80002026:	0018ca17          	auipc	s4,0x18c
    8000202a:	f1aa0a13          	addi	s4,s4,-230 # 8018df40 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000202e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002032:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002036:	10079073          	csrw	sstatus,a5
    8000203a:	0000f497          	auipc	s1,0xf
    8000203e:	10648493          	addi	s1,s1,262 # 80011140 <proc>
      if(p->state == RUNNABLE) {
    80002042:	490d                	li	s2,3
    80002044:	a809                	j	80002056 <scheduler+0x7a>
      release(&p->lock);
    80002046:	8526                	mv	a0,s1
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	c3e080e7          	jalr	-962(ra) # 80000c86 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002050:	94ce                	add	s1,s1,s3
    80002052:	fd448ee3          	beq	s1,s4,8000202e <scheduler+0x52>
      acquire(&p->lock);
    80002056:	8526                	mv	a0,s1
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	b7a080e7          	jalr	-1158(ra) # 80000bd2 <acquire>
      if(p->state == RUNNABLE) {
    80002060:	4c9c                	lw	a5,24(s1)
    80002062:	ff2792e3          	bne	a5,s2,80002046 <scheduler+0x6a>
        p->state = RUNNING;
    80002066:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    8000206a:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    8000206e:	06048593          	addi	a1,s1,96
    80002072:	855a                	mv	a0,s6
    80002074:	00000097          	auipc	ra,0x0
    80002078:	6a0080e7          	jalr	1696(ra) # 80002714 <swtch>
        c->proc = 0;
    8000207c:	020ab823          	sd	zero,48(s5)
    80002080:	b7d9                	j	80002046 <scheduler+0x6a>

0000000080002082 <sched>:
{
    80002082:	7179                	addi	sp,sp,-48
    80002084:	f406                	sd	ra,40(sp)
    80002086:	f022                	sd	s0,32(sp)
    80002088:	ec26                	sd	s1,24(sp)
    8000208a:	e84a                	sd	s2,16(sp)
    8000208c:	e44e                	sd	s3,8(sp)
    8000208e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002090:	00000097          	auipc	ra,0x0
    80002094:	952080e7          	jalr	-1710(ra) # 800019e2 <myproc>
    80002098:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	abe080e7          	jalr	-1346(ra) # 80000b58 <holding>
    800020a2:	c93d                	beqz	a0,80002118 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020a4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800020a6:	2781                	sext.w	a5,a5
    800020a8:	079e                	slli	a5,a5,0x7
    800020aa:	0000f717          	auipc	a4,0xf
    800020ae:	c6670713          	addi	a4,a4,-922 # 80010d10 <pid_lock>
    800020b2:	97ba                	add	a5,a5,a4
    800020b4:	0a87a703          	lw	a4,168(a5)
    800020b8:	4785                	li	a5,1
    800020ba:	06f71763          	bne	a4,a5,80002128 <sched+0xa6>
  if(p->state == RUNNING)
    800020be:	4c98                	lw	a4,24(s1)
    800020c0:	4791                	li	a5,4
    800020c2:	06f70b63          	beq	a4,a5,80002138 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020ca:	8b89                	andi	a5,a5,2
  if(intr_get())
    800020cc:	efb5                	bnez	a5,80002148 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020ce:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800020d0:	0000f917          	auipc	s2,0xf
    800020d4:	c4090913          	addi	s2,s2,-960 # 80010d10 <pid_lock>
    800020d8:	2781                	sext.w	a5,a5
    800020da:	079e                	slli	a5,a5,0x7
    800020dc:	97ca                	add	a5,a5,s2
    800020de:	0ac7a983          	lw	s3,172(a5)
    800020e2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800020e4:	2781                	sext.w	a5,a5
    800020e6:	079e                	slli	a5,a5,0x7
    800020e8:	0000f597          	auipc	a1,0xf
    800020ec:	c6058593          	addi	a1,a1,-928 # 80010d48 <cpus+0x8>
    800020f0:	95be                	add	a1,a1,a5
    800020f2:	06048513          	addi	a0,s1,96
    800020f6:	00000097          	auipc	ra,0x0
    800020fa:	61e080e7          	jalr	1566(ra) # 80002714 <swtch>
    800020fe:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002100:	2781                	sext.w	a5,a5
    80002102:	079e                	slli	a5,a5,0x7
    80002104:	993e                	add	s2,s2,a5
    80002106:	0b392623          	sw	s3,172(s2)
}
    8000210a:	70a2                	ld	ra,40(sp)
    8000210c:	7402                	ld	s0,32(sp)
    8000210e:	64e2                	ld	s1,24(sp)
    80002110:	6942                	ld	s2,16(sp)
    80002112:	69a2                	ld	s3,8(sp)
    80002114:	6145                	addi	sp,sp,48
    80002116:	8082                	ret
    panic("sched p->lock");
    80002118:	00006517          	auipc	a0,0x6
    8000211c:	12850513          	addi	a0,a0,296 # 80008240 <digits+0x200>
    80002120:	ffffe097          	auipc	ra,0xffffe
    80002124:	41c080e7          	jalr	1052(ra) # 8000053c <panic>
    panic("sched locks");
    80002128:	00006517          	auipc	a0,0x6
    8000212c:	12850513          	addi	a0,a0,296 # 80008250 <digits+0x210>
    80002130:	ffffe097          	auipc	ra,0xffffe
    80002134:	40c080e7          	jalr	1036(ra) # 8000053c <panic>
    panic("sched running");
    80002138:	00006517          	auipc	a0,0x6
    8000213c:	12850513          	addi	a0,a0,296 # 80008260 <digits+0x220>
    80002140:	ffffe097          	auipc	ra,0xffffe
    80002144:	3fc080e7          	jalr	1020(ra) # 8000053c <panic>
    panic("sched interruptible");
    80002148:	00006517          	auipc	a0,0x6
    8000214c:	12850513          	addi	a0,a0,296 # 80008270 <digits+0x230>
    80002150:	ffffe097          	auipc	ra,0xffffe
    80002154:	3ec080e7          	jalr	1004(ra) # 8000053c <panic>

0000000080002158 <yield>:
{
    80002158:	1101                	addi	sp,sp,-32
    8000215a:	ec06                	sd	ra,24(sp)
    8000215c:	e822                	sd	s0,16(sp)
    8000215e:	e426                	sd	s1,8(sp)
    80002160:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002162:	00000097          	auipc	ra,0x0
    80002166:	880080e7          	jalr	-1920(ra) # 800019e2 <myproc>
    8000216a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	a66080e7          	jalr	-1434(ra) # 80000bd2 <acquire>
  p->state = RUNNABLE;
    80002174:	478d                	li	a5,3
    80002176:	cc9c                	sw	a5,24(s1)
  sched();
    80002178:	00000097          	auipc	ra,0x0
    8000217c:	f0a080e7          	jalr	-246(ra) # 80002082 <sched>
  release(&p->lock);
    80002180:	8526                	mv	a0,s1
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	b04080e7          	jalr	-1276(ra) # 80000c86 <release>
}
    8000218a:	60e2                	ld	ra,24(sp)
    8000218c:	6442                	ld	s0,16(sp)
    8000218e:	64a2                	ld	s1,8(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002194:	7179                	addi	sp,sp,-48
    80002196:	f406                	sd	ra,40(sp)
    80002198:	f022                	sd	s0,32(sp)
    8000219a:	ec26                	sd	s1,24(sp)
    8000219c:	e84a                	sd	s2,16(sp)
    8000219e:	e44e                	sd	s3,8(sp)
    800021a0:	1800                	addi	s0,sp,48
    800021a2:	89aa                	mv	s3,a0
    800021a4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	83c080e7          	jalr	-1988(ra) # 800019e2 <myproc>
    800021ae:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800021b0:	fffff097          	auipc	ra,0xfffff
    800021b4:	a22080e7          	jalr	-1502(ra) # 80000bd2 <acquire>
  release(lk);
    800021b8:	854a                	mv	a0,s2
    800021ba:	fffff097          	auipc	ra,0xfffff
    800021be:	acc080e7          	jalr	-1332(ra) # 80000c86 <release>

  // Go to sleep.
  p->chan = chan;
    800021c2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800021c6:	4789                	li	a5,2
    800021c8:	cc9c                	sw	a5,24(s1)

  /* Adil: sleeping. */
  // printf("Sleeping and yielding CPU.");

  sched();
    800021ca:	00000097          	auipc	ra,0x0
    800021ce:	eb8080e7          	jalr	-328(ra) # 80002082 <sched>

  // Tidy up.
  p->chan = 0;
    800021d2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800021d6:	8526                	mv	a0,s1
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	aae080e7          	jalr	-1362(ra) # 80000c86 <release>
  acquire(lk);
    800021e0:	854a                	mv	a0,s2
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	9f0080e7          	jalr	-1552(ra) # 80000bd2 <acquire>
}
    800021ea:	70a2                	ld	ra,40(sp)
    800021ec:	7402                	ld	s0,32(sp)
    800021ee:	64e2                	ld	s1,24(sp)
    800021f0:	6942                	ld	s2,16(sp)
    800021f2:	69a2                	ld	s3,8(sp)
    800021f4:	6145                	addi	sp,sp,48
    800021f6:	8082                	ret

00000000800021f8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800021f8:	7139                	addi	sp,sp,-64
    800021fa:	fc06                	sd	ra,56(sp)
    800021fc:	f822                	sd	s0,48(sp)
    800021fe:	f426                	sd	s1,40(sp)
    80002200:	f04a                	sd	s2,32(sp)
    80002202:	ec4e                	sd	s3,24(sp)
    80002204:	e852                	sd	s4,16(sp)
    80002206:	e456                	sd	s5,8(sp)
    80002208:	e05a                	sd	s6,0(sp)
    8000220a:	0080                	addi	s0,sp,64
    8000220c:	8aaa                	mv	s5,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000220e:	0000f497          	auipc	s1,0xf
    80002212:	f3248493          	addi	s1,s1,-206 # 80011140 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002216:	4a09                	li	s4,2
        p->state = RUNNABLE;
    80002218:	4b0d                	li	s6,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000221a:	6919                	lui	s2,0x6
    8000221c:	f3890913          	addi	s2,s2,-200 # 5f38 <_entry-0x7fffa0c8>
    80002220:	0018c997          	auipc	s3,0x18c
    80002224:	d2098993          	addi	s3,s3,-736 # 8018df40 <tickslock>
    80002228:	a809                	j	8000223a <wakeup+0x42>
      }
      release(&p->lock);
    8000222a:	8526                	mv	a0,s1
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	a5a080e7          	jalr	-1446(ra) # 80000c86 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002234:	94ca                	add	s1,s1,s2
    80002236:	03348663          	beq	s1,s3,80002262 <wakeup+0x6a>
    if(p != myproc()){
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	7a8080e7          	jalr	1960(ra) # 800019e2 <myproc>
    80002242:	fea489e3          	beq	s1,a0,80002234 <wakeup+0x3c>
      acquire(&p->lock);
    80002246:	8526                	mv	a0,s1
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	98a080e7          	jalr	-1654(ra) # 80000bd2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002250:	4c9c                	lw	a5,24(s1)
    80002252:	fd479ce3          	bne	a5,s4,8000222a <wakeup+0x32>
    80002256:	709c                	ld	a5,32(s1)
    80002258:	fd5799e3          	bne	a5,s5,8000222a <wakeup+0x32>
        p->state = RUNNABLE;
    8000225c:	0164ac23          	sw	s6,24(s1)
    80002260:	b7e9                	j	8000222a <wakeup+0x32>
    }
  }
}
    80002262:	70e2                	ld	ra,56(sp)
    80002264:	7442                	ld	s0,48(sp)
    80002266:	74a2                	ld	s1,40(sp)
    80002268:	7902                	ld	s2,32(sp)
    8000226a:	69e2                	ld	s3,24(sp)
    8000226c:	6a42                	ld	s4,16(sp)
    8000226e:	6aa2                	ld	s5,8(sp)
    80002270:	6b02                	ld	s6,0(sp)
    80002272:	6121                	addi	sp,sp,64
    80002274:	8082                	ret

0000000080002276 <reparent>:
{
    80002276:	7139                	addi	sp,sp,-64
    80002278:	fc06                	sd	ra,56(sp)
    8000227a:	f822                	sd	s0,48(sp)
    8000227c:	f426                	sd	s1,40(sp)
    8000227e:	f04a                	sd	s2,32(sp)
    80002280:	ec4e                	sd	s3,24(sp)
    80002282:	e852                	sd	s4,16(sp)
    80002284:	e456                	sd	s5,8(sp)
    80002286:	0080                	addi	s0,sp,64
    80002288:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000228a:	0000f497          	auipc	s1,0xf
    8000228e:	eb648493          	addi	s1,s1,-330 # 80011140 <proc>
      pp->parent = initproc;
    80002292:	00007a97          	auipc	s5,0x7
    80002296:	806a8a93          	addi	s5,s5,-2042 # 80008a98 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000229a:	6919                	lui	s2,0x6
    8000229c:	f3890913          	addi	s2,s2,-200 # 5f38 <_entry-0x7fffa0c8>
    800022a0:	0018ca17          	auipc	s4,0x18c
    800022a4:	ca0a0a13          	addi	s4,s4,-864 # 8018df40 <tickslock>
    800022a8:	a021                	j	800022b0 <reparent+0x3a>
    800022aa:	94ca                	add	s1,s1,s2
    800022ac:	01448d63          	beq	s1,s4,800022c6 <reparent+0x50>
    if(pp->parent == p){
    800022b0:	7c9c                	ld	a5,56(s1)
    800022b2:	ff379ce3          	bne	a5,s3,800022aa <reparent+0x34>
      pp->parent = initproc;
    800022b6:	000ab503          	ld	a0,0(s5)
    800022ba:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800022bc:	00000097          	auipc	ra,0x0
    800022c0:	f3c080e7          	jalr	-196(ra) # 800021f8 <wakeup>
    800022c4:	b7dd                	j	800022aa <reparent+0x34>
}
    800022c6:	70e2                	ld	ra,56(sp)
    800022c8:	7442                	ld	s0,48(sp)
    800022ca:	74a2                	ld	s1,40(sp)
    800022cc:	7902                	ld	s2,32(sp)
    800022ce:	69e2                	ld	s3,24(sp)
    800022d0:	6a42                	ld	s4,16(sp)
    800022d2:	6aa2                	ld	s5,8(sp)
    800022d4:	6121                	addi	sp,sp,64
    800022d6:	8082                	ret

00000000800022d8 <exit>:
{
    800022d8:	7179                	addi	sp,sp,-48
    800022da:	f406                	sd	ra,40(sp)
    800022dc:	f022                	sd	s0,32(sp)
    800022de:	ec26                	sd	s1,24(sp)
    800022e0:	e84a                	sd	s2,16(sp)
    800022e2:	e44e                	sd	s3,8(sp)
    800022e4:	e052                	sd	s4,0(sp)
    800022e6:	1800                	addi	s0,sp,48
    800022e8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	6f8080e7          	jalr	1784(ra) # 800019e2 <myproc>
    800022f2:	89aa                	mv	s3,a0
  if(p == initproc)
    800022f4:	00006797          	auipc	a5,0x6
    800022f8:	7a47b783          	ld	a5,1956(a5) # 80008a98 <initproc>
    800022fc:	0d050493          	addi	s1,a0,208
    80002300:	15050913          	addi	s2,a0,336
    80002304:	02a79363          	bne	a5,a0,8000232a <exit+0x52>
    panic("init exiting");
    80002308:	00006517          	auipc	a0,0x6
    8000230c:	f8050513          	addi	a0,a0,-128 # 80008288 <digits+0x248>
    80002310:	ffffe097          	auipc	ra,0xffffe
    80002314:	22c080e7          	jalr	556(ra) # 8000053c <panic>
      fileclose(f);
    80002318:	00002097          	auipc	ra,0x2
    8000231c:	2f4080e7          	jalr	756(ra) # 8000460c <fileclose>
      p->ofile[fd] = 0;
    80002320:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002324:	04a1                	addi	s1,s1,8
    80002326:	01248563          	beq	s1,s2,80002330 <exit+0x58>
    if(p->ofile[fd]){
    8000232a:	6088                	ld	a0,0(s1)
    8000232c:	f575                	bnez	a0,80002318 <exit+0x40>
    8000232e:	bfdd                	j	80002324 <exit+0x4c>
  begin_op();
    80002330:	00002097          	auipc	ra,0x2
    80002334:	e18080e7          	jalr	-488(ra) # 80004148 <begin_op>
  iput(p->cwd);
    80002338:	1509b503          	ld	a0,336(s3)
    8000233c:	00001097          	auipc	ra,0x1
    80002340:	620080e7          	jalr	1568(ra) # 8000395c <iput>
  end_op();
    80002344:	00002097          	auipc	ra,0x2
    80002348:	e7e080e7          	jalr	-386(ra) # 800041c2 <end_op>
  p->cwd = 0;
    8000234c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002350:	0000f497          	auipc	s1,0xf
    80002354:	9d848493          	addi	s1,s1,-1576 # 80010d28 <wait_lock>
    80002358:	8526                	mv	a0,s1
    8000235a:	fffff097          	auipc	ra,0xfffff
    8000235e:	878080e7          	jalr	-1928(ra) # 80000bd2 <acquire>
  reparent(p);
    80002362:	854e                	mv	a0,s3
    80002364:	00000097          	auipc	ra,0x0
    80002368:	f12080e7          	jalr	-238(ra) # 80002276 <reparent>
  wakeup(p->parent);
    8000236c:	0389b503          	ld	a0,56(s3)
    80002370:	00000097          	auipc	ra,0x0
    80002374:	e88080e7          	jalr	-376(ra) # 800021f8 <wakeup>
  acquire(&p->lock);
    80002378:	854e                	mv	a0,s3
    8000237a:	fffff097          	auipc	ra,0xfffff
    8000237e:	858080e7          	jalr	-1960(ra) # 80000bd2 <acquire>
  p->xstate = status;
    80002382:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002386:	4795                	li	a5,5
    80002388:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000238c:	8526                	mv	a0,s1
    8000238e:	fffff097          	auipc	ra,0xfffff
    80002392:	8f8080e7          	jalr	-1800(ra) # 80000c86 <release>
  sched();
    80002396:	00000097          	auipc	ra,0x0
    8000239a:	cec080e7          	jalr	-788(ra) # 80002082 <sched>
  panic("zombie exit");
    8000239e:	00006517          	auipc	a0,0x6
    800023a2:	efa50513          	addi	a0,a0,-262 # 80008298 <digits+0x258>
    800023a6:	ffffe097          	auipc	ra,0xffffe
    800023aa:	196080e7          	jalr	406(ra) # 8000053c <panic>

00000000800023ae <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023ae:	7179                	addi	sp,sp,-48
    800023b0:	f406                	sd	ra,40(sp)
    800023b2:	f022                	sd	s0,32(sp)
    800023b4:	ec26                	sd	s1,24(sp)
    800023b6:	e84a                	sd	s2,16(sp)
    800023b8:	e44e                	sd	s3,8(sp)
    800023ba:	e052                	sd	s4,0(sp)
    800023bc:	1800                	addi	s0,sp,48
    800023be:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023c0:	0000f497          	auipc	s1,0xf
    800023c4:	d8048493          	addi	s1,s1,-640 # 80011140 <proc>
    800023c8:	6999                	lui	s3,0x6
    800023ca:	f3898993          	addi	s3,s3,-200 # 5f38 <_entry-0x7fffa0c8>
    800023ce:	0018ca17          	auipc	s4,0x18c
    800023d2:	b72a0a13          	addi	s4,s4,-1166 # 8018df40 <tickslock>
    acquire(&p->lock);
    800023d6:	8526                	mv	a0,s1
    800023d8:	ffffe097          	auipc	ra,0xffffe
    800023dc:	7fa080e7          	jalr	2042(ra) # 80000bd2 <acquire>
    if(p->pid == pid){
    800023e0:	589c                	lw	a5,48(s1)
    800023e2:	01278c63          	beq	a5,s2,800023fa <kill+0x4c>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023e6:	8526                	mv	a0,s1
    800023e8:	fffff097          	auipc	ra,0xfffff
    800023ec:	89e080e7          	jalr	-1890(ra) # 80000c86 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023f0:	94ce                	add	s1,s1,s3
    800023f2:	ff4492e3          	bne	s1,s4,800023d6 <kill+0x28>
  }
  return -1;
    800023f6:	557d                	li	a0,-1
    800023f8:	a829                	j	80002412 <kill+0x64>
      p->killed = 1;
    800023fa:	4785                	li	a5,1
    800023fc:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800023fe:	4c98                	lw	a4,24(s1)
    80002400:	4789                	li	a5,2
    80002402:	02f70063          	beq	a4,a5,80002422 <kill+0x74>
      release(&p->lock);
    80002406:	8526                	mv	a0,s1
    80002408:	fffff097          	auipc	ra,0xfffff
    8000240c:	87e080e7          	jalr	-1922(ra) # 80000c86 <release>
      return 0;
    80002410:	4501                	li	a0,0
}
    80002412:	70a2                	ld	ra,40(sp)
    80002414:	7402                	ld	s0,32(sp)
    80002416:	64e2                	ld	s1,24(sp)
    80002418:	6942                	ld	s2,16(sp)
    8000241a:	69a2                	ld	s3,8(sp)
    8000241c:	6a02                	ld	s4,0(sp)
    8000241e:	6145                	addi	sp,sp,48
    80002420:	8082                	ret
        p->state = RUNNABLE;
    80002422:	478d                	li	a5,3
    80002424:	cc9c                	sw	a5,24(s1)
    80002426:	b7c5                	j	80002406 <kill+0x58>

0000000080002428 <setkilled>:

void
setkilled(struct proc *p)
{
    80002428:	1101                	addi	sp,sp,-32
    8000242a:	ec06                	sd	ra,24(sp)
    8000242c:	e822                	sd	s0,16(sp)
    8000242e:	e426                	sd	s1,8(sp)
    80002430:	1000                	addi	s0,sp,32
    80002432:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002434:	ffffe097          	auipc	ra,0xffffe
    80002438:	79e080e7          	jalr	1950(ra) # 80000bd2 <acquire>
  p->killed = 1;
    8000243c:	4785                	li	a5,1
    8000243e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002440:	8526                	mv	a0,s1
    80002442:	fffff097          	auipc	ra,0xfffff
    80002446:	844080e7          	jalr	-1980(ra) # 80000c86 <release>
}
    8000244a:	60e2                	ld	ra,24(sp)
    8000244c:	6442                	ld	s0,16(sp)
    8000244e:	64a2                	ld	s1,8(sp)
    80002450:	6105                	addi	sp,sp,32
    80002452:	8082                	ret

0000000080002454 <killed>:

int
killed(struct proc *p)
{
    80002454:	1101                	addi	sp,sp,-32
    80002456:	ec06                	sd	ra,24(sp)
    80002458:	e822                	sd	s0,16(sp)
    8000245a:	e426                	sd	s1,8(sp)
    8000245c:	e04a                	sd	s2,0(sp)
    8000245e:	1000                	addi	s0,sp,32
    80002460:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002462:	ffffe097          	auipc	ra,0xffffe
    80002466:	770080e7          	jalr	1904(ra) # 80000bd2 <acquire>
  k = p->killed;
    8000246a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000246e:	8526                	mv	a0,s1
    80002470:	fffff097          	auipc	ra,0xfffff
    80002474:	816080e7          	jalr	-2026(ra) # 80000c86 <release>
  return k;
}
    80002478:	854a                	mv	a0,s2
    8000247a:	60e2                	ld	ra,24(sp)
    8000247c:	6442                	ld	s0,16(sp)
    8000247e:	64a2                	ld	s1,8(sp)
    80002480:	6902                	ld	s2,0(sp)
    80002482:	6105                	addi	sp,sp,32
    80002484:	8082                	ret

0000000080002486 <wait>:
{
    80002486:	715d                	addi	sp,sp,-80
    80002488:	e486                	sd	ra,72(sp)
    8000248a:	e0a2                	sd	s0,64(sp)
    8000248c:	fc26                	sd	s1,56(sp)
    8000248e:	f84a                	sd	s2,48(sp)
    80002490:	f44e                	sd	s3,40(sp)
    80002492:	f052                	sd	s4,32(sp)
    80002494:	ec56                	sd	s5,24(sp)
    80002496:	e85a                	sd	s6,16(sp)
    80002498:	e45e                	sd	s7,8(sp)
    8000249a:	0880                	addi	s0,sp,80
    8000249c:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000249e:	fffff097          	auipc	ra,0xfffff
    800024a2:	544080e7          	jalr	1348(ra) # 800019e2 <myproc>
    800024a6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800024a8:	0000f517          	auipc	a0,0xf
    800024ac:	88050513          	addi	a0,a0,-1920 # 80010d28 <wait_lock>
    800024b0:	ffffe097          	auipc	ra,0xffffe
    800024b4:	722080e7          	jalr	1826(ra) # 80000bd2 <acquire>
        if(pp->state == ZOMBIE){
    800024b8:	4a95                	li	s5,5
        havekids = 1;
    800024ba:	4b05                	li	s6,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024bc:	6999                	lui	s3,0x6
    800024be:	f3898993          	addi	s3,s3,-200 # 5f38 <_entry-0x7fffa0c8>
    800024c2:	0018ca17          	auipc	s4,0x18c
    800024c6:	a7ea0a13          	addi	s4,s4,-1410 # 8018df40 <tickslock>
    800024ca:	a0d9                	j	80002590 <wait+0x10a>
          pid = pp->pid;
    800024cc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800024d0:	000b8e63          	beqz	s7,800024ec <wait+0x66>
    800024d4:	4691                	li	a3,4
    800024d6:	02c48613          	addi	a2,s1,44
    800024da:	85de                	mv	a1,s7
    800024dc:	05093503          	ld	a0,80(s2)
    800024e0:	fffff097          	auipc	ra,0xfffff
    800024e4:	1b2080e7          	jalr	434(ra) # 80001692 <copyout>
    800024e8:	04054063          	bltz	a0,80002528 <wait+0xa2>
          freeproc(pp);
    800024ec:	8526                	mv	a0,s1
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	6a6080e7          	jalr	1702(ra) # 80001b94 <freeproc>
          release(&pp->lock);
    800024f6:	8526                	mv	a0,s1
    800024f8:	ffffe097          	auipc	ra,0xffffe
    800024fc:	78e080e7          	jalr	1934(ra) # 80000c86 <release>
          release(&wait_lock);
    80002500:	0000f517          	auipc	a0,0xf
    80002504:	82850513          	addi	a0,a0,-2008 # 80010d28 <wait_lock>
    80002508:	ffffe097          	auipc	ra,0xffffe
    8000250c:	77e080e7          	jalr	1918(ra) # 80000c86 <release>
}
    80002510:	854e                	mv	a0,s3
    80002512:	60a6                	ld	ra,72(sp)
    80002514:	6406                	ld	s0,64(sp)
    80002516:	74e2                	ld	s1,56(sp)
    80002518:	7942                	ld	s2,48(sp)
    8000251a:	79a2                	ld	s3,40(sp)
    8000251c:	7a02                	ld	s4,32(sp)
    8000251e:	6ae2                	ld	s5,24(sp)
    80002520:	6b42                	ld	s6,16(sp)
    80002522:	6ba2                	ld	s7,8(sp)
    80002524:	6161                	addi	sp,sp,80
    80002526:	8082                	ret
            release(&pp->lock);
    80002528:	8526                	mv	a0,s1
    8000252a:	ffffe097          	auipc	ra,0xffffe
    8000252e:	75c080e7          	jalr	1884(ra) # 80000c86 <release>
            release(&wait_lock);
    80002532:	0000e517          	auipc	a0,0xe
    80002536:	7f650513          	addi	a0,a0,2038 # 80010d28 <wait_lock>
    8000253a:	ffffe097          	auipc	ra,0xffffe
    8000253e:	74c080e7          	jalr	1868(ra) # 80000c86 <release>
            return -1;
    80002542:	59fd                	li	s3,-1
    80002544:	b7f1                	j	80002510 <wait+0x8a>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002546:	94ce                	add	s1,s1,s3
    80002548:	03448463          	beq	s1,s4,80002570 <wait+0xea>
      if(pp->parent == p){
    8000254c:	7c9c                	ld	a5,56(s1)
    8000254e:	ff279ce3          	bne	a5,s2,80002546 <wait+0xc0>
        acquire(&pp->lock);
    80002552:	8526                	mv	a0,s1
    80002554:	ffffe097          	auipc	ra,0xffffe
    80002558:	67e080e7          	jalr	1662(ra) # 80000bd2 <acquire>
        if(pp->state == ZOMBIE){
    8000255c:	4c9c                	lw	a5,24(s1)
    8000255e:	f75787e3          	beq	a5,s5,800024cc <wait+0x46>
        release(&pp->lock);
    80002562:	8526                	mv	a0,s1
    80002564:	ffffe097          	auipc	ra,0xffffe
    80002568:	722080e7          	jalr	1826(ra) # 80000c86 <release>
        havekids = 1;
    8000256c:	875a                	mv	a4,s6
    8000256e:	bfe1                	j	80002546 <wait+0xc0>
    if(!havekids || killed(p)){
    80002570:	c715                	beqz	a4,8000259c <wait+0x116>
    80002572:	854a                	mv	a0,s2
    80002574:	00000097          	auipc	ra,0x0
    80002578:	ee0080e7          	jalr	-288(ra) # 80002454 <killed>
    8000257c:	e105                	bnez	a0,8000259c <wait+0x116>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000257e:	0000e597          	auipc	a1,0xe
    80002582:	7aa58593          	addi	a1,a1,1962 # 80010d28 <wait_lock>
    80002586:	854a                	mv	a0,s2
    80002588:	00000097          	auipc	ra,0x0
    8000258c:	c0c080e7          	jalr	-1012(ra) # 80002194 <sleep>
    havekids = 0;
    80002590:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002592:	0000f497          	auipc	s1,0xf
    80002596:	bae48493          	addi	s1,s1,-1106 # 80011140 <proc>
    8000259a:	bf4d                	j	8000254c <wait+0xc6>
      release(&wait_lock);
    8000259c:	0000e517          	auipc	a0,0xe
    800025a0:	78c50513          	addi	a0,a0,1932 # 80010d28 <wait_lock>
    800025a4:	ffffe097          	auipc	ra,0xffffe
    800025a8:	6e2080e7          	jalr	1762(ra) # 80000c86 <release>
      return -1;
    800025ac:	59fd                	li	s3,-1
    800025ae:	b78d                	j	80002510 <wait+0x8a>

00000000800025b0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800025b0:	7179                	addi	sp,sp,-48
    800025b2:	f406                	sd	ra,40(sp)
    800025b4:	f022                	sd	s0,32(sp)
    800025b6:	ec26                	sd	s1,24(sp)
    800025b8:	e84a                	sd	s2,16(sp)
    800025ba:	e44e                	sd	s3,8(sp)
    800025bc:	e052                	sd	s4,0(sp)
    800025be:	1800                	addi	s0,sp,48
    800025c0:	84aa                	mv	s1,a0
    800025c2:	892e                	mv	s2,a1
    800025c4:	89b2                	mv	s3,a2
    800025c6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025c8:	fffff097          	auipc	ra,0xfffff
    800025cc:	41a080e7          	jalr	1050(ra) # 800019e2 <myproc>
  if(user_dst){
    800025d0:	c08d                	beqz	s1,800025f2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800025d2:	86d2                	mv	a3,s4
    800025d4:	864e                	mv	a2,s3
    800025d6:	85ca                	mv	a1,s2
    800025d8:	6928                	ld	a0,80(a0)
    800025da:	fffff097          	auipc	ra,0xfffff
    800025de:	0b8080e7          	jalr	184(ra) # 80001692 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800025e2:	70a2                	ld	ra,40(sp)
    800025e4:	7402                	ld	s0,32(sp)
    800025e6:	64e2                	ld	s1,24(sp)
    800025e8:	6942                	ld	s2,16(sp)
    800025ea:	69a2                	ld	s3,8(sp)
    800025ec:	6a02                	ld	s4,0(sp)
    800025ee:	6145                	addi	sp,sp,48
    800025f0:	8082                	ret
    memmove((char *)dst, src, len);
    800025f2:	000a061b          	sext.w	a2,s4
    800025f6:	85ce                	mv	a1,s3
    800025f8:	854a                	mv	a0,s2
    800025fa:	ffffe097          	auipc	ra,0xffffe
    800025fe:	730080e7          	jalr	1840(ra) # 80000d2a <memmove>
    return 0;
    80002602:	8526                	mv	a0,s1
    80002604:	bff9                	j	800025e2 <either_copyout+0x32>

0000000080002606 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002606:	7179                	addi	sp,sp,-48
    80002608:	f406                	sd	ra,40(sp)
    8000260a:	f022                	sd	s0,32(sp)
    8000260c:	ec26                	sd	s1,24(sp)
    8000260e:	e84a                	sd	s2,16(sp)
    80002610:	e44e                	sd	s3,8(sp)
    80002612:	e052                	sd	s4,0(sp)
    80002614:	1800                	addi	s0,sp,48
    80002616:	892a                	mv	s2,a0
    80002618:	84ae                	mv	s1,a1
    8000261a:	89b2                	mv	s3,a2
    8000261c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000261e:	fffff097          	auipc	ra,0xfffff
    80002622:	3c4080e7          	jalr	964(ra) # 800019e2 <myproc>
  if(user_src){
    80002626:	c08d                	beqz	s1,80002648 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002628:	86d2                	mv	a3,s4
    8000262a:	864e                	mv	a2,s3
    8000262c:	85ca                	mv	a1,s2
    8000262e:	6928                	ld	a0,80(a0)
    80002630:	fffff097          	auipc	ra,0xfffff
    80002634:	0ee080e7          	jalr	238(ra) # 8000171e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002638:	70a2                	ld	ra,40(sp)
    8000263a:	7402                	ld	s0,32(sp)
    8000263c:	64e2                	ld	s1,24(sp)
    8000263e:	6942                	ld	s2,16(sp)
    80002640:	69a2                	ld	s3,8(sp)
    80002642:	6a02                	ld	s4,0(sp)
    80002644:	6145                	addi	sp,sp,48
    80002646:	8082                	ret
    memmove(dst, (char*)src, len);
    80002648:	000a061b          	sext.w	a2,s4
    8000264c:	85ce                	mv	a1,s3
    8000264e:	854a                	mv	a0,s2
    80002650:	ffffe097          	auipc	ra,0xffffe
    80002654:	6da080e7          	jalr	1754(ra) # 80000d2a <memmove>
    return 0;
    80002658:	8526                	mv	a0,s1
    8000265a:	bff9                	j	80002638 <either_copyin+0x32>

000000008000265c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000265c:	715d                	addi	sp,sp,-80
    8000265e:	e486                	sd	ra,72(sp)
    80002660:	e0a2                	sd	s0,64(sp)
    80002662:	fc26                	sd	s1,56(sp)
    80002664:	f84a                	sd	s2,48(sp)
    80002666:	f44e                	sd	s3,40(sp)
    80002668:	f052                	sd	s4,32(sp)
    8000266a:	ec56                	sd	s5,24(sp)
    8000266c:	e85a                	sd	s6,16(sp)
    8000266e:	e45e                	sd	s7,8(sp)
    80002670:	e062                	sd	s8,0(sp)
    80002672:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002674:	00006517          	auipc	a0,0x6
    80002678:	3a450513          	addi	a0,a0,932 # 80008a18 <syscalls+0x5a0>
    8000267c:	ffffe097          	auipc	ra,0xffffe
    80002680:	f0a080e7          	jalr	-246(ra) # 80000586 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002684:	0000f497          	auipc	s1,0xf
    80002688:	c1448493          	addi	s1,s1,-1004 # 80011298 <proc+0x158>
    8000268c:	0018c997          	auipc	s3,0x18c
    80002690:	a0c98993          	addi	s3,s3,-1524 # 8018e098 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002694:	4b95                	li	s7,5
      state = states[p->state];
    else
      state = "???";
    80002696:	00006a17          	auipc	s4,0x6
    8000269a:	c12a0a13          	addi	s4,s4,-1006 # 800082a8 <digits+0x268>
    printf("%d %s %s", p->pid, state, p->name);
    8000269e:	00006b17          	auipc	s6,0x6
    800026a2:	c12b0b13          	addi	s6,s6,-1006 # 800082b0 <digits+0x270>
    printf("\n");
    800026a6:	00006a97          	auipc	s5,0x6
    800026aa:	372a8a93          	addi	s5,s5,882 # 80008a18 <syscalls+0x5a0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026ae:	00006c17          	auipc	s8,0x6
    800026b2:	c42c0c13          	addi	s8,s8,-958 # 800082f0 <states.0>
  for(p = proc; p < &proc[NPROC]; p++){
    800026b6:	6919                	lui	s2,0x6
    800026b8:	f3890913          	addi	s2,s2,-200 # 5f38 <_entry-0x7fffa0c8>
    800026bc:	a005                	j	800026dc <procdump+0x80>
    printf("%d %s %s", p->pid, state, p->name);
    800026be:	ed86a583          	lw	a1,-296(a3)
    800026c2:	855a                	mv	a0,s6
    800026c4:	ffffe097          	auipc	ra,0xffffe
    800026c8:	ec2080e7          	jalr	-318(ra) # 80000586 <printf>
    printf("\n");
    800026cc:	8556                	mv	a0,s5
    800026ce:	ffffe097          	auipc	ra,0xffffe
    800026d2:	eb8080e7          	jalr	-328(ra) # 80000586 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026d6:	94ca                	add	s1,s1,s2
    800026d8:	03348263          	beq	s1,s3,800026fc <procdump+0xa0>
    if(p->state == UNUSED)
    800026dc:	86a6                	mv	a3,s1
    800026de:	ec04a783          	lw	a5,-320(s1)
    800026e2:	dbf5                	beqz	a5,800026d6 <procdump+0x7a>
      state = "???";
    800026e4:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026e6:	fcfbece3          	bltu	s7,a5,800026be <procdump+0x62>
    800026ea:	02079713          	slli	a4,a5,0x20
    800026ee:	01d75793          	srli	a5,a4,0x1d
    800026f2:	97e2                	add	a5,a5,s8
    800026f4:	6390                	ld	a2,0(a5)
    800026f6:	f661                	bnez	a2,800026be <procdump+0x62>
      state = "???";
    800026f8:	8652                	mv	a2,s4
    800026fa:	b7d1                	j	800026be <procdump+0x62>
  }
}
    800026fc:	60a6                	ld	ra,72(sp)
    800026fe:	6406                	ld	s0,64(sp)
    80002700:	74e2                	ld	s1,56(sp)
    80002702:	7942                	ld	s2,48(sp)
    80002704:	79a2                	ld	s3,40(sp)
    80002706:	7a02                	ld	s4,32(sp)
    80002708:	6ae2                	ld	s5,24(sp)
    8000270a:	6b42                	ld	s6,16(sp)
    8000270c:	6ba2                	ld	s7,8(sp)
    8000270e:	6c02                	ld	s8,0(sp)
    80002710:	6161                	addi	sp,sp,80
    80002712:	8082                	ret

0000000080002714 <swtch>:
    80002714:	00153023          	sd	ra,0(a0)
    80002718:	00253423          	sd	sp,8(a0)
    8000271c:	e900                	sd	s0,16(a0)
    8000271e:	ed04                	sd	s1,24(a0)
    80002720:	03253023          	sd	s2,32(a0)
    80002724:	03353423          	sd	s3,40(a0)
    80002728:	03453823          	sd	s4,48(a0)
    8000272c:	03553c23          	sd	s5,56(a0)
    80002730:	05653023          	sd	s6,64(a0)
    80002734:	05753423          	sd	s7,72(a0)
    80002738:	05853823          	sd	s8,80(a0)
    8000273c:	05953c23          	sd	s9,88(a0)
    80002740:	07a53023          	sd	s10,96(a0)
    80002744:	07b53423          	sd	s11,104(a0)
    80002748:	0005b083          	ld	ra,0(a1)
    8000274c:	0085b103          	ld	sp,8(a1)
    80002750:	6980                	ld	s0,16(a1)
    80002752:	6d84                	ld	s1,24(a1)
    80002754:	0205b903          	ld	s2,32(a1)
    80002758:	0285b983          	ld	s3,40(a1)
    8000275c:	0305ba03          	ld	s4,48(a1)
    80002760:	0385ba83          	ld	s5,56(a1)
    80002764:	0405bb03          	ld	s6,64(a1)
    80002768:	0485bb83          	ld	s7,72(a1)
    8000276c:	0505bc03          	ld	s8,80(a1)
    80002770:	0585bc83          	ld	s9,88(a1)
    80002774:	0605bd03          	ld	s10,96(a1)
    80002778:	0685bd83          	ld	s11,104(a1)
    8000277c:	8082                	ret

000000008000277e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000277e:	1141                	addi	sp,sp,-16
    80002780:	e406                	sd	ra,8(sp)
    80002782:	e022                	sd	s0,0(sp)
    80002784:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002786:	00006597          	auipc	a1,0x6
    8000278a:	b9a58593          	addi	a1,a1,-1126 # 80008320 <states.0+0x30>
    8000278e:	0018b517          	auipc	a0,0x18b
    80002792:	7b250513          	addi	a0,a0,1970 # 8018df40 <tickslock>
    80002796:	ffffe097          	auipc	ra,0xffffe
    8000279a:	3ac080e7          	jalr	940(ra) # 80000b42 <initlock>
}
    8000279e:	60a2                	ld	ra,8(sp)
    800027a0:	6402                	ld	s0,0(sp)
    800027a2:	0141                	addi	sp,sp,16
    800027a4:	8082                	ret

00000000800027a6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800027a6:	1141                	addi	sp,sp,-16
    800027a8:	e422                	sd	s0,8(sp)
    800027aa:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027ac:	00003797          	auipc	a5,0x3
    800027b0:	4f478793          	addi	a5,a5,1268 # 80005ca0 <kernelvec>
    800027b4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800027b8:	6422                	ld	s0,8(sp)
    800027ba:	0141                	addi	sp,sp,16
    800027bc:	8082                	ret

00000000800027be <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800027be:	1141                	addi	sp,sp,-16
    800027c0:	e406                	sd	ra,8(sp)
    800027c2:	e022                	sd	s0,0(sp)
    800027c4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800027c6:	fffff097          	auipc	ra,0xfffff
    800027ca:	21c080e7          	jalr	540(ra) # 800019e2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027d2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027d4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800027d8:	00005697          	auipc	a3,0x5
    800027dc:	82868693          	addi	a3,a3,-2008 # 80007000 <_trampoline>
    800027e0:	00005717          	auipc	a4,0x5
    800027e4:	82070713          	addi	a4,a4,-2016 # 80007000 <_trampoline>
    800027e8:	8f15                	sub	a4,a4,a3
    800027ea:	040007b7          	lui	a5,0x4000
    800027ee:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800027f0:	07b2                	slli	a5,a5,0xc
    800027f2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027f4:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800027f8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800027fa:	18002673          	csrr	a2,satp
    800027fe:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002800:	6d30                	ld	a2,88(a0)
    80002802:	6138                	ld	a4,64(a0)
    80002804:	6585                	lui	a1,0x1
    80002806:	972e                	add	a4,a4,a1
    80002808:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000280a:	6d38                	ld	a4,88(a0)
    8000280c:	00000617          	auipc	a2,0x0
    80002810:	13460613          	addi	a2,a2,308 # 80002940 <usertrap>
    80002814:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002816:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002818:	8612                	mv	a2,tp
    8000281a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000281c:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002820:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002824:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002828:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000282c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000282e:	6f18                	ld	a4,24(a4)
    80002830:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002834:	6928                	ld	a0,80(a0)
    80002836:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002838:	00005717          	auipc	a4,0x5
    8000283c:	86470713          	addi	a4,a4,-1948 # 8000709c <userret>
    80002840:	8f15                	sub	a4,a4,a3
    80002842:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002844:	577d                	li	a4,-1
    80002846:	177e                	slli	a4,a4,0x3f
    80002848:	8d59                	or	a0,a0,a4
    8000284a:	9782                	jalr	a5
}
    8000284c:	60a2                	ld	ra,8(sp)
    8000284e:	6402                	ld	s0,0(sp)
    80002850:	0141                	addi	sp,sp,16
    80002852:	8082                	ret

0000000080002854 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002854:	1101                	addi	sp,sp,-32
    80002856:	ec06                	sd	ra,24(sp)
    80002858:	e822                	sd	s0,16(sp)
    8000285a:	e426                	sd	s1,8(sp)
    8000285c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    8000285e:	0018b497          	auipc	s1,0x18b
    80002862:	6e248493          	addi	s1,s1,1762 # 8018df40 <tickslock>
    80002866:	8526                	mv	a0,s1
    80002868:	ffffe097          	auipc	ra,0xffffe
    8000286c:	36a080e7          	jalr	874(ra) # 80000bd2 <acquire>
  ticks++;
    80002870:	00006517          	auipc	a0,0x6
    80002874:	23050513          	addi	a0,a0,560 # 80008aa0 <ticks>
    80002878:	411c                	lw	a5,0(a0)
    8000287a:	2785                	addiw	a5,a5,1
    8000287c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    8000287e:	00000097          	auipc	ra,0x0
    80002882:	97a080e7          	jalr	-1670(ra) # 800021f8 <wakeup>
  release(&tickslock);
    80002886:	8526                	mv	a0,s1
    80002888:	ffffe097          	auipc	ra,0xffffe
    8000288c:	3fe080e7          	jalr	1022(ra) # 80000c86 <release>
}
    80002890:	60e2                	ld	ra,24(sp)
    80002892:	6442                	ld	s0,16(sp)
    80002894:	64a2                	ld	s1,8(sp)
    80002896:	6105                	addi	sp,sp,32
    80002898:	8082                	ret

000000008000289a <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000289a:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000289e:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    800028a0:	0807df63          	bgez	a5,8000293e <devintr+0xa4>
{
    800028a4:	1101                	addi	sp,sp,-32
    800028a6:	ec06                	sd	ra,24(sp)
    800028a8:	e822                	sd	s0,16(sp)
    800028aa:	e426                	sd	s1,8(sp)
    800028ac:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    800028ae:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    800028b2:	46a5                	li	a3,9
    800028b4:	00d70d63          	beq	a4,a3,800028ce <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    800028b8:	577d                	li	a4,-1
    800028ba:	177e                	slli	a4,a4,0x3f
    800028bc:	0705                	addi	a4,a4,1
    return 0;
    800028be:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800028c0:	04e78e63          	beq	a5,a4,8000291c <devintr+0x82>
  }
}
    800028c4:	60e2                	ld	ra,24(sp)
    800028c6:	6442                	ld	s0,16(sp)
    800028c8:	64a2                	ld	s1,8(sp)
    800028ca:	6105                	addi	sp,sp,32
    800028cc:	8082                	ret
    int irq = plic_claim();
    800028ce:	00003097          	auipc	ra,0x3
    800028d2:	4da080e7          	jalr	1242(ra) # 80005da8 <plic_claim>
    800028d6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800028d8:	47a9                	li	a5,10
    800028da:	02f50763          	beq	a0,a5,80002908 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    800028de:	4785                	li	a5,1
    800028e0:	02f50963          	beq	a0,a5,80002912 <devintr+0x78>
    return 1;
    800028e4:	4505                	li	a0,1
    } else if(irq){
    800028e6:	dcf9                	beqz	s1,800028c4 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    800028e8:	85a6                	mv	a1,s1
    800028ea:	00006517          	auipc	a0,0x6
    800028ee:	a3e50513          	addi	a0,a0,-1474 # 80008328 <states.0+0x38>
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	c94080e7          	jalr	-876(ra) # 80000586 <printf>
      plic_complete(irq);
    800028fa:	8526                	mv	a0,s1
    800028fc:	00003097          	auipc	ra,0x3
    80002900:	4d0080e7          	jalr	1232(ra) # 80005dcc <plic_complete>
    return 1;
    80002904:	4505                	li	a0,1
    80002906:	bf7d                	j	800028c4 <devintr+0x2a>
      uartintr();
    80002908:	ffffe097          	auipc	ra,0xffffe
    8000290c:	08c080e7          	jalr	140(ra) # 80000994 <uartintr>
    if(irq)
    80002910:	b7ed                	j	800028fa <devintr+0x60>
      virtio_disk_intr();
    80002912:	00004097          	auipc	ra,0x4
    80002916:	980080e7          	jalr	-1664(ra) # 80006292 <virtio_disk_intr>
    if(irq)
    8000291a:	b7c5                	j	800028fa <devintr+0x60>
    if(cpuid() == 0){
    8000291c:	fffff097          	auipc	ra,0xfffff
    80002920:	09a080e7          	jalr	154(ra) # 800019b6 <cpuid>
    80002924:	c901                	beqz	a0,80002934 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002926:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000292a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000292c:	14479073          	csrw	sip,a5
    return 2;
    80002930:	4509                	li	a0,2
    80002932:	bf49                	j	800028c4 <devintr+0x2a>
      clockintr();
    80002934:	00000097          	auipc	ra,0x0
    80002938:	f20080e7          	jalr	-224(ra) # 80002854 <clockintr>
    8000293c:	b7ed                	j	80002926 <devintr+0x8c>
}
    8000293e:	8082                	ret

0000000080002940 <usertrap>:
{
    80002940:	7179                	addi	sp,sp,-48
    80002942:	f406                	sd	ra,40(sp)
    80002944:	f022                	sd	s0,32(sp)
    80002946:	ec26                	sd	s1,24(sp)
    80002948:	e84a                	sd	s2,16(sp)
    8000294a:	e44e                	sd	s3,8(sp)
    8000294c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000294e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002952:	1007f793          	andi	a5,a5,256
    80002956:	eba1                	bnez	a5,800029a6 <usertrap+0x66>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002958:	00003797          	auipc	a5,0x3
    8000295c:	34878793          	addi	a5,a5,840 # 80005ca0 <kernelvec>
    80002960:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002964:	fffff097          	auipc	ra,0xfffff
    80002968:	07e080e7          	jalr	126(ra) # 800019e2 <myproc>
    8000296c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000296e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002970:	14102773          	csrr	a4,sepc
    80002974:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002976:	142029f3          	csrr	s3,scause
  if(scauseCode == 8){
    8000297a:	47a1                	li	a5,8
    8000297c:	02f98d63          	beq	s3,a5,800029b6 <usertrap+0x76>
  } else if((which_dev = devintr()) != 0){
    80002980:	00000097          	auipc	ra,0x0
    80002984:	f1a080e7          	jalr	-230(ra) # 8000289a <devintr>
    80002988:	892a                	mv	s2,a0
    8000298a:	ed4d                	bnez	a0,80002a44 <usertrap+0x104>
  } else if(scauseCode == 12 || scauseCode == 13 || scauseCode == 15){
    8000298c:	ff498793          	addi	a5,s3,-12
    80002990:	4705                	li	a4,1
    80002992:	00f77563          	bgeu	a4,a5,8000299c <usertrap+0x5c>
    80002996:	47bd                	li	a5,15
    80002998:	06f99963          	bne	s3,a5,80002a0a <usertrap+0xca>
    page_fault_handler();
    8000299c:	00004097          	auipc	ra,0x4
    800029a0:	cb6080e7          	jalr	-842(ra) # 80006652 <page_fault_handler>
    800029a4:	a825                	j	800029dc <usertrap+0x9c>
    panic("usertrap: not from user mode");
    800029a6:	00006517          	auipc	a0,0x6
    800029aa:	9a250513          	addi	a0,a0,-1630 # 80008348 <states.0+0x58>
    800029ae:	ffffe097          	auipc	ra,0xffffe
    800029b2:	b8e080e7          	jalr	-1138(ra) # 8000053c <panic>
    if(killed(p))
    800029b6:	00000097          	auipc	ra,0x0
    800029ba:	a9e080e7          	jalr	-1378(ra) # 80002454 <killed>
    800029be:	e121                	bnez	a0,800029fe <usertrap+0xbe>
    p->trapframe->epc += 4;
    800029c0:	6cb8                	ld	a4,88(s1)
    800029c2:	6f1c                	ld	a5,24(a4)
    800029c4:	0791                	addi	a5,a5,4
    800029c6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800029cc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029d0:	10079073          	csrw	sstatus,a5
    syscall();
    800029d4:	00000097          	auipc	ra,0x0
    800029d8:	2e4080e7          	jalr	740(ra) # 80002cb8 <syscall>
  if(killed(p))
    800029dc:	8526                	mv	a0,s1
    800029de:	00000097          	auipc	ra,0x0
    800029e2:	a76080e7          	jalr	-1418(ra) # 80002454 <killed>
    800029e6:	e535                	bnez	a0,80002a52 <usertrap+0x112>
  usertrapret();
    800029e8:	00000097          	auipc	ra,0x0
    800029ec:	dd6080e7          	jalr	-554(ra) # 800027be <usertrapret>
}
    800029f0:	70a2                	ld	ra,40(sp)
    800029f2:	7402                	ld	s0,32(sp)
    800029f4:	64e2                	ld	s1,24(sp)
    800029f6:	6942                	ld	s2,16(sp)
    800029f8:	69a2                	ld	s3,8(sp)
    800029fa:	6145                	addi	sp,sp,48
    800029fc:	8082                	ret
      exit(-1);
    800029fe:	557d                	li	a0,-1
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	8d8080e7          	jalr	-1832(ra) # 800022d8 <exit>
    80002a08:	bf65                	j	800029c0 <usertrap+0x80>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a0a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002a0e:	5890                	lw	a2,48(s1)
    80002a10:	00006517          	auipc	a0,0x6
    80002a14:	95850513          	addi	a0,a0,-1704 # 80008368 <states.0+0x78>
    80002a18:	ffffe097          	auipc	ra,0xffffe
    80002a1c:	b6e080e7          	jalr	-1170(ra) # 80000586 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a20:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a24:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a28:	00006517          	auipc	a0,0x6
    80002a2c:	97050513          	addi	a0,a0,-1680 # 80008398 <states.0+0xa8>
    80002a30:	ffffe097          	auipc	ra,0xffffe
    80002a34:	b56080e7          	jalr	-1194(ra) # 80000586 <printf>
    setkilled(p);
    80002a38:	8526                	mv	a0,s1
    80002a3a:	00000097          	auipc	ra,0x0
    80002a3e:	9ee080e7          	jalr	-1554(ra) # 80002428 <setkilled>
    80002a42:	bf69                	j	800029dc <usertrap+0x9c>
  if(killed(p))
    80002a44:	8526                	mv	a0,s1
    80002a46:	00000097          	auipc	ra,0x0
    80002a4a:	a0e080e7          	jalr	-1522(ra) # 80002454 <killed>
    80002a4e:	c901                	beqz	a0,80002a5e <usertrap+0x11e>
    80002a50:	a011                	j	80002a54 <usertrap+0x114>
    80002a52:	4901                	li	s2,0
    exit(-1);
    80002a54:	557d                	li	a0,-1
    80002a56:	00000097          	auipc	ra,0x0
    80002a5a:	882080e7          	jalr	-1918(ra) # 800022d8 <exit>
  if(which_dev == 2)
    80002a5e:	4789                	li	a5,2
    80002a60:	f8f914e3          	bne	s2,a5,800029e8 <usertrap+0xa8>
    yield();
    80002a64:	fffff097          	auipc	ra,0xfffff
    80002a68:	6f4080e7          	jalr	1780(ra) # 80002158 <yield>
    80002a6c:	bfb5                	j	800029e8 <usertrap+0xa8>

0000000080002a6e <kerneltrap>:
{
    80002a6e:	7179                	addi	sp,sp,-48
    80002a70:	f406                	sd	ra,40(sp)
    80002a72:	f022                	sd	s0,32(sp)
    80002a74:	ec26                	sd	s1,24(sp)
    80002a76:	e84a                	sd	s2,16(sp)
    80002a78:	e44e                	sd	s3,8(sp)
    80002a7a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a7c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a80:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a84:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a88:	1004f793          	andi	a5,s1,256
    80002a8c:	cb85                	beqz	a5,80002abc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a8e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a92:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a94:	ef85                	bnez	a5,80002acc <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002a96:	00000097          	auipc	ra,0x0
    80002a9a:	e04080e7          	jalr	-508(ra) # 8000289a <devintr>
    80002a9e:	cd1d                	beqz	a0,80002adc <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) {
    80002aa0:	4789                	li	a5,2
    80002aa2:	06f50a63          	beq	a0,a5,80002b16 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002aa6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002aaa:	10049073          	csrw	sstatus,s1
}
    80002aae:	70a2                	ld	ra,40(sp)
    80002ab0:	7402                	ld	s0,32(sp)
    80002ab2:	64e2                	ld	s1,24(sp)
    80002ab4:	6942                	ld	s2,16(sp)
    80002ab6:	69a2                	ld	s3,8(sp)
    80002ab8:	6145                	addi	sp,sp,48
    80002aba:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002abc:	00006517          	auipc	a0,0x6
    80002ac0:	8fc50513          	addi	a0,a0,-1796 # 800083b8 <states.0+0xc8>
    80002ac4:	ffffe097          	auipc	ra,0xffffe
    80002ac8:	a78080e7          	jalr	-1416(ra) # 8000053c <panic>
    panic("kerneltrap: interrupts enabled");
    80002acc:	00006517          	auipc	a0,0x6
    80002ad0:	91450513          	addi	a0,a0,-1772 # 800083e0 <states.0+0xf0>
    80002ad4:	ffffe097          	auipc	ra,0xffffe
    80002ad8:	a68080e7          	jalr	-1432(ra) # 8000053c <panic>
    printf("scause %p\n", scause);
    80002adc:	85ce                	mv	a1,s3
    80002ade:	00006517          	auipc	a0,0x6
    80002ae2:	92250513          	addi	a0,a0,-1758 # 80008400 <states.0+0x110>
    80002ae6:	ffffe097          	auipc	ra,0xffffe
    80002aea:	aa0080e7          	jalr	-1376(ra) # 80000586 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002aee:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002af2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002af6:	00006517          	auipc	a0,0x6
    80002afa:	91a50513          	addi	a0,a0,-1766 # 80008410 <states.0+0x120>
    80002afe:	ffffe097          	auipc	ra,0xffffe
    80002b02:	a88080e7          	jalr	-1400(ra) # 80000586 <printf>
    panic("kerneltrap");
    80002b06:	00006517          	auipc	a0,0x6
    80002b0a:	92250513          	addi	a0,a0,-1758 # 80008428 <states.0+0x138>
    80002b0e:	ffffe097          	auipc	ra,0xffffe
    80002b12:	a2e080e7          	jalr	-1490(ra) # 8000053c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) {
    80002b16:	fffff097          	auipc	ra,0xfffff
    80002b1a:	ecc080e7          	jalr	-308(ra) # 800019e2 <myproc>
    80002b1e:	d541                	beqz	a0,80002aa6 <kerneltrap+0x38>
    80002b20:	fffff097          	auipc	ra,0xfffff
    80002b24:	ec2080e7          	jalr	-318(ra) # 800019e2 <myproc>
    80002b28:	4d18                	lw	a4,24(a0)
    80002b2a:	4791                	li	a5,4
    80002b2c:	f6f71de3          	bne	a4,a5,80002aa6 <kerneltrap+0x38>
    yield();
    80002b30:	fffff097          	auipc	ra,0xfffff
    80002b34:	628080e7          	jalr	1576(ra) # 80002158 <yield>
    80002b38:	b7bd                	j	80002aa6 <kerneltrap+0x38>

0000000080002b3a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b3a:	1101                	addi	sp,sp,-32
    80002b3c:	ec06                	sd	ra,24(sp)
    80002b3e:	e822                	sd	s0,16(sp)
    80002b40:	e426                	sd	s1,8(sp)
    80002b42:	1000                	addi	s0,sp,32
    80002b44:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b46:	fffff097          	auipc	ra,0xfffff
    80002b4a:	e9c080e7          	jalr	-356(ra) # 800019e2 <myproc>
  switch (n) {
    80002b4e:	4795                	li	a5,5
    80002b50:	0497e163          	bltu	a5,s1,80002b92 <argraw+0x58>
    80002b54:	048a                	slli	s1,s1,0x2
    80002b56:	00006717          	auipc	a4,0x6
    80002b5a:	90a70713          	addi	a4,a4,-1782 # 80008460 <states.0+0x170>
    80002b5e:	94ba                	add	s1,s1,a4
    80002b60:	409c                	lw	a5,0(s1)
    80002b62:	97ba                	add	a5,a5,a4
    80002b64:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b66:	6d3c                	ld	a5,88(a0)
    80002b68:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b6a:	60e2                	ld	ra,24(sp)
    80002b6c:	6442                	ld	s0,16(sp)
    80002b6e:	64a2                	ld	s1,8(sp)
    80002b70:	6105                	addi	sp,sp,32
    80002b72:	8082                	ret
    return p->trapframe->a1;
    80002b74:	6d3c                	ld	a5,88(a0)
    80002b76:	7fa8                	ld	a0,120(a5)
    80002b78:	bfcd                	j	80002b6a <argraw+0x30>
    return p->trapframe->a2;
    80002b7a:	6d3c                	ld	a5,88(a0)
    80002b7c:	63c8                	ld	a0,128(a5)
    80002b7e:	b7f5                	j	80002b6a <argraw+0x30>
    return p->trapframe->a3;
    80002b80:	6d3c                	ld	a5,88(a0)
    80002b82:	67c8                	ld	a0,136(a5)
    80002b84:	b7dd                	j	80002b6a <argraw+0x30>
    return p->trapframe->a4;
    80002b86:	6d3c                	ld	a5,88(a0)
    80002b88:	6bc8                	ld	a0,144(a5)
    80002b8a:	b7c5                	j	80002b6a <argraw+0x30>
    return p->trapframe->a5;
    80002b8c:	6d3c                	ld	a5,88(a0)
    80002b8e:	6fc8                	ld	a0,152(a5)
    80002b90:	bfe9                	j	80002b6a <argraw+0x30>
  panic("argraw");
    80002b92:	00006517          	auipc	a0,0x6
    80002b96:	8a650513          	addi	a0,a0,-1882 # 80008438 <states.0+0x148>
    80002b9a:	ffffe097          	auipc	ra,0xffffe
    80002b9e:	9a2080e7          	jalr	-1630(ra) # 8000053c <panic>

0000000080002ba2 <fetchaddr>:
{
    80002ba2:	1101                	addi	sp,sp,-32
    80002ba4:	ec06                	sd	ra,24(sp)
    80002ba6:	e822                	sd	s0,16(sp)
    80002ba8:	e426                	sd	s1,8(sp)
    80002baa:	e04a                	sd	s2,0(sp)
    80002bac:	1000                	addi	s0,sp,32
    80002bae:	84aa                	mv	s1,a0
    80002bb0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002bb2:	fffff097          	auipc	ra,0xfffff
    80002bb6:	e30080e7          	jalr	-464(ra) # 800019e2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002bba:	653c                	ld	a5,72(a0)
    80002bbc:	02f4f863          	bgeu	s1,a5,80002bec <fetchaddr+0x4a>
    80002bc0:	00848713          	addi	a4,s1,8
    80002bc4:	02e7e663          	bltu	a5,a4,80002bf0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002bc8:	46a1                	li	a3,8
    80002bca:	8626                	mv	a2,s1
    80002bcc:	85ca                	mv	a1,s2
    80002bce:	6928                	ld	a0,80(a0)
    80002bd0:	fffff097          	auipc	ra,0xfffff
    80002bd4:	b4e080e7          	jalr	-1202(ra) # 8000171e <copyin>
    80002bd8:	00a03533          	snez	a0,a0
    80002bdc:	40a00533          	neg	a0,a0
}
    80002be0:	60e2                	ld	ra,24(sp)
    80002be2:	6442                	ld	s0,16(sp)
    80002be4:	64a2                	ld	s1,8(sp)
    80002be6:	6902                	ld	s2,0(sp)
    80002be8:	6105                	addi	sp,sp,32
    80002bea:	8082                	ret
    return -1;
    80002bec:	557d                	li	a0,-1
    80002bee:	bfcd                	j	80002be0 <fetchaddr+0x3e>
    80002bf0:	557d                	li	a0,-1
    80002bf2:	b7fd                	j	80002be0 <fetchaddr+0x3e>

0000000080002bf4 <fetchstr>:
{
    80002bf4:	7179                	addi	sp,sp,-48
    80002bf6:	f406                	sd	ra,40(sp)
    80002bf8:	f022                	sd	s0,32(sp)
    80002bfa:	ec26                	sd	s1,24(sp)
    80002bfc:	e84a                	sd	s2,16(sp)
    80002bfe:	e44e                	sd	s3,8(sp)
    80002c00:	1800                	addi	s0,sp,48
    80002c02:	892a                	mv	s2,a0
    80002c04:	84ae                	mv	s1,a1
    80002c06:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002c08:	fffff097          	auipc	ra,0xfffff
    80002c0c:	dda080e7          	jalr	-550(ra) # 800019e2 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002c10:	86ce                	mv	a3,s3
    80002c12:	864a                	mv	a2,s2
    80002c14:	85a6                	mv	a1,s1
    80002c16:	6928                	ld	a0,80(a0)
    80002c18:	fffff097          	auipc	ra,0xfffff
    80002c1c:	b94080e7          	jalr	-1132(ra) # 800017ac <copyinstr>
    80002c20:	00054e63          	bltz	a0,80002c3c <fetchstr+0x48>
  return strlen(buf);
    80002c24:	8526                	mv	a0,s1
    80002c26:	ffffe097          	auipc	ra,0xffffe
    80002c2a:	222080e7          	jalr	546(ra) # 80000e48 <strlen>
}
    80002c2e:	70a2                	ld	ra,40(sp)
    80002c30:	7402                	ld	s0,32(sp)
    80002c32:	64e2                	ld	s1,24(sp)
    80002c34:	6942                	ld	s2,16(sp)
    80002c36:	69a2                	ld	s3,8(sp)
    80002c38:	6145                	addi	sp,sp,48
    80002c3a:	8082                	ret
    return -1;
    80002c3c:	557d                	li	a0,-1
    80002c3e:	bfc5                	j	80002c2e <fetchstr+0x3a>

0000000080002c40 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002c40:	1101                	addi	sp,sp,-32
    80002c42:	ec06                	sd	ra,24(sp)
    80002c44:	e822                	sd	s0,16(sp)
    80002c46:	e426                	sd	s1,8(sp)
    80002c48:	1000                	addi	s0,sp,32
    80002c4a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c4c:	00000097          	auipc	ra,0x0
    80002c50:	eee080e7          	jalr	-274(ra) # 80002b3a <argraw>
    80002c54:	c088                	sw	a0,0(s1)
}
    80002c56:	60e2                	ld	ra,24(sp)
    80002c58:	6442                	ld	s0,16(sp)
    80002c5a:	64a2                	ld	s1,8(sp)
    80002c5c:	6105                	addi	sp,sp,32
    80002c5e:	8082                	ret

0000000080002c60 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	1000                	addi	s0,sp,32
    80002c6a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c6c:	00000097          	auipc	ra,0x0
    80002c70:	ece080e7          	jalr	-306(ra) # 80002b3a <argraw>
    80002c74:	e088                	sd	a0,0(s1)
}
    80002c76:	60e2                	ld	ra,24(sp)
    80002c78:	6442                	ld	s0,16(sp)
    80002c7a:	64a2                	ld	s1,8(sp)
    80002c7c:	6105                	addi	sp,sp,32
    80002c7e:	8082                	ret

0000000080002c80 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c80:	7179                	addi	sp,sp,-48
    80002c82:	f406                	sd	ra,40(sp)
    80002c84:	f022                	sd	s0,32(sp)
    80002c86:	ec26                	sd	s1,24(sp)
    80002c88:	e84a                	sd	s2,16(sp)
    80002c8a:	1800                	addi	s0,sp,48
    80002c8c:	84ae                	mv	s1,a1
    80002c8e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002c90:	fd840593          	addi	a1,s0,-40
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	fcc080e7          	jalr	-52(ra) # 80002c60 <argaddr>
  return fetchstr(addr, buf, max);
    80002c9c:	864a                	mv	a2,s2
    80002c9e:	85a6                	mv	a1,s1
    80002ca0:	fd843503          	ld	a0,-40(s0)
    80002ca4:	00000097          	auipc	ra,0x0
    80002ca8:	f50080e7          	jalr	-176(ra) # 80002bf4 <fetchstr>
}
    80002cac:	70a2                	ld	ra,40(sp)
    80002cae:	7402                	ld	s0,32(sp)
    80002cb0:	64e2                	ld	s1,24(sp)
    80002cb2:	6942                	ld	s2,16(sp)
    80002cb4:	6145                	addi	sp,sp,48
    80002cb6:	8082                	ret

0000000080002cb8 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002cb8:	1101                	addi	sp,sp,-32
    80002cba:	ec06                	sd	ra,24(sp)
    80002cbc:	e822                	sd	s0,16(sp)
    80002cbe:	e426                	sd	s1,8(sp)
    80002cc0:	e04a                	sd	s2,0(sp)
    80002cc2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002cc4:	fffff097          	auipc	ra,0xfffff
    80002cc8:	d1e080e7          	jalr	-738(ra) # 800019e2 <myproc>
    80002ccc:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    80002cce:	05853903          	ld	s2,88(a0)
    80002cd2:	0a893783          	ld	a5,168(s2)
    80002cd6:	0007869b          	sext.w	a3,a5
  
  /* Adil: debugging */
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002cda:	37fd                	addiw	a5,a5,-1
    80002cdc:	4751                	li	a4,20
    80002cde:	00f76f63          	bltu	a4,a5,80002cfc <syscall+0x44>
    80002ce2:	00369713          	slli	a4,a3,0x3
    80002ce6:	00005797          	auipc	a5,0x5
    80002cea:	79278793          	addi	a5,a5,1938 # 80008478 <syscalls>
    80002cee:	97ba                	add	a5,a5,a4
    80002cf0:	639c                	ld	a5,0(a5)
    80002cf2:	c789                	beqz	a5,80002cfc <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002cf4:	9782                	jalr	a5
    80002cf6:	06a93823          	sd	a0,112(s2)
    80002cfa:	a839                	j	80002d18 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002cfc:	15848613          	addi	a2,s1,344
    80002d00:	588c                	lw	a1,48(s1)
    80002d02:	00005517          	auipc	a0,0x5
    80002d06:	73e50513          	addi	a0,a0,1854 # 80008440 <states.0+0x150>
    80002d0a:	ffffe097          	auipc	ra,0xffffe
    80002d0e:	87c080e7          	jalr	-1924(ra) # 80000586 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002d12:	6cbc                	ld	a5,88(s1)
    80002d14:	577d                	li	a4,-1
    80002d16:	fbb8                	sd	a4,112(a5)
  }
}
    80002d18:	60e2                	ld	ra,24(sp)
    80002d1a:	6442                	ld	s0,16(sp)
    80002d1c:	64a2                	ld	s1,8(sp)
    80002d1e:	6902                	ld	s2,0(sp)
    80002d20:	6105                	addi	sp,sp,32
    80002d22:	8082                	ret

0000000080002d24 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002d24:	1101                	addi	sp,sp,-32
    80002d26:	ec06                	sd	ra,24(sp)
    80002d28:	e822                	sd	s0,16(sp)
    80002d2a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002d2c:	fec40593          	addi	a1,s0,-20
    80002d30:	4501                	li	a0,0
    80002d32:	00000097          	auipc	ra,0x0
    80002d36:	f0e080e7          	jalr	-242(ra) # 80002c40 <argint>
  exit(n);
    80002d3a:	fec42503          	lw	a0,-20(s0)
    80002d3e:	fffff097          	auipc	ra,0xfffff
    80002d42:	59a080e7          	jalr	1434(ra) # 800022d8 <exit>
  return 0;  // not reached
}
    80002d46:	4501                	li	a0,0
    80002d48:	60e2                	ld	ra,24(sp)
    80002d4a:	6442                	ld	s0,16(sp)
    80002d4c:	6105                	addi	sp,sp,32
    80002d4e:	8082                	ret

0000000080002d50 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d50:	1141                	addi	sp,sp,-16
    80002d52:	e406                	sd	ra,8(sp)
    80002d54:	e022                	sd	s0,0(sp)
    80002d56:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	c8a080e7          	jalr	-886(ra) # 800019e2 <myproc>
}
    80002d60:	5908                	lw	a0,48(a0)
    80002d62:	60a2                	ld	ra,8(sp)
    80002d64:	6402                	ld	s0,0(sp)
    80002d66:	0141                	addi	sp,sp,16
    80002d68:	8082                	ret

0000000080002d6a <sys_fork>:

uint64
sys_fork(void)
{
    80002d6a:	1141                	addi	sp,sp,-16
    80002d6c:	e406                	sd	ra,8(sp)
    80002d6e:	e022                	sd	s0,0(sp)
    80002d70:	0800                	addi	s0,sp,16
  return fork();
    80002d72:	fffff097          	auipc	ra,0xfffff
    80002d76:	122080e7          	jalr	290(ra) # 80001e94 <fork>
}
    80002d7a:	60a2                	ld	ra,8(sp)
    80002d7c:	6402                	ld	s0,0(sp)
    80002d7e:	0141                	addi	sp,sp,16
    80002d80:	8082                	ret

0000000080002d82 <sys_wait>:

uint64
sys_wait(void)
{
    80002d82:	1101                	addi	sp,sp,-32
    80002d84:	ec06                	sd	ra,24(sp)
    80002d86:	e822                	sd	s0,16(sp)
    80002d88:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002d8a:	fe840593          	addi	a1,s0,-24
    80002d8e:	4501                	li	a0,0
    80002d90:	00000097          	auipc	ra,0x0
    80002d94:	ed0080e7          	jalr	-304(ra) # 80002c60 <argaddr>
  return wait(p);
    80002d98:	fe843503          	ld	a0,-24(s0)
    80002d9c:	fffff097          	auipc	ra,0xfffff
    80002da0:	6ea080e7          	jalr	1770(ra) # 80002486 <wait>
}
    80002da4:	60e2                	ld	ra,24(sp)
    80002da6:	6442                	ld	s0,16(sp)
    80002da8:	6105                	addi	sp,sp,32
    80002daa:	8082                	ret

0000000080002dac <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002dac:	7179                	addi	sp,sp,-48
    80002dae:	f406                	sd	ra,40(sp)
    80002db0:	f022                	sd	s0,32(sp)
    80002db2:	ec26                	sd	s1,24(sp)
    80002db4:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002db6:	fdc40593          	addi	a1,s0,-36
    80002dba:	4501                	li	a0,0
    80002dbc:	00000097          	auipc	ra,0x0
    80002dc0:	e84080e7          	jalr	-380(ra) # 80002c40 <argint>
  addr = myproc()->sz;
    80002dc4:	fffff097          	auipc	ra,0xfffff
    80002dc8:	c1e080e7          	jalr	-994(ra) # 800019e2 <myproc>
    80002dcc:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002dce:	fdc42503          	lw	a0,-36(s0)
    80002dd2:	fffff097          	auipc	ra,0xfffff
    80002dd6:	ff4080e7          	jalr	-12(ra) # 80001dc6 <growproc>
    80002dda:	00054863          	bltz	a0,80002dea <sys_sbrk+0x3e>
    return -1;

  return addr;
}
    80002dde:	8526                	mv	a0,s1
    80002de0:	70a2                	ld	ra,40(sp)
    80002de2:	7402                	ld	s0,32(sp)
    80002de4:	64e2                	ld	s1,24(sp)
    80002de6:	6145                	addi	sp,sp,48
    80002de8:	8082                	ret
    return -1;
    80002dea:	54fd                	li	s1,-1
    80002dec:	bfcd                	j	80002dde <sys_sbrk+0x32>

0000000080002dee <sys_sleep>:

uint64
sys_sleep(void)
{
    80002dee:	7139                	addi	sp,sp,-64
    80002df0:	fc06                	sd	ra,56(sp)
    80002df2:	f822                	sd	s0,48(sp)
    80002df4:	f426                	sd	s1,40(sp)
    80002df6:	f04a                	sd	s2,32(sp)
    80002df8:	ec4e                	sd	s3,24(sp)
    80002dfa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002dfc:	fcc40593          	addi	a1,s0,-52
    80002e00:	4501                	li	a0,0
    80002e02:	00000097          	auipc	ra,0x0
    80002e06:	e3e080e7          	jalr	-450(ra) # 80002c40 <argint>
  acquire(&tickslock);
    80002e0a:	0018b517          	auipc	a0,0x18b
    80002e0e:	13650513          	addi	a0,a0,310 # 8018df40 <tickslock>
    80002e12:	ffffe097          	auipc	ra,0xffffe
    80002e16:	dc0080e7          	jalr	-576(ra) # 80000bd2 <acquire>
  ticks0 = ticks;
    80002e1a:	00006917          	auipc	s2,0x6
    80002e1e:	c8692903          	lw	s2,-890(s2) # 80008aa0 <ticks>
  while(ticks - ticks0 < n){
    80002e22:	fcc42783          	lw	a5,-52(s0)
    80002e26:	cf9d                	beqz	a5,80002e64 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e28:	0018b997          	auipc	s3,0x18b
    80002e2c:	11898993          	addi	s3,s3,280 # 8018df40 <tickslock>
    80002e30:	00006497          	auipc	s1,0x6
    80002e34:	c7048493          	addi	s1,s1,-912 # 80008aa0 <ticks>
    if(killed(myproc())){
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	baa080e7          	jalr	-1110(ra) # 800019e2 <myproc>
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	614080e7          	jalr	1556(ra) # 80002454 <killed>
    80002e48:	ed15                	bnez	a0,80002e84 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002e4a:	85ce                	mv	a1,s3
    80002e4c:	8526                	mv	a0,s1
    80002e4e:	fffff097          	auipc	ra,0xfffff
    80002e52:	346080e7          	jalr	838(ra) # 80002194 <sleep>
  while(ticks - ticks0 < n){
    80002e56:	409c                	lw	a5,0(s1)
    80002e58:	412787bb          	subw	a5,a5,s2
    80002e5c:	fcc42703          	lw	a4,-52(s0)
    80002e60:	fce7ece3          	bltu	a5,a4,80002e38 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002e64:	0018b517          	auipc	a0,0x18b
    80002e68:	0dc50513          	addi	a0,a0,220 # 8018df40 <tickslock>
    80002e6c:	ffffe097          	auipc	ra,0xffffe
    80002e70:	e1a080e7          	jalr	-486(ra) # 80000c86 <release>
  return 0;
    80002e74:	4501                	li	a0,0
}
    80002e76:	70e2                	ld	ra,56(sp)
    80002e78:	7442                	ld	s0,48(sp)
    80002e7a:	74a2                	ld	s1,40(sp)
    80002e7c:	7902                	ld	s2,32(sp)
    80002e7e:	69e2                	ld	s3,24(sp)
    80002e80:	6121                	addi	sp,sp,64
    80002e82:	8082                	ret
      release(&tickslock);
    80002e84:	0018b517          	auipc	a0,0x18b
    80002e88:	0bc50513          	addi	a0,a0,188 # 8018df40 <tickslock>
    80002e8c:	ffffe097          	auipc	ra,0xffffe
    80002e90:	dfa080e7          	jalr	-518(ra) # 80000c86 <release>
      return -1;
    80002e94:	557d                	li	a0,-1
    80002e96:	b7c5                	j	80002e76 <sys_sleep+0x88>

0000000080002e98 <sys_kill>:

uint64
sys_kill(void)
{
    80002e98:	1101                	addi	sp,sp,-32
    80002e9a:	ec06                	sd	ra,24(sp)
    80002e9c:	e822                	sd	s0,16(sp)
    80002e9e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002ea0:	fec40593          	addi	a1,s0,-20
    80002ea4:	4501                	li	a0,0
    80002ea6:	00000097          	auipc	ra,0x0
    80002eaa:	d9a080e7          	jalr	-614(ra) # 80002c40 <argint>
  return kill(pid);
    80002eae:	fec42503          	lw	a0,-20(s0)
    80002eb2:	fffff097          	auipc	ra,0xfffff
    80002eb6:	4fc080e7          	jalr	1276(ra) # 800023ae <kill>
}
    80002eba:	60e2                	ld	ra,24(sp)
    80002ebc:	6442                	ld	s0,16(sp)
    80002ebe:	6105                	addi	sp,sp,32
    80002ec0:	8082                	ret

0000000080002ec2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ec2:	1101                	addi	sp,sp,-32
    80002ec4:	ec06                	sd	ra,24(sp)
    80002ec6:	e822                	sd	s0,16(sp)
    80002ec8:	e426                	sd	s1,8(sp)
    80002eca:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ecc:	0018b517          	auipc	a0,0x18b
    80002ed0:	07450513          	addi	a0,a0,116 # 8018df40 <tickslock>
    80002ed4:	ffffe097          	auipc	ra,0xffffe
    80002ed8:	cfe080e7          	jalr	-770(ra) # 80000bd2 <acquire>
  xticks = ticks;
    80002edc:	00006497          	auipc	s1,0x6
    80002ee0:	bc44a483          	lw	s1,-1084(s1) # 80008aa0 <ticks>
  release(&tickslock);
    80002ee4:	0018b517          	auipc	a0,0x18b
    80002ee8:	05c50513          	addi	a0,a0,92 # 8018df40 <tickslock>
    80002eec:	ffffe097          	auipc	ra,0xffffe
    80002ef0:	d9a080e7          	jalr	-614(ra) # 80000c86 <release>
  return xticks;
}
    80002ef4:	02049513          	slli	a0,s1,0x20
    80002ef8:	9101                	srli	a0,a0,0x20
    80002efa:	60e2                	ld	ra,24(sp)
    80002efc:	6442                	ld	s0,16(sp)
    80002efe:	64a2                	ld	s1,8(sp)
    80002f00:	6105                	addi	sp,sp,32
    80002f02:	8082                	ret

0000000080002f04 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002f04:	7179                	addi	sp,sp,-48
    80002f06:	f406                	sd	ra,40(sp)
    80002f08:	f022                	sd	s0,32(sp)
    80002f0a:	ec26                	sd	s1,24(sp)
    80002f0c:	e84a                	sd	s2,16(sp)
    80002f0e:	e44e                	sd	s3,8(sp)
    80002f10:	e052                	sd	s4,0(sp)
    80002f12:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f14:	00005597          	auipc	a1,0x5
    80002f18:	61458593          	addi	a1,a1,1556 # 80008528 <syscalls+0xb0>
    80002f1c:	0018b517          	auipc	a0,0x18b
    80002f20:	03c50513          	addi	a0,a0,60 # 8018df58 <bcache>
    80002f24:	ffffe097          	auipc	ra,0xffffe
    80002f28:	c1e080e7          	jalr	-994(ra) # 80000b42 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002f2c:	00193797          	auipc	a5,0x193
    80002f30:	02c78793          	addi	a5,a5,44 # 80195f58 <bcache+0x8000>
    80002f34:	00193717          	auipc	a4,0x193
    80002f38:	28c70713          	addi	a4,a4,652 # 801961c0 <bcache+0x8268>
    80002f3c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f40:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f44:	0018b497          	auipc	s1,0x18b
    80002f48:	02c48493          	addi	s1,s1,44 # 8018df70 <bcache+0x18>
    b->next = bcache.head.next;
    80002f4c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f4e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f50:	00005a17          	auipc	s4,0x5
    80002f54:	5e0a0a13          	addi	s4,s4,1504 # 80008530 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002f58:	2b893783          	ld	a5,696(s2)
    80002f5c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f5e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f62:	85d2                	mv	a1,s4
    80002f64:	01048513          	addi	a0,s1,16
    80002f68:	00001097          	auipc	ra,0x1
    80002f6c:	496080e7          	jalr	1174(ra) # 800043fe <initsleeplock>
    bcache.head.next->prev = b;
    80002f70:	2b893783          	ld	a5,696(s2)
    80002f74:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f76:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f7a:	45848493          	addi	s1,s1,1112
    80002f7e:	fd349de3          	bne	s1,s3,80002f58 <binit+0x54>
  }
}
    80002f82:	70a2                	ld	ra,40(sp)
    80002f84:	7402                	ld	s0,32(sp)
    80002f86:	64e2                	ld	s1,24(sp)
    80002f88:	6942                	ld	s2,16(sp)
    80002f8a:	69a2                	ld	s3,8(sp)
    80002f8c:	6a02                	ld	s4,0(sp)
    80002f8e:	6145                	addi	sp,sp,48
    80002f90:	8082                	ret

0000000080002f92 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f92:	7179                	addi	sp,sp,-48
    80002f94:	f406                	sd	ra,40(sp)
    80002f96:	f022                	sd	s0,32(sp)
    80002f98:	ec26                	sd	s1,24(sp)
    80002f9a:	e84a                	sd	s2,16(sp)
    80002f9c:	e44e                	sd	s3,8(sp)
    80002f9e:	1800                	addi	s0,sp,48
    80002fa0:	892a                	mv	s2,a0
    80002fa2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002fa4:	0018b517          	auipc	a0,0x18b
    80002fa8:	fb450513          	addi	a0,a0,-76 # 8018df58 <bcache>
    80002fac:	ffffe097          	auipc	ra,0xffffe
    80002fb0:	c26080e7          	jalr	-986(ra) # 80000bd2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002fb4:	00193497          	auipc	s1,0x193
    80002fb8:	25c4b483          	ld	s1,604(s1) # 80196210 <bcache+0x82b8>
    80002fbc:	00193797          	auipc	a5,0x193
    80002fc0:	20478793          	addi	a5,a5,516 # 801961c0 <bcache+0x8268>
    80002fc4:	02f48f63          	beq	s1,a5,80003002 <bread+0x70>
    80002fc8:	873e                	mv	a4,a5
    80002fca:	a021                	j	80002fd2 <bread+0x40>
    80002fcc:	68a4                	ld	s1,80(s1)
    80002fce:	02e48a63          	beq	s1,a4,80003002 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002fd2:	449c                	lw	a5,8(s1)
    80002fd4:	ff279ce3          	bne	a5,s2,80002fcc <bread+0x3a>
    80002fd8:	44dc                	lw	a5,12(s1)
    80002fda:	ff3799e3          	bne	a5,s3,80002fcc <bread+0x3a>
      b->refcnt++;
    80002fde:	40bc                	lw	a5,64(s1)
    80002fe0:	2785                	addiw	a5,a5,1
    80002fe2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fe4:	0018b517          	auipc	a0,0x18b
    80002fe8:	f7450513          	addi	a0,a0,-140 # 8018df58 <bcache>
    80002fec:	ffffe097          	auipc	ra,0xffffe
    80002ff0:	c9a080e7          	jalr	-870(ra) # 80000c86 <release>
      acquiresleep(&b->lock);
    80002ff4:	01048513          	addi	a0,s1,16
    80002ff8:	00001097          	auipc	ra,0x1
    80002ffc:	440080e7          	jalr	1088(ra) # 80004438 <acquiresleep>
      return b;
    80003000:	a8b9                	j	8000305e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003002:	00193497          	auipc	s1,0x193
    80003006:	2064b483          	ld	s1,518(s1) # 80196208 <bcache+0x82b0>
    8000300a:	00193797          	auipc	a5,0x193
    8000300e:	1b678793          	addi	a5,a5,438 # 801961c0 <bcache+0x8268>
    80003012:	00f48863          	beq	s1,a5,80003022 <bread+0x90>
    80003016:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003018:	40bc                	lw	a5,64(s1)
    8000301a:	cf81                	beqz	a5,80003032 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000301c:	64a4                	ld	s1,72(s1)
    8000301e:	fee49de3          	bne	s1,a4,80003018 <bread+0x86>
  panic("bget: no buffers");
    80003022:	00005517          	auipc	a0,0x5
    80003026:	51650513          	addi	a0,a0,1302 # 80008538 <syscalls+0xc0>
    8000302a:	ffffd097          	auipc	ra,0xffffd
    8000302e:	512080e7          	jalr	1298(ra) # 8000053c <panic>
      b->dev = dev;
    80003032:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003036:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000303a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000303e:	4785                	li	a5,1
    80003040:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003042:	0018b517          	auipc	a0,0x18b
    80003046:	f1650513          	addi	a0,a0,-234 # 8018df58 <bcache>
    8000304a:	ffffe097          	auipc	ra,0xffffe
    8000304e:	c3c080e7          	jalr	-964(ra) # 80000c86 <release>
      acquiresleep(&b->lock);
    80003052:	01048513          	addi	a0,s1,16
    80003056:	00001097          	auipc	ra,0x1
    8000305a:	3e2080e7          	jalr	994(ra) # 80004438 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000305e:	409c                	lw	a5,0(s1)
    80003060:	cb89                	beqz	a5,80003072 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003062:	8526                	mv	a0,s1
    80003064:	70a2                	ld	ra,40(sp)
    80003066:	7402                	ld	s0,32(sp)
    80003068:	64e2                	ld	s1,24(sp)
    8000306a:	6942                	ld	s2,16(sp)
    8000306c:	69a2                	ld	s3,8(sp)
    8000306e:	6145                	addi	sp,sp,48
    80003070:	8082                	ret
    virtio_disk_rw(b, 0);
    80003072:	4581                	li	a1,0
    80003074:	8526                	mv	a0,s1
    80003076:	00003097          	auipc	ra,0x3
    8000307a:	fec080e7          	jalr	-20(ra) # 80006062 <virtio_disk_rw>
    b->valid = 1;
    8000307e:	4785                	li	a5,1
    80003080:	c09c                	sw	a5,0(s1)
  return b;
    80003082:	b7c5                	j	80003062 <bread+0xd0>

0000000080003084 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003084:	1101                	addi	sp,sp,-32
    80003086:	ec06                	sd	ra,24(sp)
    80003088:	e822                	sd	s0,16(sp)
    8000308a:	e426                	sd	s1,8(sp)
    8000308c:	1000                	addi	s0,sp,32
    8000308e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003090:	0541                	addi	a0,a0,16
    80003092:	00001097          	auipc	ra,0x1
    80003096:	440080e7          	jalr	1088(ra) # 800044d2 <holdingsleep>
    8000309a:	cd01                	beqz	a0,800030b2 <bwrite+0x2e>
    panic("bwrite");

  virtio_disk_rw(b, 1);
    8000309c:	4585                	li	a1,1
    8000309e:	8526                	mv	a0,s1
    800030a0:	00003097          	auipc	ra,0x3
    800030a4:	fc2080e7          	jalr	-62(ra) # 80006062 <virtio_disk_rw>
}
    800030a8:	60e2                	ld	ra,24(sp)
    800030aa:	6442                	ld	s0,16(sp)
    800030ac:	64a2                	ld	s1,8(sp)
    800030ae:	6105                	addi	sp,sp,32
    800030b0:	8082                	ret
    panic("bwrite");
    800030b2:	00005517          	auipc	a0,0x5
    800030b6:	49e50513          	addi	a0,a0,1182 # 80008550 <syscalls+0xd8>
    800030ba:	ffffd097          	auipc	ra,0xffffd
    800030be:	482080e7          	jalr	1154(ra) # 8000053c <panic>

00000000800030c2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800030c2:	1101                	addi	sp,sp,-32
    800030c4:	ec06                	sd	ra,24(sp)
    800030c6:	e822                	sd	s0,16(sp)
    800030c8:	e426                	sd	s1,8(sp)
    800030ca:	e04a                	sd	s2,0(sp)
    800030cc:	1000                	addi	s0,sp,32
    800030ce:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030d0:	01050913          	addi	s2,a0,16
    800030d4:	854a                	mv	a0,s2
    800030d6:	00001097          	auipc	ra,0x1
    800030da:	3fc080e7          	jalr	1020(ra) # 800044d2 <holdingsleep>
    800030de:	c925                	beqz	a0,8000314e <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800030e0:	854a                	mv	a0,s2
    800030e2:	00001097          	auipc	ra,0x1
    800030e6:	3ac080e7          	jalr	940(ra) # 8000448e <releasesleep>

  acquire(&bcache.lock);
    800030ea:	0018b517          	auipc	a0,0x18b
    800030ee:	e6e50513          	addi	a0,a0,-402 # 8018df58 <bcache>
    800030f2:	ffffe097          	auipc	ra,0xffffe
    800030f6:	ae0080e7          	jalr	-1312(ra) # 80000bd2 <acquire>
  b->refcnt--;
    800030fa:	40bc                	lw	a5,64(s1)
    800030fc:	37fd                	addiw	a5,a5,-1
    800030fe:	0007871b          	sext.w	a4,a5
    80003102:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003104:	e71d                	bnez	a4,80003132 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003106:	68b8                	ld	a4,80(s1)
    80003108:	64bc                	ld	a5,72(s1)
    8000310a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000310c:	68b8                	ld	a4,80(s1)
    8000310e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003110:	00193797          	auipc	a5,0x193
    80003114:	e4878793          	addi	a5,a5,-440 # 80195f58 <bcache+0x8000>
    80003118:	2b87b703          	ld	a4,696(a5)
    8000311c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000311e:	00193717          	auipc	a4,0x193
    80003122:	0a270713          	addi	a4,a4,162 # 801961c0 <bcache+0x8268>
    80003126:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003128:	2b87b703          	ld	a4,696(a5)
    8000312c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000312e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003132:	0018b517          	auipc	a0,0x18b
    80003136:	e2650513          	addi	a0,a0,-474 # 8018df58 <bcache>
    8000313a:	ffffe097          	auipc	ra,0xffffe
    8000313e:	b4c080e7          	jalr	-1204(ra) # 80000c86 <release>
}
    80003142:	60e2                	ld	ra,24(sp)
    80003144:	6442                	ld	s0,16(sp)
    80003146:	64a2                	ld	s1,8(sp)
    80003148:	6902                	ld	s2,0(sp)
    8000314a:	6105                	addi	sp,sp,32
    8000314c:	8082                	ret
    panic("brelse");
    8000314e:	00005517          	auipc	a0,0x5
    80003152:	40a50513          	addi	a0,a0,1034 # 80008558 <syscalls+0xe0>
    80003156:	ffffd097          	auipc	ra,0xffffd
    8000315a:	3e6080e7          	jalr	998(ra) # 8000053c <panic>

000000008000315e <bpin>:

void
bpin(struct buf *b) {
    8000315e:	1101                	addi	sp,sp,-32
    80003160:	ec06                	sd	ra,24(sp)
    80003162:	e822                	sd	s0,16(sp)
    80003164:	e426                	sd	s1,8(sp)
    80003166:	1000                	addi	s0,sp,32
    80003168:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000316a:	0018b517          	auipc	a0,0x18b
    8000316e:	dee50513          	addi	a0,a0,-530 # 8018df58 <bcache>
    80003172:	ffffe097          	auipc	ra,0xffffe
    80003176:	a60080e7          	jalr	-1440(ra) # 80000bd2 <acquire>
  b->refcnt++;
    8000317a:	40bc                	lw	a5,64(s1)
    8000317c:	2785                	addiw	a5,a5,1
    8000317e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003180:	0018b517          	auipc	a0,0x18b
    80003184:	dd850513          	addi	a0,a0,-552 # 8018df58 <bcache>
    80003188:	ffffe097          	auipc	ra,0xffffe
    8000318c:	afe080e7          	jalr	-1282(ra) # 80000c86 <release>
}
    80003190:	60e2                	ld	ra,24(sp)
    80003192:	6442                	ld	s0,16(sp)
    80003194:	64a2                	ld	s1,8(sp)
    80003196:	6105                	addi	sp,sp,32
    80003198:	8082                	ret

000000008000319a <bunpin>:

void
bunpin(struct buf *b) {
    8000319a:	1101                	addi	sp,sp,-32
    8000319c:	ec06                	sd	ra,24(sp)
    8000319e:	e822                	sd	s0,16(sp)
    800031a0:	e426                	sd	s1,8(sp)
    800031a2:	1000                	addi	s0,sp,32
    800031a4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031a6:	0018b517          	auipc	a0,0x18b
    800031aa:	db250513          	addi	a0,a0,-590 # 8018df58 <bcache>
    800031ae:	ffffe097          	auipc	ra,0xffffe
    800031b2:	a24080e7          	jalr	-1500(ra) # 80000bd2 <acquire>
  b->refcnt--;
    800031b6:	40bc                	lw	a5,64(s1)
    800031b8:	37fd                	addiw	a5,a5,-1
    800031ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031bc:	0018b517          	auipc	a0,0x18b
    800031c0:	d9c50513          	addi	a0,a0,-612 # 8018df58 <bcache>
    800031c4:	ffffe097          	auipc	ra,0xffffe
    800031c8:	ac2080e7          	jalr	-1342(ra) # 80000c86 <release>
}
    800031cc:	60e2                	ld	ra,24(sp)
    800031ce:	6442                	ld	s0,16(sp)
    800031d0:	64a2                	ld	s1,8(sp)
    800031d2:	6105                	addi	sp,sp,32
    800031d4:	8082                	ret

00000000800031d6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800031d6:	1101                	addi	sp,sp,-32
    800031d8:	ec06                	sd	ra,24(sp)
    800031da:	e822                	sd	s0,16(sp)
    800031dc:	e426                	sd	s1,8(sp)
    800031de:	e04a                	sd	s2,0(sp)
    800031e0:	1000                	addi	s0,sp,32
    800031e2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800031e4:	00d5d59b          	srliw	a1,a1,0xd
    800031e8:	00193797          	auipc	a5,0x193
    800031ec:	44c7a783          	lw	a5,1100(a5) # 80196634 <sb+0x1c>
    800031f0:	9dbd                	addw	a1,a1,a5
    800031f2:	00000097          	auipc	ra,0x0
    800031f6:	da0080e7          	jalr	-608(ra) # 80002f92 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800031fa:	0074f713          	andi	a4,s1,7
    800031fe:	4785                	li	a5,1
    80003200:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003204:	14ce                	slli	s1,s1,0x33
    80003206:	90d9                	srli	s1,s1,0x36
    80003208:	00950733          	add	a4,a0,s1
    8000320c:	05874703          	lbu	a4,88(a4)
    80003210:	00e7f6b3          	and	a3,a5,a4
    80003214:	c69d                	beqz	a3,80003242 <bfree+0x6c>
    80003216:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003218:	94aa                	add	s1,s1,a0
    8000321a:	fff7c793          	not	a5,a5
    8000321e:	8f7d                	and	a4,a4,a5
    80003220:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003224:	00001097          	auipc	ra,0x1
    80003228:	0f6080e7          	jalr	246(ra) # 8000431a <log_write>
  brelse(bp);
    8000322c:	854a                	mv	a0,s2
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	e94080e7          	jalr	-364(ra) # 800030c2 <brelse>
}
    80003236:	60e2                	ld	ra,24(sp)
    80003238:	6442                	ld	s0,16(sp)
    8000323a:	64a2                	ld	s1,8(sp)
    8000323c:	6902                	ld	s2,0(sp)
    8000323e:	6105                	addi	sp,sp,32
    80003240:	8082                	ret
    panic("freeing free block");
    80003242:	00005517          	auipc	a0,0x5
    80003246:	31e50513          	addi	a0,a0,798 # 80008560 <syscalls+0xe8>
    8000324a:	ffffd097          	auipc	ra,0xffffd
    8000324e:	2f2080e7          	jalr	754(ra) # 8000053c <panic>

0000000080003252 <balloc>:
{
    80003252:	711d                	addi	sp,sp,-96
    80003254:	ec86                	sd	ra,88(sp)
    80003256:	e8a2                	sd	s0,80(sp)
    80003258:	e4a6                	sd	s1,72(sp)
    8000325a:	e0ca                	sd	s2,64(sp)
    8000325c:	fc4e                	sd	s3,56(sp)
    8000325e:	f852                	sd	s4,48(sp)
    80003260:	f456                	sd	s5,40(sp)
    80003262:	f05a                	sd	s6,32(sp)
    80003264:	ec5e                	sd	s7,24(sp)
    80003266:	e862                	sd	s8,16(sp)
    80003268:	e466                	sd	s9,8(sp)
    8000326a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000326c:	00193797          	auipc	a5,0x193
    80003270:	3b07a783          	lw	a5,944(a5) # 8019661c <sb+0x4>
    80003274:	cff5                	beqz	a5,80003370 <balloc+0x11e>
    80003276:	8baa                	mv	s7,a0
    80003278:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000327a:	00193b17          	auipc	s6,0x193
    8000327e:	39eb0b13          	addi	s6,s6,926 # 80196618 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003282:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003284:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003286:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003288:	6c89                	lui	s9,0x2
    8000328a:	a061                	j	80003312 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000328c:	97ca                	add	a5,a5,s2
    8000328e:	8e55                	or	a2,a2,a3
    80003290:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003294:	854a                	mv	a0,s2
    80003296:	00001097          	auipc	ra,0x1
    8000329a:	084080e7          	jalr	132(ra) # 8000431a <log_write>
        brelse(bp);
    8000329e:	854a                	mv	a0,s2
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	e22080e7          	jalr	-478(ra) # 800030c2 <brelse>
  bp = bread(dev, bno);
    800032a8:	85a6                	mv	a1,s1
    800032aa:	855e                	mv	a0,s7
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	ce6080e7          	jalr	-794(ra) # 80002f92 <bread>
    800032b4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032b6:	40000613          	li	a2,1024
    800032ba:	4581                	li	a1,0
    800032bc:	05850513          	addi	a0,a0,88
    800032c0:	ffffe097          	auipc	ra,0xffffe
    800032c4:	a0e080e7          	jalr	-1522(ra) # 80000cce <memset>
  log_write(bp);
    800032c8:	854a                	mv	a0,s2
    800032ca:	00001097          	auipc	ra,0x1
    800032ce:	050080e7          	jalr	80(ra) # 8000431a <log_write>
  brelse(bp);
    800032d2:	854a                	mv	a0,s2
    800032d4:	00000097          	auipc	ra,0x0
    800032d8:	dee080e7          	jalr	-530(ra) # 800030c2 <brelse>
}
    800032dc:	8526                	mv	a0,s1
    800032de:	60e6                	ld	ra,88(sp)
    800032e0:	6446                	ld	s0,80(sp)
    800032e2:	64a6                	ld	s1,72(sp)
    800032e4:	6906                	ld	s2,64(sp)
    800032e6:	79e2                	ld	s3,56(sp)
    800032e8:	7a42                	ld	s4,48(sp)
    800032ea:	7aa2                	ld	s5,40(sp)
    800032ec:	7b02                	ld	s6,32(sp)
    800032ee:	6be2                	ld	s7,24(sp)
    800032f0:	6c42                	ld	s8,16(sp)
    800032f2:	6ca2                	ld	s9,8(sp)
    800032f4:	6125                	addi	sp,sp,96
    800032f6:	8082                	ret
    brelse(bp);
    800032f8:	854a                	mv	a0,s2
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	dc8080e7          	jalr	-568(ra) # 800030c2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003302:	015c87bb          	addw	a5,s9,s5
    80003306:	00078a9b          	sext.w	s5,a5
    8000330a:	004b2703          	lw	a4,4(s6)
    8000330e:	06eaf163          	bgeu	s5,a4,80003370 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003312:	41fad79b          	sraiw	a5,s5,0x1f
    80003316:	0137d79b          	srliw	a5,a5,0x13
    8000331a:	015787bb          	addw	a5,a5,s5
    8000331e:	40d7d79b          	sraiw	a5,a5,0xd
    80003322:	01cb2583          	lw	a1,28(s6)
    80003326:	9dbd                	addw	a1,a1,a5
    80003328:	855e                	mv	a0,s7
    8000332a:	00000097          	auipc	ra,0x0
    8000332e:	c68080e7          	jalr	-920(ra) # 80002f92 <bread>
    80003332:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003334:	004b2503          	lw	a0,4(s6)
    80003338:	000a849b          	sext.w	s1,s5
    8000333c:	8762                	mv	a4,s8
    8000333e:	faa4fde3          	bgeu	s1,a0,800032f8 <balloc+0xa6>
      m = 1 << (bi % 8);
    80003342:	00777693          	andi	a3,a4,7
    80003346:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000334a:	41f7579b          	sraiw	a5,a4,0x1f
    8000334e:	01d7d79b          	srliw	a5,a5,0x1d
    80003352:	9fb9                	addw	a5,a5,a4
    80003354:	4037d79b          	sraiw	a5,a5,0x3
    80003358:	00f90633          	add	a2,s2,a5
    8000335c:	05864603          	lbu	a2,88(a2)
    80003360:	00c6f5b3          	and	a1,a3,a2
    80003364:	d585                	beqz	a1,8000328c <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003366:	2705                	addiw	a4,a4,1
    80003368:	2485                	addiw	s1,s1,1
    8000336a:	fd471ae3          	bne	a4,s4,8000333e <balloc+0xec>
    8000336e:	b769                	j	800032f8 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003370:	00005517          	auipc	a0,0x5
    80003374:	20850513          	addi	a0,a0,520 # 80008578 <syscalls+0x100>
    80003378:	ffffd097          	auipc	ra,0xffffd
    8000337c:	20e080e7          	jalr	526(ra) # 80000586 <printf>
  return 0;
    80003380:	4481                	li	s1,0
    80003382:	bfa9                	j	800032dc <balloc+0x8a>

0000000080003384 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003384:	7179                	addi	sp,sp,-48
    80003386:	f406                	sd	ra,40(sp)
    80003388:	f022                	sd	s0,32(sp)
    8000338a:	ec26                	sd	s1,24(sp)
    8000338c:	e84a                	sd	s2,16(sp)
    8000338e:	e44e                	sd	s3,8(sp)
    80003390:	e052                	sd	s4,0(sp)
    80003392:	1800                	addi	s0,sp,48
    80003394:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003396:	47ad                	li	a5,11
    80003398:	02b7e863          	bltu	a5,a1,800033c8 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000339c:	02059793          	slli	a5,a1,0x20
    800033a0:	01e7d593          	srli	a1,a5,0x1e
    800033a4:	00b504b3          	add	s1,a0,a1
    800033a8:	0504a903          	lw	s2,80(s1)
    800033ac:	06091e63          	bnez	s2,80003428 <bmap+0xa4>
      addr = balloc(ip->dev);
    800033b0:	4108                	lw	a0,0(a0)
    800033b2:	00000097          	auipc	ra,0x0
    800033b6:	ea0080e7          	jalr	-352(ra) # 80003252 <balloc>
    800033ba:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800033be:	06090563          	beqz	s2,80003428 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800033c2:	0524a823          	sw	s2,80(s1)
    800033c6:	a08d                	j	80003428 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800033c8:	ff45849b          	addiw	s1,a1,-12
    800033cc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800033d0:	0ff00793          	li	a5,255
    800033d4:	08e7e563          	bltu	a5,a4,8000345e <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800033d8:	08052903          	lw	s2,128(a0)
    800033dc:	00091d63          	bnez	s2,800033f6 <bmap+0x72>
      addr = balloc(ip->dev);
    800033e0:	4108                	lw	a0,0(a0)
    800033e2:	00000097          	auipc	ra,0x0
    800033e6:	e70080e7          	jalr	-400(ra) # 80003252 <balloc>
    800033ea:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800033ee:	02090d63          	beqz	s2,80003428 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800033f2:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800033f6:	85ca                	mv	a1,s2
    800033f8:	0009a503          	lw	a0,0(s3)
    800033fc:	00000097          	auipc	ra,0x0
    80003400:	b96080e7          	jalr	-1130(ra) # 80002f92 <bread>
    80003404:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003406:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000340a:	02049713          	slli	a4,s1,0x20
    8000340e:	01e75593          	srli	a1,a4,0x1e
    80003412:	00b784b3          	add	s1,a5,a1
    80003416:	0004a903          	lw	s2,0(s1)
    8000341a:	02090063          	beqz	s2,8000343a <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000341e:	8552                	mv	a0,s4
    80003420:	00000097          	auipc	ra,0x0
    80003424:	ca2080e7          	jalr	-862(ra) # 800030c2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003428:	854a                	mv	a0,s2
    8000342a:	70a2                	ld	ra,40(sp)
    8000342c:	7402                	ld	s0,32(sp)
    8000342e:	64e2                	ld	s1,24(sp)
    80003430:	6942                	ld	s2,16(sp)
    80003432:	69a2                	ld	s3,8(sp)
    80003434:	6a02                	ld	s4,0(sp)
    80003436:	6145                	addi	sp,sp,48
    80003438:	8082                	ret
      addr = balloc(ip->dev);
    8000343a:	0009a503          	lw	a0,0(s3)
    8000343e:	00000097          	auipc	ra,0x0
    80003442:	e14080e7          	jalr	-492(ra) # 80003252 <balloc>
    80003446:	0005091b          	sext.w	s2,a0
      if(addr){
    8000344a:	fc090ae3          	beqz	s2,8000341e <bmap+0x9a>
        a[bn] = addr;
    8000344e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003452:	8552                	mv	a0,s4
    80003454:	00001097          	auipc	ra,0x1
    80003458:	ec6080e7          	jalr	-314(ra) # 8000431a <log_write>
    8000345c:	b7c9                	j	8000341e <bmap+0x9a>
  panic("bmap: out of range");
    8000345e:	00005517          	auipc	a0,0x5
    80003462:	13250513          	addi	a0,a0,306 # 80008590 <syscalls+0x118>
    80003466:	ffffd097          	auipc	ra,0xffffd
    8000346a:	0d6080e7          	jalr	214(ra) # 8000053c <panic>

000000008000346e <iget>:
{
    8000346e:	7179                	addi	sp,sp,-48
    80003470:	f406                	sd	ra,40(sp)
    80003472:	f022                	sd	s0,32(sp)
    80003474:	ec26                	sd	s1,24(sp)
    80003476:	e84a                	sd	s2,16(sp)
    80003478:	e44e                	sd	s3,8(sp)
    8000347a:	e052                	sd	s4,0(sp)
    8000347c:	1800                	addi	s0,sp,48
    8000347e:	89aa                	mv	s3,a0
    80003480:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003482:	00193517          	auipc	a0,0x193
    80003486:	1be50513          	addi	a0,a0,446 # 80196640 <itable>
    8000348a:	ffffd097          	auipc	ra,0xffffd
    8000348e:	748080e7          	jalr	1864(ra) # 80000bd2 <acquire>
  empty = 0;
    80003492:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003494:	00193497          	auipc	s1,0x193
    80003498:	1c448493          	addi	s1,s1,452 # 80196658 <itable+0x18>
    8000349c:	00195697          	auipc	a3,0x195
    800034a0:	c4c68693          	addi	a3,a3,-948 # 801980e8 <log>
    800034a4:	a039                	j	800034b2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034a6:	02090b63          	beqz	s2,800034dc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800034aa:	08848493          	addi	s1,s1,136
    800034ae:	02d48a63          	beq	s1,a3,800034e2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800034b2:	449c                	lw	a5,8(s1)
    800034b4:	fef059e3          	blez	a5,800034a6 <iget+0x38>
    800034b8:	4098                	lw	a4,0(s1)
    800034ba:	ff3716e3          	bne	a4,s3,800034a6 <iget+0x38>
    800034be:	40d8                	lw	a4,4(s1)
    800034c0:	ff4713e3          	bne	a4,s4,800034a6 <iget+0x38>
      ip->ref++;
    800034c4:	2785                	addiw	a5,a5,1
    800034c6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800034c8:	00193517          	auipc	a0,0x193
    800034cc:	17850513          	addi	a0,a0,376 # 80196640 <itable>
    800034d0:	ffffd097          	auipc	ra,0xffffd
    800034d4:	7b6080e7          	jalr	1974(ra) # 80000c86 <release>
      return ip;
    800034d8:	8926                	mv	s2,s1
    800034da:	a03d                	j	80003508 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034dc:	f7f9                	bnez	a5,800034aa <iget+0x3c>
    800034de:	8926                	mv	s2,s1
    800034e0:	b7e9                	j	800034aa <iget+0x3c>
  if(empty == 0)
    800034e2:	02090c63          	beqz	s2,8000351a <iget+0xac>
  ip->dev = dev;
    800034e6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800034ea:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800034ee:	4785                	li	a5,1
    800034f0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800034f4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800034f8:	00193517          	auipc	a0,0x193
    800034fc:	14850513          	addi	a0,a0,328 # 80196640 <itable>
    80003500:	ffffd097          	auipc	ra,0xffffd
    80003504:	786080e7          	jalr	1926(ra) # 80000c86 <release>
}
    80003508:	854a                	mv	a0,s2
    8000350a:	70a2                	ld	ra,40(sp)
    8000350c:	7402                	ld	s0,32(sp)
    8000350e:	64e2                	ld	s1,24(sp)
    80003510:	6942                	ld	s2,16(sp)
    80003512:	69a2                	ld	s3,8(sp)
    80003514:	6a02                	ld	s4,0(sp)
    80003516:	6145                	addi	sp,sp,48
    80003518:	8082                	ret
    panic("iget: no inodes");
    8000351a:	00005517          	auipc	a0,0x5
    8000351e:	08e50513          	addi	a0,a0,142 # 800085a8 <syscalls+0x130>
    80003522:	ffffd097          	auipc	ra,0xffffd
    80003526:	01a080e7          	jalr	26(ra) # 8000053c <panic>

000000008000352a <fsinit>:
fsinit(int dev) {
    8000352a:	7179                	addi	sp,sp,-48
    8000352c:	f406                	sd	ra,40(sp)
    8000352e:	f022                	sd	s0,32(sp)
    80003530:	ec26                	sd	s1,24(sp)
    80003532:	e84a                	sd	s2,16(sp)
    80003534:	e44e                	sd	s3,8(sp)
    80003536:	1800                	addi	s0,sp,48
    80003538:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000353a:	4585                	li	a1,1
    8000353c:	00000097          	auipc	ra,0x0
    80003540:	a56080e7          	jalr	-1450(ra) # 80002f92 <bread>
    80003544:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003546:	00193997          	auipc	s3,0x193
    8000354a:	0d298993          	addi	s3,s3,210 # 80196618 <sb>
    8000354e:	02800613          	li	a2,40
    80003552:	05850593          	addi	a1,a0,88
    80003556:	854e                	mv	a0,s3
    80003558:	ffffd097          	auipc	ra,0xffffd
    8000355c:	7d2080e7          	jalr	2002(ra) # 80000d2a <memmove>
  brelse(bp);
    80003560:	8526                	mv	a0,s1
    80003562:	00000097          	auipc	ra,0x0
    80003566:	b60080e7          	jalr	-1184(ra) # 800030c2 <brelse>
  if(sb.magic != FSMAGIC)
    8000356a:	0009a703          	lw	a4,0(s3)
    8000356e:	102037b7          	lui	a5,0x10203
    80003572:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003576:	02f71263          	bne	a4,a5,8000359a <fsinit+0x70>
  initlog(dev, &sb);
    8000357a:	00193597          	auipc	a1,0x193
    8000357e:	09e58593          	addi	a1,a1,158 # 80196618 <sb>
    80003582:	854a                	mv	a0,s2
    80003584:	00001097          	auipc	ra,0x1
    80003588:	b2c080e7          	jalr	-1236(ra) # 800040b0 <initlog>
}
    8000358c:	70a2                	ld	ra,40(sp)
    8000358e:	7402                	ld	s0,32(sp)
    80003590:	64e2                	ld	s1,24(sp)
    80003592:	6942                	ld	s2,16(sp)
    80003594:	69a2                	ld	s3,8(sp)
    80003596:	6145                	addi	sp,sp,48
    80003598:	8082                	ret
    panic("invalid file system");
    8000359a:	00005517          	auipc	a0,0x5
    8000359e:	01e50513          	addi	a0,a0,30 # 800085b8 <syscalls+0x140>
    800035a2:	ffffd097          	auipc	ra,0xffffd
    800035a6:	f9a080e7          	jalr	-102(ra) # 8000053c <panic>

00000000800035aa <iinit>:
{
    800035aa:	7179                	addi	sp,sp,-48
    800035ac:	f406                	sd	ra,40(sp)
    800035ae:	f022                	sd	s0,32(sp)
    800035b0:	ec26                	sd	s1,24(sp)
    800035b2:	e84a                	sd	s2,16(sp)
    800035b4:	e44e                	sd	s3,8(sp)
    800035b6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800035b8:	00005597          	auipc	a1,0x5
    800035bc:	01858593          	addi	a1,a1,24 # 800085d0 <syscalls+0x158>
    800035c0:	00193517          	auipc	a0,0x193
    800035c4:	08050513          	addi	a0,a0,128 # 80196640 <itable>
    800035c8:	ffffd097          	auipc	ra,0xffffd
    800035cc:	57a080e7          	jalr	1402(ra) # 80000b42 <initlock>
  for(i = 0; i < NINODE; i++) {
    800035d0:	00193497          	auipc	s1,0x193
    800035d4:	09848493          	addi	s1,s1,152 # 80196668 <itable+0x28>
    800035d8:	00195997          	auipc	s3,0x195
    800035dc:	b2098993          	addi	s3,s3,-1248 # 801980f8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800035e0:	00005917          	auipc	s2,0x5
    800035e4:	ff890913          	addi	s2,s2,-8 # 800085d8 <syscalls+0x160>
    800035e8:	85ca                	mv	a1,s2
    800035ea:	8526                	mv	a0,s1
    800035ec:	00001097          	auipc	ra,0x1
    800035f0:	e12080e7          	jalr	-494(ra) # 800043fe <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800035f4:	08848493          	addi	s1,s1,136
    800035f8:	ff3498e3          	bne	s1,s3,800035e8 <iinit+0x3e>
}
    800035fc:	70a2                	ld	ra,40(sp)
    800035fe:	7402                	ld	s0,32(sp)
    80003600:	64e2                	ld	s1,24(sp)
    80003602:	6942                	ld	s2,16(sp)
    80003604:	69a2                	ld	s3,8(sp)
    80003606:	6145                	addi	sp,sp,48
    80003608:	8082                	ret

000000008000360a <ialloc>:
{
    8000360a:	7139                	addi	sp,sp,-64
    8000360c:	fc06                	sd	ra,56(sp)
    8000360e:	f822                	sd	s0,48(sp)
    80003610:	f426                	sd	s1,40(sp)
    80003612:	f04a                	sd	s2,32(sp)
    80003614:	ec4e                	sd	s3,24(sp)
    80003616:	e852                	sd	s4,16(sp)
    80003618:	e456                	sd	s5,8(sp)
    8000361a:	e05a                	sd	s6,0(sp)
    8000361c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000361e:	00193717          	auipc	a4,0x193
    80003622:	00672703          	lw	a4,6(a4) # 80196624 <sb+0xc>
    80003626:	4785                	li	a5,1
    80003628:	04e7f863          	bgeu	a5,a4,80003678 <ialloc+0x6e>
    8000362c:	8aaa                	mv	s5,a0
    8000362e:	8b2e                	mv	s6,a1
    80003630:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003632:	00193a17          	auipc	s4,0x193
    80003636:	fe6a0a13          	addi	s4,s4,-26 # 80196618 <sb>
    8000363a:	00495593          	srli	a1,s2,0x4
    8000363e:	018a2783          	lw	a5,24(s4)
    80003642:	9dbd                	addw	a1,a1,a5
    80003644:	8556                	mv	a0,s5
    80003646:	00000097          	auipc	ra,0x0
    8000364a:	94c080e7          	jalr	-1716(ra) # 80002f92 <bread>
    8000364e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003650:	05850993          	addi	s3,a0,88
    80003654:	00f97793          	andi	a5,s2,15
    80003658:	079a                	slli	a5,a5,0x6
    8000365a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000365c:	00099783          	lh	a5,0(s3)
    80003660:	cf9d                	beqz	a5,8000369e <ialloc+0x94>
    brelse(bp);
    80003662:	00000097          	auipc	ra,0x0
    80003666:	a60080e7          	jalr	-1440(ra) # 800030c2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000366a:	0905                	addi	s2,s2,1
    8000366c:	00ca2703          	lw	a4,12(s4)
    80003670:	0009079b          	sext.w	a5,s2
    80003674:	fce7e3e3          	bltu	a5,a4,8000363a <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80003678:	00005517          	auipc	a0,0x5
    8000367c:	f6850513          	addi	a0,a0,-152 # 800085e0 <syscalls+0x168>
    80003680:	ffffd097          	auipc	ra,0xffffd
    80003684:	f06080e7          	jalr	-250(ra) # 80000586 <printf>
  return 0;
    80003688:	4501                	li	a0,0
}
    8000368a:	70e2                	ld	ra,56(sp)
    8000368c:	7442                	ld	s0,48(sp)
    8000368e:	74a2                	ld	s1,40(sp)
    80003690:	7902                	ld	s2,32(sp)
    80003692:	69e2                	ld	s3,24(sp)
    80003694:	6a42                	ld	s4,16(sp)
    80003696:	6aa2                	ld	s5,8(sp)
    80003698:	6b02                	ld	s6,0(sp)
    8000369a:	6121                	addi	sp,sp,64
    8000369c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000369e:	04000613          	li	a2,64
    800036a2:	4581                	li	a1,0
    800036a4:	854e                	mv	a0,s3
    800036a6:	ffffd097          	auipc	ra,0xffffd
    800036aa:	628080e7          	jalr	1576(ra) # 80000cce <memset>
      dip->type = type;
    800036ae:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800036b2:	8526                	mv	a0,s1
    800036b4:	00001097          	auipc	ra,0x1
    800036b8:	c66080e7          	jalr	-922(ra) # 8000431a <log_write>
      brelse(bp);
    800036bc:	8526                	mv	a0,s1
    800036be:	00000097          	auipc	ra,0x0
    800036c2:	a04080e7          	jalr	-1532(ra) # 800030c2 <brelse>
      return iget(dev, inum);
    800036c6:	0009059b          	sext.w	a1,s2
    800036ca:	8556                	mv	a0,s5
    800036cc:	00000097          	auipc	ra,0x0
    800036d0:	da2080e7          	jalr	-606(ra) # 8000346e <iget>
    800036d4:	bf5d                	j	8000368a <ialloc+0x80>

00000000800036d6 <iupdate>:
{
    800036d6:	1101                	addi	sp,sp,-32
    800036d8:	ec06                	sd	ra,24(sp)
    800036da:	e822                	sd	s0,16(sp)
    800036dc:	e426                	sd	s1,8(sp)
    800036de:	e04a                	sd	s2,0(sp)
    800036e0:	1000                	addi	s0,sp,32
    800036e2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800036e4:	415c                	lw	a5,4(a0)
    800036e6:	0047d79b          	srliw	a5,a5,0x4
    800036ea:	00193597          	auipc	a1,0x193
    800036ee:	f465a583          	lw	a1,-186(a1) # 80196630 <sb+0x18>
    800036f2:	9dbd                	addw	a1,a1,a5
    800036f4:	4108                	lw	a0,0(a0)
    800036f6:	00000097          	auipc	ra,0x0
    800036fa:	89c080e7          	jalr	-1892(ra) # 80002f92 <bread>
    800036fe:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003700:	05850793          	addi	a5,a0,88
    80003704:	40d8                	lw	a4,4(s1)
    80003706:	8b3d                	andi	a4,a4,15
    80003708:	071a                	slli	a4,a4,0x6
    8000370a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000370c:	04449703          	lh	a4,68(s1)
    80003710:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003714:	04649703          	lh	a4,70(s1)
    80003718:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000371c:	04849703          	lh	a4,72(s1)
    80003720:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003724:	04a49703          	lh	a4,74(s1)
    80003728:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000372c:	44f8                	lw	a4,76(s1)
    8000372e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003730:	03400613          	li	a2,52
    80003734:	05048593          	addi	a1,s1,80
    80003738:	00c78513          	addi	a0,a5,12
    8000373c:	ffffd097          	auipc	ra,0xffffd
    80003740:	5ee080e7          	jalr	1518(ra) # 80000d2a <memmove>
  log_write(bp);
    80003744:	854a                	mv	a0,s2
    80003746:	00001097          	auipc	ra,0x1
    8000374a:	bd4080e7          	jalr	-1068(ra) # 8000431a <log_write>
  brelse(bp);
    8000374e:	854a                	mv	a0,s2
    80003750:	00000097          	auipc	ra,0x0
    80003754:	972080e7          	jalr	-1678(ra) # 800030c2 <brelse>
}
    80003758:	60e2                	ld	ra,24(sp)
    8000375a:	6442                	ld	s0,16(sp)
    8000375c:	64a2                	ld	s1,8(sp)
    8000375e:	6902                	ld	s2,0(sp)
    80003760:	6105                	addi	sp,sp,32
    80003762:	8082                	ret

0000000080003764 <idup>:
{
    80003764:	1101                	addi	sp,sp,-32
    80003766:	ec06                	sd	ra,24(sp)
    80003768:	e822                	sd	s0,16(sp)
    8000376a:	e426                	sd	s1,8(sp)
    8000376c:	1000                	addi	s0,sp,32
    8000376e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003770:	00193517          	auipc	a0,0x193
    80003774:	ed050513          	addi	a0,a0,-304 # 80196640 <itable>
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	45a080e7          	jalr	1114(ra) # 80000bd2 <acquire>
  ip->ref++;
    80003780:	449c                	lw	a5,8(s1)
    80003782:	2785                	addiw	a5,a5,1
    80003784:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003786:	00193517          	auipc	a0,0x193
    8000378a:	eba50513          	addi	a0,a0,-326 # 80196640 <itable>
    8000378e:	ffffd097          	auipc	ra,0xffffd
    80003792:	4f8080e7          	jalr	1272(ra) # 80000c86 <release>
}
    80003796:	8526                	mv	a0,s1
    80003798:	60e2                	ld	ra,24(sp)
    8000379a:	6442                	ld	s0,16(sp)
    8000379c:	64a2                	ld	s1,8(sp)
    8000379e:	6105                	addi	sp,sp,32
    800037a0:	8082                	ret

00000000800037a2 <ilock>:
{
    800037a2:	1101                	addi	sp,sp,-32
    800037a4:	ec06                	sd	ra,24(sp)
    800037a6:	e822                	sd	s0,16(sp)
    800037a8:	e426                	sd	s1,8(sp)
    800037aa:	e04a                	sd	s2,0(sp)
    800037ac:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800037ae:	c115                	beqz	a0,800037d2 <ilock+0x30>
    800037b0:	84aa                	mv	s1,a0
    800037b2:	451c                	lw	a5,8(a0)
    800037b4:	00f05f63          	blez	a5,800037d2 <ilock+0x30>
  acquiresleep(&ip->lock);
    800037b8:	0541                	addi	a0,a0,16
    800037ba:	00001097          	auipc	ra,0x1
    800037be:	c7e080e7          	jalr	-898(ra) # 80004438 <acquiresleep>
  if(ip->valid == 0){
    800037c2:	40bc                	lw	a5,64(s1)
    800037c4:	cf99                	beqz	a5,800037e2 <ilock+0x40>
}
    800037c6:	60e2                	ld	ra,24(sp)
    800037c8:	6442                	ld	s0,16(sp)
    800037ca:	64a2                	ld	s1,8(sp)
    800037cc:	6902                	ld	s2,0(sp)
    800037ce:	6105                	addi	sp,sp,32
    800037d0:	8082                	ret
    panic("ilock");
    800037d2:	00005517          	auipc	a0,0x5
    800037d6:	e2650513          	addi	a0,a0,-474 # 800085f8 <syscalls+0x180>
    800037da:	ffffd097          	auipc	ra,0xffffd
    800037de:	d62080e7          	jalr	-670(ra) # 8000053c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037e2:	40dc                	lw	a5,4(s1)
    800037e4:	0047d79b          	srliw	a5,a5,0x4
    800037e8:	00193597          	auipc	a1,0x193
    800037ec:	e485a583          	lw	a1,-440(a1) # 80196630 <sb+0x18>
    800037f0:	9dbd                	addw	a1,a1,a5
    800037f2:	4088                	lw	a0,0(s1)
    800037f4:	fffff097          	auipc	ra,0xfffff
    800037f8:	79e080e7          	jalr	1950(ra) # 80002f92 <bread>
    800037fc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037fe:	05850593          	addi	a1,a0,88
    80003802:	40dc                	lw	a5,4(s1)
    80003804:	8bbd                	andi	a5,a5,15
    80003806:	079a                	slli	a5,a5,0x6
    80003808:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000380a:	00059783          	lh	a5,0(a1)
    8000380e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003812:	00259783          	lh	a5,2(a1)
    80003816:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000381a:	00459783          	lh	a5,4(a1)
    8000381e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003822:	00659783          	lh	a5,6(a1)
    80003826:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000382a:	459c                	lw	a5,8(a1)
    8000382c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000382e:	03400613          	li	a2,52
    80003832:	05b1                	addi	a1,a1,12
    80003834:	05048513          	addi	a0,s1,80
    80003838:	ffffd097          	auipc	ra,0xffffd
    8000383c:	4f2080e7          	jalr	1266(ra) # 80000d2a <memmove>
    brelse(bp);
    80003840:	854a                	mv	a0,s2
    80003842:	00000097          	auipc	ra,0x0
    80003846:	880080e7          	jalr	-1920(ra) # 800030c2 <brelse>
    ip->valid = 1;
    8000384a:	4785                	li	a5,1
    8000384c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000384e:	04449783          	lh	a5,68(s1)
    80003852:	fbb5                	bnez	a5,800037c6 <ilock+0x24>
      panic("ilock: no type");
    80003854:	00005517          	auipc	a0,0x5
    80003858:	dac50513          	addi	a0,a0,-596 # 80008600 <syscalls+0x188>
    8000385c:	ffffd097          	auipc	ra,0xffffd
    80003860:	ce0080e7          	jalr	-800(ra) # 8000053c <panic>

0000000080003864 <iunlock>:
{
    80003864:	1101                	addi	sp,sp,-32
    80003866:	ec06                	sd	ra,24(sp)
    80003868:	e822                	sd	s0,16(sp)
    8000386a:	e426                	sd	s1,8(sp)
    8000386c:	e04a                	sd	s2,0(sp)
    8000386e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003870:	c905                	beqz	a0,800038a0 <iunlock+0x3c>
    80003872:	84aa                	mv	s1,a0
    80003874:	01050913          	addi	s2,a0,16
    80003878:	854a                	mv	a0,s2
    8000387a:	00001097          	auipc	ra,0x1
    8000387e:	c58080e7          	jalr	-936(ra) # 800044d2 <holdingsleep>
    80003882:	cd19                	beqz	a0,800038a0 <iunlock+0x3c>
    80003884:	449c                	lw	a5,8(s1)
    80003886:	00f05d63          	blez	a5,800038a0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000388a:	854a                	mv	a0,s2
    8000388c:	00001097          	auipc	ra,0x1
    80003890:	c02080e7          	jalr	-1022(ra) # 8000448e <releasesleep>
}
    80003894:	60e2                	ld	ra,24(sp)
    80003896:	6442                	ld	s0,16(sp)
    80003898:	64a2                	ld	s1,8(sp)
    8000389a:	6902                	ld	s2,0(sp)
    8000389c:	6105                	addi	sp,sp,32
    8000389e:	8082                	ret
    panic("iunlock");
    800038a0:	00005517          	auipc	a0,0x5
    800038a4:	d7050513          	addi	a0,a0,-656 # 80008610 <syscalls+0x198>
    800038a8:	ffffd097          	auipc	ra,0xffffd
    800038ac:	c94080e7          	jalr	-876(ra) # 8000053c <panic>

00000000800038b0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800038b0:	7179                	addi	sp,sp,-48
    800038b2:	f406                	sd	ra,40(sp)
    800038b4:	f022                	sd	s0,32(sp)
    800038b6:	ec26                	sd	s1,24(sp)
    800038b8:	e84a                	sd	s2,16(sp)
    800038ba:	e44e                	sd	s3,8(sp)
    800038bc:	e052                	sd	s4,0(sp)
    800038be:	1800                	addi	s0,sp,48
    800038c0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800038c2:	05050493          	addi	s1,a0,80
    800038c6:	08050913          	addi	s2,a0,128
    800038ca:	a021                	j	800038d2 <itrunc+0x22>
    800038cc:	0491                	addi	s1,s1,4
    800038ce:	01248d63          	beq	s1,s2,800038e8 <itrunc+0x38>
    if(ip->addrs[i]){
    800038d2:	408c                	lw	a1,0(s1)
    800038d4:	dde5                	beqz	a1,800038cc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800038d6:	0009a503          	lw	a0,0(s3)
    800038da:	00000097          	auipc	ra,0x0
    800038de:	8fc080e7          	jalr	-1796(ra) # 800031d6 <bfree>
      ip->addrs[i] = 0;
    800038e2:	0004a023          	sw	zero,0(s1)
    800038e6:	b7dd                	j	800038cc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800038e8:	0809a583          	lw	a1,128(s3)
    800038ec:	e185                	bnez	a1,8000390c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800038ee:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800038f2:	854e                	mv	a0,s3
    800038f4:	00000097          	auipc	ra,0x0
    800038f8:	de2080e7          	jalr	-542(ra) # 800036d6 <iupdate>
}
    800038fc:	70a2                	ld	ra,40(sp)
    800038fe:	7402                	ld	s0,32(sp)
    80003900:	64e2                	ld	s1,24(sp)
    80003902:	6942                	ld	s2,16(sp)
    80003904:	69a2                	ld	s3,8(sp)
    80003906:	6a02                	ld	s4,0(sp)
    80003908:	6145                	addi	sp,sp,48
    8000390a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000390c:	0009a503          	lw	a0,0(s3)
    80003910:	fffff097          	auipc	ra,0xfffff
    80003914:	682080e7          	jalr	1666(ra) # 80002f92 <bread>
    80003918:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000391a:	05850493          	addi	s1,a0,88
    8000391e:	45850913          	addi	s2,a0,1112
    80003922:	a021                	j	8000392a <itrunc+0x7a>
    80003924:	0491                	addi	s1,s1,4
    80003926:	01248b63          	beq	s1,s2,8000393c <itrunc+0x8c>
      if(a[j])
    8000392a:	408c                	lw	a1,0(s1)
    8000392c:	dde5                	beqz	a1,80003924 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    8000392e:	0009a503          	lw	a0,0(s3)
    80003932:	00000097          	auipc	ra,0x0
    80003936:	8a4080e7          	jalr	-1884(ra) # 800031d6 <bfree>
    8000393a:	b7ed                	j	80003924 <itrunc+0x74>
    brelse(bp);
    8000393c:	8552                	mv	a0,s4
    8000393e:	fffff097          	auipc	ra,0xfffff
    80003942:	784080e7          	jalr	1924(ra) # 800030c2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003946:	0809a583          	lw	a1,128(s3)
    8000394a:	0009a503          	lw	a0,0(s3)
    8000394e:	00000097          	auipc	ra,0x0
    80003952:	888080e7          	jalr	-1912(ra) # 800031d6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003956:	0809a023          	sw	zero,128(s3)
    8000395a:	bf51                	j	800038ee <itrunc+0x3e>

000000008000395c <iput>:
{
    8000395c:	1101                	addi	sp,sp,-32
    8000395e:	ec06                	sd	ra,24(sp)
    80003960:	e822                	sd	s0,16(sp)
    80003962:	e426                	sd	s1,8(sp)
    80003964:	e04a                	sd	s2,0(sp)
    80003966:	1000                	addi	s0,sp,32
    80003968:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000396a:	00193517          	auipc	a0,0x193
    8000396e:	cd650513          	addi	a0,a0,-810 # 80196640 <itable>
    80003972:	ffffd097          	auipc	ra,0xffffd
    80003976:	260080e7          	jalr	608(ra) # 80000bd2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000397a:	4498                	lw	a4,8(s1)
    8000397c:	4785                	li	a5,1
    8000397e:	02f70363          	beq	a4,a5,800039a4 <iput+0x48>
  ip->ref--;
    80003982:	449c                	lw	a5,8(s1)
    80003984:	37fd                	addiw	a5,a5,-1
    80003986:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003988:	00193517          	auipc	a0,0x193
    8000398c:	cb850513          	addi	a0,a0,-840 # 80196640 <itable>
    80003990:	ffffd097          	auipc	ra,0xffffd
    80003994:	2f6080e7          	jalr	758(ra) # 80000c86 <release>
}
    80003998:	60e2                	ld	ra,24(sp)
    8000399a:	6442                	ld	s0,16(sp)
    8000399c:	64a2                	ld	s1,8(sp)
    8000399e:	6902                	ld	s2,0(sp)
    800039a0:	6105                	addi	sp,sp,32
    800039a2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039a4:	40bc                	lw	a5,64(s1)
    800039a6:	dff1                	beqz	a5,80003982 <iput+0x26>
    800039a8:	04a49783          	lh	a5,74(s1)
    800039ac:	fbf9                	bnez	a5,80003982 <iput+0x26>
    acquiresleep(&ip->lock);
    800039ae:	01048913          	addi	s2,s1,16
    800039b2:	854a                	mv	a0,s2
    800039b4:	00001097          	auipc	ra,0x1
    800039b8:	a84080e7          	jalr	-1404(ra) # 80004438 <acquiresleep>
    release(&itable.lock);
    800039bc:	00193517          	auipc	a0,0x193
    800039c0:	c8450513          	addi	a0,a0,-892 # 80196640 <itable>
    800039c4:	ffffd097          	auipc	ra,0xffffd
    800039c8:	2c2080e7          	jalr	706(ra) # 80000c86 <release>
    itrunc(ip);
    800039cc:	8526                	mv	a0,s1
    800039ce:	00000097          	auipc	ra,0x0
    800039d2:	ee2080e7          	jalr	-286(ra) # 800038b0 <itrunc>
    ip->type = 0;
    800039d6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800039da:	8526                	mv	a0,s1
    800039dc:	00000097          	auipc	ra,0x0
    800039e0:	cfa080e7          	jalr	-774(ra) # 800036d6 <iupdate>
    ip->valid = 0;
    800039e4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800039e8:	854a                	mv	a0,s2
    800039ea:	00001097          	auipc	ra,0x1
    800039ee:	aa4080e7          	jalr	-1372(ra) # 8000448e <releasesleep>
    acquire(&itable.lock);
    800039f2:	00193517          	auipc	a0,0x193
    800039f6:	c4e50513          	addi	a0,a0,-946 # 80196640 <itable>
    800039fa:	ffffd097          	auipc	ra,0xffffd
    800039fe:	1d8080e7          	jalr	472(ra) # 80000bd2 <acquire>
    80003a02:	b741                	j	80003982 <iput+0x26>

0000000080003a04 <iunlockput>:
{
    80003a04:	1101                	addi	sp,sp,-32
    80003a06:	ec06                	sd	ra,24(sp)
    80003a08:	e822                	sd	s0,16(sp)
    80003a0a:	e426                	sd	s1,8(sp)
    80003a0c:	1000                	addi	s0,sp,32
    80003a0e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a10:	00000097          	auipc	ra,0x0
    80003a14:	e54080e7          	jalr	-428(ra) # 80003864 <iunlock>
  iput(ip);
    80003a18:	8526                	mv	a0,s1
    80003a1a:	00000097          	auipc	ra,0x0
    80003a1e:	f42080e7          	jalr	-190(ra) # 8000395c <iput>
}
    80003a22:	60e2                	ld	ra,24(sp)
    80003a24:	6442                	ld	s0,16(sp)
    80003a26:	64a2                	ld	s1,8(sp)
    80003a28:	6105                	addi	sp,sp,32
    80003a2a:	8082                	ret

0000000080003a2c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a2c:	1141                	addi	sp,sp,-16
    80003a2e:	e422                	sd	s0,8(sp)
    80003a30:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a32:	411c                	lw	a5,0(a0)
    80003a34:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a36:	415c                	lw	a5,4(a0)
    80003a38:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a3a:	04451783          	lh	a5,68(a0)
    80003a3e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a42:	04a51783          	lh	a5,74(a0)
    80003a46:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a4a:	04c56783          	lwu	a5,76(a0)
    80003a4e:	e99c                	sd	a5,16(a1)
}
    80003a50:	6422                	ld	s0,8(sp)
    80003a52:	0141                	addi	sp,sp,16
    80003a54:	8082                	ret

0000000080003a56 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a56:	457c                	lw	a5,76(a0)
    80003a58:	0ed7e963          	bltu	a5,a3,80003b4a <readi+0xf4>
{
    80003a5c:	7159                	addi	sp,sp,-112
    80003a5e:	f486                	sd	ra,104(sp)
    80003a60:	f0a2                	sd	s0,96(sp)
    80003a62:	eca6                	sd	s1,88(sp)
    80003a64:	e8ca                	sd	s2,80(sp)
    80003a66:	e4ce                	sd	s3,72(sp)
    80003a68:	e0d2                	sd	s4,64(sp)
    80003a6a:	fc56                	sd	s5,56(sp)
    80003a6c:	f85a                	sd	s6,48(sp)
    80003a6e:	f45e                	sd	s7,40(sp)
    80003a70:	f062                	sd	s8,32(sp)
    80003a72:	ec66                	sd	s9,24(sp)
    80003a74:	e86a                	sd	s10,16(sp)
    80003a76:	e46e                	sd	s11,8(sp)
    80003a78:	1880                	addi	s0,sp,112
    80003a7a:	8b2a                	mv	s6,a0
    80003a7c:	8bae                	mv	s7,a1
    80003a7e:	8a32                	mv	s4,a2
    80003a80:	84b6                	mv	s1,a3
    80003a82:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a84:	9f35                	addw	a4,a4,a3
    return 0;
    80003a86:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a88:	0ad76063          	bltu	a4,a3,80003b28 <readi+0xd2>
  if(off + n > ip->size)
    80003a8c:	00e7f463          	bgeu	a5,a4,80003a94 <readi+0x3e>
    n = ip->size - off;
    80003a90:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a94:	0a0a8963          	beqz	s5,80003b46 <readi+0xf0>
    80003a98:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a9a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a9e:	5c7d                	li	s8,-1
    80003aa0:	a82d                	j	80003ada <readi+0x84>
    80003aa2:	020d1d93          	slli	s11,s10,0x20
    80003aa6:	020ddd93          	srli	s11,s11,0x20
    80003aaa:	05890613          	addi	a2,s2,88
    80003aae:	86ee                	mv	a3,s11
    80003ab0:	963a                	add	a2,a2,a4
    80003ab2:	85d2                	mv	a1,s4
    80003ab4:	855e                	mv	a0,s7
    80003ab6:	fffff097          	auipc	ra,0xfffff
    80003aba:	afa080e7          	jalr	-1286(ra) # 800025b0 <either_copyout>
    80003abe:	05850d63          	beq	a0,s8,80003b18 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ac2:	854a                	mv	a0,s2
    80003ac4:	fffff097          	auipc	ra,0xfffff
    80003ac8:	5fe080e7          	jalr	1534(ra) # 800030c2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003acc:	013d09bb          	addw	s3,s10,s3
    80003ad0:	009d04bb          	addw	s1,s10,s1
    80003ad4:	9a6e                	add	s4,s4,s11
    80003ad6:	0559f763          	bgeu	s3,s5,80003b24 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003ada:	00a4d59b          	srliw	a1,s1,0xa
    80003ade:	855a                	mv	a0,s6
    80003ae0:	00000097          	auipc	ra,0x0
    80003ae4:	8a4080e7          	jalr	-1884(ra) # 80003384 <bmap>
    80003ae8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003aec:	cd85                	beqz	a1,80003b24 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003aee:	000b2503          	lw	a0,0(s6)
    80003af2:	fffff097          	auipc	ra,0xfffff
    80003af6:	4a0080e7          	jalr	1184(ra) # 80002f92 <bread>
    80003afa:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003afc:	3ff4f713          	andi	a4,s1,1023
    80003b00:	40ec87bb          	subw	a5,s9,a4
    80003b04:	413a86bb          	subw	a3,s5,s3
    80003b08:	8d3e                	mv	s10,a5
    80003b0a:	2781                	sext.w	a5,a5
    80003b0c:	0006861b          	sext.w	a2,a3
    80003b10:	f8f679e3          	bgeu	a2,a5,80003aa2 <readi+0x4c>
    80003b14:	8d36                	mv	s10,a3
    80003b16:	b771                	j	80003aa2 <readi+0x4c>
      brelse(bp);
    80003b18:	854a                	mv	a0,s2
    80003b1a:	fffff097          	auipc	ra,0xfffff
    80003b1e:	5a8080e7          	jalr	1448(ra) # 800030c2 <brelse>
      tot = -1;
    80003b22:	59fd                	li	s3,-1
  }
  return tot;
    80003b24:	0009851b          	sext.w	a0,s3
}
    80003b28:	70a6                	ld	ra,104(sp)
    80003b2a:	7406                	ld	s0,96(sp)
    80003b2c:	64e6                	ld	s1,88(sp)
    80003b2e:	6946                	ld	s2,80(sp)
    80003b30:	69a6                	ld	s3,72(sp)
    80003b32:	6a06                	ld	s4,64(sp)
    80003b34:	7ae2                	ld	s5,56(sp)
    80003b36:	7b42                	ld	s6,48(sp)
    80003b38:	7ba2                	ld	s7,40(sp)
    80003b3a:	7c02                	ld	s8,32(sp)
    80003b3c:	6ce2                	ld	s9,24(sp)
    80003b3e:	6d42                	ld	s10,16(sp)
    80003b40:	6da2                	ld	s11,8(sp)
    80003b42:	6165                	addi	sp,sp,112
    80003b44:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b46:	89d6                	mv	s3,s5
    80003b48:	bff1                	j	80003b24 <readi+0xce>
    return 0;
    80003b4a:	4501                	li	a0,0
}
    80003b4c:	8082                	ret

0000000080003b4e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b4e:	457c                	lw	a5,76(a0)
    80003b50:	10d7e863          	bltu	a5,a3,80003c60 <writei+0x112>
{
    80003b54:	7159                	addi	sp,sp,-112
    80003b56:	f486                	sd	ra,104(sp)
    80003b58:	f0a2                	sd	s0,96(sp)
    80003b5a:	eca6                	sd	s1,88(sp)
    80003b5c:	e8ca                	sd	s2,80(sp)
    80003b5e:	e4ce                	sd	s3,72(sp)
    80003b60:	e0d2                	sd	s4,64(sp)
    80003b62:	fc56                	sd	s5,56(sp)
    80003b64:	f85a                	sd	s6,48(sp)
    80003b66:	f45e                	sd	s7,40(sp)
    80003b68:	f062                	sd	s8,32(sp)
    80003b6a:	ec66                	sd	s9,24(sp)
    80003b6c:	e86a                	sd	s10,16(sp)
    80003b6e:	e46e                	sd	s11,8(sp)
    80003b70:	1880                	addi	s0,sp,112
    80003b72:	8aaa                	mv	s5,a0
    80003b74:	8bae                	mv	s7,a1
    80003b76:	8a32                	mv	s4,a2
    80003b78:	8936                	mv	s2,a3
    80003b7a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b7c:	00e687bb          	addw	a5,a3,a4
    80003b80:	0ed7e263          	bltu	a5,a3,80003c64 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b84:	00043737          	lui	a4,0x43
    80003b88:	0ef76063          	bltu	a4,a5,80003c68 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b8c:	0c0b0863          	beqz	s6,80003c5c <writei+0x10e>
    80003b90:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b92:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b96:	5c7d                	li	s8,-1
    80003b98:	a091                	j	80003bdc <writei+0x8e>
    80003b9a:	020d1d93          	slli	s11,s10,0x20
    80003b9e:	020ddd93          	srli	s11,s11,0x20
    80003ba2:	05848513          	addi	a0,s1,88
    80003ba6:	86ee                	mv	a3,s11
    80003ba8:	8652                	mv	a2,s4
    80003baa:	85de                	mv	a1,s7
    80003bac:	953a                	add	a0,a0,a4
    80003bae:	fffff097          	auipc	ra,0xfffff
    80003bb2:	a58080e7          	jalr	-1448(ra) # 80002606 <either_copyin>
    80003bb6:	07850263          	beq	a0,s8,80003c1a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003bba:	8526                	mv	a0,s1
    80003bbc:	00000097          	auipc	ra,0x0
    80003bc0:	75e080e7          	jalr	1886(ra) # 8000431a <log_write>
    brelse(bp);
    80003bc4:	8526                	mv	a0,s1
    80003bc6:	fffff097          	auipc	ra,0xfffff
    80003bca:	4fc080e7          	jalr	1276(ra) # 800030c2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bce:	013d09bb          	addw	s3,s10,s3
    80003bd2:	012d093b          	addw	s2,s10,s2
    80003bd6:	9a6e                	add	s4,s4,s11
    80003bd8:	0569f663          	bgeu	s3,s6,80003c24 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003bdc:	00a9559b          	srliw	a1,s2,0xa
    80003be0:	8556                	mv	a0,s5
    80003be2:	fffff097          	auipc	ra,0xfffff
    80003be6:	7a2080e7          	jalr	1954(ra) # 80003384 <bmap>
    80003bea:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003bee:	c99d                	beqz	a1,80003c24 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003bf0:	000aa503          	lw	a0,0(s5)
    80003bf4:	fffff097          	auipc	ra,0xfffff
    80003bf8:	39e080e7          	jalr	926(ra) # 80002f92 <bread>
    80003bfc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bfe:	3ff97713          	andi	a4,s2,1023
    80003c02:	40ec87bb          	subw	a5,s9,a4
    80003c06:	413b06bb          	subw	a3,s6,s3
    80003c0a:	8d3e                	mv	s10,a5
    80003c0c:	2781                	sext.w	a5,a5
    80003c0e:	0006861b          	sext.w	a2,a3
    80003c12:	f8f674e3          	bgeu	a2,a5,80003b9a <writei+0x4c>
    80003c16:	8d36                	mv	s10,a3
    80003c18:	b749                	j	80003b9a <writei+0x4c>
      brelse(bp);
    80003c1a:	8526                	mv	a0,s1
    80003c1c:	fffff097          	auipc	ra,0xfffff
    80003c20:	4a6080e7          	jalr	1190(ra) # 800030c2 <brelse>
  }

  if(off > ip->size)
    80003c24:	04caa783          	lw	a5,76(s5)
    80003c28:	0127f463          	bgeu	a5,s2,80003c30 <writei+0xe2>
    ip->size = off;
    80003c2c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c30:	8556                	mv	a0,s5
    80003c32:	00000097          	auipc	ra,0x0
    80003c36:	aa4080e7          	jalr	-1372(ra) # 800036d6 <iupdate>

  return tot;
    80003c3a:	0009851b          	sext.w	a0,s3
}
    80003c3e:	70a6                	ld	ra,104(sp)
    80003c40:	7406                	ld	s0,96(sp)
    80003c42:	64e6                	ld	s1,88(sp)
    80003c44:	6946                	ld	s2,80(sp)
    80003c46:	69a6                	ld	s3,72(sp)
    80003c48:	6a06                	ld	s4,64(sp)
    80003c4a:	7ae2                	ld	s5,56(sp)
    80003c4c:	7b42                	ld	s6,48(sp)
    80003c4e:	7ba2                	ld	s7,40(sp)
    80003c50:	7c02                	ld	s8,32(sp)
    80003c52:	6ce2                	ld	s9,24(sp)
    80003c54:	6d42                	ld	s10,16(sp)
    80003c56:	6da2                	ld	s11,8(sp)
    80003c58:	6165                	addi	sp,sp,112
    80003c5a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c5c:	89da                	mv	s3,s6
    80003c5e:	bfc9                	j	80003c30 <writei+0xe2>
    return -1;
    80003c60:	557d                	li	a0,-1
}
    80003c62:	8082                	ret
    return -1;
    80003c64:	557d                	li	a0,-1
    80003c66:	bfe1                	j	80003c3e <writei+0xf0>
    return -1;
    80003c68:	557d                	li	a0,-1
    80003c6a:	bfd1                	j	80003c3e <writei+0xf0>

0000000080003c6c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c6c:	1141                	addi	sp,sp,-16
    80003c6e:	e406                	sd	ra,8(sp)
    80003c70:	e022                	sd	s0,0(sp)
    80003c72:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c74:	4639                	li	a2,14
    80003c76:	ffffd097          	auipc	ra,0xffffd
    80003c7a:	128080e7          	jalr	296(ra) # 80000d9e <strncmp>
}
    80003c7e:	60a2                	ld	ra,8(sp)
    80003c80:	6402                	ld	s0,0(sp)
    80003c82:	0141                	addi	sp,sp,16
    80003c84:	8082                	ret

0000000080003c86 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c86:	7139                	addi	sp,sp,-64
    80003c88:	fc06                	sd	ra,56(sp)
    80003c8a:	f822                	sd	s0,48(sp)
    80003c8c:	f426                	sd	s1,40(sp)
    80003c8e:	f04a                	sd	s2,32(sp)
    80003c90:	ec4e                	sd	s3,24(sp)
    80003c92:	e852                	sd	s4,16(sp)
    80003c94:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c96:	04451703          	lh	a4,68(a0)
    80003c9a:	4785                	li	a5,1
    80003c9c:	00f71a63          	bne	a4,a5,80003cb0 <dirlookup+0x2a>
    80003ca0:	892a                	mv	s2,a0
    80003ca2:	89ae                	mv	s3,a1
    80003ca4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ca6:	457c                	lw	a5,76(a0)
    80003ca8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003caa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cac:	e79d                	bnez	a5,80003cda <dirlookup+0x54>
    80003cae:	a8a5                	j	80003d26 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003cb0:	00005517          	auipc	a0,0x5
    80003cb4:	96850513          	addi	a0,a0,-1688 # 80008618 <syscalls+0x1a0>
    80003cb8:	ffffd097          	auipc	ra,0xffffd
    80003cbc:	884080e7          	jalr	-1916(ra) # 8000053c <panic>
      panic("dirlookup read");
    80003cc0:	00005517          	auipc	a0,0x5
    80003cc4:	97050513          	addi	a0,a0,-1680 # 80008630 <syscalls+0x1b8>
    80003cc8:	ffffd097          	auipc	ra,0xffffd
    80003ccc:	874080e7          	jalr	-1932(ra) # 8000053c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cd0:	24c1                	addiw	s1,s1,16
    80003cd2:	04c92783          	lw	a5,76(s2)
    80003cd6:	04f4f763          	bgeu	s1,a5,80003d24 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cda:	4741                	li	a4,16
    80003cdc:	86a6                	mv	a3,s1
    80003cde:	fc040613          	addi	a2,s0,-64
    80003ce2:	4581                	li	a1,0
    80003ce4:	854a                	mv	a0,s2
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	d70080e7          	jalr	-656(ra) # 80003a56 <readi>
    80003cee:	47c1                	li	a5,16
    80003cf0:	fcf518e3          	bne	a0,a5,80003cc0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003cf4:	fc045783          	lhu	a5,-64(s0)
    80003cf8:	dfe1                	beqz	a5,80003cd0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003cfa:	fc240593          	addi	a1,s0,-62
    80003cfe:	854e                	mv	a0,s3
    80003d00:	00000097          	auipc	ra,0x0
    80003d04:	f6c080e7          	jalr	-148(ra) # 80003c6c <namecmp>
    80003d08:	f561                	bnez	a0,80003cd0 <dirlookup+0x4a>
      if(poff)
    80003d0a:	000a0463          	beqz	s4,80003d12 <dirlookup+0x8c>
        *poff = off;
    80003d0e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d12:	fc045583          	lhu	a1,-64(s0)
    80003d16:	00092503          	lw	a0,0(s2)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	754080e7          	jalr	1876(ra) # 8000346e <iget>
    80003d22:	a011                	j	80003d26 <dirlookup+0xa0>
  return 0;
    80003d24:	4501                	li	a0,0
}
    80003d26:	70e2                	ld	ra,56(sp)
    80003d28:	7442                	ld	s0,48(sp)
    80003d2a:	74a2                	ld	s1,40(sp)
    80003d2c:	7902                	ld	s2,32(sp)
    80003d2e:	69e2                	ld	s3,24(sp)
    80003d30:	6a42                	ld	s4,16(sp)
    80003d32:	6121                	addi	sp,sp,64
    80003d34:	8082                	ret

0000000080003d36 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d36:	711d                	addi	sp,sp,-96
    80003d38:	ec86                	sd	ra,88(sp)
    80003d3a:	e8a2                	sd	s0,80(sp)
    80003d3c:	e4a6                	sd	s1,72(sp)
    80003d3e:	e0ca                	sd	s2,64(sp)
    80003d40:	fc4e                	sd	s3,56(sp)
    80003d42:	f852                	sd	s4,48(sp)
    80003d44:	f456                	sd	s5,40(sp)
    80003d46:	f05a                	sd	s6,32(sp)
    80003d48:	ec5e                	sd	s7,24(sp)
    80003d4a:	e862                	sd	s8,16(sp)
    80003d4c:	e466                	sd	s9,8(sp)
    80003d4e:	1080                	addi	s0,sp,96
    80003d50:	84aa                	mv	s1,a0
    80003d52:	8b2e                	mv	s6,a1
    80003d54:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d56:	00054703          	lbu	a4,0(a0)
    80003d5a:	02f00793          	li	a5,47
    80003d5e:	02f70263          	beq	a4,a5,80003d82 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d62:	ffffe097          	auipc	ra,0xffffe
    80003d66:	c80080e7          	jalr	-896(ra) # 800019e2 <myproc>
    80003d6a:	15053503          	ld	a0,336(a0)
    80003d6e:	00000097          	auipc	ra,0x0
    80003d72:	9f6080e7          	jalr	-1546(ra) # 80003764 <idup>
    80003d76:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d78:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d7c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d7e:	4b85                	li	s7,1
    80003d80:	a875                	j	80003e3c <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003d82:	4585                	li	a1,1
    80003d84:	4505                	li	a0,1
    80003d86:	fffff097          	auipc	ra,0xfffff
    80003d8a:	6e8080e7          	jalr	1768(ra) # 8000346e <iget>
    80003d8e:	8a2a                	mv	s4,a0
    80003d90:	b7e5                	j	80003d78 <namex+0x42>
      iunlockput(ip);
    80003d92:	8552                	mv	a0,s4
    80003d94:	00000097          	auipc	ra,0x0
    80003d98:	c70080e7          	jalr	-912(ra) # 80003a04 <iunlockput>
      return 0;
    80003d9c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d9e:	8552                	mv	a0,s4
    80003da0:	60e6                	ld	ra,88(sp)
    80003da2:	6446                	ld	s0,80(sp)
    80003da4:	64a6                	ld	s1,72(sp)
    80003da6:	6906                	ld	s2,64(sp)
    80003da8:	79e2                	ld	s3,56(sp)
    80003daa:	7a42                	ld	s4,48(sp)
    80003dac:	7aa2                	ld	s5,40(sp)
    80003dae:	7b02                	ld	s6,32(sp)
    80003db0:	6be2                	ld	s7,24(sp)
    80003db2:	6c42                	ld	s8,16(sp)
    80003db4:	6ca2                	ld	s9,8(sp)
    80003db6:	6125                	addi	sp,sp,96
    80003db8:	8082                	ret
      iunlock(ip);
    80003dba:	8552                	mv	a0,s4
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	aa8080e7          	jalr	-1368(ra) # 80003864 <iunlock>
      return ip;
    80003dc4:	bfe9                	j	80003d9e <namex+0x68>
      iunlockput(ip);
    80003dc6:	8552                	mv	a0,s4
    80003dc8:	00000097          	auipc	ra,0x0
    80003dcc:	c3c080e7          	jalr	-964(ra) # 80003a04 <iunlockput>
      return 0;
    80003dd0:	8a4e                	mv	s4,s3
    80003dd2:	b7f1                	j	80003d9e <namex+0x68>
  len = path - s;
    80003dd4:	40998633          	sub	a2,s3,s1
    80003dd8:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003ddc:	099c5863          	bge	s8,s9,80003e6c <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003de0:	4639                	li	a2,14
    80003de2:	85a6                	mv	a1,s1
    80003de4:	8556                	mv	a0,s5
    80003de6:	ffffd097          	auipc	ra,0xffffd
    80003dea:	f44080e7          	jalr	-188(ra) # 80000d2a <memmove>
    80003dee:	84ce                	mv	s1,s3
  while(*path == '/')
    80003df0:	0004c783          	lbu	a5,0(s1)
    80003df4:	01279763          	bne	a5,s2,80003e02 <namex+0xcc>
    path++;
    80003df8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003dfa:	0004c783          	lbu	a5,0(s1)
    80003dfe:	ff278de3          	beq	a5,s2,80003df8 <namex+0xc2>
    ilock(ip);
    80003e02:	8552                	mv	a0,s4
    80003e04:	00000097          	auipc	ra,0x0
    80003e08:	99e080e7          	jalr	-1634(ra) # 800037a2 <ilock>
    if(ip->type != T_DIR){
    80003e0c:	044a1783          	lh	a5,68(s4)
    80003e10:	f97791e3          	bne	a5,s7,80003d92 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003e14:	000b0563          	beqz	s6,80003e1e <namex+0xe8>
    80003e18:	0004c783          	lbu	a5,0(s1)
    80003e1c:	dfd9                	beqz	a5,80003dba <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e1e:	4601                	li	a2,0
    80003e20:	85d6                	mv	a1,s5
    80003e22:	8552                	mv	a0,s4
    80003e24:	00000097          	auipc	ra,0x0
    80003e28:	e62080e7          	jalr	-414(ra) # 80003c86 <dirlookup>
    80003e2c:	89aa                	mv	s3,a0
    80003e2e:	dd41                	beqz	a0,80003dc6 <namex+0x90>
    iunlockput(ip);
    80003e30:	8552                	mv	a0,s4
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	bd2080e7          	jalr	-1070(ra) # 80003a04 <iunlockput>
    ip = next;
    80003e3a:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e3c:	0004c783          	lbu	a5,0(s1)
    80003e40:	01279763          	bne	a5,s2,80003e4e <namex+0x118>
    path++;
    80003e44:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e46:	0004c783          	lbu	a5,0(s1)
    80003e4a:	ff278de3          	beq	a5,s2,80003e44 <namex+0x10e>
  if(*path == 0)
    80003e4e:	cb9d                	beqz	a5,80003e84 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003e50:	0004c783          	lbu	a5,0(s1)
    80003e54:	89a6                	mv	s3,s1
  len = path - s;
    80003e56:	4c81                	li	s9,0
    80003e58:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e5a:	01278963          	beq	a5,s2,80003e6c <namex+0x136>
    80003e5e:	dbbd                	beqz	a5,80003dd4 <namex+0x9e>
    path++;
    80003e60:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e62:	0009c783          	lbu	a5,0(s3)
    80003e66:	ff279ce3          	bne	a5,s2,80003e5e <namex+0x128>
    80003e6a:	b7ad                	j	80003dd4 <namex+0x9e>
    memmove(name, s, len);
    80003e6c:	2601                	sext.w	a2,a2
    80003e6e:	85a6                	mv	a1,s1
    80003e70:	8556                	mv	a0,s5
    80003e72:	ffffd097          	auipc	ra,0xffffd
    80003e76:	eb8080e7          	jalr	-328(ra) # 80000d2a <memmove>
    name[len] = 0;
    80003e7a:	9cd6                	add	s9,s9,s5
    80003e7c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e80:	84ce                	mv	s1,s3
    80003e82:	b7bd                	j	80003df0 <namex+0xba>
  if(nameiparent){
    80003e84:	f00b0de3          	beqz	s6,80003d9e <namex+0x68>
    iput(ip);
    80003e88:	8552                	mv	a0,s4
    80003e8a:	00000097          	auipc	ra,0x0
    80003e8e:	ad2080e7          	jalr	-1326(ra) # 8000395c <iput>
    return 0;
    80003e92:	4a01                	li	s4,0
    80003e94:	b729                	j	80003d9e <namex+0x68>

0000000080003e96 <dirlink>:
{
    80003e96:	7139                	addi	sp,sp,-64
    80003e98:	fc06                	sd	ra,56(sp)
    80003e9a:	f822                	sd	s0,48(sp)
    80003e9c:	f426                	sd	s1,40(sp)
    80003e9e:	f04a                	sd	s2,32(sp)
    80003ea0:	ec4e                	sd	s3,24(sp)
    80003ea2:	e852                	sd	s4,16(sp)
    80003ea4:	0080                	addi	s0,sp,64
    80003ea6:	892a                	mv	s2,a0
    80003ea8:	8a2e                	mv	s4,a1
    80003eaa:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003eac:	4601                	li	a2,0
    80003eae:	00000097          	auipc	ra,0x0
    80003eb2:	dd8080e7          	jalr	-552(ra) # 80003c86 <dirlookup>
    80003eb6:	e93d                	bnez	a0,80003f2c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003eb8:	04c92483          	lw	s1,76(s2)
    80003ebc:	c49d                	beqz	s1,80003eea <dirlink+0x54>
    80003ebe:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ec0:	4741                	li	a4,16
    80003ec2:	86a6                	mv	a3,s1
    80003ec4:	fc040613          	addi	a2,s0,-64
    80003ec8:	4581                	li	a1,0
    80003eca:	854a                	mv	a0,s2
    80003ecc:	00000097          	auipc	ra,0x0
    80003ed0:	b8a080e7          	jalr	-1142(ra) # 80003a56 <readi>
    80003ed4:	47c1                	li	a5,16
    80003ed6:	06f51163          	bne	a0,a5,80003f38 <dirlink+0xa2>
    if(de.inum == 0)
    80003eda:	fc045783          	lhu	a5,-64(s0)
    80003ede:	c791                	beqz	a5,80003eea <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ee0:	24c1                	addiw	s1,s1,16
    80003ee2:	04c92783          	lw	a5,76(s2)
    80003ee6:	fcf4ede3          	bltu	s1,a5,80003ec0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003eea:	4639                	li	a2,14
    80003eec:	85d2                	mv	a1,s4
    80003eee:	fc240513          	addi	a0,s0,-62
    80003ef2:	ffffd097          	auipc	ra,0xffffd
    80003ef6:	ee8080e7          	jalr	-280(ra) # 80000dda <strncpy>
  de.inum = inum;
    80003efa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003efe:	4741                	li	a4,16
    80003f00:	86a6                	mv	a3,s1
    80003f02:	fc040613          	addi	a2,s0,-64
    80003f06:	4581                	li	a1,0
    80003f08:	854a                	mv	a0,s2
    80003f0a:	00000097          	auipc	ra,0x0
    80003f0e:	c44080e7          	jalr	-956(ra) # 80003b4e <writei>
    80003f12:	1541                	addi	a0,a0,-16
    80003f14:	00a03533          	snez	a0,a0
    80003f18:	40a00533          	neg	a0,a0
}
    80003f1c:	70e2                	ld	ra,56(sp)
    80003f1e:	7442                	ld	s0,48(sp)
    80003f20:	74a2                	ld	s1,40(sp)
    80003f22:	7902                	ld	s2,32(sp)
    80003f24:	69e2                	ld	s3,24(sp)
    80003f26:	6a42                	ld	s4,16(sp)
    80003f28:	6121                	addi	sp,sp,64
    80003f2a:	8082                	ret
    iput(ip);
    80003f2c:	00000097          	auipc	ra,0x0
    80003f30:	a30080e7          	jalr	-1488(ra) # 8000395c <iput>
    return -1;
    80003f34:	557d                	li	a0,-1
    80003f36:	b7dd                	j	80003f1c <dirlink+0x86>
      panic("dirlink read");
    80003f38:	00004517          	auipc	a0,0x4
    80003f3c:	70850513          	addi	a0,a0,1800 # 80008640 <syscalls+0x1c8>
    80003f40:	ffffc097          	auipc	ra,0xffffc
    80003f44:	5fc080e7          	jalr	1532(ra) # 8000053c <panic>

0000000080003f48 <namei>:

struct inode*
namei(char *path)
{
    80003f48:	1101                	addi	sp,sp,-32
    80003f4a:	ec06                	sd	ra,24(sp)
    80003f4c:	e822                	sd	s0,16(sp)
    80003f4e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f50:	fe040613          	addi	a2,s0,-32
    80003f54:	4581                	li	a1,0
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	de0080e7          	jalr	-544(ra) # 80003d36 <namex>
}
    80003f5e:	60e2                	ld	ra,24(sp)
    80003f60:	6442                	ld	s0,16(sp)
    80003f62:	6105                	addi	sp,sp,32
    80003f64:	8082                	ret

0000000080003f66 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f66:	1141                	addi	sp,sp,-16
    80003f68:	e406                	sd	ra,8(sp)
    80003f6a:	e022                	sd	s0,0(sp)
    80003f6c:	0800                	addi	s0,sp,16
    80003f6e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f70:	4585                	li	a1,1
    80003f72:	00000097          	auipc	ra,0x0
    80003f76:	dc4080e7          	jalr	-572(ra) # 80003d36 <namex>
}
    80003f7a:	60a2                	ld	ra,8(sp)
    80003f7c:	6402                	ld	s0,0(sp)
    80003f7e:	0141                	addi	sp,sp,16
    80003f80:	8082                	ret

0000000080003f82 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f82:	1101                	addi	sp,sp,-32
    80003f84:	ec06                	sd	ra,24(sp)
    80003f86:	e822                	sd	s0,16(sp)
    80003f88:	e426                	sd	s1,8(sp)
    80003f8a:	e04a                	sd	s2,0(sp)
    80003f8c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f8e:	00194917          	auipc	s2,0x194
    80003f92:	15a90913          	addi	s2,s2,346 # 801980e8 <log>
    80003f96:	01892583          	lw	a1,24(s2)
    80003f9a:	02892503          	lw	a0,40(s2)
    80003f9e:	fffff097          	auipc	ra,0xfffff
    80003fa2:	ff4080e7          	jalr	-12(ra) # 80002f92 <bread>
    80003fa6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003fa8:	02c92603          	lw	a2,44(s2)
    80003fac:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003fae:	00c05f63          	blez	a2,80003fcc <write_head+0x4a>
    80003fb2:	00194717          	auipc	a4,0x194
    80003fb6:	16670713          	addi	a4,a4,358 # 80198118 <log+0x30>
    80003fba:	87aa                	mv	a5,a0
    80003fbc:	060a                	slli	a2,a2,0x2
    80003fbe:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003fc0:	4314                	lw	a3,0(a4)
    80003fc2:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003fc4:	0711                	addi	a4,a4,4
    80003fc6:	0791                	addi	a5,a5,4
    80003fc8:	fec79ce3          	bne	a5,a2,80003fc0 <write_head+0x3e>
  }
  bwrite(buf);
    80003fcc:	8526                	mv	a0,s1
    80003fce:	fffff097          	auipc	ra,0xfffff
    80003fd2:	0b6080e7          	jalr	182(ra) # 80003084 <bwrite>
  brelse(buf);
    80003fd6:	8526                	mv	a0,s1
    80003fd8:	fffff097          	auipc	ra,0xfffff
    80003fdc:	0ea080e7          	jalr	234(ra) # 800030c2 <brelse>
}
    80003fe0:	60e2                	ld	ra,24(sp)
    80003fe2:	6442                	ld	s0,16(sp)
    80003fe4:	64a2                	ld	s1,8(sp)
    80003fe6:	6902                	ld	s2,0(sp)
    80003fe8:	6105                	addi	sp,sp,32
    80003fea:	8082                	ret

0000000080003fec <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fec:	00194797          	auipc	a5,0x194
    80003ff0:	1287a783          	lw	a5,296(a5) # 80198114 <log+0x2c>
    80003ff4:	0af05d63          	blez	a5,800040ae <install_trans+0xc2>
{
    80003ff8:	7139                	addi	sp,sp,-64
    80003ffa:	fc06                	sd	ra,56(sp)
    80003ffc:	f822                	sd	s0,48(sp)
    80003ffe:	f426                	sd	s1,40(sp)
    80004000:	f04a                	sd	s2,32(sp)
    80004002:	ec4e                	sd	s3,24(sp)
    80004004:	e852                	sd	s4,16(sp)
    80004006:	e456                	sd	s5,8(sp)
    80004008:	e05a                	sd	s6,0(sp)
    8000400a:	0080                	addi	s0,sp,64
    8000400c:	8b2a                	mv	s6,a0
    8000400e:	00194a97          	auipc	s5,0x194
    80004012:	10aa8a93          	addi	s5,s5,266 # 80198118 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004016:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004018:	00194997          	auipc	s3,0x194
    8000401c:	0d098993          	addi	s3,s3,208 # 801980e8 <log>
    80004020:	a00d                	j	80004042 <install_trans+0x56>
    brelse(lbuf);
    80004022:	854a                	mv	a0,s2
    80004024:	fffff097          	auipc	ra,0xfffff
    80004028:	09e080e7          	jalr	158(ra) # 800030c2 <brelse>
    brelse(dbuf);
    8000402c:	8526                	mv	a0,s1
    8000402e:	fffff097          	auipc	ra,0xfffff
    80004032:	094080e7          	jalr	148(ra) # 800030c2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004036:	2a05                	addiw	s4,s4,1
    80004038:	0a91                	addi	s5,s5,4
    8000403a:	02c9a783          	lw	a5,44(s3)
    8000403e:	04fa5e63          	bge	s4,a5,8000409a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004042:	0189a583          	lw	a1,24(s3)
    80004046:	014585bb          	addw	a1,a1,s4
    8000404a:	2585                	addiw	a1,a1,1
    8000404c:	0289a503          	lw	a0,40(s3)
    80004050:	fffff097          	auipc	ra,0xfffff
    80004054:	f42080e7          	jalr	-190(ra) # 80002f92 <bread>
    80004058:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000405a:	000aa583          	lw	a1,0(s5)
    8000405e:	0289a503          	lw	a0,40(s3)
    80004062:	fffff097          	auipc	ra,0xfffff
    80004066:	f30080e7          	jalr	-208(ra) # 80002f92 <bread>
    8000406a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000406c:	40000613          	li	a2,1024
    80004070:	05890593          	addi	a1,s2,88
    80004074:	05850513          	addi	a0,a0,88
    80004078:	ffffd097          	auipc	ra,0xffffd
    8000407c:	cb2080e7          	jalr	-846(ra) # 80000d2a <memmove>
    bwrite(dbuf);  // write dst to disk
    80004080:	8526                	mv	a0,s1
    80004082:	fffff097          	auipc	ra,0xfffff
    80004086:	002080e7          	jalr	2(ra) # 80003084 <bwrite>
    if(recovering == 0)
    8000408a:	f80b1ce3          	bnez	s6,80004022 <install_trans+0x36>
      bunpin(dbuf);
    8000408e:	8526                	mv	a0,s1
    80004090:	fffff097          	auipc	ra,0xfffff
    80004094:	10a080e7          	jalr	266(ra) # 8000319a <bunpin>
    80004098:	b769                	j	80004022 <install_trans+0x36>
}
    8000409a:	70e2                	ld	ra,56(sp)
    8000409c:	7442                	ld	s0,48(sp)
    8000409e:	74a2                	ld	s1,40(sp)
    800040a0:	7902                	ld	s2,32(sp)
    800040a2:	69e2                	ld	s3,24(sp)
    800040a4:	6a42                	ld	s4,16(sp)
    800040a6:	6aa2                	ld	s5,8(sp)
    800040a8:	6b02                	ld	s6,0(sp)
    800040aa:	6121                	addi	sp,sp,64
    800040ac:	8082                	ret
    800040ae:	8082                	ret

00000000800040b0 <initlog>:
{
    800040b0:	7179                	addi	sp,sp,-48
    800040b2:	f406                	sd	ra,40(sp)
    800040b4:	f022                	sd	s0,32(sp)
    800040b6:	ec26                	sd	s1,24(sp)
    800040b8:	e84a                	sd	s2,16(sp)
    800040ba:	e44e                	sd	s3,8(sp)
    800040bc:	1800                	addi	s0,sp,48
    800040be:	892a                	mv	s2,a0
    800040c0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800040c2:	00194497          	auipc	s1,0x194
    800040c6:	02648493          	addi	s1,s1,38 # 801980e8 <log>
    800040ca:	00004597          	auipc	a1,0x4
    800040ce:	58658593          	addi	a1,a1,1414 # 80008650 <syscalls+0x1d8>
    800040d2:	8526                	mv	a0,s1
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	a6e080e7          	jalr	-1426(ra) # 80000b42 <initlock>
  log.start = sb->logstart;
    800040dc:	0149a583          	lw	a1,20(s3)
    800040e0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800040e2:	0109a783          	lw	a5,16(s3)
    800040e6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800040e8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800040ec:	854a                	mv	a0,s2
    800040ee:	fffff097          	auipc	ra,0xfffff
    800040f2:	ea4080e7          	jalr	-348(ra) # 80002f92 <bread>
  log.lh.n = lh->n;
    800040f6:	4d30                	lw	a2,88(a0)
    800040f8:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040fa:	00c05f63          	blez	a2,80004118 <initlog+0x68>
    800040fe:	87aa                	mv	a5,a0
    80004100:	00194717          	auipc	a4,0x194
    80004104:	01870713          	addi	a4,a4,24 # 80198118 <log+0x30>
    80004108:	060a                	slli	a2,a2,0x2
    8000410a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000410c:	4ff4                	lw	a3,92(a5)
    8000410e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004110:	0791                	addi	a5,a5,4
    80004112:	0711                	addi	a4,a4,4
    80004114:	fec79ce3          	bne	a5,a2,8000410c <initlog+0x5c>
  brelse(buf);
    80004118:	fffff097          	auipc	ra,0xfffff
    8000411c:	faa080e7          	jalr	-86(ra) # 800030c2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004120:	4505                	li	a0,1
    80004122:	00000097          	auipc	ra,0x0
    80004126:	eca080e7          	jalr	-310(ra) # 80003fec <install_trans>
  log.lh.n = 0;
    8000412a:	00194797          	auipc	a5,0x194
    8000412e:	fe07a523          	sw	zero,-22(a5) # 80198114 <log+0x2c>
  write_head(); // clear the log
    80004132:	00000097          	auipc	ra,0x0
    80004136:	e50080e7          	jalr	-432(ra) # 80003f82 <write_head>
}
    8000413a:	70a2                	ld	ra,40(sp)
    8000413c:	7402                	ld	s0,32(sp)
    8000413e:	64e2                	ld	s1,24(sp)
    80004140:	6942                	ld	s2,16(sp)
    80004142:	69a2                	ld	s3,8(sp)
    80004144:	6145                	addi	sp,sp,48
    80004146:	8082                	ret

0000000080004148 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004148:	1101                	addi	sp,sp,-32
    8000414a:	ec06                	sd	ra,24(sp)
    8000414c:	e822                	sd	s0,16(sp)
    8000414e:	e426                	sd	s1,8(sp)
    80004150:	e04a                	sd	s2,0(sp)
    80004152:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004154:	00194517          	auipc	a0,0x194
    80004158:	f9450513          	addi	a0,a0,-108 # 801980e8 <log>
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	a76080e7          	jalr	-1418(ra) # 80000bd2 <acquire>
  while(1){
    if(log.committing){
    80004164:	00194497          	auipc	s1,0x194
    80004168:	f8448493          	addi	s1,s1,-124 # 801980e8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000416c:	4979                	li	s2,30
    8000416e:	a039                	j	8000417c <begin_op+0x34>
      sleep(&log, &log.lock);
    80004170:	85a6                	mv	a1,s1
    80004172:	8526                	mv	a0,s1
    80004174:	ffffe097          	auipc	ra,0xffffe
    80004178:	020080e7          	jalr	32(ra) # 80002194 <sleep>
    if(log.committing){
    8000417c:	50dc                	lw	a5,36(s1)
    8000417e:	fbed                	bnez	a5,80004170 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004180:	5098                	lw	a4,32(s1)
    80004182:	2705                	addiw	a4,a4,1
    80004184:	0027179b          	slliw	a5,a4,0x2
    80004188:	9fb9                	addw	a5,a5,a4
    8000418a:	0017979b          	slliw	a5,a5,0x1
    8000418e:	54d4                	lw	a3,44(s1)
    80004190:	9fb5                	addw	a5,a5,a3
    80004192:	00f95963          	bge	s2,a5,800041a4 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004196:	85a6                	mv	a1,s1
    80004198:	8526                	mv	a0,s1
    8000419a:	ffffe097          	auipc	ra,0xffffe
    8000419e:	ffa080e7          	jalr	-6(ra) # 80002194 <sleep>
    800041a2:	bfe9                	j	8000417c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800041a4:	00194517          	auipc	a0,0x194
    800041a8:	f4450513          	addi	a0,a0,-188 # 801980e8 <log>
    800041ac:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800041ae:	ffffd097          	auipc	ra,0xffffd
    800041b2:	ad8080e7          	jalr	-1320(ra) # 80000c86 <release>
      break;
    }
  }
}
    800041b6:	60e2                	ld	ra,24(sp)
    800041b8:	6442                	ld	s0,16(sp)
    800041ba:	64a2                	ld	s1,8(sp)
    800041bc:	6902                	ld	s2,0(sp)
    800041be:	6105                	addi	sp,sp,32
    800041c0:	8082                	ret

00000000800041c2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800041c2:	7139                	addi	sp,sp,-64
    800041c4:	fc06                	sd	ra,56(sp)
    800041c6:	f822                	sd	s0,48(sp)
    800041c8:	f426                	sd	s1,40(sp)
    800041ca:	f04a                	sd	s2,32(sp)
    800041cc:	ec4e                	sd	s3,24(sp)
    800041ce:	e852                	sd	s4,16(sp)
    800041d0:	e456                	sd	s5,8(sp)
    800041d2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800041d4:	00194497          	auipc	s1,0x194
    800041d8:	f1448493          	addi	s1,s1,-236 # 801980e8 <log>
    800041dc:	8526                	mv	a0,s1
    800041de:	ffffd097          	auipc	ra,0xffffd
    800041e2:	9f4080e7          	jalr	-1548(ra) # 80000bd2 <acquire>
  log.outstanding -= 1;
    800041e6:	509c                	lw	a5,32(s1)
    800041e8:	37fd                	addiw	a5,a5,-1
    800041ea:	0007891b          	sext.w	s2,a5
    800041ee:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800041f0:	50dc                	lw	a5,36(s1)
    800041f2:	e7b9                	bnez	a5,80004240 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041f4:	04091e63          	bnez	s2,80004250 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800041f8:	00194497          	auipc	s1,0x194
    800041fc:	ef048493          	addi	s1,s1,-272 # 801980e8 <log>
    80004200:	4785                	li	a5,1
    80004202:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004204:	8526                	mv	a0,s1
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	a80080e7          	jalr	-1408(ra) # 80000c86 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000420e:	54dc                	lw	a5,44(s1)
    80004210:	06f04763          	bgtz	a5,8000427e <end_op+0xbc>
    acquire(&log.lock);
    80004214:	00194497          	auipc	s1,0x194
    80004218:	ed448493          	addi	s1,s1,-300 # 801980e8 <log>
    8000421c:	8526                	mv	a0,s1
    8000421e:	ffffd097          	auipc	ra,0xffffd
    80004222:	9b4080e7          	jalr	-1612(ra) # 80000bd2 <acquire>
    log.committing = 0;
    80004226:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000422a:	8526                	mv	a0,s1
    8000422c:	ffffe097          	auipc	ra,0xffffe
    80004230:	fcc080e7          	jalr	-52(ra) # 800021f8 <wakeup>
    release(&log.lock);
    80004234:	8526                	mv	a0,s1
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	a50080e7          	jalr	-1456(ra) # 80000c86 <release>
}
    8000423e:	a03d                	j	8000426c <end_op+0xaa>
    panic("log.committing");
    80004240:	00004517          	auipc	a0,0x4
    80004244:	41850513          	addi	a0,a0,1048 # 80008658 <syscalls+0x1e0>
    80004248:	ffffc097          	auipc	ra,0xffffc
    8000424c:	2f4080e7          	jalr	756(ra) # 8000053c <panic>
    wakeup(&log);
    80004250:	00194497          	auipc	s1,0x194
    80004254:	e9848493          	addi	s1,s1,-360 # 801980e8 <log>
    80004258:	8526                	mv	a0,s1
    8000425a:	ffffe097          	auipc	ra,0xffffe
    8000425e:	f9e080e7          	jalr	-98(ra) # 800021f8 <wakeup>
  release(&log.lock);
    80004262:	8526                	mv	a0,s1
    80004264:	ffffd097          	auipc	ra,0xffffd
    80004268:	a22080e7          	jalr	-1502(ra) # 80000c86 <release>
}
    8000426c:	70e2                	ld	ra,56(sp)
    8000426e:	7442                	ld	s0,48(sp)
    80004270:	74a2                	ld	s1,40(sp)
    80004272:	7902                	ld	s2,32(sp)
    80004274:	69e2                	ld	s3,24(sp)
    80004276:	6a42                	ld	s4,16(sp)
    80004278:	6aa2                	ld	s5,8(sp)
    8000427a:	6121                	addi	sp,sp,64
    8000427c:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000427e:	00194a97          	auipc	s5,0x194
    80004282:	e9aa8a93          	addi	s5,s5,-358 # 80198118 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004286:	00194a17          	auipc	s4,0x194
    8000428a:	e62a0a13          	addi	s4,s4,-414 # 801980e8 <log>
    8000428e:	018a2583          	lw	a1,24(s4)
    80004292:	012585bb          	addw	a1,a1,s2
    80004296:	2585                	addiw	a1,a1,1
    80004298:	028a2503          	lw	a0,40(s4)
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	cf6080e7          	jalr	-778(ra) # 80002f92 <bread>
    800042a4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800042a6:	000aa583          	lw	a1,0(s5)
    800042aa:	028a2503          	lw	a0,40(s4)
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	ce4080e7          	jalr	-796(ra) # 80002f92 <bread>
    800042b6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800042b8:	40000613          	li	a2,1024
    800042bc:	05850593          	addi	a1,a0,88
    800042c0:	05848513          	addi	a0,s1,88
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	a66080e7          	jalr	-1434(ra) # 80000d2a <memmove>
    bwrite(to);  // write the log
    800042cc:	8526                	mv	a0,s1
    800042ce:	fffff097          	auipc	ra,0xfffff
    800042d2:	db6080e7          	jalr	-586(ra) # 80003084 <bwrite>
    brelse(from);
    800042d6:	854e                	mv	a0,s3
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	dea080e7          	jalr	-534(ra) # 800030c2 <brelse>
    brelse(to);
    800042e0:	8526                	mv	a0,s1
    800042e2:	fffff097          	auipc	ra,0xfffff
    800042e6:	de0080e7          	jalr	-544(ra) # 800030c2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042ea:	2905                	addiw	s2,s2,1
    800042ec:	0a91                	addi	s5,s5,4
    800042ee:	02ca2783          	lw	a5,44(s4)
    800042f2:	f8f94ee3          	blt	s2,a5,8000428e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800042f6:	00000097          	auipc	ra,0x0
    800042fa:	c8c080e7          	jalr	-884(ra) # 80003f82 <write_head>
    install_trans(0); // Now install writes to home locations
    800042fe:	4501                	li	a0,0
    80004300:	00000097          	auipc	ra,0x0
    80004304:	cec080e7          	jalr	-788(ra) # 80003fec <install_trans>
    log.lh.n = 0;
    80004308:	00194797          	auipc	a5,0x194
    8000430c:	e007a623          	sw	zero,-500(a5) # 80198114 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004310:	00000097          	auipc	ra,0x0
    80004314:	c72080e7          	jalr	-910(ra) # 80003f82 <write_head>
    80004318:	bdf5                	j	80004214 <end_op+0x52>

000000008000431a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000431a:	1101                	addi	sp,sp,-32
    8000431c:	ec06                	sd	ra,24(sp)
    8000431e:	e822                	sd	s0,16(sp)
    80004320:	e426                	sd	s1,8(sp)
    80004322:	e04a                	sd	s2,0(sp)
    80004324:	1000                	addi	s0,sp,32
    80004326:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004328:	00194917          	auipc	s2,0x194
    8000432c:	dc090913          	addi	s2,s2,-576 # 801980e8 <log>
    80004330:	854a                	mv	a0,s2
    80004332:	ffffd097          	auipc	ra,0xffffd
    80004336:	8a0080e7          	jalr	-1888(ra) # 80000bd2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000433a:	02c92603          	lw	a2,44(s2)
    8000433e:	47f5                	li	a5,29
    80004340:	06c7c563          	blt	a5,a2,800043aa <log_write+0x90>
    80004344:	00194797          	auipc	a5,0x194
    80004348:	dc07a783          	lw	a5,-576(a5) # 80198104 <log+0x1c>
    8000434c:	37fd                	addiw	a5,a5,-1
    8000434e:	04f65e63          	bge	a2,a5,800043aa <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004352:	00194797          	auipc	a5,0x194
    80004356:	db67a783          	lw	a5,-586(a5) # 80198108 <log+0x20>
    8000435a:	06f05063          	blez	a5,800043ba <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000435e:	4781                	li	a5,0
    80004360:	06c05563          	blez	a2,800043ca <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004364:	44cc                	lw	a1,12(s1)
    80004366:	00194717          	auipc	a4,0x194
    8000436a:	db270713          	addi	a4,a4,-590 # 80198118 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000436e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004370:	4314                	lw	a3,0(a4)
    80004372:	04b68c63          	beq	a3,a1,800043ca <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004376:	2785                	addiw	a5,a5,1
    80004378:	0711                	addi	a4,a4,4
    8000437a:	fef61be3          	bne	a2,a5,80004370 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000437e:	0621                	addi	a2,a2,8
    80004380:	060a                	slli	a2,a2,0x2
    80004382:	00194797          	auipc	a5,0x194
    80004386:	d6678793          	addi	a5,a5,-666 # 801980e8 <log>
    8000438a:	97b2                	add	a5,a5,a2
    8000438c:	44d8                	lw	a4,12(s1)
    8000438e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004390:	8526                	mv	a0,s1
    80004392:	fffff097          	auipc	ra,0xfffff
    80004396:	dcc080e7          	jalr	-564(ra) # 8000315e <bpin>
    log.lh.n++;
    8000439a:	00194717          	auipc	a4,0x194
    8000439e:	d4e70713          	addi	a4,a4,-690 # 801980e8 <log>
    800043a2:	575c                	lw	a5,44(a4)
    800043a4:	2785                	addiw	a5,a5,1
    800043a6:	d75c                	sw	a5,44(a4)
    800043a8:	a82d                	j	800043e2 <log_write+0xc8>
    panic("too big a transaction");
    800043aa:	00004517          	auipc	a0,0x4
    800043ae:	2be50513          	addi	a0,a0,702 # 80008668 <syscalls+0x1f0>
    800043b2:	ffffc097          	auipc	ra,0xffffc
    800043b6:	18a080e7          	jalr	394(ra) # 8000053c <panic>
    panic("log_write outside of trans");
    800043ba:	00004517          	auipc	a0,0x4
    800043be:	2c650513          	addi	a0,a0,710 # 80008680 <syscalls+0x208>
    800043c2:	ffffc097          	auipc	ra,0xffffc
    800043c6:	17a080e7          	jalr	378(ra) # 8000053c <panic>
  log.lh.block[i] = b->blockno;
    800043ca:	00878693          	addi	a3,a5,8
    800043ce:	068a                	slli	a3,a3,0x2
    800043d0:	00194717          	auipc	a4,0x194
    800043d4:	d1870713          	addi	a4,a4,-744 # 801980e8 <log>
    800043d8:	9736                	add	a4,a4,a3
    800043da:	44d4                	lw	a3,12(s1)
    800043dc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800043de:	faf609e3          	beq	a2,a5,80004390 <log_write+0x76>
  }
  release(&log.lock);
    800043e2:	00194517          	auipc	a0,0x194
    800043e6:	d0650513          	addi	a0,a0,-762 # 801980e8 <log>
    800043ea:	ffffd097          	auipc	ra,0xffffd
    800043ee:	89c080e7          	jalr	-1892(ra) # 80000c86 <release>
}
    800043f2:	60e2                	ld	ra,24(sp)
    800043f4:	6442                	ld	s0,16(sp)
    800043f6:	64a2                	ld	s1,8(sp)
    800043f8:	6902                	ld	s2,0(sp)
    800043fa:	6105                	addi	sp,sp,32
    800043fc:	8082                	ret

00000000800043fe <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043fe:	1101                	addi	sp,sp,-32
    80004400:	ec06                	sd	ra,24(sp)
    80004402:	e822                	sd	s0,16(sp)
    80004404:	e426                	sd	s1,8(sp)
    80004406:	e04a                	sd	s2,0(sp)
    80004408:	1000                	addi	s0,sp,32
    8000440a:	84aa                	mv	s1,a0
    8000440c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000440e:	00004597          	auipc	a1,0x4
    80004412:	29258593          	addi	a1,a1,658 # 800086a0 <syscalls+0x228>
    80004416:	0521                	addi	a0,a0,8
    80004418:	ffffc097          	auipc	ra,0xffffc
    8000441c:	72a080e7          	jalr	1834(ra) # 80000b42 <initlock>
  lk->name = name;
    80004420:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004424:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004428:	0204a423          	sw	zero,40(s1)
}
    8000442c:	60e2                	ld	ra,24(sp)
    8000442e:	6442                	ld	s0,16(sp)
    80004430:	64a2                	ld	s1,8(sp)
    80004432:	6902                	ld	s2,0(sp)
    80004434:	6105                	addi	sp,sp,32
    80004436:	8082                	ret

0000000080004438 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004438:	1101                	addi	sp,sp,-32
    8000443a:	ec06                	sd	ra,24(sp)
    8000443c:	e822                	sd	s0,16(sp)
    8000443e:	e426                	sd	s1,8(sp)
    80004440:	e04a                	sd	s2,0(sp)
    80004442:	1000                	addi	s0,sp,32
    80004444:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004446:	00850913          	addi	s2,a0,8
    8000444a:	854a                	mv	a0,s2
    8000444c:	ffffc097          	auipc	ra,0xffffc
    80004450:	786080e7          	jalr	1926(ra) # 80000bd2 <acquire>
  while (lk->locked) {
    80004454:	409c                	lw	a5,0(s1)
    80004456:	cb89                	beqz	a5,80004468 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004458:	85ca                	mv	a1,s2
    8000445a:	8526                	mv	a0,s1
    8000445c:	ffffe097          	auipc	ra,0xffffe
    80004460:	d38080e7          	jalr	-712(ra) # 80002194 <sleep>
  while (lk->locked) {
    80004464:	409c                	lw	a5,0(s1)
    80004466:	fbed                	bnez	a5,80004458 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004468:	4785                	li	a5,1
    8000446a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000446c:	ffffd097          	auipc	ra,0xffffd
    80004470:	576080e7          	jalr	1398(ra) # 800019e2 <myproc>
    80004474:	591c                	lw	a5,48(a0)
    80004476:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004478:	854a                	mv	a0,s2
    8000447a:	ffffd097          	auipc	ra,0xffffd
    8000447e:	80c080e7          	jalr	-2036(ra) # 80000c86 <release>
}
    80004482:	60e2                	ld	ra,24(sp)
    80004484:	6442                	ld	s0,16(sp)
    80004486:	64a2                	ld	s1,8(sp)
    80004488:	6902                	ld	s2,0(sp)
    8000448a:	6105                	addi	sp,sp,32
    8000448c:	8082                	ret

000000008000448e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000448e:	1101                	addi	sp,sp,-32
    80004490:	ec06                	sd	ra,24(sp)
    80004492:	e822                	sd	s0,16(sp)
    80004494:	e426                	sd	s1,8(sp)
    80004496:	e04a                	sd	s2,0(sp)
    80004498:	1000                	addi	s0,sp,32
    8000449a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000449c:	00850913          	addi	s2,a0,8
    800044a0:	854a                	mv	a0,s2
    800044a2:	ffffc097          	auipc	ra,0xffffc
    800044a6:	730080e7          	jalr	1840(ra) # 80000bd2 <acquire>
  lk->locked = 0;
    800044aa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800044ae:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800044b2:	8526                	mv	a0,s1
    800044b4:	ffffe097          	auipc	ra,0xffffe
    800044b8:	d44080e7          	jalr	-700(ra) # 800021f8 <wakeup>
  release(&lk->lk);
    800044bc:	854a                	mv	a0,s2
    800044be:	ffffc097          	auipc	ra,0xffffc
    800044c2:	7c8080e7          	jalr	1992(ra) # 80000c86 <release>
}
    800044c6:	60e2                	ld	ra,24(sp)
    800044c8:	6442                	ld	s0,16(sp)
    800044ca:	64a2                	ld	s1,8(sp)
    800044cc:	6902                	ld	s2,0(sp)
    800044ce:	6105                	addi	sp,sp,32
    800044d0:	8082                	ret

00000000800044d2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800044d2:	7179                	addi	sp,sp,-48
    800044d4:	f406                	sd	ra,40(sp)
    800044d6:	f022                	sd	s0,32(sp)
    800044d8:	ec26                	sd	s1,24(sp)
    800044da:	e84a                	sd	s2,16(sp)
    800044dc:	e44e                	sd	s3,8(sp)
    800044de:	1800                	addi	s0,sp,48
    800044e0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044e2:	00850913          	addi	s2,a0,8
    800044e6:	854a                	mv	a0,s2
    800044e8:	ffffc097          	auipc	ra,0xffffc
    800044ec:	6ea080e7          	jalr	1770(ra) # 80000bd2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044f0:	409c                	lw	a5,0(s1)
    800044f2:	ef99                	bnez	a5,80004510 <holdingsleep+0x3e>
    800044f4:	4481                	li	s1,0
  release(&lk->lk);
    800044f6:	854a                	mv	a0,s2
    800044f8:	ffffc097          	auipc	ra,0xffffc
    800044fc:	78e080e7          	jalr	1934(ra) # 80000c86 <release>
  return r;
}
    80004500:	8526                	mv	a0,s1
    80004502:	70a2                	ld	ra,40(sp)
    80004504:	7402                	ld	s0,32(sp)
    80004506:	64e2                	ld	s1,24(sp)
    80004508:	6942                	ld	s2,16(sp)
    8000450a:	69a2                	ld	s3,8(sp)
    8000450c:	6145                	addi	sp,sp,48
    8000450e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004510:	0284a983          	lw	s3,40(s1)
    80004514:	ffffd097          	auipc	ra,0xffffd
    80004518:	4ce080e7          	jalr	1230(ra) # 800019e2 <myproc>
    8000451c:	5904                	lw	s1,48(a0)
    8000451e:	413484b3          	sub	s1,s1,s3
    80004522:	0014b493          	seqz	s1,s1
    80004526:	bfc1                	j	800044f6 <holdingsleep+0x24>

0000000080004528 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004528:	1141                	addi	sp,sp,-16
    8000452a:	e406                	sd	ra,8(sp)
    8000452c:	e022                	sd	s0,0(sp)
    8000452e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004530:	00004597          	auipc	a1,0x4
    80004534:	18058593          	addi	a1,a1,384 # 800086b0 <syscalls+0x238>
    80004538:	00194517          	auipc	a0,0x194
    8000453c:	cf850513          	addi	a0,a0,-776 # 80198230 <ftable>
    80004540:	ffffc097          	auipc	ra,0xffffc
    80004544:	602080e7          	jalr	1538(ra) # 80000b42 <initlock>
}
    80004548:	60a2                	ld	ra,8(sp)
    8000454a:	6402                	ld	s0,0(sp)
    8000454c:	0141                	addi	sp,sp,16
    8000454e:	8082                	ret

0000000080004550 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004550:	1101                	addi	sp,sp,-32
    80004552:	ec06                	sd	ra,24(sp)
    80004554:	e822                	sd	s0,16(sp)
    80004556:	e426                	sd	s1,8(sp)
    80004558:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000455a:	00194517          	auipc	a0,0x194
    8000455e:	cd650513          	addi	a0,a0,-810 # 80198230 <ftable>
    80004562:	ffffc097          	auipc	ra,0xffffc
    80004566:	670080e7          	jalr	1648(ra) # 80000bd2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000456a:	00194497          	auipc	s1,0x194
    8000456e:	cde48493          	addi	s1,s1,-802 # 80198248 <ftable+0x18>
    80004572:	00195717          	auipc	a4,0x195
    80004576:	c7670713          	addi	a4,a4,-906 # 801991e8 <disk>
    if(f->ref == 0){
    8000457a:	40dc                	lw	a5,4(s1)
    8000457c:	cf99                	beqz	a5,8000459a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000457e:	02848493          	addi	s1,s1,40
    80004582:	fee49ce3          	bne	s1,a4,8000457a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004586:	00194517          	auipc	a0,0x194
    8000458a:	caa50513          	addi	a0,a0,-854 # 80198230 <ftable>
    8000458e:	ffffc097          	auipc	ra,0xffffc
    80004592:	6f8080e7          	jalr	1784(ra) # 80000c86 <release>
  return 0;
    80004596:	4481                	li	s1,0
    80004598:	a819                	j	800045ae <filealloc+0x5e>
      f->ref = 1;
    8000459a:	4785                	li	a5,1
    8000459c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000459e:	00194517          	auipc	a0,0x194
    800045a2:	c9250513          	addi	a0,a0,-878 # 80198230 <ftable>
    800045a6:	ffffc097          	auipc	ra,0xffffc
    800045aa:	6e0080e7          	jalr	1760(ra) # 80000c86 <release>
}
    800045ae:	8526                	mv	a0,s1
    800045b0:	60e2                	ld	ra,24(sp)
    800045b2:	6442                	ld	s0,16(sp)
    800045b4:	64a2                	ld	s1,8(sp)
    800045b6:	6105                	addi	sp,sp,32
    800045b8:	8082                	ret

00000000800045ba <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800045ba:	1101                	addi	sp,sp,-32
    800045bc:	ec06                	sd	ra,24(sp)
    800045be:	e822                	sd	s0,16(sp)
    800045c0:	e426                	sd	s1,8(sp)
    800045c2:	1000                	addi	s0,sp,32
    800045c4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800045c6:	00194517          	auipc	a0,0x194
    800045ca:	c6a50513          	addi	a0,a0,-918 # 80198230 <ftable>
    800045ce:	ffffc097          	auipc	ra,0xffffc
    800045d2:	604080e7          	jalr	1540(ra) # 80000bd2 <acquire>
  if(f->ref < 1)
    800045d6:	40dc                	lw	a5,4(s1)
    800045d8:	02f05263          	blez	a5,800045fc <filedup+0x42>
    panic("filedup");
  f->ref++;
    800045dc:	2785                	addiw	a5,a5,1
    800045de:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045e0:	00194517          	auipc	a0,0x194
    800045e4:	c5050513          	addi	a0,a0,-944 # 80198230 <ftable>
    800045e8:	ffffc097          	auipc	ra,0xffffc
    800045ec:	69e080e7          	jalr	1694(ra) # 80000c86 <release>
  return f;
}
    800045f0:	8526                	mv	a0,s1
    800045f2:	60e2                	ld	ra,24(sp)
    800045f4:	6442                	ld	s0,16(sp)
    800045f6:	64a2                	ld	s1,8(sp)
    800045f8:	6105                	addi	sp,sp,32
    800045fa:	8082                	ret
    panic("filedup");
    800045fc:	00004517          	auipc	a0,0x4
    80004600:	0bc50513          	addi	a0,a0,188 # 800086b8 <syscalls+0x240>
    80004604:	ffffc097          	auipc	ra,0xffffc
    80004608:	f38080e7          	jalr	-200(ra) # 8000053c <panic>

000000008000460c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000460c:	7139                	addi	sp,sp,-64
    8000460e:	fc06                	sd	ra,56(sp)
    80004610:	f822                	sd	s0,48(sp)
    80004612:	f426                	sd	s1,40(sp)
    80004614:	f04a                	sd	s2,32(sp)
    80004616:	ec4e                	sd	s3,24(sp)
    80004618:	e852                	sd	s4,16(sp)
    8000461a:	e456                	sd	s5,8(sp)
    8000461c:	0080                	addi	s0,sp,64
    8000461e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004620:	00194517          	auipc	a0,0x194
    80004624:	c1050513          	addi	a0,a0,-1008 # 80198230 <ftable>
    80004628:	ffffc097          	auipc	ra,0xffffc
    8000462c:	5aa080e7          	jalr	1450(ra) # 80000bd2 <acquire>
  if(f->ref < 1)
    80004630:	40dc                	lw	a5,4(s1)
    80004632:	06f05163          	blez	a5,80004694 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004636:	37fd                	addiw	a5,a5,-1
    80004638:	0007871b          	sext.w	a4,a5
    8000463c:	c0dc                	sw	a5,4(s1)
    8000463e:	06e04363          	bgtz	a4,800046a4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004642:	0004a903          	lw	s2,0(s1)
    80004646:	0094ca83          	lbu	s5,9(s1)
    8000464a:	0104ba03          	ld	s4,16(s1)
    8000464e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004652:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004656:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000465a:	00194517          	auipc	a0,0x194
    8000465e:	bd650513          	addi	a0,a0,-1066 # 80198230 <ftable>
    80004662:	ffffc097          	auipc	ra,0xffffc
    80004666:	624080e7          	jalr	1572(ra) # 80000c86 <release>

  if(ff.type == FD_PIPE){
    8000466a:	4785                	li	a5,1
    8000466c:	04f90d63          	beq	s2,a5,800046c6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004670:	3979                	addiw	s2,s2,-2
    80004672:	4785                	li	a5,1
    80004674:	0527e063          	bltu	a5,s2,800046b4 <fileclose+0xa8>
    begin_op();
    80004678:	00000097          	auipc	ra,0x0
    8000467c:	ad0080e7          	jalr	-1328(ra) # 80004148 <begin_op>
    iput(ff.ip);
    80004680:	854e                	mv	a0,s3
    80004682:	fffff097          	auipc	ra,0xfffff
    80004686:	2da080e7          	jalr	730(ra) # 8000395c <iput>
    end_op();
    8000468a:	00000097          	auipc	ra,0x0
    8000468e:	b38080e7          	jalr	-1224(ra) # 800041c2 <end_op>
    80004692:	a00d                	j	800046b4 <fileclose+0xa8>
    panic("fileclose");
    80004694:	00004517          	auipc	a0,0x4
    80004698:	02c50513          	addi	a0,a0,44 # 800086c0 <syscalls+0x248>
    8000469c:	ffffc097          	auipc	ra,0xffffc
    800046a0:	ea0080e7          	jalr	-352(ra) # 8000053c <panic>
    release(&ftable.lock);
    800046a4:	00194517          	auipc	a0,0x194
    800046a8:	b8c50513          	addi	a0,a0,-1140 # 80198230 <ftable>
    800046ac:	ffffc097          	auipc	ra,0xffffc
    800046b0:	5da080e7          	jalr	1498(ra) # 80000c86 <release>
  }
}
    800046b4:	70e2                	ld	ra,56(sp)
    800046b6:	7442                	ld	s0,48(sp)
    800046b8:	74a2                	ld	s1,40(sp)
    800046ba:	7902                	ld	s2,32(sp)
    800046bc:	69e2                	ld	s3,24(sp)
    800046be:	6a42                	ld	s4,16(sp)
    800046c0:	6aa2                	ld	s5,8(sp)
    800046c2:	6121                	addi	sp,sp,64
    800046c4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800046c6:	85d6                	mv	a1,s5
    800046c8:	8552                	mv	a0,s4
    800046ca:	00000097          	auipc	ra,0x0
    800046ce:	348080e7          	jalr	840(ra) # 80004a12 <pipeclose>
    800046d2:	b7cd                	j	800046b4 <fileclose+0xa8>

00000000800046d4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800046d4:	715d                	addi	sp,sp,-80
    800046d6:	e486                	sd	ra,72(sp)
    800046d8:	e0a2                	sd	s0,64(sp)
    800046da:	fc26                	sd	s1,56(sp)
    800046dc:	f84a                	sd	s2,48(sp)
    800046de:	f44e                	sd	s3,40(sp)
    800046e0:	0880                	addi	s0,sp,80
    800046e2:	84aa                	mv	s1,a0
    800046e4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800046e6:	ffffd097          	auipc	ra,0xffffd
    800046ea:	2fc080e7          	jalr	764(ra) # 800019e2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046ee:	409c                	lw	a5,0(s1)
    800046f0:	37f9                	addiw	a5,a5,-2
    800046f2:	4705                	li	a4,1
    800046f4:	04f76763          	bltu	a4,a5,80004742 <filestat+0x6e>
    800046f8:	892a                	mv	s2,a0
    ilock(f->ip);
    800046fa:	6c88                	ld	a0,24(s1)
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	0a6080e7          	jalr	166(ra) # 800037a2 <ilock>
    stati(f->ip, &st);
    80004704:	fb840593          	addi	a1,s0,-72
    80004708:	6c88                	ld	a0,24(s1)
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	322080e7          	jalr	802(ra) # 80003a2c <stati>
    iunlock(f->ip);
    80004712:	6c88                	ld	a0,24(s1)
    80004714:	fffff097          	auipc	ra,0xfffff
    80004718:	150080e7          	jalr	336(ra) # 80003864 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000471c:	46e1                	li	a3,24
    8000471e:	fb840613          	addi	a2,s0,-72
    80004722:	85ce                	mv	a1,s3
    80004724:	05093503          	ld	a0,80(s2)
    80004728:	ffffd097          	auipc	ra,0xffffd
    8000472c:	f6a080e7          	jalr	-150(ra) # 80001692 <copyout>
    80004730:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004734:	60a6                	ld	ra,72(sp)
    80004736:	6406                	ld	s0,64(sp)
    80004738:	74e2                	ld	s1,56(sp)
    8000473a:	7942                	ld	s2,48(sp)
    8000473c:	79a2                	ld	s3,40(sp)
    8000473e:	6161                	addi	sp,sp,80
    80004740:	8082                	ret
  return -1;
    80004742:	557d                	li	a0,-1
    80004744:	bfc5                	j	80004734 <filestat+0x60>

0000000080004746 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004746:	7179                	addi	sp,sp,-48
    80004748:	f406                	sd	ra,40(sp)
    8000474a:	f022                	sd	s0,32(sp)
    8000474c:	ec26                	sd	s1,24(sp)
    8000474e:	e84a                	sd	s2,16(sp)
    80004750:	e44e                	sd	s3,8(sp)
    80004752:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004754:	00854783          	lbu	a5,8(a0)
    80004758:	c3d5                	beqz	a5,800047fc <fileread+0xb6>
    8000475a:	84aa                	mv	s1,a0
    8000475c:	89ae                	mv	s3,a1
    8000475e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004760:	411c                	lw	a5,0(a0)
    80004762:	4705                	li	a4,1
    80004764:	04e78963          	beq	a5,a4,800047b6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004768:	470d                	li	a4,3
    8000476a:	04e78d63          	beq	a5,a4,800047c4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000476e:	4709                	li	a4,2
    80004770:	06e79e63          	bne	a5,a4,800047ec <fileread+0xa6>
    ilock(f->ip);
    80004774:	6d08                	ld	a0,24(a0)
    80004776:	fffff097          	auipc	ra,0xfffff
    8000477a:	02c080e7          	jalr	44(ra) # 800037a2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000477e:	874a                	mv	a4,s2
    80004780:	5094                	lw	a3,32(s1)
    80004782:	864e                	mv	a2,s3
    80004784:	4585                	li	a1,1
    80004786:	6c88                	ld	a0,24(s1)
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	2ce080e7          	jalr	718(ra) # 80003a56 <readi>
    80004790:	892a                	mv	s2,a0
    80004792:	00a05563          	blez	a0,8000479c <fileread+0x56>
      f->off += r;
    80004796:	509c                	lw	a5,32(s1)
    80004798:	9fa9                	addw	a5,a5,a0
    8000479a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000479c:	6c88                	ld	a0,24(s1)
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	0c6080e7          	jalr	198(ra) # 80003864 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800047a6:	854a                	mv	a0,s2
    800047a8:	70a2                	ld	ra,40(sp)
    800047aa:	7402                	ld	s0,32(sp)
    800047ac:	64e2                	ld	s1,24(sp)
    800047ae:	6942                	ld	s2,16(sp)
    800047b0:	69a2                	ld	s3,8(sp)
    800047b2:	6145                	addi	sp,sp,48
    800047b4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800047b6:	6908                	ld	a0,16(a0)
    800047b8:	00000097          	auipc	ra,0x0
    800047bc:	3c2080e7          	jalr	962(ra) # 80004b7a <piperead>
    800047c0:	892a                	mv	s2,a0
    800047c2:	b7d5                	j	800047a6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800047c4:	02451783          	lh	a5,36(a0)
    800047c8:	03079693          	slli	a3,a5,0x30
    800047cc:	92c1                	srli	a3,a3,0x30
    800047ce:	4725                	li	a4,9
    800047d0:	02d76863          	bltu	a4,a3,80004800 <fileread+0xba>
    800047d4:	0792                	slli	a5,a5,0x4
    800047d6:	00194717          	auipc	a4,0x194
    800047da:	9ba70713          	addi	a4,a4,-1606 # 80198190 <devsw>
    800047de:	97ba                	add	a5,a5,a4
    800047e0:	639c                	ld	a5,0(a5)
    800047e2:	c38d                	beqz	a5,80004804 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800047e4:	4505                	li	a0,1
    800047e6:	9782                	jalr	a5
    800047e8:	892a                	mv	s2,a0
    800047ea:	bf75                	j	800047a6 <fileread+0x60>
    panic("fileread");
    800047ec:	00004517          	auipc	a0,0x4
    800047f0:	ee450513          	addi	a0,a0,-284 # 800086d0 <syscalls+0x258>
    800047f4:	ffffc097          	auipc	ra,0xffffc
    800047f8:	d48080e7          	jalr	-696(ra) # 8000053c <panic>
    return -1;
    800047fc:	597d                	li	s2,-1
    800047fe:	b765                	j	800047a6 <fileread+0x60>
      return -1;
    80004800:	597d                	li	s2,-1
    80004802:	b755                	j	800047a6 <fileread+0x60>
    80004804:	597d                	li	s2,-1
    80004806:	b745                	j	800047a6 <fileread+0x60>

0000000080004808 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004808:	00954783          	lbu	a5,9(a0)
    8000480c:	10078e63          	beqz	a5,80004928 <filewrite+0x120>
{
    80004810:	715d                	addi	sp,sp,-80
    80004812:	e486                	sd	ra,72(sp)
    80004814:	e0a2                	sd	s0,64(sp)
    80004816:	fc26                	sd	s1,56(sp)
    80004818:	f84a                	sd	s2,48(sp)
    8000481a:	f44e                	sd	s3,40(sp)
    8000481c:	f052                	sd	s4,32(sp)
    8000481e:	ec56                	sd	s5,24(sp)
    80004820:	e85a                	sd	s6,16(sp)
    80004822:	e45e                	sd	s7,8(sp)
    80004824:	e062                	sd	s8,0(sp)
    80004826:	0880                	addi	s0,sp,80
    80004828:	892a                	mv	s2,a0
    8000482a:	8b2e                	mv	s6,a1
    8000482c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000482e:	411c                	lw	a5,0(a0)
    80004830:	4705                	li	a4,1
    80004832:	02e78263          	beq	a5,a4,80004856 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004836:	470d                	li	a4,3
    80004838:	02e78563          	beq	a5,a4,80004862 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000483c:	4709                	li	a4,2
    8000483e:	0ce79d63          	bne	a5,a4,80004918 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004842:	0ac05b63          	blez	a2,800048f8 <filewrite+0xf0>
    int i = 0;
    80004846:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004848:	6b85                	lui	s7,0x1
    8000484a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000484e:	6c05                	lui	s8,0x1
    80004850:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004854:	a851                	j	800048e8 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004856:	6908                	ld	a0,16(a0)
    80004858:	00000097          	auipc	ra,0x0
    8000485c:	22a080e7          	jalr	554(ra) # 80004a82 <pipewrite>
    80004860:	a045                	j	80004900 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004862:	02451783          	lh	a5,36(a0)
    80004866:	03079693          	slli	a3,a5,0x30
    8000486a:	92c1                	srli	a3,a3,0x30
    8000486c:	4725                	li	a4,9
    8000486e:	0ad76f63          	bltu	a4,a3,8000492c <filewrite+0x124>
    80004872:	0792                	slli	a5,a5,0x4
    80004874:	00194717          	auipc	a4,0x194
    80004878:	91c70713          	addi	a4,a4,-1764 # 80198190 <devsw>
    8000487c:	97ba                	add	a5,a5,a4
    8000487e:	679c                	ld	a5,8(a5)
    80004880:	cbc5                	beqz	a5,80004930 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004882:	4505                	li	a0,1
    80004884:	9782                	jalr	a5
    80004886:	a8ad                	j	80004900 <filewrite+0xf8>
      if(n1 > max)
    80004888:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000488c:	00000097          	auipc	ra,0x0
    80004890:	8bc080e7          	jalr	-1860(ra) # 80004148 <begin_op>
      ilock(f->ip);
    80004894:	01893503          	ld	a0,24(s2)
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	f0a080e7          	jalr	-246(ra) # 800037a2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800048a0:	8756                	mv	a4,s5
    800048a2:	02092683          	lw	a3,32(s2)
    800048a6:	01698633          	add	a2,s3,s6
    800048aa:	4585                	li	a1,1
    800048ac:	01893503          	ld	a0,24(s2)
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	29e080e7          	jalr	670(ra) # 80003b4e <writei>
    800048b8:	84aa                	mv	s1,a0
    800048ba:	00a05763          	blez	a0,800048c8 <filewrite+0xc0>
        f->off += r;
    800048be:	02092783          	lw	a5,32(s2)
    800048c2:	9fa9                	addw	a5,a5,a0
    800048c4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800048c8:	01893503          	ld	a0,24(s2)
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	f98080e7          	jalr	-104(ra) # 80003864 <iunlock>
      end_op();
    800048d4:	00000097          	auipc	ra,0x0
    800048d8:	8ee080e7          	jalr	-1810(ra) # 800041c2 <end_op>

      if(r != n1){
    800048dc:	009a9f63          	bne	s5,s1,800048fa <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    800048e0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800048e4:	0149db63          	bge	s3,s4,800048fa <filewrite+0xf2>
      int n1 = n - i;
    800048e8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800048ec:	0004879b          	sext.w	a5,s1
    800048f0:	f8fbdce3          	bge	s7,a5,80004888 <filewrite+0x80>
    800048f4:	84e2                	mv	s1,s8
    800048f6:	bf49                	j	80004888 <filewrite+0x80>
    int i = 0;
    800048f8:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800048fa:	033a1d63          	bne	s4,s3,80004934 <filewrite+0x12c>
    800048fe:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004900:	60a6                	ld	ra,72(sp)
    80004902:	6406                	ld	s0,64(sp)
    80004904:	74e2                	ld	s1,56(sp)
    80004906:	7942                	ld	s2,48(sp)
    80004908:	79a2                	ld	s3,40(sp)
    8000490a:	7a02                	ld	s4,32(sp)
    8000490c:	6ae2                	ld	s5,24(sp)
    8000490e:	6b42                	ld	s6,16(sp)
    80004910:	6ba2                	ld	s7,8(sp)
    80004912:	6c02                	ld	s8,0(sp)
    80004914:	6161                	addi	sp,sp,80
    80004916:	8082                	ret
    panic("filewrite");
    80004918:	00004517          	auipc	a0,0x4
    8000491c:	dc850513          	addi	a0,a0,-568 # 800086e0 <syscalls+0x268>
    80004920:	ffffc097          	auipc	ra,0xffffc
    80004924:	c1c080e7          	jalr	-996(ra) # 8000053c <panic>
    return -1;
    80004928:	557d                	li	a0,-1
}
    8000492a:	8082                	ret
      return -1;
    8000492c:	557d                	li	a0,-1
    8000492e:	bfc9                	j	80004900 <filewrite+0xf8>
    80004930:	557d                	li	a0,-1
    80004932:	b7f9                	j	80004900 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80004934:	557d                	li	a0,-1
    80004936:	b7e9                	j	80004900 <filewrite+0xf8>

0000000080004938 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004938:	7179                	addi	sp,sp,-48
    8000493a:	f406                	sd	ra,40(sp)
    8000493c:	f022                	sd	s0,32(sp)
    8000493e:	ec26                	sd	s1,24(sp)
    80004940:	e84a                	sd	s2,16(sp)
    80004942:	e44e                	sd	s3,8(sp)
    80004944:	e052                	sd	s4,0(sp)
    80004946:	1800                	addi	s0,sp,48
    80004948:	84aa                	mv	s1,a0
    8000494a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000494c:	0005b023          	sd	zero,0(a1)
    80004950:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004954:	00000097          	auipc	ra,0x0
    80004958:	bfc080e7          	jalr	-1028(ra) # 80004550 <filealloc>
    8000495c:	e088                	sd	a0,0(s1)
    8000495e:	c551                	beqz	a0,800049ea <pipealloc+0xb2>
    80004960:	00000097          	auipc	ra,0x0
    80004964:	bf0080e7          	jalr	-1040(ra) # 80004550 <filealloc>
    80004968:	00aa3023          	sd	a0,0(s4)
    8000496c:	c92d                	beqz	a0,800049de <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000496e:	ffffc097          	auipc	ra,0xffffc
    80004972:	174080e7          	jalr	372(ra) # 80000ae2 <kalloc>
    80004976:	892a                	mv	s2,a0
    80004978:	c125                	beqz	a0,800049d8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000497a:	4985                	li	s3,1
    8000497c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004980:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004984:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004988:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000498c:	00004597          	auipc	a1,0x4
    80004990:	d6458593          	addi	a1,a1,-668 # 800086f0 <syscalls+0x278>
    80004994:	ffffc097          	auipc	ra,0xffffc
    80004998:	1ae080e7          	jalr	430(ra) # 80000b42 <initlock>
  (*f0)->type = FD_PIPE;
    8000499c:	609c                	ld	a5,0(s1)
    8000499e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800049a2:	609c                	ld	a5,0(s1)
    800049a4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800049a8:	609c                	ld	a5,0(s1)
    800049aa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800049ae:	609c                	ld	a5,0(s1)
    800049b0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800049b4:	000a3783          	ld	a5,0(s4)
    800049b8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800049bc:	000a3783          	ld	a5,0(s4)
    800049c0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800049c4:	000a3783          	ld	a5,0(s4)
    800049c8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800049cc:	000a3783          	ld	a5,0(s4)
    800049d0:	0127b823          	sd	s2,16(a5)
  return 0;
    800049d4:	4501                	li	a0,0
    800049d6:	a025                	j	800049fe <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800049d8:	6088                	ld	a0,0(s1)
    800049da:	e501                	bnez	a0,800049e2 <pipealloc+0xaa>
    800049dc:	a039                	j	800049ea <pipealloc+0xb2>
    800049de:	6088                	ld	a0,0(s1)
    800049e0:	c51d                	beqz	a0,80004a0e <pipealloc+0xd6>
    fileclose(*f0);
    800049e2:	00000097          	auipc	ra,0x0
    800049e6:	c2a080e7          	jalr	-982(ra) # 8000460c <fileclose>
  if(*f1)
    800049ea:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049ee:	557d                	li	a0,-1
  if(*f1)
    800049f0:	c799                	beqz	a5,800049fe <pipealloc+0xc6>
    fileclose(*f1);
    800049f2:	853e                	mv	a0,a5
    800049f4:	00000097          	auipc	ra,0x0
    800049f8:	c18080e7          	jalr	-1000(ra) # 8000460c <fileclose>
  return -1;
    800049fc:	557d                	li	a0,-1
}
    800049fe:	70a2                	ld	ra,40(sp)
    80004a00:	7402                	ld	s0,32(sp)
    80004a02:	64e2                	ld	s1,24(sp)
    80004a04:	6942                	ld	s2,16(sp)
    80004a06:	69a2                	ld	s3,8(sp)
    80004a08:	6a02                	ld	s4,0(sp)
    80004a0a:	6145                	addi	sp,sp,48
    80004a0c:	8082                	ret
  return -1;
    80004a0e:	557d                	li	a0,-1
    80004a10:	b7fd                	j	800049fe <pipealloc+0xc6>

0000000080004a12 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a12:	1101                	addi	sp,sp,-32
    80004a14:	ec06                	sd	ra,24(sp)
    80004a16:	e822                	sd	s0,16(sp)
    80004a18:	e426                	sd	s1,8(sp)
    80004a1a:	e04a                	sd	s2,0(sp)
    80004a1c:	1000                	addi	s0,sp,32
    80004a1e:	84aa                	mv	s1,a0
    80004a20:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a22:	ffffc097          	auipc	ra,0xffffc
    80004a26:	1b0080e7          	jalr	432(ra) # 80000bd2 <acquire>
  if(writable){
    80004a2a:	02090d63          	beqz	s2,80004a64 <pipeclose+0x52>
    pi->writeopen = 0;
    80004a2e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a32:	21848513          	addi	a0,s1,536
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	7c2080e7          	jalr	1986(ra) # 800021f8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a3e:	2204b783          	ld	a5,544(s1)
    80004a42:	eb95                	bnez	a5,80004a76 <pipeclose+0x64>
    release(&pi->lock);
    80004a44:	8526                	mv	a0,s1
    80004a46:	ffffc097          	auipc	ra,0xffffc
    80004a4a:	240080e7          	jalr	576(ra) # 80000c86 <release>
    kfree((char*)pi);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffc097          	auipc	ra,0xffffc
    80004a54:	f94080e7          	jalr	-108(ra) # 800009e4 <kfree>
  } else
    release(&pi->lock);
}
    80004a58:	60e2                	ld	ra,24(sp)
    80004a5a:	6442                	ld	s0,16(sp)
    80004a5c:	64a2                	ld	s1,8(sp)
    80004a5e:	6902                	ld	s2,0(sp)
    80004a60:	6105                	addi	sp,sp,32
    80004a62:	8082                	ret
    pi->readopen = 0;
    80004a64:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a68:	21c48513          	addi	a0,s1,540
    80004a6c:	ffffd097          	auipc	ra,0xffffd
    80004a70:	78c080e7          	jalr	1932(ra) # 800021f8 <wakeup>
    80004a74:	b7e9                	j	80004a3e <pipeclose+0x2c>
    release(&pi->lock);
    80004a76:	8526                	mv	a0,s1
    80004a78:	ffffc097          	auipc	ra,0xffffc
    80004a7c:	20e080e7          	jalr	526(ra) # 80000c86 <release>
}
    80004a80:	bfe1                	j	80004a58 <pipeclose+0x46>

0000000080004a82 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a82:	711d                	addi	sp,sp,-96
    80004a84:	ec86                	sd	ra,88(sp)
    80004a86:	e8a2                	sd	s0,80(sp)
    80004a88:	e4a6                	sd	s1,72(sp)
    80004a8a:	e0ca                	sd	s2,64(sp)
    80004a8c:	fc4e                	sd	s3,56(sp)
    80004a8e:	f852                	sd	s4,48(sp)
    80004a90:	f456                	sd	s5,40(sp)
    80004a92:	f05a                	sd	s6,32(sp)
    80004a94:	ec5e                	sd	s7,24(sp)
    80004a96:	e862                	sd	s8,16(sp)
    80004a98:	1080                	addi	s0,sp,96
    80004a9a:	84aa                	mv	s1,a0
    80004a9c:	8aae                	mv	s5,a1
    80004a9e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004aa0:	ffffd097          	auipc	ra,0xffffd
    80004aa4:	f42080e7          	jalr	-190(ra) # 800019e2 <myproc>
    80004aa8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffc097          	auipc	ra,0xffffc
    80004ab0:	126080e7          	jalr	294(ra) # 80000bd2 <acquire>
  while(i < n){
    80004ab4:	0b405663          	blez	s4,80004b60 <pipewrite+0xde>
  int i = 0;
    80004ab8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004aba:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004abc:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ac0:	21c48b93          	addi	s7,s1,540
    80004ac4:	a089                	j	80004b06 <pipewrite+0x84>
      release(&pi->lock);
    80004ac6:	8526                	mv	a0,s1
    80004ac8:	ffffc097          	auipc	ra,0xffffc
    80004acc:	1be080e7          	jalr	446(ra) # 80000c86 <release>
      return -1;
    80004ad0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004ad2:	854a                	mv	a0,s2
    80004ad4:	60e6                	ld	ra,88(sp)
    80004ad6:	6446                	ld	s0,80(sp)
    80004ad8:	64a6                	ld	s1,72(sp)
    80004ada:	6906                	ld	s2,64(sp)
    80004adc:	79e2                	ld	s3,56(sp)
    80004ade:	7a42                	ld	s4,48(sp)
    80004ae0:	7aa2                	ld	s5,40(sp)
    80004ae2:	7b02                	ld	s6,32(sp)
    80004ae4:	6be2                	ld	s7,24(sp)
    80004ae6:	6c42                	ld	s8,16(sp)
    80004ae8:	6125                	addi	sp,sp,96
    80004aea:	8082                	ret
      wakeup(&pi->nread);
    80004aec:	8562                	mv	a0,s8
    80004aee:	ffffd097          	auipc	ra,0xffffd
    80004af2:	70a080e7          	jalr	1802(ra) # 800021f8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004af6:	85a6                	mv	a1,s1
    80004af8:	855e                	mv	a0,s7
    80004afa:	ffffd097          	auipc	ra,0xffffd
    80004afe:	69a080e7          	jalr	1690(ra) # 80002194 <sleep>
  while(i < n){
    80004b02:	07495063          	bge	s2,s4,80004b62 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004b06:	2204a783          	lw	a5,544(s1)
    80004b0a:	dfd5                	beqz	a5,80004ac6 <pipewrite+0x44>
    80004b0c:	854e                	mv	a0,s3
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	946080e7          	jalr	-1722(ra) # 80002454 <killed>
    80004b16:	f945                	bnez	a0,80004ac6 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004b18:	2184a783          	lw	a5,536(s1)
    80004b1c:	21c4a703          	lw	a4,540(s1)
    80004b20:	2007879b          	addiw	a5,a5,512
    80004b24:	fcf704e3          	beq	a4,a5,80004aec <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b28:	4685                	li	a3,1
    80004b2a:	01590633          	add	a2,s2,s5
    80004b2e:	faf40593          	addi	a1,s0,-81
    80004b32:	0509b503          	ld	a0,80(s3)
    80004b36:	ffffd097          	auipc	ra,0xffffd
    80004b3a:	be8080e7          	jalr	-1048(ra) # 8000171e <copyin>
    80004b3e:	03650263          	beq	a0,s6,80004b62 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b42:	21c4a783          	lw	a5,540(s1)
    80004b46:	0017871b          	addiw	a4,a5,1
    80004b4a:	20e4ae23          	sw	a4,540(s1)
    80004b4e:	1ff7f793          	andi	a5,a5,511
    80004b52:	97a6                	add	a5,a5,s1
    80004b54:	faf44703          	lbu	a4,-81(s0)
    80004b58:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b5c:	2905                	addiw	s2,s2,1
    80004b5e:	b755                	j	80004b02 <pipewrite+0x80>
  int i = 0;
    80004b60:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004b62:	21848513          	addi	a0,s1,536
    80004b66:	ffffd097          	auipc	ra,0xffffd
    80004b6a:	692080e7          	jalr	1682(ra) # 800021f8 <wakeup>
  release(&pi->lock);
    80004b6e:	8526                	mv	a0,s1
    80004b70:	ffffc097          	auipc	ra,0xffffc
    80004b74:	116080e7          	jalr	278(ra) # 80000c86 <release>
  return i;
    80004b78:	bfa9                	j	80004ad2 <pipewrite+0x50>

0000000080004b7a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b7a:	715d                	addi	sp,sp,-80
    80004b7c:	e486                	sd	ra,72(sp)
    80004b7e:	e0a2                	sd	s0,64(sp)
    80004b80:	fc26                	sd	s1,56(sp)
    80004b82:	f84a                	sd	s2,48(sp)
    80004b84:	f44e                	sd	s3,40(sp)
    80004b86:	f052                	sd	s4,32(sp)
    80004b88:	ec56                	sd	s5,24(sp)
    80004b8a:	e85a                	sd	s6,16(sp)
    80004b8c:	0880                	addi	s0,sp,80
    80004b8e:	84aa                	mv	s1,a0
    80004b90:	892e                	mv	s2,a1
    80004b92:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b94:	ffffd097          	auipc	ra,0xffffd
    80004b98:	e4e080e7          	jalr	-434(ra) # 800019e2 <myproc>
    80004b9c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b9e:	8526                	mv	a0,s1
    80004ba0:	ffffc097          	auipc	ra,0xffffc
    80004ba4:	032080e7          	jalr	50(ra) # 80000bd2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ba8:	2184a703          	lw	a4,536(s1)
    80004bac:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004bb0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004bb4:	02f71763          	bne	a4,a5,80004be2 <piperead+0x68>
    80004bb8:	2244a783          	lw	a5,548(s1)
    80004bbc:	c39d                	beqz	a5,80004be2 <piperead+0x68>
    if(killed(pr)){
    80004bbe:	8552                	mv	a0,s4
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	894080e7          	jalr	-1900(ra) # 80002454 <killed>
    80004bc8:	e949                	bnez	a0,80004c5a <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004bca:	85a6                	mv	a1,s1
    80004bcc:	854e                	mv	a0,s3
    80004bce:	ffffd097          	auipc	ra,0xffffd
    80004bd2:	5c6080e7          	jalr	1478(ra) # 80002194 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004bd6:	2184a703          	lw	a4,536(s1)
    80004bda:	21c4a783          	lw	a5,540(s1)
    80004bde:	fcf70de3          	beq	a4,a5,80004bb8 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004be2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004be4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004be6:	05505463          	blez	s5,80004c2e <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004bea:	2184a783          	lw	a5,536(s1)
    80004bee:	21c4a703          	lw	a4,540(s1)
    80004bf2:	02f70e63          	beq	a4,a5,80004c2e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004bf6:	0017871b          	addiw	a4,a5,1
    80004bfa:	20e4ac23          	sw	a4,536(s1)
    80004bfe:	1ff7f793          	andi	a5,a5,511
    80004c02:	97a6                	add	a5,a5,s1
    80004c04:	0187c783          	lbu	a5,24(a5)
    80004c08:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c0c:	4685                	li	a3,1
    80004c0e:	fbf40613          	addi	a2,s0,-65
    80004c12:	85ca                	mv	a1,s2
    80004c14:	050a3503          	ld	a0,80(s4)
    80004c18:	ffffd097          	auipc	ra,0xffffd
    80004c1c:	a7a080e7          	jalr	-1414(ra) # 80001692 <copyout>
    80004c20:	01650763          	beq	a0,s6,80004c2e <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c24:	2985                	addiw	s3,s3,1
    80004c26:	0905                	addi	s2,s2,1
    80004c28:	fd3a91e3          	bne	s5,s3,80004bea <piperead+0x70>
    80004c2c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004c2e:	21c48513          	addi	a0,s1,540
    80004c32:	ffffd097          	auipc	ra,0xffffd
    80004c36:	5c6080e7          	jalr	1478(ra) # 800021f8 <wakeup>
  release(&pi->lock);
    80004c3a:	8526                	mv	a0,s1
    80004c3c:	ffffc097          	auipc	ra,0xffffc
    80004c40:	04a080e7          	jalr	74(ra) # 80000c86 <release>
  return i;
}
    80004c44:	854e                	mv	a0,s3
    80004c46:	60a6                	ld	ra,72(sp)
    80004c48:	6406                	ld	s0,64(sp)
    80004c4a:	74e2                	ld	s1,56(sp)
    80004c4c:	7942                	ld	s2,48(sp)
    80004c4e:	79a2                	ld	s3,40(sp)
    80004c50:	7a02                	ld	s4,32(sp)
    80004c52:	6ae2                	ld	s5,24(sp)
    80004c54:	6b42                	ld	s6,16(sp)
    80004c56:	6161                	addi	sp,sp,80
    80004c58:	8082                	ret
      release(&pi->lock);
    80004c5a:	8526                	mv	a0,s1
    80004c5c:	ffffc097          	auipc	ra,0xffffc
    80004c60:	02a080e7          	jalr	42(ra) # 80000c86 <release>
      return -1;
    80004c64:	59fd                	li	s3,-1
    80004c66:	bff9                	j	80004c44 <piperead+0xca>

0000000080004c68 <flags2perm>:

// static 
int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004c68:	1141                	addi	sp,sp,-16
    80004c6a:	e422                	sd	s0,8(sp)
    80004c6c:	0800                	addi	s0,sp,16
    80004c6e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004c70:	8905                	andi	a0,a0,1
    80004c72:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004c74:	8b89                	andi	a5,a5,2
    80004c76:	c399                	beqz	a5,80004c7c <flags2perm+0x14>
      perm |= PTE_W;
    80004c78:	00456513          	ori	a0,a0,4
    return perm;
}
    80004c7c:	6422                	ld	s0,8(sp)
    80004c7e:	0141                	addi	sp,sp,16
    80004c80:	8082                	ret

0000000080004c82 <loadseg>:
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004c82:	c749                	beqz	a4,80004d0c <loadseg+0x8a>
{
    80004c84:	711d                	addi	sp,sp,-96
    80004c86:	ec86                	sd	ra,88(sp)
    80004c88:	e8a2                	sd	s0,80(sp)
    80004c8a:	e4a6                	sd	s1,72(sp)
    80004c8c:	e0ca                	sd	s2,64(sp)
    80004c8e:	fc4e                	sd	s3,56(sp)
    80004c90:	f852                	sd	s4,48(sp)
    80004c92:	f456                	sd	s5,40(sp)
    80004c94:	f05a                	sd	s6,32(sp)
    80004c96:	ec5e                	sd	s7,24(sp)
    80004c98:	e862                	sd	s8,16(sp)
    80004c9a:	e466                	sd	s9,8(sp)
    80004c9c:	1080                	addi	s0,sp,96
    80004c9e:	8aaa                	mv	s5,a0
    80004ca0:	8b2e                	mv	s6,a1
    80004ca2:	8bb2                	mv	s7,a2
    80004ca4:	8c36                	mv	s8,a3
    80004ca6:	89ba                	mv	s3,a4
  for(i = 0; i < sz; i += PGSIZE){
    80004ca8:	4901                	li	s2,0
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004caa:	6c85                	lui	s9,0x1
    80004cac:	6a05                	lui	s4,0x1
    80004cae:	a815                	j	80004ce2 <loadseg+0x60>
      panic("loadseg: address should exist");
    80004cb0:	00004517          	auipc	a0,0x4
    80004cb4:	a4850513          	addi	a0,a0,-1464 # 800086f8 <syscalls+0x280>
    80004cb8:	ffffc097          	auipc	ra,0xffffc
    80004cbc:	884080e7          	jalr	-1916(ra) # 8000053c <panic>
    if(sz - i < PGSIZE)
    80004cc0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004cc2:	8726                	mv	a4,s1
    80004cc4:	012c06bb          	addw	a3,s8,s2
    80004cc8:	4581                	li	a1,0
    80004cca:	855e                	mv	a0,s7
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	d8a080e7          	jalr	-630(ra) # 80003a56 <readi>
    80004cd4:	2501                	sext.w	a0,a0
    80004cd6:	02951d63          	bne	a0,s1,80004d10 <loadseg+0x8e>
  for(i = 0; i < sz; i += PGSIZE){
    80004cda:	012a093b          	addw	s2,s4,s2
    80004cde:	03397563          	bgeu	s2,s3,80004d08 <loadseg+0x86>
    pa = walkaddr(pagetable, va + i);
    80004ce2:	02091593          	slli	a1,s2,0x20
    80004ce6:	9181                	srli	a1,a1,0x20
    80004ce8:	95da                	add	a1,a1,s6
    80004cea:	8556                	mv	a0,s5
    80004cec:	ffffc097          	auipc	ra,0xffffc
    80004cf0:	372080e7          	jalr	882(ra) # 8000105e <walkaddr>
    80004cf4:	862a                	mv	a2,a0
    if(pa == 0)
    80004cf6:	dd4d                	beqz	a0,80004cb0 <loadseg+0x2e>
    if(sz - i < PGSIZE)
    80004cf8:	412984bb          	subw	s1,s3,s2
    80004cfc:	0004879b          	sext.w	a5,s1
    80004d00:	fcfcf0e3          	bgeu	s9,a5,80004cc0 <loadseg+0x3e>
    80004d04:	84d2                	mv	s1,s4
    80004d06:	bf6d                	j	80004cc0 <loadseg+0x3e>
      return -1;
  }
  
  return 0;
    80004d08:	4501                	li	a0,0
    80004d0a:	a021                	j	80004d12 <loadseg+0x90>
    80004d0c:	4501                	li	a0,0
}
    80004d0e:	8082                	ret
      return -1;
    80004d10:	557d                	li	a0,-1
}
    80004d12:	60e6                	ld	ra,88(sp)
    80004d14:	6446                	ld	s0,80(sp)
    80004d16:	64a6                	ld	s1,72(sp)
    80004d18:	6906                	ld	s2,64(sp)
    80004d1a:	79e2                	ld	s3,56(sp)
    80004d1c:	7a42                	ld	s4,48(sp)
    80004d1e:	7aa2                	ld	s5,40(sp)
    80004d20:	7b02                	ld	s6,32(sp)
    80004d22:	6be2                	ld	s7,24(sp)
    80004d24:	6c42                	ld	s8,16(sp)
    80004d26:	6ca2                	ld	s9,8(sp)
    80004d28:	6125                	addi	sp,sp,96
    80004d2a:	8082                	ret

0000000080004d2c <exec>:
{
    80004d2c:	7101                	addi	sp,sp,-512
    80004d2e:	ff86                	sd	ra,504(sp)
    80004d30:	fba2                	sd	s0,496(sp)
    80004d32:	f7a6                	sd	s1,488(sp)
    80004d34:	f3ca                	sd	s2,480(sp)
    80004d36:	efce                	sd	s3,472(sp)
    80004d38:	ebd2                	sd	s4,464(sp)
    80004d3a:	e7d6                	sd	s5,456(sp)
    80004d3c:	e3da                	sd	s6,448(sp)
    80004d3e:	ff5e                	sd	s7,440(sp)
    80004d40:	fb62                	sd	s8,432(sp)
    80004d42:	f766                	sd	s9,424(sp)
    80004d44:	f36a                	sd	s10,416(sp)
    80004d46:	ef6e                	sd	s11,408(sp)
    80004d48:	0400                	addi	s0,sp,512
    80004d4a:	84aa                	mv	s1,a0
    80004d4c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80004d4e:	ffffd097          	auipc	ra,0xffffd
    80004d52:	c94080e7          	jalr	-876(ra) # 800019e2 <myproc>
    80004d56:	89aa                	mv	s3,a0
  if(strncmp(path,"sh", 2) == 0 || strncmp(path,"/init", 5) == 0){
    80004d58:	4609                	li	a2,2
    80004d5a:	00004597          	auipc	a1,0x4
    80004d5e:	9be58593          	addi	a1,a1,-1602 # 80008718 <syscalls+0x2a0>
    80004d62:	8526                	mv	a0,s1
    80004d64:	ffffc097          	auipc	ra,0xffffc
    80004d68:	03a080e7          	jalr	58(ra) # 80000d9e <strncmp>
    ondemand = false;
    80004d6c:	4a81                	li	s5,0
  if(strncmp(path,"sh", 2) == 0 || strncmp(path,"/init", 5) == 0){
    80004d6e:	e149                	bnez	a0,80004df0 <exec+0xc4>
  begin_op();
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	3d8080e7          	jalr	984(ra) # 80004148 <begin_op>
  if((ip = namei(path)) == 0){
    80004d78:	8526                	mv	a0,s1
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	1ce080e7          	jalr	462(ra) # 80003f48 <namei>
    80004d82:	8baa                	mv	s7,a0
    80004d84:	c941                	beqz	a0,80004e14 <exec+0xe8>
  ilock(ip);
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	a1c080e7          	jalr	-1508(ra) # 800037a2 <ilock>
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004d8e:	04000713          	li	a4,64
    80004d92:	4681                	li	a3,0
    80004d94:	e5040613          	addi	a2,s0,-432
    80004d98:	4581                	li	a1,0
    80004d9a:	855e                	mv	a0,s7
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	cba080e7          	jalr	-838(ra) # 80003a56 <readi>
    80004da4:	04000793          	li	a5,64
    80004da8:	00f51a63          	bne	a0,a5,80004dbc <exec+0x90>
  if(elf.magic != ELF_MAGIC)
    80004dac:	e5042703          	lw	a4,-432(s0)
    80004db0:	464c47b7          	lui	a5,0x464c4
    80004db4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004db8:	06f70463          	beq	a4,a5,80004e20 <exec+0xf4>
    iunlockput(ip);
    80004dbc:	855e                	mv	a0,s7
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	c46080e7          	jalr	-954(ra) # 80003a04 <iunlockput>
    end_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	3fc080e7          	jalr	1020(ra) # 800041c2 <end_op>
  return -1;
    80004dce:	557d                	li	a0,-1
}
    80004dd0:	70fe                	ld	ra,504(sp)
    80004dd2:	745e                	ld	s0,496(sp)
    80004dd4:	74be                	ld	s1,488(sp)
    80004dd6:	791e                	ld	s2,480(sp)
    80004dd8:	69fe                	ld	s3,472(sp)
    80004dda:	6a5e                	ld	s4,464(sp)
    80004ddc:	6abe                	ld	s5,456(sp)
    80004dde:	6b1e                	ld	s6,448(sp)
    80004de0:	7bfa                	ld	s7,440(sp)
    80004de2:	7c5a                	ld	s8,432(sp)
    80004de4:	7cba                	ld	s9,424(sp)
    80004de6:	7d1a                	ld	s10,416(sp)
    80004de8:	6dfa                	ld	s11,408(sp)
    80004dea:	20010113          	addi	sp,sp,512
    80004dee:	8082                	ret
  if(strncmp(path,"sh", 2) == 0 || strncmp(path,"/init", 5) == 0){
    80004df0:	4615                	li	a2,5
    80004df2:	00004597          	auipc	a1,0x4
    80004df6:	92e58593          	addi	a1,a1,-1746 # 80008720 <syscalls+0x2a8>
    80004dfa:	8526                	mv	a0,s1
    80004dfc:	ffffc097          	auipc	ra,0xffffc
    80004e00:	fa2080e7          	jalr	-94(ra) # 80000d9e <strncmp>
    80004e04:	d535                	beqz	a0,80004d70 <exec+0x44>
    print_ondemand_proc(path);
    80004e06:	8526                	mv	a0,s1
    80004e08:	00002097          	auipc	ra,0x2
    80004e0c:	ab6080e7          	jalr	-1354(ra) # 800068be <print_ondemand_proc>
  bool ondemand = true;
    80004e10:	4a85                	li	s5,1
    80004e12:	bfb9                	j	80004d70 <exec+0x44>
    end_op();
    80004e14:	fffff097          	auipc	ra,0xfffff
    80004e18:	3ae080e7          	jalr	942(ra) # 800041c2 <end_op>
    return -1;
    80004e1c:	557d                	li	a0,-1
    80004e1e:	bf4d                	j	80004dd0 <exec+0xa4>
  if((pagetable = proc_pagetable(p)) == 0)
    80004e20:	854e                	mv	a0,s3
    80004e22:	ffffd097          	auipc	ra,0xffffd
    80004e26:	c84080e7          	jalr	-892(ra) # 80001aa6 <proc_pagetable>
    80004e2a:	8b2a                	mv	s6,a0
    80004e2c:	d941                	beqz	a0,80004dbc <exec+0x90>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e2e:	e7042a03          	lw	s4,-400(s0)
    80004e32:	e8845783          	lhu	a5,-376(s0)
    80004e36:	cbd5                	beqz	a5,80004eea <exec+0x1be>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e38:	4981                	li	s3,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e3a:	4c01                	li	s8,0
    if(ph.type != ELF_PROG_LOAD)
    80004e3c:	4c85                	li	s9,1
    if(ph.vaddr % PGSIZE != 0)
    80004e3e:	6d05                	lui	s10,0x1
    80004e40:	1d7d                	addi	s10,s10,-1 # fff <_entry-0x7ffff001>
    80004e42:	a0b9                	j	80004e90 <exec+0x164>
      if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004e44:	e1c42503          	lw	a0,-484(s0)
    80004e48:	00000097          	auipc	ra,0x0
    80004e4c:	e20080e7          	jalr	-480(ra) # 80004c68 <flags2perm>
    80004e50:	86aa                	mv	a3,a0
    80004e52:	866e                	mv	a2,s11
    80004e54:	85ce                	mv	a1,s3
    80004e56:	855a                	mv	a0,s6
    80004e58:	ffffc097          	auipc	ra,0xffffc
    80004e5c:	5ac080e7          	jalr	1452(ra) # 80001404 <uvmalloc>
    80004e60:	8daa                	mv	s11,a0
    80004e62:	c971                	beqz	a0,80004f36 <exec+0x20a>
      if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004e64:	e3842703          	lw	a4,-456(s0)
    80004e68:	e2042683          	lw	a3,-480(s0)
    80004e6c:	865e                	mv	a2,s7
    80004e6e:	e2843583          	ld	a1,-472(s0)
    80004e72:	855a                	mv	a0,s6
    80004e74:	00000097          	auipc	ra,0x0
    80004e78:	e0e080e7          	jalr	-498(ra) # 80004c82 <loadseg>
    80004e7c:	20054a63          	bltz	a0,80005090 <exec+0x364>
      if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004e80:	89ee                	mv	s3,s11
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e82:	2c05                	addiw	s8,s8,1
    80004e84:	038a0a1b          	addiw	s4,s4,56 # 1038 <_entry-0x7fffefc8>
    80004e88:	e8845783          	lhu	a5,-376(s0)
    80004e8c:	06fc5063          	bge	s8,a5,80004eec <exec+0x1c0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e90:	2a01                	sext.w	s4,s4
    80004e92:	03800713          	li	a4,56
    80004e96:	86d2                	mv	a3,s4
    80004e98:	e1840613          	addi	a2,s0,-488
    80004e9c:	4581                	li	a1,0
    80004e9e:	855e                	mv	a0,s7
    80004ea0:	fffff097          	auipc	ra,0xfffff
    80004ea4:	bb6080e7          	jalr	-1098(ra) # 80003a56 <readi>
    80004ea8:	03800793          	li	a5,56
    80004eac:	08f51563          	bne	a0,a5,80004f36 <exec+0x20a>
    if(ph.type != ELF_PROG_LOAD)
    80004eb0:	e1842783          	lw	a5,-488(s0)
    80004eb4:	fd9797e3          	bne	a5,s9,80004e82 <exec+0x156>
    if(ph.memsz < ph.filesz)
    80004eb8:	e4043d83          	ld	s11,-448(s0)
    80004ebc:	e3843783          	ld	a5,-456(s0)
    80004ec0:	06fdeb63          	bltu	s11,a5,80004f36 <exec+0x20a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004ec4:	e2843583          	ld	a1,-472(s0)
    80004ec8:	9dae                	add	s11,s11,a1
    80004eca:	06bde663          	bltu	s11,a1,80004f36 <exec+0x20a>
    if(ph.vaddr % PGSIZE != 0)
    80004ece:	01a5f7b3          	and	a5,a1,s10
    80004ed2:	e3b5                	bnez	a5,80004f36 <exec+0x20a>
    if (ondemand == true) {
    80004ed4:	f60a88e3          	beqz	s5,80004e44 <exec+0x118>
      print_skip_section(path, ph.vaddr, sz1-sz);
    80004ed8:	413d863b          	subw	a2,s11,s3
    80004edc:	8526                	mv	a0,s1
    80004ede:	00002097          	auipc	ra,0x2
    80004ee2:	a02080e7          	jalr	-1534(ra) # 800068e0 <print_skip_section>
      sz=sz1;
    80004ee6:	89ee                	mv	s3,s11
    80004ee8:	bf69                	j	80004e82 <exec+0x156>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004eea:	4981                	li	s3,0
  iunlockput(ip);
    80004eec:	855e                	mv	a0,s7
    80004eee:	fffff097          	auipc	ra,0xfffff
    80004ef2:	b16080e7          	jalr	-1258(ra) # 80003a04 <iunlockput>
  end_op();
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	2cc080e7          	jalr	716(ra) # 800041c2 <end_op>
  p = myproc();
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	ae4080e7          	jalr	-1308(ra) # 800019e2 <myproc>
    80004f06:	e0a43423          	sd	a0,-504(s0)
  uint64 oldsz = p->sz;
    80004f0a:	653c                	ld	a5,72(a0)
    80004f0c:	e0f43023          	sd	a5,-512(s0)
  sz = PGROUNDUP(sz);
    80004f10:	6b85                	lui	s7,0x1
    80004f12:	1bfd                	addi	s7,s7,-1 # fff <_entry-0x7ffff001>
    80004f14:	9bce                	add	s7,s7,s3
    80004f16:	77fd                	lui	a5,0xfffff
    80004f18:	00fbfbb3          	and	s7,s7,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004f1c:	4691                	li	a3,4
    80004f1e:	6609                	lui	a2,0x2
    80004f20:	965e                	add	a2,a2,s7
    80004f22:	85de                	mv	a1,s7
    80004f24:	855a                	mv	a0,s6
    80004f26:	ffffc097          	auipc	ra,0xffffc
    80004f2a:	4de080e7          	jalr	1246(ra) # 80001404 <uvmalloc>
    80004f2e:	89aa                	mv	s3,a0
    80004f30:	ed09                	bnez	a0,80004f4a <exec+0x21e>
      if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004f32:	89de                	mv	s3,s7
    80004f34:	4b81                	li	s7,0
    proc_freepagetable(pagetable, sz);
    80004f36:	85ce                	mv	a1,s3
    80004f38:	855a                	mv	a0,s6
    80004f3a:	ffffd097          	auipc	ra,0xffffd
    80004f3e:	c08080e7          	jalr	-1016(ra) # 80001b42 <proc_freepagetable>
  return -1;
    80004f42:	557d                	li	a0,-1
  if(ip){
    80004f44:	e80b86e3          	beqz	s7,80004dd0 <exec+0xa4>
    80004f48:	bd95                	j	80004dbc <exec+0x90>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004f4a:	75f9                	lui	a1,0xffffe
    80004f4c:	95aa                	add	a1,a1,a0
    80004f4e:	855a                	mv	a0,s6
    80004f50:	ffffc097          	auipc	ra,0xffffc
    80004f54:	6de080e7          	jalr	1758(ra) # 8000162e <uvmclear>
  stackbase = sp - PGSIZE;
    80004f58:	7d7d                	lui	s10,0xfffff
    80004f5a:	9d4e                	add	s10,s10,s3
  for(argc = 0; argv[argc]; argc++) {
    80004f5c:	00093503          	ld	a0,0(s2)
    80004f60:	c125                	beqz	a0,80004fc0 <exec+0x294>
    80004f62:	e9040c13          	addi	s8,s0,-368
    80004f66:	f9040d93          	addi	s11,s0,-112
  sp = sz;
    80004f6a:	8bce                	mv	s7,s3
  for(argc = 0; argv[argc]; argc++) {
    80004f6c:	4a01                	li	s4,0
    sp -= strlen(argv[argc]) + 1;
    80004f6e:	ffffc097          	auipc	ra,0xffffc
    80004f72:	eda080e7          	jalr	-294(ra) # 80000e48 <strlen>
    80004f76:	2505                	addiw	a0,a0,1
    80004f78:	40ab8533          	sub	a0,s7,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004f7c:	ff057b93          	andi	s7,a0,-16
    if(sp < stackbase)
    80004f80:	11abea63          	bltu	s7,s10,80005094 <exec+0x368>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004f84:	00093c83          	ld	s9,0(s2)
    80004f88:	8566                	mv	a0,s9
    80004f8a:	ffffc097          	auipc	ra,0xffffc
    80004f8e:	ebe080e7          	jalr	-322(ra) # 80000e48 <strlen>
    80004f92:	0015069b          	addiw	a3,a0,1
    80004f96:	8666                	mv	a2,s9
    80004f98:	85de                	mv	a1,s7
    80004f9a:	855a                	mv	a0,s6
    80004f9c:	ffffc097          	auipc	ra,0xffffc
    80004fa0:	6f6080e7          	jalr	1782(ra) # 80001692 <copyout>
    80004fa4:	0e054a63          	bltz	a0,80005098 <exec+0x36c>
    ustack[argc] = sp;
    80004fa8:	017c3023          	sd	s7,0(s8)
  for(argc = 0; argv[argc]; argc++) {
    80004fac:	0a05                	addi	s4,s4,1
    80004fae:	0921                	addi	s2,s2,8
    80004fb0:	00093503          	ld	a0,0(s2)
    80004fb4:	c901                	beqz	a0,80004fc4 <exec+0x298>
    if(argc >= MAXARG)
    80004fb6:	0c21                	addi	s8,s8,8
    80004fb8:	fbbc1be3          	bne	s8,s11,80004f6e <exec+0x242>
  ip = 0;
    80004fbc:	4b81                	li	s7,0
    80004fbe:	bfa5                	j	80004f36 <exec+0x20a>
  sp = sz;
    80004fc0:	8bce                	mv	s7,s3
  for(argc = 0; argv[argc]; argc++) {
    80004fc2:	4a01                	li	s4,0
  ustack[argc] = 0;
    80004fc4:	003a1793          	slli	a5,s4,0x3
    80004fc8:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fe65880>
    80004fcc:	97a2                	add	a5,a5,s0
    80004fce:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004fd2:	001a0693          	addi	a3,s4,1
    80004fd6:	068e                	slli	a3,a3,0x3
    80004fd8:	40db8933          	sub	s2,s7,a3
  sp -= sp % 16;
    80004fdc:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004fe0:	8bce                	mv	s7,s3
  if(sp < stackbase)
    80004fe2:	f5a968e3          	bltu	s2,s10,80004f32 <exec+0x206>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004fe6:	e9040613          	addi	a2,s0,-368
    80004fea:	85ca                	mv	a1,s2
    80004fec:	855a                	mv	a0,s6
    80004fee:	ffffc097          	auipc	ra,0xffffc
    80004ff2:	6a4080e7          	jalr	1700(ra) # 80001692 <copyout>
    80004ff6:	f2054ee3          	bltz	a0,80004f32 <exec+0x206>
  p->trapframe->a1 = sp;
    80004ffa:	e0843783          	ld	a5,-504(s0)
    80004ffe:	6fbc                	ld	a5,88(a5)
    80005000:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005004:	0004c703          	lbu	a4,0(s1)
    80005008:	cf11                	beqz	a4,80005024 <exec+0x2f8>
    8000500a:	00148793          	addi	a5,s1,1
    if(*s == '/')
    8000500e:	02f00693          	li	a3,47
    80005012:	a029                	j	8000501c <exec+0x2f0>
  for(last=s=path; *s; s++)
    80005014:	0785                	addi	a5,a5,1
    80005016:	fff7c703          	lbu	a4,-1(a5)
    8000501a:	c709                	beqz	a4,80005024 <exec+0x2f8>
    if(*s == '/')
    8000501c:	fed71ce3          	bne	a4,a3,80005014 <exec+0x2e8>
      last = s+1;
    80005020:	84be                	mv	s1,a5
    80005022:	bfcd                	j	80005014 <exec+0x2e8>
  safestrcpy(p->name, last, sizeof(p->name));
    80005024:	4641                	li	a2,16
    80005026:	85a6                	mv	a1,s1
    80005028:	e0843483          	ld	s1,-504(s0)
    8000502c:	15848513          	addi	a0,s1,344
    80005030:	ffffc097          	auipc	ra,0xffffc
    80005034:	de6080e7          	jalr	-538(ra) # 80000e16 <safestrcpy>
  oldpagetable = p->pagetable;
    80005038:	68a8                	ld	a0,80(s1)
  p->pagetable = pagetable;
    8000503a:	0564b823          	sd	s6,80(s1)
  p->sz = sz;
    8000503e:	0534b423          	sd	s3,72(s1)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005042:	6cbc                	ld	a5,88(s1)
    80005044:	e6843703          	ld	a4,-408(s0)
    80005048:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000504a:	6cbc                	ld	a5,88(s1)
    8000504c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005050:	e0043583          	ld	a1,-512(s0)
    80005054:	ffffd097          	auipc	ra,0xffffd
    80005058:	aee080e7          	jalr	-1298(ra) # 80001b42 <proc_freepagetable>
  for (int i = 0; i < MAXHEAP; i++) {
    8000505c:	17048793          	addi	a5,s1,368
    80005060:	6699                	lui	a3,0x6
    80005062:	f3068693          	addi	a3,a3,-208 # 5f30 <_entry-0x7fffa0d0>
    80005066:	96a6                	add	a3,a3,s1
    p->heap_tracker[i].addr            = 0xFFFFFFFFFFFFFFFF;
    80005068:	577d                	li	a4,-1
    8000506a:	e398                	sd	a4,0(a5)
    p->heap_tracker[i].startblock      = -1;
    8000506c:	cbd8                	sw	a4,20(a5)
    p->heap_tracker[i].last_load_time  = 0xFFFFFFFFFFFFFFFF;
    8000506e:	e798                	sd	a4,8(a5)
    p->heap_tracker[i].loaded          = false;
    80005070:	00078823          	sb	zero,16(a5)
  for (int i = 0; i < MAXHEAP; i++) {
    80005074:	07e1                	addi	a5,a5,24
    80005076:	fed79ae3          	bne	a5,a3,8000506a <exec+0x33e>
  p->resident_heap_pages = 0;
    8000507a:	6799                	lui	a5,0x6
    8000507c:	e0843703          	ld	a4,-504(s0)
    80005080:	97ba                	add	a5,a5,a4
    80005082:	f207a823          	sw	zero,-208(a5) # 5f30 <_entry-0x7fffa0d0>
  p->ondemand = ondemand;
    80005086:	17570423          	sb	s5,360(a4)
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000508a:	000a051b          	sext.w	a0,s4
    8000508e:	b389                	j	80004dd0 <exec+0xa4>
      if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005090:	89ee                	mv	s3,s11
    80005092:	b555                	j	80004f36 <exec+0x20a>
  ip = 0;
    80005094:	4b81                	li	s7,0
    80005096:	b545                	j	80004f36 <exec+0x20a>
    80005098:	4b81                	li	s7,0
  if(pagetable)
    8000509a:	bd71                	j	80004f36 <exec+0x20a>

000000008000509c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000509c:	7179                	addi	sp,sp,-48
    8000509e:	f406                	sd	ra,40(sp)
    800050a0:	f022                	sd	s0,32(sp)
    800050a2:	ec26                	sd	s1,24(sp)
    800050a4:	e84a                	sd	s2,16(sp)
    800050a6:	1800                	addi	s0,sp,48
    800050a8:	892e                	mv	s2,a1
    800050aa:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800050ac:	fdc40593          	addi	a1,s0,-36
    800050b0:	ffffe097          	auipc	ra,0xffffe
    800050b4:	b90080e7          	jalr	-1136(ra) # 80002c40 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800050b8:	fdc42703          	lw	a4,-36(s0)
    800050bc:	47bd                	li	a5,15
    800050be:	02e7eb63          	bltu	a5,a4,800050f4 <argfd+0x58>
    800050c2:	ffffd097          	auipc	ra,0xffffd
    800050c6:	920080e7          	jalr	-1760(ra) # 800019e2 <myproc>
    800050ca:	fdc42703          	lw	a4,-36(s0)
    800050ce:	01a70793          	addi	a5,a4,26
    800050d2:	078e                	slli	a5,a5,0x3
    800050d4:	953e                	add	a0,a0,a5
    800050d6:	611c                	ld	a5,0(a0)
    800050d8:	c385                	beqz	a5,800050f8 <argfd+0x5c>
    return -1;
  if(pfd)
    800050da:	00090463          	beqz	s2,800050e2 <argfd+0x46>
    *pfd = fd;
    800050de:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800050e2:	4501                	li	a0,0
  if(pf)
    800050e4:	c091                	beqz	s1,800050e8 <argfd+0x4c>
    *pf = f;
    800050e6:	e09c                	sd	a5,0(s1)
}
    800050e8:	70a2                	ld	ra,40(sp)
    800050ea:	7402                	ld	s0,32(sp)
    800050ec:	64e2                	ld	s1,24(sp)
    800050ee:	6942                	ld	s2,16(sp)
    800050f0:	6145                	addi	sp,sp,48
    800050f2:	8082                	ret
    return -1;
    800050f4:	557d                	li	a0,-1
    800050f6:	bfcd                	j	800050e8 <argfd+0x4c>
    800050f8:	557d                	li	a0,-1
    800050fa:	b7fd                	j	800050e8 <argfd+0x4c>

00000000800050fc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800050fc:	1101                	addi	sp,sp,-32
    800050fe:	ec06                	sd	ra,24(sp)
    80005100:	e822                	sd	s0,16(sp)
    80005102:	e426                	sd	s1,8(sp)
    80005104:	1000                	addi	s0,sp,32
    80005106:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005108:	ffffd097          	auipc	ra,0xffffd
    8000510c:	8da080e7          	jalr	-1830(ra) # 800019e2 <myproc>
    80005110:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005112:	0d050793          	addi	a5,a0,208
    80005116:	4501                	li	a0,0
    80005118:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000511a:	6398                	ld	a4,0(a5)
    8000511c:	cb19                	beqz	a4,80005132 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000511e:	2505                	addiw	a0,a0,1
    80005120:	07a1                	addi	a5,a5,8
    80005122:	fed51ce3          	bne	a0,a3,8000511a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005126:	557d                	li	a0,-1
}
    80005128:	60e2                	ld	ra,24(sp)
    8000512a:	6442                	ld	s0,16(sp)
    8000512c:	64a2                	ld	s1,8(sp)
    8000512e:	6105                	addi	sp,sp,32
    80005130:	8082                	ret
      p->ofile[fd] = f;
    80005132:	01a50793          	addi	a5,a0,26
    80005136:	078e                	slli	a5,a5,0x3
    80005138:	963e                	add	a2,a2,a5
    8000513a:	e204                	sd	s1,0(a2)
      return fd;
    8000513c:	b7f5                	j	80005128 <fdalloc+0x2c>

000000008000513e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000513e:	715d                	addi	sp,sp,-80
    80005140:	e486                	sd	ra,72(sp)
    80005142:	e0a2                	sd	s0,64(sp)
    80005144:	fc26                	sd	s1,56(sp)
    80005146:	f84a                	sd	s2,48(sp)
    80005148:	f44e                	sd	s3,40(sp)
    8000514a:	f052                	sd	s4,32(sp)
    8000514c:	ec56                	sd	s5,24(sp)
    8000514e:	e85a                	sd	s6,16(sp)
    80005150:	0880                	addi	s0,sp,80
    80005152:	8b2e                	mv	s6,a1
    80005154:	89b2                	mv	s3,a2
    80005156:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005158:	fb040593          	addi	a1,s0,-80
    8000515c:	fffff097          	auipc	ra,0xfffff
    80005160:	e0a080e7          	jalr	-502(ra) # 80003f66 <nameiparent>
    80005164:	84aa                	mv	s1,a0
    80005166:	14050b63          	beqz	a0,800052bc <create+0x17e>
    return 0;

  ilock(dp);
    8000516a:	ffffe097          	auipc	ra,0xffffe
    8000516e:	638080e7          	jalr	1592(ra) # 800037a2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005172:	4601                	li	a2,0
    80005174:	fb040593          	addi	a1,s0,-80
    80005178:	8526                	mv	a0,s1
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	b0c080e7          	jalr	-1268(ra) # 80003c86 <dirlookup>
    80005182:	8aaa                	mv	s5,a0
    80005184:	c921                	beqz	a0,800051d4 <create+0x96>
    iunlockput(dp);
    80005186:	8526                	mv	a0,s1
    80005188:	fffff097          	auipc	ra,0xfffff
    8000518c:	87c080e7          	jalr	-1924(ra) # 80003a04 <iunlockput>
    ilock(ip);
    80005190:	8556                	mv	a0,s5
    80005192:	ffffe097          	auipc	ra,0xffffe
    80005196:	610080e7          	jalr	1552(ra) # 800037a2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000519a:	4789                	li	a5,2
    8000519c:	02fb1563          	bne	s6,a5,800051c6 <create+0x88>
    800051a0:	044ad783          	lhu	a5,68(s5)
    800051a4:	37f9                	addiw	a5,a5,-2
    800051a6:	17c2                	slli	a5,a5,0x30
    800051a8:	93c1                	srli	a5,a5,0x30
    800051aa:	4705                	li	a4,1
    800051ac:	00f76d63          	bltu	a4,a5,800051c6 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800051b0:	8556                	mv	a0,s5
    800051b2:	60a6                	ld	ra,72(sp)
    800051b4:	6406                	ld	s0,64(sp)
    800051b6:	74e2                	ld	s1,56(sp)
    800051b8:	7942                	ld	s2,48(sp)
    800051ba:	79a2                	ld	s3,40(sp)
    800051bc:	7a02                	ld	s4,32(sp)
    800051be:	6ae2                	ld	s5,24(sp)
    800051c0:	6b42                	ld	s6,16(sp)
    800051c2:	6161                	addi	sp,sp,80
    800051c4:	8082                	ret
    iunlockput(ip);
    800051c6:	8556                	mv	a0,s5
    800051c8:	fffff097          	auipc	ra,0xfffff
    800051cc:	83c080e7          	jalr	-1988(ra) # 80003a04 <iunlockput>
    return 0;
    800051d0:	4a81                	li	s5,0
    800051d2:	bff9                	j	800051b0 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800051d4:	85da                	mv	a1,s6
    800051d6:	4088                	lw	a0,0(s1)
    800051d8:	ffffe097          	auipc	ra,0xffffe
    800051dc:	432080e7          	jalr	1074(ra) # 8000360a <ialloc>
    800051e0:	8a2a                	mv	s4,a0
    800051e2:	c529                	beqz	a0,8000522c <create+0xee>
  ilock(ip);
    800051e4:	ffffe097          	auipc	ra,0xffffe
    800051e8:	5be080e7          	jalr	1470(ra) # 800037a2 <ilock>
  ip->major = major;
    800051ec:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800051f0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800051f4:	4905                	li	s2,1
    800051f6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800051fa:	8552                	mv	a0,s4
    800051fc:	ffffe097          	auipc	ra,0xffffe
    80005200:	4da080e7          	jalr	1242(ra) # 800036d6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005204:	032b0b63          	beq	s6,s2,8000523a <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005208:	004a2603          	lw	a2,4(s4)
    8000520c:	fb040593          	addi	a1,s0,-80
    80005210:	8526                	mv	a0,s1
    80005212:	fffff097          	auipc	ra,0xfffff
    80005216:	c84080e7          	jalr	-892(ra) # 80003e96 <dirlink>
    8000521a:	06054f63          	bltz	a0,80005298 <create+0x15a>
  iunlockput(dp);
    8000521e:	8526                	mv	a0,s1
    80005220:	ffffe097          	auipc	ra,0xffffe
    80005224:	7e4080e7          	jalr	2020(ra) # 80003a04 <iunlockput>
  return ip;
    80005228:	8ad2                	mv	s5,s4
    8000522a:	b759                	j	800051b0 <create+0x72>
    iunlockput(dp);
    8000522c:	8526                	mv	a0,s1
    8000522e:	ffffe097          	auipc	ra,0xffffe
    80005232:	7d6080e7          	jalr	2006(ra) # 80003a04 <iunlockput>
    return 0;
    80005236:	8ad2                	mv	s5,s4
    80005238:	bfa5                	j	800051b0 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000523a:	004a2603          	lw	a2,4(s4)
    8000523e:	00003597          	auipc	a1,0x3
    80005242:	4ea58593          	addi	a1,a1,1258 # 80008728 <syscalls+0x2b0>
    80005246:	8552                	mv	a0,s4
    80005248:	fffff097          	auipc	ra,0xfffff
    8000524c:	c4e080e7          	jalr	-946(ra) # 80003e96 <dirlink>
    80005250:	04054463          	bltz	a0,80005298 <create+0x15a>
    80005254:	40d0                	lw	a2,4(s1)
    80005256:	00003597          	auipc	a1,0x3
    8000525a:	4da58593          	addi	a1,a1,1242 # 80008730 <syscalls+0x2b8>
    8000525e:	8552                	mv	a0,s4
    80005260:	fffff097          	auipc	ra,0xfffff
    80005264:	c36080e7          	jalr	-970(ra) # 80003e96 <dirlink>
    80005268:	02054863          	bltz	a0,80005298 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    8000526c:	004a2603          	lw	a2,4(s4)
    80005270:	fb040593          	addi	a1,s0,-80
    80005274:	8526                	mv	a0,s1
    80005276:	fffff097          	auipc	ra,0xfffff
    8000527a:	c20080e7          	jalr	-992(ra) # 80003e96 <dirlink>
    8000527e:	00054d63          	bltz	a0,80005298 <create+0x15a>
    dp->nlink++;  // for ".."
    80005282:	04a4d783          	lhu	a5,74(s1)
    80005286:	2785                	addiw	a5,a5,1
    80005288:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000528c:	8526                	mv	a0,s1
    8000528e:	ffffe097          	auipc	ra,0xffffe
    80005292:	448080e7          	jalr	1096(ra) # 800036d6 <iupdate>
    80005296:	b761                	j	8000521e <create+0xe0>
  ip->nlink = 0;
    80005298:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000529c:	8552                	mv	a0,s4
    8000529e:	ffffe097          	auipc	ra,0xffffe
    800052a2:	438080e7          	jalr	1080(ra) # 800036d6 <iupdate>
  iunlockput(ip);
    800052a6:	8552                	mv	a0,s4
    800052a8:	ffffe097          	auipc	ra,0xffffe
    800052ac:	75c080e7          	jalr	1884(ra) # 80003a04 <iunlockput>
  iunlockput(dp);
    800052b0:	8526                	mv	a0,s1
    800052b2:	ffffe097          	auipc	ra,0xffffe
    800052b6:	752080e7          	jalr	1874(ra) # 80003a04 <iunlockput>
  return 0;
    800052ba:	bddd                	j	800051b0 <create+0x72>
    return 0;
    800052bc:	8aaa                	mv	s5,a0
    800052be:	bdcd                	j	800051b0 <create+0x72>

00000000800052c0 <sys_dup>:
{
    800052c0:	7179                	addi	sp,sp,-48
    800052c2:	f406                	sd	ra,40(sp)
    800052c4:	f022                	sd	s0,32(sp)
    800052c6:	ec26                	sd	s1,24(sp)
    800052c8:	e84a                	sd	s2,16(sp)
    800052ca:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800052cc:	fd840613          	addi	a2,s0,-40
    800052d0:	4581                	li	a1,0
    800052d2:	4501                	li	a0,0
    800052d4:	00000097          	auipc	ra,0x0
    800052d8:	dc8080e7          	jalr	-568(ra) # 8000509c <argfd>
    return -1;
    800052dc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800052de:	02054363          	bltz	a0,80005304 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800052e2:	fd843903          	ld	s2,-40(s0)
    800052e6:	854a                	mv	a0,s2
    800052e8:	00000097          	auipc	ra,0x0
    800052ec:	e14080e7          	jalr	-492(ra) # 800050fc <fdalloc>
    800052f0:	84aa                	mv	s1,a0
    return -1;
    800052f2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800052f4:	00054863          	bltz	a0,80005304 <sys_dup+0x44>
  filedup(f);
    800052f8:	854a                	mv	a0,s2
    800052fa:	fffff097          	auipc	ra,0xfffff
    800052fe:	2c0080e7          	jalr	704(ra) # 800045ba <filedup>
  return fd;
    80005302:	87a6                	mv	a5,s1
}
    80005304:	853e                	mv	a0,a5
    80005306:	70a2                	ld	ra,40(sp)
    80005308:	7402                	ld	s0,32(sp)
    8000530a:	64e2                	ld	s1,24(sp)
    8000530c:	6942                	ld	s2,16(sp)
    8000530e:	6145                	addi	sp,sp,48
    80005310:	8082                	ret

0000000080005312 <sys_read>:
{
    80005312:	7179                	addi	sp,sp,-48
    80005314:	f406                	sd	ra,40(sp)
    80005316:	f022                	sd	s0,32(sp)
    80005318:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000531a:	fd840593          	addi	a1,s0,-40
    8000531e:	4505                	li	a0,1
    80005320:	ffffe097          	auipc	ra,0xffffe
    80005324:	940080e7          	jalr	-1728(ra) # 80002c60 <argaddr>
  argint(2, &n);
    80005328:	fe440593          	addi	a1,s0,-28
    8000532c:	4509                	li	a0,2
    8000532e:	ffffe097          	auipc	ra,0xffffe
    80005332:	912080e7          	jalr	-1774(ra) # 80002c40 <argint>
  if(argfd(0, 0, &f) < 0)
    80005336:	fe840613          	addi	a2,s0,-24
    8000533a:	4581                	li	a1,0
    8000533c:	4501                	li	a0,0
    8000533e:	00000097          	auipc	ra,0x0
    80005342:	d5e080e7          	jalr	-674(ra) # 8000509c <argfd>
    80005346:	87aa                	mv	a5,a0
    return -1;
    80005348:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000534a:	0007cc63          	bltz	a5,80005362 <sys_read+0x50>
  return fileread(f, p, n);
    8000534e:	fe442603          	lw	a2,-28(s0)
    80005352:	fd843583          	ld	a1,-40(s0)
    80005356:	fe843503          	ld	a0,-24(s0)
    8000535a:	fffff097          	auipc	ra,0xfffff
    8000535e:	3ec080e7          	jalr	1004(ra) # 80004746 <fileread>
}
    80005362:	70a2                	ld	ra,40(sp)
    80005364:	7402                	ld	s0,32(sp)
    80005366:	6145                	addi	sp,sp,48
    80005368:	8082                	ret

000000008000536a <sys_write>:
{
    8000536a:	7179                	addi	sp,sp,-48
    8000536c:	f406                	sd	ra,40(sp)
    8000536e:	f022                	sd	s0,32(sp)
    80005370:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005372:	fd840593          	addi	a1,s0,-40
    80005376:	4505                	li	a0,1
    80005378:	ffffe097          	auipc	ra,0xffffe
    8000537c:	8e8080e7          	jalr	-1816(ra) # 80002c60 <argaddr>
  argint(2, &n);
    80005380:	fe440593          	addi	a1,s0,-28
    80005384:	4509                	li	a0,2
    80005386:	ffffe097          	auipc	ra,0xffffe
    8000538a:	8ba080e7          	jalr	-1862(ra) # 80002c40 <argint>
  if(argfd(0, 0, &f) < 0)
    8000538e:	fe840613          	addi	a2,s0,-24
    80005392:	4581                	li	a1,0
    80005394:	4501                	li	a0,0
    80005396:	00000097          	auipc	ra,0x0
    8000539a:	d06080e7          	jalr	-762(ra) # 8000509c <argfd>
    8000539e:	87aa                	mv	a5,a0
    return -1;
    800053a0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053a2:	0007cc63          	bltz	a5,800053ba <sys_write+0x50>
  return filewrite(f, p, n);
    800053a6:	fe442603          	lw	a2,-28(s0)
    800053aa:	fd843583          	ld	a1,-40(s0)
    800053ae:	fe843503          	ld	a0,-24(s0)
    800053b2:	fffff097          	auipc	ra,0xfffff
    800053b6:	456080e7          	jalr	1110(ra) # 80004808 <filewrite>
}
    800053ba:	70a2                	ld	ra,40(sp)
    800053bc:	7402                	ld	s0,32(sp)
    800053be:	6145                	addi	sp,sp,48
    800053c0:	8082                	ret

00000000800053c2 <sys_close>:
{
    800053c2:	1101                	addi	sp,sp,-32
    800053c4:	ec06                	sd	ra,24(sp)
    800053c6:	e822                	sd	s0,16(sp)
    800053c8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800053ca:	fe040613          	addi	a2,s0,-32
    800053ce:	fec40593          	addi	a1,s0,-20
    800053d2:	4501                	li	a0,0
    800053d4:	00000097          	auipc	ra,0x0
    800053d8:	cc8080e7          	jalr	-824(ra) # 8000509c <argfd>
    return -1;
    800053dc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800053de:	02054463          	bltz	a0,80005406 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800053e2:	ffffc097          	auipc	ra,0xffffc
    800053e6:	600080e7          	jalr	1536(ra) # 800019e2 <myproc>
    800053ea:	fec42783          	lw	a5,-20(s0)
    800053ee:	07e9                	addi	a5,a5,26
    800053f0:	078e                	slli	a5,a5,0x3
    800053f2:	953e                	add	a0,a0,a5
    800053f4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800053f8:	fe043503          	ld	a0,-32(s0)
    800053fc:	fffff097          	auipc	ra,0xfffff
    80005400:	210080e7          	jalr	528(ra) # 8000460c <fileclose>
  return 0;
    80005404:	4781                	li	a5,0
}
    80005406:	853e                	mv	a0,a5
    80005408:	60e2                	ld	ra,24(sp)
    8000540a:	6442                	ld	s0,16(sp)
    8000540c:	6105                	addi	sp,sp,32
    8000540e:	8082                	ret

0000000080005410 <sys_fstat>:
{
    80005410:	1101                	addi	sp,sp,-32
    80005412:	ec06                	sd	ra,24(sp)
    80005414:	e822                	sd	s0,16(sp)
    80005416:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005418:	fe040593          	addi	a1,s0,-32
    8000541c:	4505                	li	a0,1
    8000541e:	ffffe097          	auipc	ra,0xffffe
    80005422:	842080e7          	jalr	-1982(ra) # 80002c60 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005426:	fe840613          	addi	a2,s0,-24
    8000542a:	4581                	li	a1,0
    8000542c:	4501                	li	a0,0
    8000542e:	00000097          	auipc	ra,0x0
    80005432:	c6e080e7          	jalr	-914(ra) # 8000509c <argfd>
    80005436:	87aa                	mv	a5,a0
    return -1;
    80005438:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000543a:	0007ca63          	bltz	a5,8000544e <sys_fstat+0x3e>
  return filestat(f, st);
    8000543e:	fe043583          	ld	a1,-32(s0)
    80005442:	fe843503          	ld	a0,-24(s0)
    80005446:	fffff097          	auipc	ra,0xfffff
    8000544a:	28e080e7          	jalr	654(ra) # 800046d4 <filestat>
}
    8000544e:	60e2                	ld	ra,24(sp)
    80005450:	6442                	ld	s0,16(sp)
    80005452:	6105                	addi	sp,sp,32
    80005454:	8082                	ret

0000000080005456 <sys_link>:
{
    80005456:	7169                	addi	sp,sp,-304
    80005458:	f606                	sd	ra,296(sp)
    8000545a:	f222                	sd	s0,288(sp)
    8000545c:	ee26                	sd	s1,280(sp)
    8000545e:	ea4a                	sd	s2,272(sp)
    80005460:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005462:	08000613          	li	a2,128
    80005466:	ed040593          	addi	a1,s0,-304
    8000546a:	4501                	li	a0,0
    8000546c:	ffffe097          	auipc	ra,0xffffe
    80005470:	814080e7          	jalr	-2028(ra) # 80002c80 <argstr>
    return -1;
    80005474:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005476:	10054e63          	bltz	a0,80005592 <sys_link+0x13c>
    8000547a:	08000613          	li	a2,128
    8000547e:	f5040593          	addi	a1,s0,-176
    80005482:	4505                	li	a0,1
    80005484:	ffffd097          	auipc	ra,0xffffd
    80005488:	7fc080e7          	jalr	2044(ra) # 80002c80 <argstr>
    return -1;
    8000548c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000548e:	10054263          	bltz	a0,80005592 <sys_link+0x13c>
  begin_op();
    80005492:	fffff097          	auipc	ra,0xfffff
    80005496:	cb6080e7          	jalr	-842(ra) # 80004148 <begin_op>
  if((ip = namei(old)) == 0){
    8000549a:	ed040513          	addi	a0,s0,-304
    8000549e:	fffff097          	auipc	ra,0xfffff
    800054a2:	aaa080e7          	jalr	-1366(ra) # 80003f48 <namei>
    800054a6:	84aa                	mv	s1,a0
    800054a8:	c551                	beqz	a0,80005534 <sys_link+0xde>
  ilock(ip);
    800054aa:	ffffe097          	auipc	ra,0xffffe
    800054ae:	2f8080e7          	jalr	760(ra) # 800037a2 <ilock>
  if(ip->type == T_DIR){
    800054b2:	04449703          	lh	a4,68(s1)
    800054b6:	4785                	li	a5,1
    800054b8:	08f70463          	beq	a4,a5,80005540 <sys_link+0xea>
  ip->nlink++;
    800054bc:	04a4d783          	lhu	a5,74(s1)
    800054c0:	2785                	addiw	a5,a5,1
    800054c2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054c6:	8526                	mv	a0,s1
    800054c8:	ffffe097          	auipc	ra,0xffffe
    800054cc:	20e080e7          	jalr	526(ra) # 800036d6 <iupdate>
  iunlock(ip);
    800054d0:	8526                	mv	a0,s1
    800054d2:	ffffe097          	auipc	ra,0xffffe
    800054d6:	392080e7          	jalr	914(ra) # 80003864 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800054da:	fd040593          	addi	a1,s0,-48
    800054de:	f5040513          	addi	a0,s0,-176
    800054e2:	fffff097          	auipc	ra,0xfffff
    800054e6:	a84080e7          	jalr	-1404(ra) # 80003f66 <nameiparent>
    800054ea:	892a                	mv	s2,a0
    800054ec:	c935                	beqz	a0,80005560 <sys_link+0x10a>
  ilock(dp);
    800054ee:	ffffe097          	auipc	ra,0xffffe
    800054f2:	2b4080e7          	jalr	692(ra) # 800037a2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800054f6:	00092703          	lw	a4,0(s2)
    800054fa:	409c                	lw	a5,0(s1)
    800054fc:	04f71d63          	bne	a4,a5,80005556 <sys_link+0x100>
    80005500:	40d0                	lw	a2,4(s1)
    80005502:	fd040593          	addi	a1,s0,-48
    80005506:	854a                	mv	a0,s2
    80005508:	fffff097          	auipc	ra,0xfffff
    8000550c:	98e080e7          	jalr	-1650(ra) # 80003e96 <dirlink>
    80005510:	04054363          	bltz	a0,80005556 <sys_link+0x100>
  iunlockput(dp);
    80005514:	854a                	mv	a0,s2
    80005516:	ffffe097          	auipc	ra,0xffffe
    8000551a:	4ee080e7          	jalr	1262(ra) # 80003a04 <iunlockput>
  iput(ip);
    8000551e:	8526                	mv	a0,s1
    80005520:	ffffe097          	auipc	ra,0xffffe
    80005524:	43c080e7          	jalr	1084(ra) # 8000395c <iput>
  end_op();
    80005528:	fffff097          	auipc	ra,0xfffff
    8000552c:	c9a080e7          	jalr	-870(ra) # 800041c2 <end_op>
  return 0;
    80005530:	4781                	li	a5,0
    80005532:	a085                	j	80005592 <sys_link+0x13c>
    end_op();
    80005534:	fffff097          	auipc	ra,0xfffff
    80005538:	c8e080e7          	jalr	-882(ra) # 800041c2 <end_op>
    return -1;
    8000553c:	57fd                	li	a5,-1
    8000553e:	a891                	j	80005592 <sys_link+0x13c>
    iunlockput(ip);
    80005540:	8526                	mv	a0,s1
    80005542:	ffffe097          	auipc	ra,0xffffe
    80005546:	4c2080e7          	jalr	1218(ra) # 80003a04 <iunlockput>
    end_op();
    8000554a:	fffff097          	auipc	ra,0xfffff
    8000554e:	c78080e7          	jalr	-904(ra) # 800041c2 <end_op>
    return -1;
    80005552:	57fd                	li	a5,-1
    80005554:	a83d                	j	80005592 <sys_link+0x13c>
    iunlockput(dp);
    80005556:	854a                	mv	a0,s2
    80005558:	ffffe097          	auipc	ra,0xffffe
    8000555c:	4ac080e7          	jalr	1196(ra) # 80003a04 <iunlockput>
  ilock(ip);
    80005560:	8526                	mv	a0,s1
    80005562:	ffffe097          	auipc	ra,0xffffe
    80005566:	240080e7          	jalr	576(ra) # 800037a2 <ilock>
  ip->nlink--;
    8000556a:	04a4d783          	lhu	a5,74(s1)
    8000556e:	37fd                	addiw	a5,a5,-1
    80005570:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005574:	8526                	mv	a0,s1
    80005576:	ffffe097          	auipc	ra,0xffffe
    8000557a:	160080e7          	jalr	352(ra) # 800036d6 <iupdate>
  iunlockput(ip);
    8000557e:	8526                	mv	a0,s1
    80005580:	ffffe097          	auipc	ra,0xffffe
    80005584:	484080e7          	jalr	1156(ra) # 80003a04 <iunlockput>
  end_op();
    80005588:	fffff097          	auipc	ra,0xfffff
    8000558c:	c3a080e7          	jalr	-966(ra) # 800041c2 <end_op>
  return -1;
    80005590:	57fd                	li	a5,-1
}
    80005592:	853e                	mv	a0,a5
    80005594:	70b2                	ld	ra,296(sp)
    80005596:	7412                	ld	s0,288(sp)
    80005598:	64f2                	ld	s1,280(sp)
    8000559a:	6952                	ld	s2,272(sp)
    8000559c:	6155                	addi	sp,sp,304
    8000559e:	8082                	ret

00000000800055a0 <sys_unlink>:
{
    800055a0:	7151                	addi	sp,sp,-240
    800055a2:	f586                	sd	ra,232(sp)
    800055a4:	f1a2                	sd	s0,224(sp)
    800055a6:	eda6                	sd	s1,216(sp)
    800055a8:	e9ca                	sd	s2,208(sp)
    800055aa:	e5ce                	sd	s3,200(sp)
    800055ac:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800055ae:	08000613          	li	a2,128
    800055b2:	f3040593          	addi	a1,s0,-208
    800055b6:	4501                	li	a0,0
    800055b8:	ffffd097          	auipc	ra,0xffffd
    800055bc:	6c8080e7          	jalr	1736(ra) # 80002c80 <argstr>
    800055c0:	18054163          	bltz	a0,80005742 <sys_unlink+0x1a2>
  begin_op();
    800055c4:	fffff097          	auipc	ra,0xfffff
    800055c8:	b84080e7          	jalr	-1148(ra) # 80004148 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800055cc:	fb040593          	addi	a1,s0,-80
    800055d0:	f3040513          	addi	a0,s0,-208
    800055d4:	fffff097          	auipc	ra,0xfffff
    800055d8:	992080e7          	jalr	-1646(ra) # 80003f66 <nameiparent>
    800055dc:	84aa                	mv	s1,a0
    800055de:	c979                	beqz	a0,800056b4 <sys_unlink+0x114>
  ilock(dp);
    800055e0:	ffffe097          	auipc	ra,0xffffe
    800055e4:	1c2080e7          	jalr	450(ra) # 800037a2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800055e8:	00003597          	auipc	a1,0x3
    800055ec:	14058593          	addi	a1,a1,320 # 80008728 <syscalls+0x2b0>
    800055f0:	fb040513          	addi	a0,s0,-80
    800055f4:	ffffe097          	auipc	ra,0xffffe
    800055f8:	678080e7          	jalr	1656(ra) # 80003c6c <namecmp>
    800055fc:	14050a63          	beqz	a0,80005750 <sys_unlink+0x1b0>
    80005600:	00003597          	auipc	a1,0x3
    80005604:	13058593          	addi	a1,a1,304 # 80008730 <syscalls+0x2b8>
    80005608:	fb040513          	addi	a0,s0,-80
    8000560c:	ffffe097          	auipc	ra,0xffffe
    80005610:	660080e7          	jalr	1632(ra) # 80003c6c <namecmp>
    80005614:	12050e63          	beqz	a0,80005750 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005618:	f2c40613          	addi	a2,s0,-212
    8000561c:	fb040593          	addi	a1,s0,-80
    80005620:	8526                	mv	a0,s1
    80005622:	ffffe097          	auipc	ra,0xffffe
    80005626:	664080e7          	jalr	1636(ra) # 80003c86 <dirlookup>
    8000562a:	892a                	mv	s2,a0
    8000562c:	12050263          	beqz	a0,80005750 <sys_unlink+0x1b0>
  ilock(ip);
    80005630:	ffffe097          	auipc	ra,0xffffe
    80005634:	172080e7          	jalr	370(ra) # 800037a2 <ilock>
  if(ip->nlink < 1)
    80005638:	04a91783          	lh	a5,74(s2)
    8000563c:	08f05263          	blez	a5,800056c0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005640:	04491703          	lh	a4,68(s2)
    80005644:	4785                	li	a5,1
    80005646:	08f70563          	beq	a4,a5,800056d0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000564a:	4641                	li	a2,16
    8000564c:	4581                	li	a1,0
    8000564e:	fc040513          	addi	a0,s0,-64
    80005652:	ffffb097          	auipc	ra,0xffffb
    80005656:	67c080e7          	jalr	1660(ra) # 80000cce <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000565a:	4741                	li	a4,16
    8000565c:	f2c42683          	lw	a3,-212(s0)
    80005660:	fc040613          	addi	a2,s0,-64
    80005664:	4581                	li	a1,0
    80005666:	8526                	mv	a0,s1
    80005668:	ffffe097          	auipc	ra,0xffffe
    8000566c:	4e6080e7          	jalr	1254(ra) # 80003b4e <writei>
    80005670:	47c1                	li	a5,16
    80005672:	0af51563          	bne	a0,a5,8000571c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005676:	04491703          	lh	a4,68(s2)
    8000567a:	4785                	li	a5,1
    8000567c:	0af70863          	beq	a4,a5,8000572c <sys_unlink+0x18c>
  iunlockput(dp);
    80005680:	8526                	mv	a0,s1
    80005682:	ffffe097          	auipc	ra,0xffffe
    80005686:	382080e7          	jalr	898(ra) # 80003a04 <iunlockput>
  ip->nlink--;
    8000568a:	04a95783          	lhu	a5,74(s2)
    8000568e:	37fd                	addiw	a5,a5,-1
    80005690:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005694:	854a                	mv	a0,s2
    80005696:	ffffe097          	auipc	ra,0xffffe
    8000569a:	040080e7          	jalr	64(ra) # 800036d6 <iupdate>
  iunlockput(ip);
    8000569e:	854a                	mv	a0,s2
    800056a0:	ffffe097          	auipc	ra,0xffffe
    800056a4:	364080e7          	jalr	868(ra) # 80003a04 <iunlockput>
  end_op();
    800056a8:	fffff097          	auipc	ra,0xfffff
    800056ac:	b1a080e7          	jalr	-1254(ra) # 800041c2 <end_op>
  return 0;
    800056b0:	4501                	li	a0,0
    800056b2:	a84d                	j	80005764 <sys_unlink+0x1c4>
    end_op();
    800056b4:	fffff097          	auipc	ra,0xfffff
    800056b8:	b0e080e7          	jalr	-1266(ra) # 800041c2 <end_op>
    return -1;
    800056bc:	557d                	li	a0,-1
    800056be:	a05d                	j	80005764 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800056c0:	00003517          	auipc	a0,0x3
    800056c4:	07850513          	addi	a0,a0,120 # 80008738 <syscalls+0x2c0>
    800056c8:	ffffb097          	auipc	ra,0xffffb
    800056cc:	e74080e7          	jalr	-396(ra) # 8000053c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056d0:	04c92703          	lw	a4,76(s2)
    800056d4:	02000793          	li	a5,32
    800056d8:	f6e7f9e3          	bgeu	a5,a4,8000564a <sys_unlink+0xaa>
    800056dc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056e0:	4741                	li	a4,16
    800056e2:	86ce                	mv	a3,s3
    800056e4:	f1840613          	addi	a2,s0,-232
    800056e8:	4581                	li	a1,0
    800056ea:	854a                	mv	a0,s2
    800056ec:	ffffe097          	auipc	ra,0xffffe
    800056f0:	36a080e7          	jalr	874(ra) # 80003a56 <readi>
    800056f4:	47c1                	li	a5,16
    800056f6:	00f51b63          	bne	a0,a5,8000570c <sys_unlink+0x16c>
    if(de.inum != 0)
    800056fa:	f1845783          	lhu	a5,-232(s0)
    800056fe:	e7a1                	bnez	a5,80005746 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005700:	29c1                	addiw	s3,s3,16
    80005702:	04c92783          	lw	a5,76(s2)
    80005706:	fcf9ede3          	bltu	s3,a5,800056e0 <sys_unlink+0x140>
    8000570a:	b781                	j	8000564a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000570c:	00003517          	auipc	a0,0x3
    80005710:	04450513          	addi	a0,a0,68 # 80008750 <syscalls+0x2d8>
    80005714:	ffffb097          	auipc	ra,0xffffb
    80005718:	e28080e7          	jalr	-472(ra) # 8000053c <panic>
    panic("unlink: writei");
    8000571c:	00003517          	auipc	a0,0x3
    80005720:	04c50513          	addi	a0,a0,76 # 80008768 <syscalls+0x2f0>
    80005724:	ffffb097          	auipc	ra,0xffffb
    80005728:	e18080e7          	jalr	-488(ra) # 8000053c <panic>
    dp->nlink--;
    8000572c:	04a4d783          	lhu	a5,74(s1)
    80005730:	37fd                	addiw	a5,a5,-1
    80005732:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005736:	8526                	mv	a0,s1
    80005738:	ffffe097          	auipc	ra,0xffffe
    8000573c:	f9e080e7          	jalr	-98(ra) # 800036d6 <iupdate>
    80005740:	b781                	j	80005680 <sys_unlink+0xe0>
    return -1;
    80005742:	557d                	li	a0,-1
    80005744:	a005                	j	80005764 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005746:	854a                	mv	a0,s2
    80005748:	ffffe097          	auipc	ra,0xffffe
    8000574c:	2bc080e7          	jalr	700(ra) # 80003a04 <iunlockput>
  iunlockput(dp);
    80005750:	8526                	mv	a0,s1
    80005752:	ffffe097          	auipc	ra,0xffffe
    80005756:	2b2080e7          	jalr	690(ra) # 80003a04 <iunlockput>
  end_op();
    8000575a:	fffff097          	auipc	ra,0xfffff
    8000575e:	a68080e7          	jalr	-1432(ra) # 800041c2 <end_op>
  return -1;
    80005762:	557d                	li	a0,-1
}
    80005764:	70ae                	ld	ra,232(sp)
    80005766:	740e                	ld	s0,224(sp)
    80005768:	64ee                	ld	s1,216(sp)
    8000576a:	694e                	ld	s2,208(sp)
    8000576c:	69ae                	ld	s3,200(sp)
    8000576e:	616d                	addi	sp,sp,240
    80005770:	8082                	ret

0000000080005772 <sys_open>:

uint64
sys_open(void)
{
    80005772:	7131                	addi	sp,sp,-192
    80005774:	fd06                	sd	ra,184(sp)
    80005776:	f922                	sd	s0,176(sp)
    80005778:	f526                	sd	s1,168(sp)
    8000577a:	f14a                	sd	s2,160(sp)
    8000577c:	ed4e                	sd	s3,152(sp)
    8000577e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005780:	f4c40593          	addi	a1,s0,-180
    80005784:	4505                	li	a0,1
    80005786:	ffffd097          	auipc	ra,0xffffd
    8000578a:	4ba080e7          	jalr	1210(ra) # 80002c40 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000578e:	08000613          	li	a2,128
    80005792:	f5040593          	addi	a1,s0,-176
    80005796:	4501                	li	a0,0
    80005798:	ffffd097          	auipc	ra,0xffffd
    8000579c:	4e8080e7          	jalr	1256(ra) # 80002c80 <argstr>
    800057a0:	87aa                	mv	a5,a0
    return -1;
    800057a2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800057a4:	0a07c863          	bltz	a5,80005854 <sys_open+0xe2>

  begin_op();
    800057a8:	fffff097          	auipc	ra,0xfffff
    800057ac:	9a0080e7          	jalr	-1632(ra) # 80004148 <begin_op>

  if(omode & O_CREATE){
    800057b0:	f4c42783          	lw	a5,-180(s0)
    800057b4:	2007f793          	andi	a5,a5,512
    800057b8:	cbdd                	beqz	a5,8000586e <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    800057ba:	4681                	li	a3,0
    800057bc:	4601                	li	a2,0
    800057be:	4589                	li	a1,2
    800057c0:	f5040513          	addi	a0,s0,-176
    800057c4:	00000097          	auipc	ra,0x0
    800057c8:	97a080e7          	jalr	-1670(ra) # 8000513e <create>
    800057cc:	84aa                	mv	s1,a0
    if(ip == 0){
    800057ce:	c951                	beqz	a0,80005862 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800057d0:	04449703          	lh	a4,68(s1)
    800057d4:	478d                	li	a5,3
    800057d6:	00f71763          	bne	a4,a5,800057e4 <sys_open+0x72>
    800057da:	0464d703          	lhu	a4,70(s1)
    800057de:	47a5                	li	a5,9
    800057e0:	0ce7ec63          	bltu	a5,a4,800058b8 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800057e4:	fffff097          	auipc	ra,0xfffff
    800057e8:	d6c080e7          	jalr	-660(ra) # 80004550 <filealloc>
    800057ec:	892a                	mv	s2,a0
    800057ee:	c56d                	beqz	a0,800058d8 <sys_open+0x166>
    800057f0:	00000097          	auipc	ra,0x0
    800057f4:	90c080e7          	jalr	-1780(ra) # 800050fc <fdalloc>
    800057f8:	89aa                	mv	s3,a0
    800057fa:	0c054a63          	bltz	a0,800058ce <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800057fe:	04449703          	lh	a4,68(s1)
    80005802:	478d                	li	a5,3
    80005804:	0ef70563          	beq	a4,a5,800058ee <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005808:	4789                	li	a5,2
    8000580a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000580e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005812:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005816:	f4c42783          	lw	a5,-180(s0)
    8000581a:	0017c713          	xori	a4,a5,1
    8000581e:	8b05                	andi	a4,a4,1
    80005820:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005824:	0037f713          	andi	a4,a5,3
    80005828:	00e03733          	snez	a4,a4
    8000582c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005830:	4007f793          	andi	a5,a5,1024
    80005834:	c791                	beqz	a5,80005840 <sys_open+0xce>
    80005836:	04449703          	lh	a4,68(s1)
    8000583a:	4789                	li	a5,2
    8000583c:	0cf70063          	beq	a4,a5,800058fc <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80005840:	8526                	mv	a0,s1
    80005842:	ffffe097          	auipc	ra,0xffffe
    80005846:	022080e7          	jalr	34(ra) # 80003864 <iunlock>
  end_op();
    8000584a:	fffff097          	auipc	ra,0xfffff
    8000584e:	978080e7          	jalr	-1672(ra) # 800041c2 <end_op>

  return fd;
    80005852:	854e                	mv	a0,s3
}
    80005854:	70ea                	ld	ra,184(sp)
    80005856:	744a                	ld	s0,176(sp)
    80005858:	74aa                	ld	s1,168(sp)
    8000585a:	790a                	ld	s2,160(sp)
    8000585c:	69ea                	ld	s3,152(sp)
    8000585e:	6129                	addi	sp,sp,192
    80005860:	8082                	ret
      end_op();
    80005862:	fffff097          	auipc	ra,0xfffff
    80005866:	960080e7          	jalr	-1696(ra) # 800041c2 <end_op>
      return -1;
    8000586a:	557d                	li	a0,-1
    8000586c:	b7e5                	j	80005854 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    8000586e:	f5040513          	addi	a0,s0,-176
    80005872:	ffffe097          	auipc	ra,0xffffe
    80005876:	6d6080e7          	jalr	1750(ra) # 80003f48 <namei>
    8000587a:	84aa                	mv	s1,a0
    8000587c:	c905                	beqz	a0,800058ac <sys_open+0x13a>
    ilock(ip);
    8000587e:	ffffe097          	auipc	ra,0xffffe
    80005882:	f24080e7          	jalr	-220(ra) # 800037a2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005886:	04449703          	lh	a4,68(s1)
    8000588a:	4785                	li	a5,1
    8000588c:	f4f712e3          	bne	a4,a5,800057d0 <sys_open+0x5e>
    80005890:	f4c42783          	lw	a5,-180(s0)
    80005894:	dba1                	beqz	a5,800057e4 <sys_open+0x72>
      iunlockput(ip);
    80005896:	8526                	mv	a0,s1
    80005898:	ffffe097          	auipc	ra,0xffffe
    8000589c:	16c080e7          	jalr	364(ra) # 80003a04 <iunlockput>
      end_op();
    800058a0:	fffff097          	auipc	ra,0xfffff
    800058a4:	922080e7          	jalr	-1758(ra) # 800041c2 <end_op>
      return -1;
    800058a8:	557d                	li	a0,-1
    800058aa:	b76d                	j	80005854 <sys_open+0xe2>
      end_op();
    800058ac:	fffff097          	auipc	ra,0xfffff
    800058b0:	916080e7          	jalr	-1770(ra) # 800041c2 <end_op>
      return -1;
    800058b4:	557d                	li	a0,-1
    800058b6:	bf79                	j	80005854 <sys_open+0xe2>
    iunlockput(ip);
    800058b8:	8526                	mv	a0,s1
    800058ba:	ffffe097          	auipc	ra,0xffffe
    800058be:	14a080e7          	jalr	330(ra) # 80003a04 <iunlockput>
    end_op();
    800058c2:	fffff097          	auipc	ra,0xfffff
    800058c6:	900080e7          	jalr	-1792(ra) # 800041c2 <end_op>
    return -1;
    800058ca:	557d                	li	a0,-1
    800058cc:	b761                	j	80005854 <sys_open+0xe2>
      fileclose(f);
    800058ce:	854a                	mv	a0,s2
    800058d0:	fffff097          	auipc	ra,0xfffff
    800058d4:	d3c080e7          	jalr	-708(ra) # 8000460c <fileclose>
    iunlockput(ip);
    800058d8:	8526                	mv	a0,s1
    800058da:	ffffe097          	auipc	ra,0xffffe
    800058de:	12a080e7          	jalr	298(ra) # 80003a04 <iunlockput>
    end_op();
    800058e2:	fffff097          	auipc	ra,0xfffff
    800058e6:	8e0080e7          	jalr	-1824(ra) # 800041c2 <end_op>
    return -1;
    800058ea:	557d                	li	a0,-1
    800058ec:	b7a5                	j	80005854 <sys_open+0xe2>
    f->type = FD_DEVICE;
    800058ee:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800058f2:	04649783          	lh	a5,70(s1)
    800058f6:	02f91223          	sh	a5,36(s2)
    800058fa:	bf21                	j	80005812 <sys_open+0xa0>
    itrunc(ip);
    800058fc:	8526                	mv	a0,s1
    800058fe:	ffffe097          	auipc	ra,0xffffe
    80005902:	fb2080e7          	jalr	-78(ra) # 800038b0 <itrunc>
    80005906:	bf2d                	j	80005840 <sys_open+0xce>

0000000080005908 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005908:	7175                	addi	sp,sp,-144
    8000590a:	e506                	sd	ra,136(sp)
    8000590c:	e122                	sd	s0,128(sp)
    8000590e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005910:	fffff097          	auipc	ra,0xfffff
    80005914:	838080e7          	jalr	-1992(ra) # 80004148 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005918:	08000613          	li	a2,128
    8000591c:	f7040593          	addi	a1,s0,-144
    80005920:	4501                	li	a0,0
    80005922:	ffffd097          	auipc	ra,0xffffd
    80005926:	35e080e7          	jalr	862(ra) # 80002c80 <argstr>
    8000592a:	02054963          	bltz	a0,8000595c <sys_mkdir+0x54>
    8000592e:	4681                	li	a3,0
    80005930:	4601                	li	a2,0
    80005932:	4585                	li	a1,1
    80005934:	f7040513          	addi	a0,s0,-144
    80005938:	00000097          	auipc	ra,0x0
    8000593c:	806080e7          	jalr	-2042(ra) # 8000513e <create>
    80005940:	cd11                	beqz	a0,8000595c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005942:	ffffe097          	auipc	ra,0xffffe
    80005946:	0c2080e7          	jalr	194(ra) # 80003a04 <iunlockput>
  end_op();
    8000594a:	fffff097          	auipc	ra,0xfffff
    8000594e:	878080e7          	jalr	-1928(ra) # 800041c2 <end_op>
  return 0;
    80005952:	4501                	li	a0,0
}
    80005954:	60aa                	ld	ra,136(sp)
    80005956:	640a                	ld	s0,128(sp)
    80005958:	6149                	addi	sp,sp,144
    8000595a:	8082                	ret
    end_op();
    8000595c:	fffff097          	auipc	ra,0xfffff
    80005960:	866080e7          	jalr	-1946(ra) # 800041c2 <end_op>
    return -1;
    80005964:	557d                	li	a0,-1
    80005966:	b7fd                	j	80005954 <sys_mkdir+0x4c>

0000000080005968 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005968:	7135                	addi	sp,sp,-160
    8000596a:	ed06                	sd	ra,152(sp)
    8000596c:	e922                	sd	s0,144(sp)
    8000596e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005970:	ffffe097          	auipc	ra,0xffffe
    80005974:	7d8080e7          	jalr	2008(ra) # 80004148 <begin_op>
  argint(1, &major);
    80005978:	f6c40593          	addi	a1,s0,-148
    8000597c:	4505                	li	a0,1
    8000597e:	ffffd097          	auipc	ra,0xffffd
    80005982:	2c2080e7          	jalr	706(ra) # 80002c40 <argint>
  argint(2, &minor);
    80005986:	f6840593          	addi	a1,s0,-152
    8000598a:	4509                	li	a0,2
    8000598c:	ffffd097          	auipc	ra,0xffffd
    80005990:	2b4080e7          	jalr	692(ra) # 80002c40 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005994:	08000613          	li	a2,128
    80005998:	f7040593          	addi	a1,s0,-144
    8000599c:	4501                	li	a0,0
    8000599e:	ffffd097          	auipc	ra,0xffffd
    800059a2:	2e2080e7          	jalr	738(ra) # 80002c80 <argstr>
    800059a6:	02054b63          	bltz	a0,800059dc <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800059aa:	f6841683          	lh	a3,-152(s0)
    800059ae:	f6c41603          	lh	a2,-148(s0)
    800059b2:	458d                	li	a1,3
    800059b4:	f7040513          	addi	a0,s0,-144
    800059b8:	fffff097          	auipc	ra,0xfffff
    800059bc:	786080e7          	jalr	1926(ra) # 8000513e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800059c0:	cd11                	beqz	a0,800059dc <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059c2:	ffffe097          	auipc	ra,0xffffe
    800059c6:	042080e7          	jalr	66(ra) # 80003a04 <iunlockput>
  end_op();
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	7f8080e7          	jalr	2040(ra) # 800041c2 <end_op>
  return 0;
    800059d2:	4501                	li	a0,0
}
    800059d4:	60ea                	ld	ra,152(sp)
    800059d6:	644a                	ld	s0,144(sp)
    800059d8:	610d                	addi	sp,sp,160
    800059da:	8082                	ret
    end_op();
    800059dc:	ffffe097          	auipc	ra,0xffffe
    800059e0:	7e6080e7          	jalr	2022(ra) # 800041c2 <end_op>
    return -1;
    800059e4:	557d                	li	a0,-1
    800059e6:	b7fd                	j	800059d4 <sys_mknod+0x6c>

00000000800059e8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800059e8:	7135                	addi	sp,sp,-160
    800059ea:	ed06                	sd	ra,152(sp)
    800059ec:	e922                	sd	s0,144(sp)
    800059ee:	e526                	sd	s1,136(sp)
    800059f0:	e14a                	sd	s2,128(sp)
    800059f2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800059f4:	ffffc097          	auipc	ra,0xffffc
    800059f8:	fee080e7          	jalr	-18(ra) # 800019e2 <myproc>
    800059fc:	892a                	mv	s2,a0
  
  begin_op();
    800059fe:	ffffe097          	auipc	ra,0xffffe
    80005a02:	74a080e7          	jalr	1866(ra) # 80004148 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a06:	08000613          	li	a2,128
    80005a0a:	f6040593          	addi	a1,s0,-160
    80005a0e:	4501                	li	a0,0
    80005a10:	ffffd097          	auipc	ra,0xffffd
    80005a14:	270080e7          	jalr	624(ra) # 80002c80 <argstr>
    80005a18:	04054b63          	bltz	a0,80005a6e <sys_chdir+0x86>
    80005a1c:	f6040513          	addi	a0,s0,-160
    80005a20:	ffffe097          	auipc	ra,0xffffe
    80005a24:	528080e7          	jalr	1320(ra) # 80003f48 <namei>
    80005a28:	84aa                	mv	s1,a0
    80005a2a:	c131                	beqz	a0,80005a6e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	d76080e7          	jalr	-650(ra) # 800037a2 <ilock>
  if(ip->type != T_DIR){
    80005a34:	04449703          	lh	a4,68(s1)
    80005a38:	4785                	li	a5,1
    80005a3a:	04f71063          	bne	a4,a5,80005a7a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005a3e:	8526                	mv	a0,s1
    80005a40:	ffffe097          	auipc	ra,0xffffe
    80005a44:	e24080e7          	jalr	-476(ra) # 80003864 <iunlock>
  iput(p->cwd);
    80005a48:	15093503          	ld	a0,336(s2)
    80005a4c:	ffffe097          	auipc	ra,0xffffe
    80005a50:	f10080e7          	jalr	-240(ra) # 8000395c <iput>
  end_op();
    80005a54:	ffffe097          	auipc	ra,0xffffe
    80005a58:	76e080e7          	jalr	1902(ra) # 800041c2 <end_op>
  p->cwd = ip;
    80005a5c:	14993823          	sd	s1,336(s2)
  return 0;
    80005a60:	4501                	li	a0,0
}
    80005a62:	60ea                	ld	ra,152(sp)
    80005a64:	644a                	ld	s0,144(sp)
    80005a66:	64aa                	ld	s1,136(sp)
    80005a68:	690a                	ld	s2,128(sp)
    80005a6a:	610d                	addi	sp,sp,160
    80005a6c:	8082                	ret
    end_op();
    80005a6e:	ffffe097          	auipc	ra,0xffffe
    80005a72:	754080e7          	jalr	1876(ra) # 800041c2 <end_op>
    return -1;
    80005a76:	557d                	li	a0,-1
    80005a78:	b7ed                	j	80005a62 <sys_chdir+0x7a>
    iunlockput(ip);
    80005a7a:	8526                	mv	a0,s1
    80005a7c:	ffffe097          	auipc	ra,0xffffe
    80005a80:	f88080e7          	jalr	-120(ra) # 80003a04 <iunlockput>
    end_op();
    80005a84:	ffffe097          	auipc	ra,0xffffe
    80005a88:	73e080e7          	jalr	1854(ra) # 800041c2 <end_op>
    return -1;
    80005a8c:	557d                	li	a0,-1
    80005a8e:	bfd1                	j	80005a62 <sys_chdir+0x7a>

0000000080005a90 <sys_exec>:

uint64
sys_exec(void)
{
    80005a90:	7121                	addi	sp,sp,-448
    80005a92:	ff06                	sd	ra,440(sp)
    80005a94:	fb22                	sd	s0,432(sp)
    80005a96:	f726                	sd	s1,424(sp)
    80005a98:	f34a                	sd	s2,416(sp)
    80005a9a:	ef4e                	sd	s3,408(sp)
    80005a9c:	eb52                	sd	s4,400(sp)
    80005a9e:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005aa0:	e4840593          	addi	a1,s0,-440
    80005aa4:	4505                	li	a0,1
    80005aa6:	ffffd097          	auipc	ra,0xffffd
    80005aaa:	1ba080e7          	jalr	442(ra) # 80002c60 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005aae:	08000613          	li	a2,128
    80005ab2:	f5040593          	addi	a1,s0,-176
    80005ab6:	4501                	li	a0,0
    80005ab8:	ffffd097          	auipc	ra,0xffffd
    80005abc:	1c8080e7          	jalr	456(ra) # 80002c80 <argstr>
    80005ac0:	87aa                	mv	a5,a0
    return -1;
    80005ac2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005ac4:	0c07c263          	bltz	a5,80005b88 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005ac8:	10000613          	li	a2,256
    80005acc:	4581                	li	a1,0
    80005ace:	e5040513          	addi	a0,s0,-432
    80005ad2:	ffffb097          	auipc	ra,0xffffb
    80005ad6:	1fc080e7          	jalr	508(ra) # 80000cce <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005ada:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005ade:	89a6                	mv	s3,s1
    80005ae0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005ae2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005ae6:	00391513          	slli	a0,s2,0x3
    80005aea:	e4040593          	addi	a1,s0,-448
    80005aee:	e4843783          	ld	a5,-440(s0)
    80005af2:	953e                	add	a0,a0,a5
    80005af4:	ffffd097          	auipc	ra,0xffffd
    80005af8:	0ae080e7          	jalr	174(ra) # 80002ba2 <fetchaddr>
    80005afc:	02054a63          	bltz	a0,80005b30 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005b00:	e4043783          	ld	a5,-448(s0)
    80005b04:	c3b9                	beqz	a5,80005b4a <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b06:	ffffb097          	auipc	ra,0xffffb
    80005b0a:	fdc080e7          	jalr	-36(ra) # 80000ae2 <kalloc>
    80005b0e:	85aa                	mv	a1,a0
    80005b10:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005b14:	cd11                	beqz	a0,80005b30 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005b16:	6605                	lui	a2,0x1
    80005b18:	e4043503          	ld	a0,-448(s0)
    80005b1c:	ffffd097          	auipc	ra,0xffffd
    80005b20:	0d8080e7          	jalr	216(ra) # 80002bf4 <fetchstr>
    80005b24:	00054663          	bltz	a0,80005b30 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005b28:	0905                	addi	s2,s2,1
    80005b2a:	09a1                	addi	s3,s3,8
    80005b2c:	fb491de3          	bne	s2,s4,80005ae6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b30:	f5040913          	addi	s2,s0,-176
    80005b34:	6088                	ld	a0,0(s1)
    80005b36:	c921                	beqz	a0,80005b86 <sys_exec+0xf6>
    kfree(argv[i]);
    80005b38:	ffffb097          	auipc	ra,0xffffb
    80005b3c:	eac080e7          	jalr	-340(ra) # 800009e4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b40:	04a1                	addi	s1,s1,8
    80005b42:	ff2499e3          	bne	s1,s2,80005b34 <sys_exec+0xa4>
  return -1;
    80005b46:	557d                	li	a0,-1
    80005b48:	a081                	j	80005b88 <sys_exec+0xf8>
      argv[i] = 0;
    80005b4a:	0009079b          	sext.w	a5,s2
    80005b4e:	078e                	slli	a5,a5,0x3
    80005b50:	fd078793          	addi	a5,a5,-48
    80005b54:	97a2                	add	a5,a5,s0
    80005b56:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005b5a:	e5040593          	addi	a1,s0,-432
    80005b5e:	f5040513          	addi	a0,s0,-176
    80005b62:	fffff097          	auipc	ra,0xfffff
    80005b66:	1ca080e7          	jalr	458(ra) # 80004d2c <exec>
    80005b6a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b6c:	f5040993          	addi	s3,s0,-176
    80005b70:	6088                	ld	a0,0(s1)
    80005b72:	c901                	beqz	a0,80005b82 <sys_exec+0xf2>
    kfree(argv[i]);
    80005b74:	ffffb097          	auipc	ra,0xffffb
    80005b78:	e70080e7          	jalr	-400(ra) # 800009e4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b7c:	04a1                	addi	s1,s1,8
    80005b7e:	ff3499e3          	bne	s1,s3,80005b70 <sys_exec+0xe0>
  return ret;
    80005b82:	854a                	mv	a0,s2
    80005b84:	a011                	j	80005b88 <sys_exec+0xf8>
  return -1;
    80005b86:	557d                	li	a0,-1
}
    80005b88:	70fa                	ld	ra,440(sp)
    80005b8a:	745a                	ld	s0,432(sp)
    80005b8c:	74ba                	ld	s1,424(sp)
    80005b8e:	791a                	ld	s2,416(sp)
    80005b90:	69fa                	ld	s3,408(sp)
    80005b92:	6a5a                	ld	s4,400(sp)
    80005b94:	6139                	addi	sp,sp,448
    80005b96:	8082                	ret

0000000080005b98 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b98:	7139                	addi	sp,sp,-64
    80005b9a:	fc06                	sd	ra,56(sp)
    80005b9c:	f822                	sd	s0,48(sp)
    80005b9e:	f426                	sd	s1,40(sp)
    80005ba0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005ba2:	ffffc097          	auipc	ra,0xffffc
    80005ba6:	e40080e7          	jalr	-448(ra) # 800019e2 <myproc>
    80005baa:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005bac:	fd840593          	addi	a1,s0,-40
    80005bb0:	4501                	li	a0,0
    80005bb2:	ffffd097          	auipc	ra,0xffffd
    80005bb6:	0ae080e7          	jalr	174(ra) # 80002c60 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005bba:	fc840593          	addi	a1,s0,-56
    80005bbe:	fd040513          	addi	a0,s0,-48
    80005bc2:	fffff097          	auipc	ra,0xfffff
    80005bc6:	d76080e7          	jalr	-650(ra) # 80004938 <pipealloc>
    return -1;
    80005bca:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005bcc:	0c054463          	bltz	a0,80005c94 <sys_pipe+0xfc>
  fd0 = -1;
    80005bd0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005bd4:	fd043503          	ld	a0,-48(s0)
    80005bd8:	fffff097          	auipc	ra,0xfffff
    80005bdc:	524080e7          	jalr	1316(ra) # 800050fc <fdalloc>
    80005be0:	fca42223          	sw	a0,-60(s0)
    80005be4:	08054b63          	bltz	a0,80005c7a <sys_pipe+0xe2>
    80005be8:	fc843503          	ld	a0,-56(s0)
    80005bec:	fffff097          	auipc	ra,0xfffff
    80005bf0:	510080e7          	jalr	1296(ra) # 800050fc <fdalloc>
    80005bf4:	fca42023          	sw	a0,-64(s0)
    80005bf8:	06054863          	bltz	a0,80005c68 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005bfc:	4691                	li	a3,4
    80005bfe:	fc440613          	addi	a2,s0,-60
    80005c02:	fd843583          	ld	a1,-40(s0)
    80005c06:	68a8                	ld	a0,80(s1)
    80005c08:	ffffc097          	auipc	ra,0xffffc
    80005c0c:	a8a080e7          	jalr	-1398(ra) # 80001692 <copyout>
    80005c10:	02054063          	bltz	a0,80005c30 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005c14:	4691                	li	a3,4
    80005c16:	fc040613          	addi	a2,s0,-64
    80005c1a:	fd843583          	ld	a1,-40(s0)
    80005c1e:	0591                	addi	a1,a1,4
    80005c20:	68a8                	ld	a0,80(s1)
    80005c22:	ffffc097          	auipc	ra,0xffffc
    80005c26:	a70080e7          	jalr	-1424(ra) # 80001692 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005c2a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c2c:	06055463          	bgez	a0,80005c94 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005c30:	fc442783          	lw	a5,-60(s0)
    80005c34:	07e9                	addi	a5,a5,26
    80005c36:	078e                	slli	a5,a5,0x3
    80005c38:	97a6                	add	a5,a5,s1
    80005c3a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005c3e:	fc042783          	lw	a5,-64(s0)
    80005c42:	07e9                	addi	a5,a5,26
    80005c44:	078e                	slli	a5,a5,0x3
    80005c46:	94be                	add	s1,s1,a5
    80005c48:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005c4c:	fd043503          	ld	a0,-48(s0)
    80005c50:	fffff097          	auipc	ra,0xfffff
    80005c54:	9bc080e7          	jalr	-1604(ra) # 8000460c <fileclose>
    fileclose(wf);
    80005c58:	fc843503          	ld	a0,-56(s0)
    80005c5c:	fffff097          	auipc	ra,0xfffff
    80005c60:	9b0080e7          	jalr	-1616(ra) # 8000460c <fileclose>
    return -1;
    80005c64:	57fd                	li	a5,-1
    80005c66:	a03d                	j	80005c94 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005c68:	fc442783          	lw	a5,-60(s0)
    80005c6c:	0007c763          	bltz	a5,80005c7a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005c70:	07e9                	addi	a5,a5,26
    80005c72:	078e                	slli	a5,a5,0x3
    80005c74:	97a6                	add	a5,a5,s1
    80005c76:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005c7a:	fd043503          	ld	a0,-48(s0)
    80005c7e:	fffff097          	auipc	ra,0xfffff
    80005c82:	98e080e7          	jalr	-1650(ra) # 8000460c <fileclose>
    fileclose(wf);
    80005c86:	fc843503          	ld	a0,-56(s0)
    80005c8a:	fffff097          	auipc	ra,0xfffff
    80005c8e:	982080e7          	jalr	-1662(ra) # 8000460c <fileclose>
    return -1;
    80005c92:	57fd                	li	a5,-1
}
    80005c94:	853e                	mv	a0,a5
    80005c96:	70e2                	ld	ra,56(sp)
    80005c98:	7442                	ld	s0,48(sp)
    80005c9a:	74a2                	ld	s1,40(sp)
    80005c9c:	6121                	addi	sp,sp,64
    80005c9e:	8082                	ret

0000000080005ca0 <kernelvec>:
    80005ca0:	7111                	addi	sp,sp,-256
    80005ca2:	e006                	sd	ra,0(sp)
    80005ca4:	e40a                	sd	sp,8(sp)
    80005ca6:	e80e                	sd	gp,16(sp)
    80005ca8:	ec12                	sd	tp,24(sp)
    80005caa:	f016                	sd	t0,32(sp)
    80005cac:	f41a                	sd	t1,40(sp)
    80005cae:	f81e                	sd	t2,48(sp)
    80005cb0:	fc22                	sd	s0,56(sp)
    80005cb2:	e0a6                	sd	s1,64(sp)
    80005cb4:	e4aa                	sd	a0,72(sp)
    80005cb6:	e8ae                	sd	a1,80(sp)
    80005cb8:	ecb2                	sd	a2,88(sp)
    80005cba:	f0b6                	sd	a3,96(sp)
    80005cbc:	f4ba                	sd	a4,104(sp)
    80005cbe:	f8be                	sd	a5,112(sp)
    80005cc0:	fcc2                	sd	a6,120(sp)
    80005cc2:	e146                	sd	a7,128(sp)
    80005cc4:	e54a                	sd	s2,136(sp)
    80005cc6:	e94e                	sd	s3,144(sp)
    80005cc8:	ed52                	sd	s4,152(sp)
    80005cca:	f156                	sd	s5,160(sp)
    80005ccc:	f55a                	sd	s6,168(sp)
    80005cce:	f95e                	sd	s7,176(sp)
    80005cd0:	fd62                	sd	s8,184(sp)
    80005cd2:	e1e6                	sd	s9,192(sp)
    80005cd4:	e5ea                	sd	s10,200(sp)
    80005cd6:	e9ee                	sd	s11,208(sp)
    80005cd8:	edf2                	sd	t3,216(sp)
    80005cda:	f1f6                	sd	t4,224(sp)
    80005cdc:	f5fa                	sd	t5,232(sp)
    80005cde:	f9fe                	sd	t6,240(sp)
    80005ce0:	d8ffc0ef          	jal	ra,80002a6e <kerneltrap>
    80005ce4:	6082                	ld	ra,0(sp)
    80005ce6:	6122                	ld	sp,8(sp)
    80005ce8:	61c2                	ld	gp,16(sp)
    80005cea:	7282                	ld	t0,32(sp)
    80005cec:	7322                	ld	t1,40(sp)
    80005cee:	73c2                	ld	t2,48(sp)
    80005cf0:	7462                	ld	s0,56(sp)
    80005cf2:	6486                	ld	s1,64(sp)
    80005cf4:	6526                	ld	a0,72(sp)
    80005cf6:	65c6                	ld	a1,80(sp)
    80005cf8:	6666                	ld	a2,88(sp)
    80005cfa:	7686                	ld	a3,96(sp)
    80005cfc:	7726                	ld	a4,104(sp)
    80005cfe:	77c6                	ld	a5,112(sp)
    80005d00:	7866                	ld	a6,120(sp)
    80005d02:	688a                	ld	a7,128(sp)
    80005d04:	692a                	ld	s2,136(sp)
    80005d06:	69ca                	ld	s3,144(sp)
    80005d08:	6a6a                	ld	s4,152(sp)
    80005d0a:	7a8a                	ld	s5,160(sp)
    80005d0c:	7b2a                	ld	s6,168(sp)
    80005d0e:	7bca                	ld	s7,176(sp)
    80005d10:	7c6a                	ld	s8,184(sp)
    80005d12:	6c8e                	ld	s9,192(sp)
    80005d14:	6d2e                	ld	s10,200(sp)
    80005d16:	6dce                	ld	s11,208(sp)
    80005d18:	6e6e                	ld	t3,216(sp)
    80005d1a:	7e8e                	ld	t4,224(sp)
    80005d1c:	7f2e                	ld	t5,232(sp)
    80005d1e:	7fce                	ld	t6,240(sp)
    80005d20:	6111                	addi	sp,sp,256
    80005d22:	10200073          	sret
    80005d26:	00000013          	nop
    80005d2a:	00000013          	nop
    80005d2e:	0001                	nop

0000000080005d30 <timervec>:
    80005d30:	34051573          	csrrw	a0,mscratch,a0
    80005d34:	e10c                	sd	a1,0(a0)
    80005d36:	e510                	sd	a2,8(a0)
    80005d38:	e914                	sd	a3,16(a0)
    80005d3a:	6d0c                	ld	a1,24(a0)
    80005d3c:	7110                	ld	a2,32(a0)
    80005d3e:	6194                	ld	a3,0(a1)
    80005d40:	96b2                	add	a3,a3,a2
    80005d42:	e194                	sd	a3,0(a1)
    80005d44:	4589                	li	a1,2
    80005d46:	14459073          	csrw	sip,a1
    80005d4a:	6914                	ld	a3,16(a0)
    80005d4c:	6510                	ld	a2,8(a0)
    80005d4e:	610c                	ld	a1,0(a0)
    80005d50:	34051573          	csrrw	a0,mscratch,a0
    80005d54:	30200073          	mret
	...

0000000080005d5a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005d5a:	1141                	addi	sp,sp,-16
    80005d5c:	e422                	sd	s0,8(sp)
    80005d5e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005d60:	0c0007b7          	lui	a5,0xc000
    80005d64:	4705                	li	a4,1
    80005d66:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005d68:	c3d8                	sw	a4,4(a5)
}
    80005d6a:	6422                	ld	s0,8(sp)
    80005d6c:	0141                	addi	sp,sp,16
    80005d6e:	8082                	ret

0000000080005d70 <plicinithart>:

void
plicinithart(void)
{
    80005d70:	1141                	addi	sp,sp,-16
    80005d72:	e406                	sd	ra,8(sp)
    80005d74:	e022                	sd	s0,0(sp)
    80005d76:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d78:	ffffc097          	auipc	ra,0xffffc
    80005d7c:	c3e080e7          	jalr	-962(ra) # 800019b6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005d80:	0085171b          	slliw	a4,a0,0x8
    80005d84:	0c0027b7          	lui	a5,0xc002
    80005d88:	97ba                	add	a5,a5,a4
    80005d8a:	40200713          	li	a4,1026
    80005d8e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005d92:	00d5151b          	slliw	a0,a0,0xd
    80005d96:	0c2017b7          	lui	a5,0xc201
    80005d9a:	97aa                	add	a5,a5,a0
    80005d9c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005da0:	60a2                	ld	ra,8(sp)
    80005da2:	6402                	ld	s0,0(sp)
    80005da4:	0141                	addi	sp,sp,16
    80005da6:	8082                	ret

0000000080005da8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005da8:	1141                	addi	sp,sp,-16
    80005daa:	e406                	sd	ra,8(sp)
    80005dac:	e022                	sd	s0,0(sp)
    80005dae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005db0:	ffffc097          	auipc	ra,0xffffc
    80005db4:	c06080e7          	jalr	-1018(ra) # 800019b6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005db8:	00d5151b          	slliw	a0,a0,0xd
    80005dbc:	0c2017b7          	lui	a5,0xc201
    80005dc0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005dc2:	43c8                	lw	a0,4(a5)
    80005dc4:	60a2                	ld	ra,8(sp)
    80005dc6:	6402                	ld	s0,0(sp)
    80005dc8:	0141                	addi	sp,sp,16
    80005dca:	8082                	ret

0000000080005dcc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005dcc:	1101                	addi	sp,sp,-32
    80005dce:	ec06                	sd	ra,24(sp)
    80005dd0:	e822                	sd	s0,16(sp)
    80005dd2:	e426                	sd	s1,8(sp)
    80005dd4:	1000                	addi	s0,sp,32
    80005dd6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005dd8:	ffffc097          	auipc	ra,0xffffc
    80005ddc:	bde080e7          	jalr	-1058(ra) # 800019b6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005de0:	00d5151b          	slliw	a0,a0,0xd
    80005de4:	0c2017b7          	lui	a5,0xc201
    80005de8:	97aa                	add	a5,a5,a0
    80005dea:	c3c4                	sw	s1,4(a5)
}
    80005dec:	60e2                	ld	ra,24(sp)
    80005dee:	6442                	ld	s0,16(sp)
    80005df0:	64a2                	ld	s1,8(sp)
    80005df2:	6105                	addi	sp,sp,32
    80005df4:	8082                	ret

0000000080005df6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005df6:	1141                	addi	sp,sp,-16
    80005df8:	e406                	sd	ra,8(sp)
    80005dfa:	e022                	sd	s0,0(sp)
    80005dfc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005dfe:	479d                	li	a5,7
    80005e00:	04a7cc63          	blt	a5,a0,80005e58 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005e04:	00193797          	auipc	a5,0x193
    80005e08:	3e478793          	addi	a5,a5,996 # 801991e8 <disk>
    80005e0c:	97aa                	add	a5,a5,a0
    80005e0e:	0187c783          	lbu	a5,24(a5)
    80005e12:	ebb9                	bnez	a5,80005e68 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005e14:	00451693          	slli	a3,a0,0x4
    80005e18:	00193797          	auipc	a5,0x193
    80005e1c:	3d078793          	addi	a5,a5,976 # 801991e8 <disk>
    80005e20:	6398                	ld	a4,0(a5)
    80005e22:	9736                	add	a4,a4,a3
    80005e24:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005e28:	6398                	ld	a4,0(a5)
    80005e2a:	9736                	add	a4,a4,a3
    80005e2c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005e30:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005e34:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005e38:	97aa                	add	a5,a5,a0
    80005e3a:	4705                	li	a4,1
    80005e3c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005e40:	00193517          	auipc	a0,0x193
    80005e44:	3c050513          	addi	a0,a0,960 # 80199200 <disk+0x18>
    80005e48:	ffffc097          	auipc	ra,0xffffc
    80005e4c:	3b0080e7          	jalr	944(ra) # 800021f8 <wakeup>
}
    80005e50:	60a2                	ld	ra,8(sp)
    80005e52:	6402                	ld	s0,0(sp)
    80005e54:	0141                	addi	sp,sp,16
    80005e56:	8082                	ret
    panic("free_desc 1");
    80005e58:	00003517          	auipc	a0,0x3
    80005e5c:	92050513          	addi	a0,a0,-1760 # 80008778 <syscalls+0x300>
    80005e60:	ffffa097          	auipc	ra,0xffffa
    80005e64:	6dc080e7          	jalr	1756(ra) # 8000053c <panic>
    panic("free_desc 2");
    80005e68:	00003517          	auipc	a0,0x3
    80005e6c:	92050513          	addi	a0,a0,-1760 # 80008788 <syscalls+0x310>
    80005e70:	ffffa097          	auipc	ra,0xffffa
    80005e74:	6cc080e7          	jalr	1740(ra) # 8000053c <panic>

0000000080005e78 <virtio_disk_init>:
{
    80005e78:	1101                	addi	sp,sp,-32
    80005e7a:	ec06                	sd	ra,24(sp)
    80005e7c:	e822                	sd	s0,16(sp)
    80005e7e:	e426                	sd	s1,8(sp)
    80005e80:	e04a                	sd	s2,0(sp)
    80005e82:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005e84:	00003597          	auipc	a1,0x3
    80005e88:	91458593          	addi	a1,a1,-1772 # 80008798 <syscalls+0x320>
    80005e8c:	00193517          	auipc	a0,0x193
    80005e90:	48450513          	addi	a0,a0,1156 # 80199310 <disk+0x128>
    80005e94:	ffffb097          	auipc	ra,0xffffb
    80005e98:	cae080e7          	jalr	-850(ra) # 80000b42 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e9c:	100017b7          	lui	a5,0x10001
    80005ea0:	4398                	lw	a4,0(a5)
    80005ea2:	2701                	sext.w	a4,a4
    80005ea4:	747277b7          	lui	a5,0x74727
    80005ea8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005eac:	14f71b63          	bne	a4,a5,80006002 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005eb0:	100017b7          	lui	a5,0x10001
    80005eb4:	43dc                	lw	a5,4(a5)
    80005eb6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005eb8:	4709                	li	a4,2
    80005eba:	14e79463          	bne	a5,a4,80006002 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005ebe:	100017b7          	lui	a5,0x10001
    80005ec2:	479c                	lw	a5,8(a5)
    80005ec4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005ec6:	12e79e63          	bne	a5,a4,80006002 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005eca:	100017b7          	lui	a5,0x10001
    80005ece:	47d8                	lw	a4,12(a5)
    80005ed0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005ed2:	554d47b7          	lui	a5,0x554d4
    80005ed6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005eda:	12f71463          	bne	a4,a5,80006002 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ede:	100017b7          	lui	a5,0x10001
    80005ee2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ee6:	4705                	li	a4,1
    80005ee8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005eea:	470d                	li	a4,3
    80005eec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005eee:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005ef0:	c7ffe6b7          	lui	a3,0xc7ffe
    80005ef4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47e6504f>
    80005ef8:	8f75                	and	a4,a4,a3
    80005efa:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005efc:	472d                	li	a4,11
    80005efe:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005f00:	5bbc                	lw	a5,112(a5)
    80005f02:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005f06:	8ba1                	andi	a5,a5,8
    80005f08:	10078563          	beqz	a5,80006012 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005f0c:	100017b7          	lui	a5,0x10001
    80005f10:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005f14:	43fc                	lw	a5,68(a5)
    80005f16:	2781                	sext.w	a5,a5
    80005f18:	10079563          	bnez	a5,80006022 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005f1c:	100017b7          	lui	a5,0x10001
    80005f20:	5bdc                	lw	a5,52(a5)
    80005f22:	2781                	sext.w	a5,a5
  if(max == 0)
    80005f24:	10078763          	beqz	a5,80006032 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005f28:	471d                	li	a4,7
    80005f2a:	10f77c63          	bgeu	a4,a5,80006042 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005f2e:	ffffb097          	auipc	ra,0xffffb
    80005f32:	bb4080e7          	jalr	-1100(ra) # 80000ae2 <kalloc>
    80005f36:	00193497          	auipc	s1,0x193
    80005f3a:	2b248493          	addi	s1,s1,690 # 801991e8 <disk>
    80005f3e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005f40:	ffffb097          	auipc	ra,0xffffb
    80005f44:	ba2080e7          	jalr	-1118(ra) # 80000ae2 <kalloc>
    80005f48:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005f4a:	ffffb097          	auipc	ra,0xffffb
    80005f4e:	b98080e7          	jalr	-1128(ra) # 80000ae2 <kalloc>
    80005f52:	87aa                	mv	a5,a0
    80005f54:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005f56:	6088                	ld	a0,0(s1)
    80005f58:	cd6d                	beqz	a0,80006052 <virtio_disk_init+0x1da>
    80005f5a:	00193717          	auipc	a4,0x193
    80005f5e:	29673703          	ld	a4,662(a4) # 801991f0 <disk+0x8>
    80005f62:	cb65                	beqz	a4,80006052 <virtio_disk_init+0x1da>
    80005f64:	c7fd                	beqz	a5,80006052 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005f66:	6605                	lui	a2,0x1
    80005f68:	4581                	li	a1,0
    80005f6a:	ffffb097          	auipc	ra,0xffffb
    80005f6e:	d64080e7          	jalr	-668(ra) # 80000cce <memset>
  memset(disk.avail, 0, PGSIZE);
    80005f72:	00193497          	auipc	s1,0x193
    80005f76:	27648493          	addi	s1,s1,630 # 801991e8 <disk>
    80005f7a:	6605                	lui	a2,0x1
    80005f7c:	4581                	li	a1,0
    80005f7e:	6488                	ld	a0,8(s1)
    80005f80:	ffffb097          	auipc	ra,0xffffb
    80005f84:	d4e080e7          	jalr	-690(ra) # 80000cce <memset>
  memset(disk.used, 0, PGSIZE);
    80005f88:	6605                	lui	a2,0x1
    80005f8a:	4581                	li	a1,0
    80005f8c:	6888                	ld	a0,16(s1)
    80005f8e:	ffffb097          	auipc	ra,0xffffb
    80005f92:	d40080e7          	jalr	-704(ra) # 80000cce <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005f96:	100017b7          	lui	a5,0x10001
    80005f9a:	4721                	li	a4,8
    80005f9c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005f9e:	4098                	lw	a4,0(s1)
    80005fa0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005fa4:	40d8                	lw	a4,4(s1)
    80005fa6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005faa:	6498                	ld	a4,8(s1)
    80005fac:	0007069b          	sext.w	a3,a4
    80005fb0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005fb4:	9701                	srai	a4,a4,0x20
    80005fb6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005fba:	6898                	ld	a4,16(s1)
    80005fbc:	0007069b          	sext.w	a3,a4
    80005fc0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005fc4:	9701                	srai	a4,a4,0x20
    80005fc6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005fca:	4705                	li	a4,1
    80005fcc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005fce:	00e48c23          	sb	a4,24(s1)
    80005fd2:	00e48ca3          	sb	a4,25(s1)
    80005fd6:	00e48d23          	sb	a4,26(s1)
    80005fda:	00e48da3          	sb	a4,27(s1)
    80005fde:	00e48e23          	sb	a4,28(s1)
    80005fe2:	00e48ea3          	sb	a4,29(s1)
    80005fe6:	00e48f23          	sb	a4,30(s1)
    80005fea:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005fee:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ff2:	0727a823          	sw	s2,112(a5)
}
    80005ff6:	60e2                	ld	ra,24(sp)
    80005ff8:	6442                	ld	s0,16(sp)
    80005ffa:	64a2                	ld	s1,8(sp)
    80005ffc:	6902                	ld	s2,0(sp)
    80005ffe:	6105                	addi	sp,sp,32
    80006000:	8082                	ret
    panic("could not find virtio disk");
    80006002:	00002517          	auipc	a0,0x2
    80006006:	7a650513          	addi	a0,a0,1958 # 800087a8 <syscalls+0x330>
    8000600a:	ffffa097          	auipc	ra,0xffffa
    8000600e:	532080e7          	jalr	1330(ra) # 8000053c <panic>
    panic("virtio disk FEATURES_OK unset");
    80006012:	00002517          	auipc	a0,0x2
    80006016:	7b650513          	addi	a0,a0,1974 # 800087c8 <syscalls+0x350>
    8000601a:	ffffa097          	auipc	ra,0xffffa
    8000601e:	522080e7          	jalr	1314(ra) # 8000053c <panic>
    panic("virtio disk should not be ready");
    80006022:	00002517          	auipc	a0,0x2
    80006026:	7c650513          	addi	a0,a0,1990 # 800087e8 <syscalls+0x370>
    8000602a:	ffffa097          	auipc	ra,0xffffa
    8000602e:	512080e7          	jalr	1298(ra) # 8000053c <panic>
    panic("virtio disk has no queue 0");
    80006032:	00002517          	auipc	a0,0x2
    80006036:	7d650513          	addi	a0,a0,2006 # 80008808 <syscalls+0x390>
    8000603a:	ffffa097          	auipc	ra,0xffffa
    8000603e:	502080e7          	jalr	1282(ra) # 8000053c <panic>
    panic("virtio disk max queue too short");
    80006042:	00002517          	auipc	a0,0x2
    80006046:	7e650513          	addi	a0,a0,2022 # 80008828 <syscalls+0x3b0>
    8000604a:	ffffa097          	auipc	ra,0xffffa
    8000604e:	4f2080e7          	jalr	1266(ra) # 8000053c <panic>
    panic("virtio disk kalloc");
    80006052:	00002517          	auipc	a0,0x2
    80006056:	7f650513          	addi	a0,a0,2038 # 80008848 <syscalls+0x3d0>
    8000605a:	ffffa097          	auipc	ra,0xffffa
    8000605e:	4e2080e7          	jalr	1250(ra) # 8000053c <panic>

0000000080006062 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006062:	7159                	addi	sp,sp,-112
    80006064:	f486                	sd	ra,104(sp)
    80006066:	f0a2                	sd	s0,96(sp)
    80006068:	eca6                	sd	s1,88(sp)
    8000606a:	e8ca                	sd	s2,80(sp)
    8000606c:	e4ce                	sd	s3,72(sp)
    8000606e:	e0d2                	sd	s4,64(sp)
    80006070:	fc56                	sd	s5,56(sp)
    80006072:	f85a                	sd	s6,48(sp)
    80006074:	f45e                	sd	s7,40(sp)
    80006076:	f062                	sd	s8,32(sp)
    80006078:	ec66                	sd	s9,24(sp)
    8000607a:	e86a                	sd	s10,16(sp)
    8000607c:	1880                	addi	s0,sp,112
    8000607e:	8a2a                	mv	s4,a0
    80006080:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006082:	00c52c83          	lw	s9,12(a0)
    80006086:	001c9c9b          	slliw	s9,s9,0x1
    8000608a:	1c82                	slli	s9,s9,0x20
    8000608c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006090:	00193517          	auipc	a0,0x193
    80006094:	28050513          	addi	a0,a0,640 # 80199310 <disk+0x128>
    80006098:	ffffb097          	auipc	ra,0xffffb
    8000609c:	b3a080e7          	jalr	-1222(ra) # 80000bd2 <acquire>
  for(int i = 0; i < 3; i++){
    800060a0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800060a2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800060a4:	00193b17          	auipc	s6,0x193
    800060a8:	144b0b13          	addi	s6,s6,324 # 801991e8 <disk>
  for(int i = 0; i < 3; i++){
    800060ac:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800060ae:	00193c17          	auipc	s8,0x193
    800060b2:	262c0c13          	addi	s8,s8,610 # 80199310 <disk+0x128>
    800060b6:	a095                	j	8000611a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800060b8:	00fb0733          	add	a4,s6,a5
    800060bc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800060c0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800060c2:	0207c563          	bltz	a5,800060ec <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800060c6:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800060c8:	0591                	addi	a1,a1,4
    800060ca:	05560d63          	beq	a2,s5,80006124 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800060ce:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800060d0:	00193717          	auipc	a4,0x193
    800060d4:	11870713          	addi	a4,a4,280 # 801991e8 <disk>
    800060d8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800060da:	01874683          	lbu	a3,24(a4)
    800060de:	fee9                	bnez	a3,800060b8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    800060e0:	2785                	addiw	a5,a5,1
    800060e2:	0705                	addi	a4,a4,1
    800060e4:	fe979be3          	bne	a5,s1,800060da <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    800060e8:	57fd                	li	a5,-1
    800060ea:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800060ec:	00c05e63          	blez	a2,80006108 <virtio_disk_rw+0xa6>
    800060f0:	060a                	slli	a2,a2,0x2
    800060f2:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800060f6:	0009a503          	lw	a0,0(s3)
    800060fa:	00000097          	auipc	ra,0x0
    800060fe:	cfc080e7          	jalr	-772(ra) # 80005df6 <free_desc>
      for(int j = 0; j < i; j++)
    80006102:	0991                	addi	s3,s3,4
    80006104:	ffa999e3          	bne	s3,s10,800060f6 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006108:	85e2                	mv	a1,s8
    8000610a:	00193517          	auipc	a0,0x193
    8000610e:	0f650513          	addi	a0,a0,246 # 80199200 <disk+0x18>
    80006112:	ffffc097          	auipc	ra,0xffffc
    80006116:	082080e7          	jalr	130(ra) # 80002194 <sleep>
  for(int i = 0; i < 3; i++){
    8000611a:	f9040993          	addi	s3,s0,-112
{
    8000611e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80006120:	864a                	mv	a2,s2
    80006122:	b775                	j	800060ce <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006124:	f9042503          	lw	a0,-112(s0)
    80006128:	00a50713          	addi	a4,a0,10
    8000612c:	0712                	slli	a4,a4,0x4

  if(write)
    8000612e:	00193797          	auipc	a5,0x193
    80006132:	0ba78793          	addi	a5,a5,186 # 801991e8 <disk>
    80006136:	00e786b3          	add	a3,a5,a4
    8000613a:	01703633          	snez	a2,s7
    8000613e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006140:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006144:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006148:	f6070613          	addi	a2,a4,-160
    8000614c:	6394                	ld	a3,0(a5)
    8000614e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006150:	00870593          	addi	a1,a4,8
    80006154:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006156:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006158:	0007b803          	ld	a6,0(a5)
    8000615c:	9642                	add	a2,a2,a6
    8000615e:	46c1                	li	a3,16
    80006160:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006162:	4585                	li	a1,1
    80006164:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80006168:	f9442683          	lw	a3,-108(s0)
    8000616c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006170:	0692                	slli	a3,a3,0x4
    80006172:	9836                	add	a6,a6,a3
    80006174:	058a0613          	addi	a2,s4,88
    80006178:	00c83023          	sd	a2,0(a6) # 1000 <_entry-0x7ffff000>
  disk.desc[idx[1]].len = BSIZE;
    8000617c:	0007b803          	ld	a6,0(a5)
    80006180:	96c2                	add	a3,a3,a6
    80006182:	40000613          	li	a2,1024
    80006186:	c690                	sw	a2,8(a3)
  if(write)
    80006188:	001bb613          	seqz	a2,s7
    8000618c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006190:	00166613          	ori	a2,a2,1
    80006194:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006198:	f9842603          	lw	a2,-104(s0)
    8000619c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800061a0:	00250693          	addi	a3,a0,2
    800061a4:	0692                	slli	a3,a3,0x4
    800061a6:	96be                	add	a3,a3,a5
    800061a8:	58fd                	li	a7,-1
    800061aa:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800061ae:	0612                	slli	a2,a2,0x4
    800061b0:	9832                	add	a6,a6,a2
    800061b2:	f9070713          	addi	a4,a4,-112
    800061b6:	973e                	add	a4,a4,a5
    800061b8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800061bc:	6398                	ld	a4,0(a5)
    800061be:	9732                	add	a4,a4,a2
    800061c0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800061c2:	4609                	li	a2,2
    800061c4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800061c8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800061cc:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800061d0:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800061d4:	6794                	ld	a3,8(a5)
    800061d6:	0026d703          	lhu	a4,2(a3)
    800061da:	8b1d                	andi	a4,a4,7
    800061dc:	0706                	slli	a4,a4,0x1
    800061de:	96ba                	add	a3,a3,a4
    800061e0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800061e4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800061e8:	6798                	ld	a4,8(a5)
    800061ea:	00275783          	lhu	a5,2(a4)
    800061ee:	2785                	addiw	a5,a5,1
    800061f0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800061f4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800061f8:	100017b7          	lui	a5,0x10001
    800061fc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006200:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006204:	00193917          	auipc	s2,0x193
    80006208:	10c90913          	addi	s2,s2,268 # 80199310 <disk+0x128>
  while(b->disk == 1) {
    8000620c:	4485                	li	s1,1
    8000620e:	00b79c63          	bne	a5,a1,80006226 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006212:	85ca                	mv	a1,s2
    80006214:	8552                	mv	a0,s4
    80006216:	ffffc097          	auipc	ra,0xffffc
    8000621a:	f7e080e7          	jalr	-130(ra) # 80002194 <sleep>
  while(b->disk == 1) {
    8000621e:	004a2783          	lw	a5,4(s4)
    80006222:	fe9788e3          	beq	a5,s1,80006212 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006226:	f9042903          	lw	s2,-112(s0)
    8000622a:	00290713          	addi	a4,s2,2
    8000622e:	0712                	slli	a4,a4,0x4
    80006230:	00193797          	auipc	a5,0x193
    80006234:	fb878793          	addi	a5,a5,-72 # 801991e8 <disk>
    80006238:	97ba                	add	a5,a5,a4
    8000623a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000623e:	00193997          	auipc	s3,0x193
    80006242:	faa98993          	addi	s3,s3,-86 # 801991e8 <disk>
    80006246:	00491713          	slli	a4,s2,0x4
    8000624a:	0009b783          	ld	a5,0(s3)
    8000624e:	97ba                	add	a5,a5,a4
    80006250:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006254:	854a                	mv	a0,s2
    80006256:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	b9c080e7          	jalr	-1124(ra) # 80005df6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006262:	8885                	andi	s1,s1,1
    80006264:	f0ed                	bnez	s1,80006246 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006266:	00193517          	auipc	a0,0x193
    8000626a:	0aa50513          	addi	a0,a0,170 # 80199310 <disk+0x128>
    8000626e:	ffffb097          	auipc	ra,0xffffb
    80006272:	a18080e7          	jalr	-1512(ra) # 80000c86 <release>
}
    80006276:	70a6                	ld	ra,104(sp)
    80006278:	7406                	ld	s0,96(sp)
    8000627a:	64e6                	ld	s1,88(sp)
    8000627c:	6946                	ld	s2,80(sp)
    8000627e:	69a6                	ld	s3,72(sp)
    80006280:	6a06                	ld	s4,64(sp)
    80006282:	7ae2                	ld	s5,56(sp)
    80006284:	7b42                	ld	s6,48(sp)
    80006286:	7ba2                	ld	s7,40(sp)
    80006288:	7c02                	ld	s8,32(sp)
    8000628a:	6ce2                	ld	s9,24(sp)
    8000628c:	6d42                	ld	s10,16(sp)
    8000628e:	6165                	addi	sp,sp,112
    80006290:	8082                	ret

0000000080006292 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006292:	1101                	addi	sp,sp,-32
    80006294:	ec06                	sd	ra,24(sp)
    80006296:	e822                	sd	s0,16(sp)
    80006298:	e426                	sd	s1,8(sp)
    8000629a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000629c:	00193497          	auipc	s1,0x193
    800062a0:	f4c48493          	addi	s1,s1,-180 # 801991e8 <disk>
    800062a4:	00193517          	auipc	a0,0x193
    800062a8:	06c50513          	addi	a0,a0,108 # 80199310 <disk+0x128>
    800062ac:	ffffb097          	auipc	ra,0xffffb
    800062b0:	926080e7          	jalr	-1754(ra) # 80000bd2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800062b4:	10001737          	lui	a4,0x10001
    800062b8:	533c                	lw	a5,96(a4)
    800062ba:	8b8d                	andi	a5,a5,3
    800062bc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800062be:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800062c2:	689c                	ld	a5,16(s1)
    800062c4:	0204d703          	lhu	a4,32(s1)
    800062c8:	0027d783          	lhu	a5,2(a5)
    800062cc:	04f70863          	beq	a4,a5,8000631c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800062d0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800062d4:	6898                	ld	a4,16(s1)
    800062d6:	0204d783          	lhu	a5,32(s1)
    800062da:	8b9d                	andi	a5,a5,7
    800062dc:	078e                	slli	a5,a5,0x3
    800062de:	97ba                	add	a5,a5,a4
    800062e0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800062e2:	00278713          	addi	a4,a5,2
    800062e6:	0712                	slli	a4,a4,0x4
    800062e8:	9726                	add	a4,a4,s1
    800062ea:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800062ee:	e721                	bnez	a4,80006336 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800062f0:	0789                	addi	a5,a5,2
    800062f2:	0792                	slli	a5,a5,0x4
    800062f4:	97a6                	add	a5,a5,s1
    800062f6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800062f8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800062fc:	ffffc097          	auipc	ra,0xffffc
    80006300:	efc080e7          	jalr	-260(ra) # 800021f8 <wakeup>

    disk.used_idx += 1;
    80006304:	0204d783          	lhu	a5,32(s1)
    80006308:	2785                	addiw	a5,a5,1
    8000630a:	17c2                	slli	a5,a5,0x30
    8000630c:	93c1                	srli	a5,a5,0x30
    8000630e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006312:	6898                	ld	a4,16(s1)
    80006314:	00275703          	lhu	a4,2(a4)
    80006318:	faf71ce3          	bne	a4,a5,800062d0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000631c:	00193517          	auipc	a0,0x193
    80006320:	ff450513          	addi	a0,a0,-12 # 80199310 <disk+0x128>
    80006324:	ffffb097          	auipc	ra,0xffffb
    80006328:	962080e7          	jalr	-1694(ra) # 80000c86 <release>
}
    8000632c:	60e2                	ld	ra,24(sp)
    8000632e:	6442                	ld	s0,16(sp)
    80006330:	64a2                	ld	s1,8(sp)
    80006332:	6105                	addi	sp,sp,32
    80006334:	8082                	ret
      panic("virtio_disk_intr status");
    80006336:	00002517          	auipc	a0,0x2
    8000633a:	52a50513          	addi	a0,a0,1322 # 80008860 <syscalls+0x3e8>
    8000633e:	ffffa097          	auipc	ra,0xffffa
    80006342:	1fe080e7          	jalr	510(ra) # 8000053c <panic>

0000000080006346 <read_current_timestamp>:

int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz);
int flags2perm(int flags);

/* CSE 536: (2.4) read current time. */
uint64 read_current_timestamp() {
    80006346:	1101                	addi	sp,sp,-32
    80006348:	ec06                	sd	ra,24(sp)
    8000634a:	e822                	sd	s0,16(sp)
    8000634c:	e426                	sd	s1,8(sp)
    8000634e:	1000                	addi	s0,sp,32
  uint64 curticks = 0;
  acquire(&tickslock);
    80006350:	00188517          	auipc	a0,0x188
    80006354:	bf050513          	addi	a0,a0,-1040 # 8018df40 <tickslock>
    80006358:	ffffb097          	auipc	ra,0xffffb
    8000635c:	87a080e7          	jalr	-1926(ra) # 80000bd2 <acquire>
  curticks = ticks;
    80006360:	00002517          	auipc	a0,0x2
    80006364:	74050513          	addi	a0,a0,1856 # 80008aa0 <ticks>
    80006368:	00056483          	lwu	s1,0(a0)
  wakeup(&ticks);
    8000636c:	ffffc097          	auipc	ra,0xffffc
    80006370:	e8c080e7          	jalr	-372(ra) # 800021f8 <wakeup>
  release(&tickslock);
    80006374:	00188517          	auipc	a0,0x188
    80006378:	bcc50513          	addi	a0,a0,-1076 # 8018df40 <tickslock>
    8000637c:	ffffb097          	auipc	ra,0xffffb
    80006380:	90a080e7          	jalr	-1782(ra) # 80000c86 <release>
  return curticks;
}
    80006384:	8526                	mv	a0,s1
    80006386:	60e2                	ld	ra,24(sp)
    80006388:	6442                	ld	s0,16(sp)
    8000638a:	64a2                	ld	s1,8(sp)
    8000638c:	6105                	addi	sp,sp,32
    8000638e:	8082                	ret

0000000080006390 <init_psa_regions>:

bool psa_tracker[PSASIZE];

/* All blocks are free during initialization. */
void init_psa_regions(void)
{
    80006390:	1141                	addi	sp,sp,-16
    80006392:	e422                	sd	s0,8(sp)
    80006394:	0800                	addi	s0,sp,16
    for (int i = 0; i < PSASIZE; i++) 
    80006396:	00193797          	auipc	a5,0x193
    8000639a:	f9278793          	addi	a5,a5,-110 # 80199328 <psa_tracker>
    8000639e:	00193717          	auipc	a4,0x193
    800063a2:	37270713          	addi	a4,a4,882 # 80199710 <end>
        psa_tracker[i] = false;
    800063a6:	00078023          	sb	zero,0(a5)
    for (int i = 0; i < PSASIZE; i++) 
    800063aa:	0785                	addi	a5,a5,1
    800063ac:	fee79de3          	bne	a5,a4,800063a6 <init_psa_regions+0x16>
}
    800063b0:	6422                	ld	s0,8(sp)
    800063b2:	0141                	addi	sp,sp,16
    800063b4:	8082                	ret

00000000800063b6 <free_psa_block>:

// set the psa block as false
void free_psa_block(int x){
    800063b6:	1141                	addi	sp,sp,-16
    800063b8:	e422                	sd	s0,8(sp)
    800063ba:	0800                	addi	s0,sp,16
    psa_tracker[x] = false;
    800063bc:	00193797          	auipc	a5,0x193
    800063c0:	f6c78793          	addi	a5,a5,-148 # 80199328 <psa_tracker>
    800063c4:	97aa                	add	a5,a5,a0
    800063c6:	00078023          	sb	zero,0(a5)
}
    800063ca:	6422                	ld	s0,8(sp)
    800063cc:	0141                	addi	sp,sp,16
    800063ce:	8082                	ret

00000000800063d0 <find_free_block>:

// find a free psa block
int find_free_block() 
{
    800063d0:	1141                	addi	sp,sp,-16
    800063d2:	e422                	sd	s0,8(sp)
    800063d4:	0800                	addi	s0,sp,16
    int free_block_index = -1;
    for(int i = 0; i < PSASIZE; i+=4){
    800063d6:	00193797          	auipc	a5,0x193
    800063da:	f5278793          	addi	a5,a5,-174 # 80199328 <psa_tracker>
    800063de:	4501                	li	a0,0
    800063e0:	3e800693          	li	a3,1000
        if(!psa_tracker[i]) {
    800063e4:	0007c703          	lbu	a4,0(a5)
    800063e8:	c711                	beqz	a4,800063f4 <find_free_block+0x24>
    for(int i = 0; i < PSASIZE; i+=4){
    800063ea:	2511                	addiw	a0,a0,4
    800063ec:	0791                	addi	a5,a5,4
    800063ee:	fed51be3          	bne	a0,a3,800063e4 <find_free_block+0x14>
    int free_block_index = -1;
    800063f2:	557d                	li	a0,-1
            free_block_index = i;
            break;
        }
    }
    psa_tracker[free_block_index] = true;
    800063f4:	00193797          	auipc	a5,0x193
    800063f8:	f3478793          	addi	a5,a5,-204 # 80199328 <psa_tracker>
    800063fc:	97aa                	add	a5,a5,a0
    800063fe:	4705                	li	a4,1
    80006400:	00e78023          	sb	a4,0(a5)
    return free_block_index;
}
    80006404:	6422                	ld	s0,8(sp)
    80006406:	0141                	addi	sp,sp,16
    80006408:	8082                	ret

000000008000640a <find_victim_using_fifo>:

int find_victim_using_fifo(struct proc* p) {
    8000640a:	1101                	addi	sp,sp,-32
    8000640c:	ec06                	sd	ra,24(sp)
    8000640e:	e822                	sd	s0,16(sp)
    80006410:	e426                	sd	s1,8(sp)
    80006412:	1000                	addi	s0,sp,32
    80006414:	84aa                	mv	s1,a0
    uint64 first_loaded_heap_time = 0;
    uint64 current_time = read_current_timestamp();
    80006416:	00000097          	auipc	ra,0x0
    8000641a:	f30080e7          	jalr	-208(ra) # 80006346 <read_current_timestamp>
    8000641e:	882a                	mv	a6,a0
    int first_loaded_heap_index = -1;

    for(int i = 0; i < MAXHEAP; i++){
    80006420:	17848793          	addi	a5,s1,376
    80006424:	4701                	li	a4,0
    int first_loaded_heap_index = -1;
    80006426:	557d                	li	a0,-1
    uint64 first_loaded_heap_time = 0;
    80006428:	4581                	li	a1,0
        if(p->heap_tracker[i].loaded == true){
            uint64 time_diff = current_time - p->heap_tracker[i].last_load_time;
            if(first_loaded_heap_index == -1 || time_diff > first_loaded_heap_time) {
    8000642a:	58fd                	li	a7,-1
    for(int i = 0; i < MAXHEAP; i++){
    8000642c:	3e800613          	li	a2,1000
    80006430:	a039                	j	8000643e <find_victim_using_fifo+0x34>
    80006432:	853a                	mv	a0,a4
                first_loaded_heap_index = i;
                first_loaded_heap_time = time_diff;
    80006434:	85b6                	mv	a1,a3
    for(int i = 0; i < MAXHEAP; i++){
    80006436:	2705                	addiw	a4,a4,1
    80006438:	07e1                	addi	a5,a5,24
    8000643a:	00c70f63          	beq	a4,a2,80006458 <find_victim_using_fifo+0x4e>
        if(p->heap_tracker[i].loaded == true){
    8000643e:	0087c683          	lbu	a3,8(a5)
    80006442:	daf5                	beqz	a3,80006436 <find_victim_using_fifo+0x2c>
            uint64 time_diff = current_time - p->heap_tracker[i].last_load_time;
    80006444:	6394                	ld	a3,0(a5)
    80006446:	40d806b3          	sub	a3,a6,a3
            if(first_loaded_heap_index == -1 || time_diff > first_loaded_heap_time) {
    8000644a:	ff1504e3          	beq	a0,a7,80006432 <find_victim_using_fifo+0x28>
    8000644e:	fed5f4e3          	bgeu	a1,a3,80006436 <find_victim_using_fifo+0x2c>
    80006452:	853a                	mv	a0,a4
                first_loaded_heap_time = time_diff;
    80006454:	85b6                	mv	a1,a3
    80006456:	b7c5                	j	80006436 <find_victim_using_fifo+0x2c>
            }
        }
    }
    return first_loaded_heap_index;
}
    80006458:	60e2                	ld	ra,24(sp)
    8000645a:	6442                	ld	s0,16(sp)
    8000645c:	64a2                	ld	s1,8(sp)
    8000645e:	6105                	addi	sp,sp,32
    80006460:	8082                	ret

0000000080006462 <evict_page_to_disk>:

/* Evict heap page to disk when resident pages exceed limit */
void evict_page_to_disk(struct proc* p) {
    80006462:	715d                	addi	sp,sp,-80
    80006464:	e486                	sd	ra,72(sp)
    80006466:	e0a2                	sd	s0,64(sp)
    80006468:	fc26                	sd	s1,56(sp)
    8000646a:	f84a                	sd	s2,48(sp)
    8000646c:	f44e                	sd	s3,40(sp)
    8000646e:	f052                	sd	s4,32(sp)
    80006470:	ec56                	sd	s5,24(sp)
    80006472:	e85a                	sd	s6,16(sp)
    80006474:	e45e                	sd	s7,8(sp)
    80006476:	e062                	sd	s8,0(sp)
    80006478:	0880                	addi	s0,sp,80
    8000647a:	89aa                	mv	s3,a0
    /* Find free block */
    int blockno = find_free_block();
    8000647c:	00000097          	auipc	ra,0x0
    80006480:	f54080e7          	jalr	-172(ra) # 800063d0 <find_free_block>
    80006484:	8aaa                	mv	s5,a0

    /* Find victim page using FIFO. */
    int first_loaded_heap_index = find_victim_using_fifo(p);
    80006486:	854e                	mv	a0,s3
    80006488:	00000097          	auipc	ra,0x0
    8000648c:	f82080e7          	jalr	-126(ra) # 8000640a <find_victim_using_fifo>
    80006490:	8b2a                	mv	s6,a0

    /* Print statement. */
    print_evict_page(p->heap_tracker[first_loaded_heap_index].addr, blockno);
    80006492:	00151493          	slli	s1,a0,0x1
    80006496:	94aa                	add	s1,s1,a0
    80006498:	048e                	slli	s1,s1,0x3
    8000649a:	94ce                	add	s1,s1,s3
    8000649c:	85d6                	mv	a1,s5
    8000649e:	1704b503          	ld	a0,368(s1)
    800064a2:	00000097          	auipc	ra,0x0
    800064a6:	4a4080e7          	jalr	1188(ra) # 80006946 <print_evict_page>

    /* Read memory from the user to kernel memory first. */
    char *kernel_mem = kalloc();
    800064aa:	ffffa097          	auipc	ra,0xffffa
    800064ae:	638080e7          	jalr	1592(ra) # 80000ae2 <kalloc>
    800064b2:	8baa                	mv	s7,a0
    if(copyin(p->pagetable, kernel_mem, p->heap_tracker[first_loaded_heap_index].addr, PGSIZE) != 0){
    800064b4:	6685                	lui	a3,0x1
    800064b6:	1704b603          	ld	a2,368(s1)
    800064ba:	85aa                	mv	a1,a0
    800064bc:	0509b503          	ld	a0,80(s3)
    800064c0:	ffffb097          	auipc	ra,0xffffb
    800064c4:	25e080e7          	jalr	606(ra) # 8000171e <copyin>
    800064c8:	e14d                	bnez	a0,8000656a <evict_page_to_disk+0x108>
    800064ca:	021a8a1b          	addiw	s4,s5,33
    800064ce:	895e                	mv	s2,s7
    800064d0:	6c05                	lui	s8,0x1
    800064d2:	9c5e                	add	s8,s8,s7
    
    /* Write to the disk blocks. Below is a template as to how this works. There is
     * definitely a better way but this works for now. :p */
    struct buf* b;
    for(int i = 0; i < 4; i++){
        b = bread(1, PSASTART+(blockno + i));
    800064d4:	85d2                	mv	a1,s4
    800064d6:	4505                	li	a0,1
    800064d8:	ffffd097          	auipc	ra,0xffffd
    800064dc:	aba080e7          	jalr	-1350(ra) # 80002f92 <bread>
    800064e0:	84aa                	mv	s1,a0

        // Copy page contents to b.data using memmove.
        memmove(b->data, (const void*)(kernel_mem + (i * 1024)), 1024);
    800064e2:	40000613          	li	a2,1024
    800064e6:	85ca                	mv	a1,s2
    800064e8:	05850513          	addi	a0,a0,88
    800064ec:	ffffb097          	auipc	ra,0xffffb
    800064f0:	83e080e7          	jalr	-1986(ra) # 80000d2a <memmove>

        bwrite(b);
    800064f4:	8526                	mv	a0,s1
    800064f6:	ffffd097          	auipc	ra,0xffffd
    800064fa:	b8e080e7          	jalr	-1138(ra) # 80003084 <bwrite>
        brelse(b);
    800064fe:	8526                	mv	a0,s1
    80006500:	ffffd097          	auipc	ra,0xffffd
    80006504:	bc2080e7          	jalr	-1086(ra) # 800030c2 <brelse>
    for(int i = 0; i < 4; i++){
    80006508:	2a05                	addiw	s4,s4,1
    8000650a:	40090913          	addi	s2,s2,1024
    8000650e:	fd8913e3          	bne	s2,s8,800064d4 <evict_page_to_disk+0x72>
    }
    
    /* Unmap swapped out page */
    uvmunmap(p->pagetable, p->heap_tracker[first_loaded_heap_index].addr, 1, 1);
    80006512:	001b1493          	slli	s1,s6,0x1
    80006516:	01648933          	add	s2,s1,s6
    8000651a:	090e                	slli	s2,s2,0x3
    8000651c:	994e                	add	s2,s2,s3
    8000651e:	4685                	li	a3,1
    80006520:	4605                	li	a2,1
    80006522:	17093583          	ld	a1,368(s2)
    80006526:	0509b503          	ld	a0,80(s3)
    8000652a:	ffffb097          	auipc	ra,0xffffb
    8000652e:	d3c080e7          	jalr	-708(ra) # 80001266 <uvmunmap>
    kfree(kernel_mem);
    80006532:	855e                	mv	a0,s7
    80006534:	ffffa097          	auipc	ra,0xffffa
    80006538:	4b0080e7          	jalr	1200(ra) # 800009e4 <kfree>

    /* Update the resident heap tracker. */
    p->resident_heap_pages--;
    8000653c:	6799                	lui	a5,0x6
    8000653e:	97ce                	add	a5,a5,s3
    80006540:	f307a703          	lw	a4,-208(a5) # 5f30 <_entry-0x7fffa0d0>
    80006544:	377d                	addiw	a4,a4,-1
    80006546:	f2e7a823          	sw	a4,-208(a5)
    p->heap_tracker[first_loaded_heap_index].loaded = false;
    8000654a:	18090023          	sb	zero,384(s2)
    p->heap_tracker[first_loaded_heap_index].startblock = blockno;
    8000654e:	19592223          	sw	s5,388(s2)
}
    80006552:	60a6                	ld	ra,72(sp)
    80006554:	6406                	ld	s0,64(sp)
    80006556:	74e2                	ld	s1,56(sp)
    80006558:	7942                	ld	s2,48(sp)
    8000655a:	79a2                	ld	s3,40(sp)
    8000655c:	7a02                	ld	s4,32(sp)
    8000655e:	6ae2                	ld	s5,24(sp)
    80006560:	6b42                	ld	s6,16(sp)
    80006562:	6ba2                	ld	s7,8(sp)
    80006564:	6c02                	ld	s8,0(sp)
    80006566:	6161                	addi	sp,sp,80
    80006568:	8082                	ret
        exit(-1);
    8000656a:	557d                	li	a0,-1
    8000656c:	ffffc097          	auipc	ra,0xffffc
    80006570:	d6c080e7          	jalr	-660(ra) # 800022d8 <exit>
        return;
    80006574:	bff9                	j	80006552 <evict_page_to_disk+0xf0>

0000000080006576 <retrieve_page_from_disk>:

/* Retrieve faulted page from disk. */
void retrieve_page_from_disk(struct proc* p, uint64 uvaddr) {
    80006576:	715d                	addi	sp,sp,-80
    80006578:	e486                	sd	ra,72(sp)
    8000657a:	e0a2                	sd	s0,64(sp)
    8000657c:	fc26                	sd	s1,56(sp)
    8000657e:	f84a                	sd	s2,48(sp)
    80006580:	f44e                	sd	s3,40(sp)
    80006582:	f052                	sd	s4,32(sp)
    80006584:	ec56                	sd	s5,24(sp)
    80006586:	e85a                	sd	s6,16(sp)
    80006588:	e45e                	sd	s7,8(sp)
    8000658a:	0880                	addi	s0,sp,80
    8000658c:	8a2a                	mv	s4,a0
    /* Find where the page is located in disk */
    uint64 page_base_addr = PGROUNDDOWN(uvaddr);
    8000658e:	77fd                	lui	a5,0xfffff
    80006590:	00f5f4b3          	and	s1,a1,a5
    int heap_index = -1;
    for(int i=0; i < MAXHEAP; i++){
    80006594:	17050713          	addi	a4,a0,368
    80006598:	4781                	li	a5,0
    8000659a:	3e800613          	li	a2,1000
        if(p->heap_tracker[i].addr == page_base_addr){
    8000659e:	6314                	ld	a3,0(a4)
    800065a0:	00968763          	beq	a3,s1,800065ae <retrieve_page_from_disk+0x38>
    for(int i=0; i < MAXHEAP; i++){
    800065a4:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7fe658f1>
    800065a6:	0761                	addi	a4,a4,24
    800065a8:	fec79be3          	bne	a5,a2,8000659e <retrieve_page_from_disk+0x28>
    int heap_index = -1;
    800065ac:	57fd                	li	a5,-1
           heap_index = i;
            break;
        }
    }

    int block_no = p->heap_tracker[heap_index].startblock;
    800065ae:	00179713          	slli	a4,a5,0x1
    800065b2:	97ba                	add	a5,a5,a4
    800065b4:	078e                	slli	a5,a5,0x3
    800065b6:	97d2                	add	a5,a5,s4
    800065b8:	1847ab83          	lw	s7,388(a5)
    /* Print statement. */
    print_retrieve_page(page_base_addr, block_no);
    800065bc:	85de                	mv	a1,s7
    800065be:	8526                	mv	a0,s1
    800065c0:	00000097          	auipc	ra,0x0
    800065c4:	3ae080e7          	jalr	942(ra) # 8000696e <print_retrieve_page>

    /* Create a kernel page to read memory temporarily into first. */
    char *kernel_mem = kalloc();
    800065c8:	ffffa097          	auipc	ra,0xffffa
    800065cc:	51a080e7          	jalr	1306(ra) # 80000ae2 <kalloc>
    800065d0:	8b2a                	mv	s6,a0
    
    /* Read the disk block into temp kernel page. */
    struct buf* b;
    for(int i = 0; i < 4; i++){
    800065d2:	021b899b          	addiw	s3,s7,33
    800065d6:	892a                	mv	s2,a0
    800065d8:	6a85                	lui	s5,0x1
    800065da:	9aaa                	add	s5,s5,a0
        b = bread(1, PSASTART+(block_no + i));
    800065dc:	85ce                	mv	a1,s3
    800065de:	4505                	li	a0,1
    800065e0:	ffffd097          	auipc	ra,0xffffd
    800065e4:	9b2080e7          	jalr	-1614(ra) # 80002f92 <bread>

        // Copy b.data to page contents  using memmove.
        memmove((kernel_mem + (i * 1024)), (const void*)(b->data), 1024);
    800065e8:	40000613          	li	a2,1024
    800065ec:	05850593          	addi	a1,a0,88
    800065f0:	854a                	mv	a0,s2
    800065f2:	ffffa097          	auipc	ra,0xffffa
    800065f6:	738080e7          	jalr	1848(ra) # 80000d2a <memmove>
    for(int i = 0; i < 4; i++){
    800065fa:	2985                	addiw	s3,s3,1
    800065fc:	40090913          	addi	s2,s2,1024
    80006600:	fd591ee3          	bne	s2,s5,800065dc <retrieve_page_from_disk+0x66>
    }

    /* Copy from temp kernel page to uvaddr (use copyout) */
    if(copyout(p->pagetable, page_base_addr, kernel_mem, PGSIZE) != 0){
    80006604:	6685                	lui	a3,0x1
    80006606:	865a                	mv	a2,s6
    80006608:	85a6                	mv	a1,s1
    8000660a:	050a3503          	ld	a0,80(s4)
    8000660e:	ffffb097          	auipc	ra,0xffffb
    80006612:	084080e7          	jalr	132(ra) # 80001692 <copyout>
    80006616:	e905                	bnez	a0,80006646 <retrieve_page_from_disk+0xd0>
        exit(-1);
        return;
    }
    kfree(kernel_mem);
    80006618:	855a                	mv	a0,s6
    8000661a:	ffffa097          	auipc	ra,0xffffa
    8000661e:	3ca080e7          	jalr	970(ra) # 800009e4 <kfree>
    psa_tracker[block_no] = false;
    80006622:	00193797          	auipc	a5,0x193
    80006626:	d0678793          	addi	a5,a5,-762 # 80199328 <psa_tracker>
    8000662a:	97de                	add	a5,a5,s7
    8000662c:	00078023          	sb	zero,0(a5)
    return;
}
    80006630:	60a6                	ld	ra,72(sp)
    80006632:	6406                	ld	s0,64(sp)
    80006634:	74e2                	ld	s1,56(sp)
    80006636:	7942                	ld	s2,48(sp)
    80006638:	79a2                	ld	s3,40(sp)
    8000663a:	7a02                	ld	s4,32(sp)
    8000663c:	6ae2                	ld	s5,24(sp)
    8000663e:	6b42                	ld	s6,16(sp)
    80006640:	6ba2                	ld	s7,8(sp)
    80006642:	6161                	addi	sp,sp,80
    80006644:	8082                	ret
        exit(-1);
    80006646:	557d                	li	a0,-1
    80006648:	ffffc097          	auipc	ra,0xffffc
    8000664c:	c90080e7          	jalr	-880(ra) # 800022d8 <exit>
        return;
    80006650:	b7c5                	j	80006630 <retrieve_page_from_disk+0xba>

0000000080006652 <page_fault_handler>:


void page_fault_handler(void) 
{
    80006652:	7155                	addi	sp,sp,-208
    80006654:	e586                	sd	ra,200(sp)
    80006656:	e1a2                	sd	s0,192(sp)
    80006658:	fd26                	sd	s1,184(sp)
    8000665a:	f94a                	sd	s2,176(sp)
    8000665c:	f54e                	sd	s3,168(sp)
    8000665e:	f152                	sd	s4,160(sp)
    80006660:	ed56                	sd	s5,152(sp)
    80006662:	e95a                	sd	s6,144(sp)
    80006664:	e55e                	sd	s7,136(sp)
    80006666:	e162                	sd	s8,128(sp)
    80006668:	0980                	addi	s0,sp,208
    /* Current process struct */
    struct proc *p = myproc();
    8000666a:	ffffb097          	auipc	ra,0xffffb
    8000666e:	378080e7          	jalr	888(ra) # 800019e2 <myproc>
    80006672:	8a2a                	mv	s4,a0
    80006674:	143029f3          	csrr	s3,stval
    /* Track whether the heap page should be brought back from disk or not. */
    bool load_from_disk = false;

    /* Find faulting address. */
    uint64 faulting_addr = r_stval();
    uint64 page_base_addr = PGROUNDDOWN(faulting_addr);
    80006678:	797d                	lui	s2,0xfffff
    8000667a:	0129f933          	and	s2,s3,s2
    print_page_fault(p->name, page_base_addr);
    8000667e:	15850a93          	addi	s5,a0,344
    80006682:	85ca                	mv	a1,s2
    80006684:	8556                	mv	a0,s5
    80006686:	00000097          	auipc	ra,0x0
    8000668a:	280080e7          	jalr	640(ra) # 80006906 <print_page_fault>

    /* Check if the fault address is a heap page. Use p->heap_tracker */
    bool is_heap_page = false;
    int heappage_index = -1;
    for(int i=0; i < MAXHEAP; i++){
    8000668e:	170a0793          	addi	a5,s4,368
    80006692:	4481                	li	s1,0
    80006694:	3e800693          	li	a3,1000
        if(p->heap_tracker[i].addr == page_base_addr){
    80006698:	6398                	ld	a4,0(a5)
    8000669a:	05270d63          	beq	a4,s2,800066f4 <page_fault_handler+0xa2>
    for(int i=0; i < MAXHEAP; i++){
    8000669e:	2485                	addiw	s1,s1,1
    800066a0:	07e1                	addi	a5,a5,24
    800066a2:	fed49be3          	bne	s1,a3,80006698 <page_fault_handler+0x46>

    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    uint64 sz = page_base_addr;
    begin_op();
    800066a6:	ffffe097          	auipc	ra,0xffffe
    800066aa:	aa2080e7          	jalr	-1374(ra) # 80004148 <begin_op>
    if((ip = namei(p->name)) == 0){
    800066ae:	8556                	mv	a0,s5
    800066b0:	ffffe097          	auipc	ra,0xffffe
    800066b4:	898080e7          	jalr	-1896(ra) # 80003f48 <namei>
    800066b8:	8aaa                	mv	s5,a0
    800066ba:	c961                	beqz	a0,8000678a <page_fault_handler+0x138>
        end_op();
        goto bad;
    }

    ilock(ip);
    800066bc:	ffffd097          	auipc	ra,0xffffd
    800066c0:	0e6080e7          	jalr	230(ra) # 800037a2 <ilock>
    if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800066c4:	04000713          	li	a4,64
    800066c8:	4681                	li	a3,0
    800066ca:	f7040613          	addi	a2,s0,-144
    800066ce:	4581                	li	a1,0
    800066d0:	8556                	mv	a0,s5
    800066d2:	ffffd097          	auipc	ra,0xffffd
    800066d6:	384080e7          	jalr	900(ra) # 80003a56 <readi>
    800066da:	04000793          	li	a5,64
    800066de:	0af51a63          	bne	a0,a5,80006792 <page_fault_handler+0x140>
        goto bad;
    for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800066e2:	f9042483          	lw	s1,-112(s0)
    800066e6:	fa845783          	lhu	a5,-88(s0)
    800066ea:	14078f63          	beqz	a5,80006848 <page_fault_handler+0x1f6>
    800066ee:	4981                	li	s3,0
        if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
            goto bad;
        if(ph.type != ELF_PROG_LOAD)
    800066f0:	4b05                	li	s6,1
    800066f2:	a0d1                	j	800067b6 <page_fault_handler+0x164>
            if (p->heap_tracker[i].startblock != -1) {
    800066f4:	00149793          	slli	a5,s1,0x1
    800066f8:	97a6                	add	a5,a5,s1
    800066fa:	078e                	slli	a5,a5,0x3
    800066fc:	97d2                	add	a5,a5,s4
    800066fe:	1847a903          	lw	s2,388(a5)
    /* Go to out, since the remainder of this code is for the heap. */
    goto out;

heap_handle:
    /* 2.4: Check if resident pages are more than heap pages. If yes, evict. */
    if (p->resident_heap_pages == MAXRESHEAP) {
    80006702:	6799                	lui	a5,0x6
    80006704:	97d2                	add	a5,a5,s4
    80006706:	f307a703          	lw	a4,-208(a5) # 5f30 <_entry-0x7fffa0d0>
    8000670a:	06400793          	li	a5,100
    8000670e:	14f70763          	beq	a4,a5,8000685c <page_fault_handler+0x20a>
        evict_page_to_disk(p);
    }

    /* 2.3: Map a heap page into the process' address space. (Hint: check growproc) */
    if(load_from_disk == false){
    80006712:	57fd                	li	a5,-1
    80006714:	14f91a63          	bne	s2,a5,80006868 <page_fault_handler+0x216>
        if((uvmalloc(p->pagetable, p->heap_tracker[heappage_index].addr, p->heap_tracker[heappage_index].addr + PGSIZE, PTE_W)) == 0) {
    80006718:	00149793          	slli	a5,s1,0x1
    8000671c:	97a6                	add	a5,a5,s1
    8000671e:	078e                	slli	a5,a5,0x3
    80006720:	97d2                	add	a5,a5,s4
    80006722:	1707b583          	ld	a1,368(a5)
    80006726:	4691                	li	a3,4
    80006728:	6605                	lui	a2,0x1
    8000672a:	962e                	add	a2,a2,a1
    8000672c:	050a3503          	ld	a0,80(s4)
    80006730:	ffffb097          	auipc	ra,0xffffb
    80006734:	cd4080e7          	jalr	-812(ra) # 80001404 <uvmalloc>
    80006738:	cd0d                	beqz	a0,80006772 <page_fault_handler+0x120>
            return;
        }
    }
    
    /* 2.4: Update the last load time for the loaded heap page in p->heap_tracker. */
    p->heap_tracker[heappage_index].loaded = true;
    8000673a:	00149913          	slli	s2,s1,0x1
    8000673e:	009907b3          	add	a5,s2,s1
    80006742:	078e                	slli	a5,a5,0x3
    80006744:	97d2                	add	a5,a5,s4
    80006746:	4705                	li	a4,1
    80006748:	18e78023          	sb	a4,384(a5)
    p->heap_tracker[heappage_index].last_load_time = read_current_timestamp();
    8000674c:	00000097          	auipc	ra,0x0
    80006750:	bfa080e7          	jalr	-1030(ra) # 80006346 <read_current_timestamp>
    80006754:	009907b3          	add	a5,s2,s1
    80006758:	078e                	slli	a5,a5,0x3
    8000675a:	97d2                	add	a5,a5,s4
    8000675c:	16a7bc23          	sd	a0,376(a5)
    if (load_from_disk) {
        retrieve_page_from_disk(p, faulting_addr);
    }

    /* Track that another heap page has been brought into memory. */
    p->resident_heap_pages++;
    80006760:	6799                	lui	a5,0x6
    80006762:	97d2                	add	a5,a5,s4
    80006764:	f307a703          	lw	a4,-208(a5) # 5f30 <_entry-0x7fffa0d0>
    80006768:	2705                	addiw	a4,a4,1
    8000676a:	f2e7a823          	sw	a4,-208(a5)
  asm volatile("sfence.vma zero, zero");
    8000676e:	12000073          	sfence.vma

bad:
    setkilled(p);
    exit(-1);
    return;    
    80006772:	60ae                	ld	ra,200(sp)
    80006774:	640e                	ld	s0,192(sp)
    80006776:	74ea                	ld	s1,184(sp)
    80006778:	794a                	ld	s2,176(sp)
    8000677a:	79aa                	ld	s3,168(sp)
    8000677c:	7a0a                	ld	s4,160(sp)
    8000677e:	6aea                	ld	s5,152(sp)
    80006780:	6b4a                	ld	s6,144(sp)
    80006782:	6baa                	ld	s7,136(sp)
    80006784:	6c0a                	ld	s8,128(sp)
    80006786:	6169                	addi	sp,sp,208
    80006788:	8082                	ret
        end_op();
    8000678a:	ffffe097          	auipc	ra,0xffffe
    8000678e:	a38080e7          	jalr	-1480(ra) # 800041c2 <end_op>
    setkilled(p);
    80006792:	8552                	mv	a0,s4
    80006794:	ffffc097          	auipc	ra,0xffffc
    80006798:	c94080e7          	jalr	-876(ra) # 80002428 <setkilled>
    exit(-1);
    8000679c:	557d                	li	a0,-1
    8000679e:	ffffc097          	auipc	ra,0xffffc
    800067a2:	b3a080e7          	jalr	-1222(ra) # 800022d8 <exit>
    return;    
    800067a6:	b7f1                	j	80006772 <page_fault_handler+0x120>
    for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800067a8:	2985                	addiw	s3,s3,1
    800067aa:	0384849b          	addiw	s1,s1,56
    800067ae:	fa845783          	lhu	a5,-88(s0)
    800067b2:	08f9db63          	bge	s3,a5,80006848 <page_fault_handler+0x1f6>
        if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800067b6:	2481                	sext.w	s1,s1
    800067b8:	03800713          	li	a4,56
    800067bc:	86a6                	mv	a3,s1
    800067be:	f3840613          	addi	a2,s0,-200
    800067c2:	4581                	li	a1,0
    800067c4:	8556                	mv	a0,s5
    800067c6:	ffffd097          	auipc	ra,0xffffd
    800067ca:	290080e7          	jalr	656(ra) # 80003a56 <readi>
    800067ce:	03800793          	li	a5,56
    800067d2:	fcf510e3          	bne	a0,a5,80006792 <page_fault_handler+0x140>
        if(ph.type != ELF_PROG_LOAD)
    800067d6:	f3842783          	lw	a5,-200(s0)
    800067da:	fd6797e3          	bne	a5,s6,800067a8 <page_fault_handler+0x156>
        if(ph.vaddr == sz) {
    800067de:	f4843783          	ld	a5,-184(s0)
    800067e2:	fd2793e3          	bne	a5,s2,800067a8 <page_fault_handler+0x156>
            if(uvmalloc(p->pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags)) == 0)
    800067e6:	050a3c03          	ld	s8,80(s4)
    800067ea:	f6043703          	ld	a4,-160(s0)
    800067ee:	00e78bb3          	add	s7,a5,a4
    800067f2:	f3c42503          	lw	a0,-196(s0)
    800067f6:	ffffe097          	auipc	ra,0xffffe
    800067fa:	472080e7          	jalr	1138(ra) # 80004c68 <flags2perm>
    800067fe:	86aa                	mv	a3,a0
    80006800:	865e                	mv	a2,s7
    80006802:	85ca                	mv	a1,s2
    80006804:	8562                	mv	a0,s8
    80006806:	ffffb097          	auipc	ra,0xffffb
    8000680a:	bfe080e7          	jalr	-1026(ra) # 80001404 <uvmalloc>
    8000680e:	d151                	beqz	a0,80006792 <page_fault_handler+0x140>
            if(loadseg(p->pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80006810:	f5842703          	lw	a4,-168(s0)
    80006814:	f4042683          	lw	a3,-192(s0)
    80006818:	8656                	mv	a2,s5
    8000681a:	f4843583          	ld	a1,-184(s0)
    8000681e:	050a3503          	ld	a0,80(s4)
    80006822:	ffffe097          	auipc	ra,0xffffe
    80006826:	460080e7          	jalr	1120(ra) # 80004c82 <loadseg>
    8000682a:	f60544e3          	bltz	a0,80006792 <page_fault_handler+0x140>
            print_load_seg(page_base_addr, ph.vaddr + ph.off, ph.memsz);  
    8000682e:	f6042603          	lw	a2,-160(s0)
    80006832:	f4843583          	ld	a1,-184(s0)
    80006836:	f4043783          	ld	a5,-192(s0)
    8000683a:	95be                	add	a1,a1,a5
    8000683c:	854a                	mv	a0,s2
    8000683e:	00000097          	auipc	ra,0x0
    80006842:	158080e7          	jalr	344(ra) # 80006996 <print_load_seg>
    80006846:	b78d                	j	800067a8 <page_fault_handler+0x156>
    iunlockput(ip);
    80006848:	8556                	mv	a0,s5
    8000684a:	ffffd097          	auipc	ra,0xffffd
    8000684e:	1ba080e7          	jalr	442(ra) # 80003a04 <iunlockput>
    end_op();
    80006852:	ffffe097          	auipc	ra,0xffffe
    80006856:	970080e7          	jalr	-1680(ra) # 800041c2 <end_op>
    goto out;
    8000685a:	bf11                	j	8000676e <page_fault_handler+0x11c>
        evict_page_to_disk(p);
    8000685c:	8552                	mv	a0,s4
    8000685e:	00000097          	auipc	ra,0x0
    80006862:	c04080e7          	jalr	-1020(ra) # 80006462 <evict_page_to_disk>
    80006866:	b575                	j	80006712 <page_fault_handler+0xc0>
    p->heap_tracker[heappage_index].loaded = true;
    80006868:	00149913          	slli	s2,s1,0x1
    8000686c:	009907b3          	add	a5,s2,s1
    80006870:	078e                	slli	a5,a5,0x3
    80006872:	97d2                	add	a5,a5,s4
    80006874:	4705                	li	a4,1
    80006876:	18e78023          	sb	a4,384(a5)
    p->heap_tracker[heappage_index].last_load_time = read_current_timestamp();
    8000687a:	00000097          	auipc	ra,0x0
    8000687e:	acc080e7          	jalr	-1332(ra) # 80006346 <read_current_timestamp>
    80006882:	009907b3          	add	a5,s2,s1
    80006886:	078e                	slli	a5,a5,0x3
    80006888:	97d2                	add	a5,a5,s4
    8000688a:	16a7bc23          	sd	a0,376(a5)
        retrieve_page_from_disk(p, faulting_addr);
    8000688e:	85ce                	mv	a1,s3
    80006890:	8552                	mv	a0,s4
    80006892:	00000097          	auipc	ra,0x0
    80006896:	ce4080e7          	jalr	-796(ra) # 80006576 <retrieve_page_from_disk>
    8000689a:	b5d9                	j	80006760 <page_fault_handler+0x10e>

000000008000689c <print_static_proc>:
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "elf.h"

void print_static_proc(char* name) {
    8000689c:	1141                	addi	sp,sp,-16
    8000689e:	e406                	sd	ra,8(sp)
    800068a0:	e022                	sd	s0,0(sp)
    800068a2:	0800                	addi	s0,sp,16
    800068a4:	85aa                	mv	a1,a0
    printf("Static process creation (proc: %s)\n", name);
    800068a6:	00002517          	auipc	a0,0x2
    800068aa:	fd250513          	addi	a0,a0,-46 # 80008878 <syscalls+0x400>
    800068ae:	ffffa097          	auipc	ra,0xffffa
    800068b2:	cd8080e7          	jalr	-808(ra) # 80000586 <printf>
}
    800068b6:	60a2                	ld	ra,8(sp)
    800068b8:	6402                	ld	s0,0(sp)
    800068ba:	0141                	addi	sp,sp,16
    800068bc:	8082                	ret

00000000800068be <print_ondemand_proc>:

void print_ondemand_proc(char* name) {
    800068be:	1141                	addi	sp,sp,-16
    800068c0:	e406                	sd	ra,8(sp)
    800068c2:	e022                	sd	s0,0(sp)
    800068c4:	0800                	addi	s0,sp,16
    800068c6:	85aa                	mv	a1,a0
    printf("Ondemand process creation (proc: %s)\n", name);
    800068c8:	00002517          	auipc	a0,0x2
    800068cc:	fd850513          	addi	a0,a0,-40 # 800088a0 <syscalls+0x428>
    800068d0:	ffffa097          	auipc	ra,0xffffa
    800068d4:	cb6080e7          	jalr	-842(ra) # 80000586 <printf>
}
    800068d8:	60a2                	ld	ra,8(sp)
    800068da:	6402                	ld	s0,0(sp)
    800068dc:	0141                	addi	sp,sp,16
    800068de:	8082                	ret

00000000800068e0 <print_skip_section>:

void print_skip_section(char* name, uint64 vaddr, int size) {
    800068e0:	1141                	addi	sp,sp,-16
    800068e2:	e406                	sd	ra,8(sp)
    800068e4:	e022                	sd	s0,0(sp)
    800068e6:	0800                	addi	s0,sp,16
    800068e8:	86b2                	mv	a3,a2
    printf("Skipping program section loading (proc: %s, addr: %x, size: %d)\n", 
    800068ea:	862e                	mv	a2,a1
    800068ec:	85aa                	mv	a1,a0
    800068ee:	00002517          	auipc	a0,0x2
    800068f2:	fda50513          	addi	a0,a0,-38 # 800088c8 <syscalls+0x450>
    800068f6:	ffffa097          	auipc	ra,0xffffa
    800068fa:	c90080e7          	jalr	-880(ra) # 80000586 <printf>
        name, vaddr, size);
}
    800068fe:	60a2                	ld	ra,8(sp)
    80006900:	6402                	ld	s0,0(sp)
    80006902:	0141                	addi	sp,sp,16
    80006904:	8082                	ret

0000000080006906 <print_page_fault>:

void print_page_fault(char* name, uint64 vaddr) {
    80006906:	1101                	addi	sp,sp,-32
    80006908:	ec06                	sd	ra,24(sp)
    8000690a:	e822                	sd	s0,16(sp)
    8000690c:	e426                	sd	s1,8(sp)
    8000690e:	e04a                	sd	s2,0(sp)
    80006910:	1000                	addi	s0,sp,32
    80006912:	84aa                	mv	s1,a0
    80006914:	892e                	mv	s2,a1
    printf("----------------------------------------\n");
    80006916:	00002517          	auipc	a0,0x2
    8000691a:	ffa50513          	addi	a0,a0,-6 # 80008910 <syscalls+0x498>
    8000691e:	ffffa097          	auipc	ra,0xffffa
    80006922:	c68080e7          	jalr	-920(ra) # 80000586 <printf>
    printf("#PF: Proc (%s), Page (%x)\n", name, vaddr);
    80006926:	864a                	mv	a2,s2
    80006928:	85a6                	mv	a1,s1
    8000692a:	00002517          	auipc	a0,0x2
    8000692e:	01650513          	addi	a0,a0,22 # 80008940 <syscalls+0x4c8>
    80006932:	ffffa097          	auipc	ra,0xffffa
    80006936:	c54080e7          	jalr	-940(ra) # 80000586 <printf>
}
    8000693a:	60e2                	ld	ra,24(sp)
    8000693c:	6442                	ld	s0,16(sp)
    8000693e:	64a2                	ld	s1,8(sp)
    80006940:	6902                	ld	s2,0(sp)
    80006942:	6105                	addi	sp,sp,32
    80006944:	8082                	ret

0000000080006946 <print_evict_page>:

void print_evict_page(uint64 vaddr, int startblock) {
    80006946:	1141                	addi	sp,sp,-16
    80006948:	e406                	sd	ra,8(sp)
    8000694a:	e022                	sd	s0,0(sp)
    8000694c:	0800                	addi	s0,sp,16
    8000694e:	862e                	mv	a2,a1
    printf("EVICT: Page (%x) --> PSA (%d - %d)\n", vaddr, startblock, startblock+3);
    80006950:	0035869b          	addiw	a3,a1,3
    80006954:	85aa                	mv	a1,a0
    80006956:	00002517          	auipc	a0,0x2
    8000695a:	00a50513          	addi	a0,a0,10 # 80008960 <syscalls+0x4e8>
    8000695e:	ffffa097          	auipc	ra,0xffffa
    80006962:	c28080e7          	jalr	-984(ra) # 80000586 <printf>
}
    80006966:	60a2                	ld	ra,8(sp)
    80006968:	6402                	ld	s0,0(sp)
    8000696a:	0141                	addi	sp,sp,16
    8000696c:	8082                	ret

000000008000696e <print_retrieve_page>:

void print_retrieve_page(uint64 vaddr, int startblock) {
    8000696e:	1141                	addi	sp,sp,-16
    80006970:	e406                	sd	ra,8(sp)
    80006972:	e022                	sd	s0,0(sp)
    80006974:	0800                	addi	s0,sp,16
    80006976:	862e                	mv	a2,a1
    printf("RETRIEVE: Page (%x) --> PSA (%d - %d)\n", vaddr, startblock, startblock+3);
    80006978:	0035869b          	addiw	a3,a1,3
    8000697c:	85aa                	mv	a1,a0
    8000697e:	00002517          	auipc	a0,0x2
    80006982:	00a50513          	addi	a0,a0,10 # 80008988 <syscalls+0x510>
    80006986:	ffffa097          	auipc	ra,0xffffa
    8000698a:	c00080e7          	jalr	-1024(ra) # 80000586 <printf>
}
    8000698e:	60a2                	ld	ra,8(sp)
    80006990:	6402                	ld	s0,0(sp)
    80006992:	0141                	addi	sp,sp,16
    80006994:	8082                	ret

0000000080006996 <print_load_seg>:

void print_load_seg(uint64 vaddr, uint64 seg, int size) {
    80006996:	1141                	addi	sp,sp,-16
    80006998:	e406                	sd	ra,8(sp)
    8000699a:	e022                	sd	s0,0(sp)
    8000699c:	0800                	addi	s0,sp,16
    8000699e:	86b2                	mv	a3,a2
    printf("LOAD: Addr (%x), SEG: (%x), SIZE (%d)\n", vaddr, seg, size);
    800069a0:	862e                	mv	a2,a1
    800069a2:	85aa                	mv	a1,a0
    800069a4:	00002517          	auipc	a0,0x2
    800069a8:	00c50513          	addi	a0,a0,12 # 800089b0 <syscalls+0x538>
    800069ac:	ffffa097          	auipc	ra,0xffffa
    800069b0:	bda080e7          	jalr	-1062(ra) # 80000586 <printf>
}
    800069b4:	60a2                	ld	ra,8(sp)
    800069b6:	6402                	ld	s0,0(sp)
    800069b8:	0141                	addi	sp,sp,16
    800069ba:	8082                	ret

00000000800069bc <print_skip_heap_region>:

void print_skip_heap_region(char* name, uint64 vaddr, int npages) {
    800069bc:	1141                	addi	sp,sp,-16
    800069be:	e406                	sd	ra,8(sp)
    800069c0:	e022                	sd	s0,0(sp)
    800069c2:	0800                	addi	s0,sp,16
    800069c4:	86b2                	mv	a3,a2
    printf("Skipping heap region allocation (proc: %s, addr: %x, npages: %d)\n", 
    800069c6:	862e                	mv	a2,a1
    800069c8:	85aa                	mv	a1,a0
    800069ca:	00002517          	auipc	a0,0x2
    800069ce:	00e50513          	addi	a0,a0,14 # 800089d8 <syscalls+0x560>
    800069d2:	ffffa097          	auipc	ra,0xffffa
    800069d6:	bb4080e7          	jalr	-1100(ra) # 80000586 <printf>
        name, vaddr, npages);
}
    800069da:	60a2                	ld	ra,8(sp)
    800069dc:	6402                	ld	s0,0(sp)
    800069de:	0141                	addi	sp,sp,16
    800069e0:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...

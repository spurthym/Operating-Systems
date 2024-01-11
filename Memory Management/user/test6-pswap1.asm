
user/_test6-pswap1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#include <stdarg.h>

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    /* Allocate as many pages as allowed. */
    int npages = 110;
    void* heappages = sbrk(4096*npages);
   8:	0006e537          	lui	a0,0x6e
   c:	00000097          	auipc	ra,0x0
  10:	37a080e7          	jalr	890(ra) # 386 <sbrk>
    if (!heappages) {
  14:	c921                	beqz	a0,64 <main+0x64>
  16:	6785                	lui	a5,0x1
  18:	00f50733          	add	a4,a0,a5
        return -1;
    }

    /* Write random numbers to the allocated heap regions. */
    int* a;
    int count = 0;
  1c:	4681                	li	a3,0
    for (int i = 0; i < npages; i++) {
        a = ((int*) (heappages + i*PGSIZE));
  1e:	757d                	lui	a0,0xfffff
    for (int i = 0; i < npages; i++) {
  20:	6585                	lui	a1,0x1
  22:	06e00613          	li	a2,110
        a = ((int*) (heappages + i*PGSIZE));
  26:	00a707b3          	add	a5,a4,a0
        for (int j = 0; j < PGSIZE/sizeof(int); j++) {
            *a = count;
  2a:	c394                	sw	a3,0(a5)
            a++;
  2c:	0791                	addi	a5,a5,4 # 1004 <freep+0x4>
        for (int j = 0; j < PGSIZE/sizeof(int); j++) {
  2e:	fee79ee3          	bne	a5,a4,2a <main+0x2a>
        }
        count++;
  32:	2685                	addiw	a3,a3,1
    for (int i = 0; i < npages; i++) {
  34:	972e                	add	a4,a4,a1
  36:	fec698e3          	bne	a3,a2,26 <main+0x26>
    }

    printf("[*] PSWAP TEST1 COMPLETE.\n");
  3a:	00000517          	auipc	a0,0x0
  3e:	7fe50513          	addi	a0,a0,2046 # 838 <malloc+0x11a>
  42:	00000097          	auipc	ra,0x0
  46:	624080e7          	jalr	1572(ra) # 666 <printf>
    printf("    (Check output for correctness)\n");
  4a:	00001517          	auipc	a0,0x1
  4e:	80e50513          	addi	a0,a0,-2034 # 858 <malloc+0x13a>
  52:	00000097          	auipc	ra,0x0
  56:	614080e7          	jalr	1556(ra) # 666 <printf>
    return 0;
  5a:	4501                	li	a0,0
  5c:	60a2                	ld	ra,8(sp)
  5e:	6402                	ld	s0,0(sp)
  60:	0141                	addi	sp,sp,16
  62:	8082                	ret
        printf("[X] Heap memory allocation FAILED.\n");
  64:	00000517          	auipc	a0,0x0
  68:	7ac50513          	addi	a0,a0,1964 # 810 <malloc+0xf2>
  6c:	00000097          	auipc	ra,0x0
  70:	5fa080e7          	jalr	1530(ra) # 666 <printf>
        return -1;
  74:	557d                	li	a0,-1
  76:	b7dd                	j	5c <main+0x5c>

0000000000000078 <_main>:
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  80:	00000097          	auipc	ra,0x0
  84:	f80080e7          	jalr	-128(ra) # 0 <main>
  88:	4501                	li	a0,0
  8a:	00000097          	auipc	ra,0x0
  8e:	274080e7          	jalr	628(ra) # 2fe <exit>

0000000000000092 <strcpy>:
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  98:	87aa                	mv	a5,a0
  9a:	0585                	addi	a1,a1,1 # 1001 <freep+0x1>
  9c:	0785                	addi	a5,a5,1
  9e:	fff5c703          	lbu	a4,-1(a1)
  a2:	fee78fa3          	sb	a4,-1(a5)
  a6:	fb75                	bnez	a4,9a <strcpy+0x8>
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strcmp>:
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x1e>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x1e>
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xc>
  cc:	0005c503          	lbu	a0,0(a1)
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strlen>:
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cf91                	beqz	a5,100 <strlen+0x26>
  e6:	0505                	addi	a0,a0,1
  e8:	87aa                	mv	a5,a0
  ea:	86be                	mv	a3,a5
  ec:	0785                	addi	a5,a5,1
  ee:	fff7c703          	lbu	a4,-1(a5)
  f2:	ff65                	bnez	a4,ea <strlen+0x10>
  f4:	40a6853b          	subw	a0,a3,a0
  f8:	2505                	addiw	a0,a0,1
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret
 100:	4501                	li	a0,0
 102:	bfe5                	j	fa <strlen+0x20>

0000000000000104 <memset>:
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
 10a:	ca19                	beqz	a2,120 <memset+0x1c>
 10c:	87aa                	mv	a5,a0
 10e:	1602                	slli	a2,a2,0x20
 110:	9201                	srli	a2,a2,0x20
 112:	00a60733          	add	a4,a2,a0
 116:	00b78023          	sb	a1,0(a5)
 11a:	0785                	addi	a5,a5,1
 11c:	fee79de3          	bne	a5,a4,116 <memset+0x12>
 120:	6422                	ld	s0,8(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strchr>:
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
 12c:	00054783          	lbu	a5,0(a0)
 130:	cb99                	beqz	a5,146 <strchr+0x20>
 132:	00f58763          	beq	a1,a5,140 <strchr+0x1a>
 136:	0505                	addi	a0,a0,1
 138:	00054783          	lbu	a5,0(a0)
 13c:	fbfd                	bnez	a5,132 <strchr+0xc>
 13e:	4501                	li	a0,0
 140:	6422                	ld	s0,8(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
 146:	4501                	li	a0,0
 148:	bfe5                	j	140 <strchr+0x1a>

000000000000014a <gets>:
 14a:	711d                	addi	sp,sp,-96
 14c:	ec86                	sd	ra,88(sp)
 14e:	e8a2                	sd	s0,80(sp)
 150:	e4a6                	sd	s1,72(sp)
 152:	e0ca                	sd	s2,64(sp)
 154:	fc4e                	sd	s3,56(sp)
 156:	f852                	sd	s4,48(sp)
 158:	f456                	sd	s5,40(sp)
 15a:	f05a                	sd	s6,32(sp)
 15c:	ec5e                	sd	s7,24(sp)
 15e:	1080                	addi	s0,sp,96
 160:	8baa                	mv	s7,a0
 162:	8a2e                	mv	s4,a1
 164:	892a                	mv	s2,a0
 166:	4481                	li	s1,0
 168:	4aa9                	li	s5,10
 16a:	4b35                	li	s6,13
 16c:	89a6                	mv	s3,s1
 16e:	2485                	addiw	s1,s1,1
 170:	0344d863          	bge	s1,s4,1a0 <gets+0x56>
 174:	4605                	li	a2,1
 176:	faf40593          	addi	a1,s0,-81
 17a:	4501                	li	a0,0
 17c:	00000097          	auipc	ra,0x0
 180:	19a080e7          	jalr	410(ra) # 316 <read>
 184:	00a05e63          	blez	a0,1a0 <gets+0x56>
 188:	faf44783          	lbu	a5,-81(s0)
 18c:	00f90023          	sb	a5,0(s2)
 190:	01578763          	beq	a5,s5,19e <gets+0x54>
 194:	0905                	addi	s2,s2,1
 196:	fd679be3          	bne	a5,s6,16c <gets+0x22>
 19a:	89a6                	mv	s3,s1
 19c:	a011                	j	1a0 <gets+0x56>
 19e:	89a6                	mv	s3,s1
 1a0:	99de                	add	s3,s3,s7
 1a2:	00098023          	sb	zero,0(s3)
 1a6:	855e                	mv	a0,s7
 1a8:	60e6                	ld	ra,88(sp)
 1aa:	6446                	ld	s0,80(sp)
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	6906                	ld	s2,64(sp)
 1b0:	79e2                	ld	s3,56(sp)
 1b2:	7a42                	ld	s4,48(sp)
 1b4:	7aa2                	ld	s5,40(sp)
 1b6:	7b02                	ld	s6,32(sp)
 1b8:	6be2                	ld	s7,24(sp)
 1ba:	6125                	addi	sp,sp,96
 1bc:	8082                	ret

00000000000001be <stat>:
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec06                	sd	ra,24(sp)
 1c2:	e822                	sd	s0,16(sp)
 1c4:	e426                	sd	s1,8(sp)
 1c6:	e04a                	sd	s2,0(sp)
 1c8:	1000                	addi	s0,sp,32
 1ca:	892e                	mv	s2,a1
 1cc:	4581                	li	a1,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	170080e7          	jalr	368(ra) # 33e <open>
 1d6:	02054563          	bltz	a0,200 <stat+0x42>
 1da:	84aa                	mv	s1,a0
 1dc:	85ca                	mv	a1,s2
 1de:	00000097          	auipc	ra,0x0
 1e2:	178080e7          	jalr	376(ra) # 356 <fstat>
 1e6:	892a                	mv	s2,a0
 1e8:	8526                	mv	a0,s1
 1ea:	00000097          	auipc	ra,0x0
 1ee:	13c080e7          	jalr	316(ra) # 326 <close>
 1f2:	854a                	mv	a0,s2
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	64a2                	ld	s1,8(sp)
 1fa:	6902                	ld	s2,0(sp)
 1fc:	6105                	addi	sp,sp,32
 1fe:	8082                	ret
 200:	597d                	li	s2,-1
 202:	bfc5                	j	1f2 <stat+0x34>

0000000000000204 <atoi>:
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
 20a:	00054683          	lbu	a3,0(a0)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	4625                	li	a2,9
 218:	02f66863          	bltu	a2,a5,248 <atoi+0x44>
 21c:	872a                	mv	a4,a0
 21e:	4501                	li	a0,0
 220:	0705                	addi	a4,a4,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb5                	addw	a5,a5,a3
 22e:	fd07851b          	addiw	a0,a5,-48
 232:	00074683          	lbu	a3,0(a4)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	fef671e3          	bgeu	a2,a5,220 <atoi+0x1c>
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
 248:	4501                	li	a0,0
 24a:	bfe5                	j	242 <atoi+0x3e>

000000000000024c <memmove>:
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
 252:	02b57463          	bgeu	a0,a1,27a <memmove+0x2e>
 256:	00c05f63          	blez	a2,274 <memmove+0x28>
 25a:	1602                	slli	a2,a2,0x20
 25c:	9201                	srli	a2,a2,0x20
 25e:	00c507b3          	add	a5,a0,a2
 262:	872a                	mv	a4,a0
 264:	0585                	addi	a1,a1,1
 266:	0705                	addi	a4,a4,1
 268:	fff5c683          	lbu	a3,-1(a1)
 26c:	fed70fa3          	sb	a3,-1(a4)
 270:	fee79ae3          	bne	a5,a4,264 <memmove+0x18>
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
 27a:	00c50733          	add	a4,a0,a2
 27e:	95b2                	add	a1,a1,a2
 280:	fec05ae3          	blez	a2,274 <memmove+0x28>
 284:	fff6079b          	addiw	a5,a2,-1
 288:	1782                	slli	a5,a5,0x20
 28a:	9381                	srli	a5,a5,0x20
 28c:	fff7c793          	not	a5,a5
 290:	97ba                	add	a5,a5,a4
 292:	15fd                	addi	a1,a1,-1
 294:	177d                	addi	a4,a4,-1
 296:	0005c683          	lbu	a3,0(a1)
 29a:	00d70023          	sb	a3,0(a4)
 29e:	fee79ae3          	bne	a5,a4,292 <memmove+0x46>
 2a2:	bfc9                	j	274 <memmove+0x28>

00000000000002a4 <memcmp>:
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
 2aa:	ca05                	beqz	a2,2da <memcmp+0x36>
 2ac:	fff6069b          	addiw	a3,a2,-1
 2b0:	1682                	slli	a3,a3,0x20
 2b2:	9281                	srli	a3,a3,0x20
 2b4:	0685                	addi	a3,a3,1
 2b6:	96aa                	add	a3,a3,a0
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	0005c703          	lbu	a4,0(a1)
 2c0:	00e79863          	bne	a5,a4,2d0 <memcmp+0x2c>
 2c4:	0505                	addi	a0,a0,1
 2c6:	0585                	addi	a1,a1,1
 2c8:	fed518e3          	bne	a0,a3,2b8 <memcmp+0x14>
 2cc:	4501                	li	a0,0
 2ce:	a019                	j	2d4 <memcmp+0x30>
 2d0:	40e7853b          	subw	a0,a5,a4
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <memcmp+0x30>

00000000000002de <memcpy>:
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
 2e6:	00000097          	auipc	ra,0x0
 2ea:	f66080e7          	jalr	-154(ra) # 24c <memmove>
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <fork>:
 2f6:	4885                	li	a7,1
 2f8:	00000073          	ecall
 2fc:	8082                	ret

00000000000002fe <exit>:
 2fe:	4889                	li	a7,2
 300:	00000073          	ecall
 304:	8082                	ret

0000000000000306 <wait>:
 306:	488d                	li	a7,3
 308:	00000073          	ecall
 30c:	8082                	ret

000000000000030e <pipe>:
 30e:	4891                	li	a7,4
 310:	00000073          	ecall
 314:	8082                	ret

0000000000000316 <read>:
 316:	4895                	li	a7,5
 318:	00000073          	ecall
 31c:	8082                	ret

000000000000031e <write>:
 31e:	48c1                	li	a7,16
 320:	00000073          	ecall
 324:	8082                	ret

0000000000000326 <close>:
 326:	48d5                	li	a7,21
 328:	00000073          	ecall
 32c:	8082                	ret

000000000000032e <kill>:
 32e:	4899                	li	a7,6
 330:	00000073          	ecall
 334:	8082                	ret

0000000000000336 <exec>:
 336:	489d                	li	a7,7
 338:	00000073          	ecall
 33c:	8082                	ret

000000000000033e <open>:
 33e:	48bd                	li	a7,15
 340:	00000073          	ecall
 344:	8082                	ret

0000000000000346 <mknod>:
 346:	48c5                	li	a7,17
 348:	00000073          	ecall
 34c:	8082                	ret

000000000000034e <unlink>:
 34e:	48c9                	li	a7,18
 350:	00000073          	ecall
 354:	8082                	ret

0000000000000356 <fstat>:
 356:	48a1                	li	a7,8
 358:	00000073          	ecall
 35c:	8082                	ret

000000000000035e <link>:
 35e:	48cd                	li	a7,19
 360:	00000073          	ecall
 364:	8082                	ret

0000000000000366 <mkdir>:
 366:	48d1                	li	a7,20
 368:	00000073          	ecall
 36c:	8082                	ret

000000000000036e <chdir>:
 36e:	48a5                	li	a7,9
 370:	00000073          	ecall
 374:	8082                	ret

0000000000000376 <dup>:
 376:	48a9                	li	a7,10
 378:	00000073          	ecall
 37c:	8082                	ret

000000000000037e <getpid>:
 37e:	48ad                	li	a7,11
 380:	00000073          	ecall
 384:	8082                	ret

0000000000000386 <sbrk>:
 386:	48b1                	li	a7,12
 388:	00000073          	ecall
 38c:	8082                	ret

000000000000038e <sleep>:
 38e:	48b5                	li	a7,13
 390:	00000073          	ecall
 394:	8082                	ret

0000000000000396 <uptime>:
 396:	48b9                	li	a7,14
 398:	00000073          	ecall
 39c:	8082                	ret

000000000000039e <putc>:
 39e:	1101                	addi	sp,sp,-32
 3a0:	ec06                	sd	ra,24(sp)
 3a2:	e822                	sd	s0,16(sp)
 3a4:	1000                	addi	s0,sp,32
 3a6:	feb407a3          	sb	a1,-17(s0)
 3aa:	4605                	li	a2,1
 3ac:	fef40593          	addi	a1,s0,-17
 3b0:	00000097          	auipc	ra,0x0
 3b4:	f6e080e7          	jalr	-146(ra) # 31e <write>
 3b8:	60e2                	ld	ra,24(sp)
 3ba:	6442                	ld	s0,16(sp)
 3bc:	6105                	addi	sp,sp,32
 3be:	8082                	ret

00000000000003c0 <printint>:
 3c0:	7139                	addi	sp,sp,-64
 3c2:	fc06                	sd	ra,56(sp)
 3c4:	f822                	sd	s0,48(sp)
 3c6:	f426                	sd	s1,40(sp)
 3c8:	f04a                	sd	s2,32(sp)
 3ca:	ec4e                	sd	s3,24(sp)
 3cc:	0080                	addi	s0,sp,64
 3ce:	84aa                	mv	s1,a0
 3d0:	c299                	beqz	a3,3d6 <printint+0x16>
 3d2:	0805c963          	bltz	a1,464 <printint+0xa4>
 3d6:	2581                	sext.w	a1,a1
 3d8:	4881                	li	a7,0
 3da:	fc040693          	addi	a3,s0,-64
 3de:	4701                	li	a4,0
 3e0:	2601                	sext.w	a2,a2
 3e2:	00000517          	auipc	a0,0x0
 3e6:	4fe50513          	addi	a0,a0,1278 # 8e0 <digits>
 3ea:	883a                	mv	a6,a4
 3ec:	2705                	addiw	a4,a4,1
 3ee:	02c5f7bb          	remuw	a5,a1,a2
 3f2:	1782                	slli	a5,a5,0x20
 3f4:	9381                	srli	a5,a5,0x20
 3f6:	97aa                	add	a5,a5,a0
 3f8:	0007c783          	lbu	a5,0(a5)
 3fc:	00f68023          	sb	a5,0(a3)
 400:	0005879b          	sext.w	a5,a1
 404:	02c5d5bb          	divuw	a1,a1,a2
 408:	0685                	addi	a3,a3,1
 40a:	fec7f0e3          	bgeu	a5,a2,3ea <printint+0x2a>
 40e:	00088c63          	beqz	a7,426 <printint+0x66>
 412:	fd070793          	addi	a5,a4,-48
 416:	00878733          	add	a4,a5,s0
 41a:	02d00793          	li	a5,45
 41e:	fef70823          	sb	a5,-16(a4)
 422:	0028071b          	addiw	a4,a6,2
 426:	02e05863          	blez	a4,456 <printint+0x96>
 42a:	fc040793          	addi	a5,s0,-64
 42e:	00e78933          	add	s2,a5,a4
 432:	fff78993          	addi	s3,a5,-1
 436:	99ba                	add	s3,s3,a4
 438:	377d                	addiw	a4,a4,-1
 43a:	1702                	slli	a4,a4,0x20
 43c:	9301                	srli	a4,a4,0x20
 43e:	40e989b3          	sub	s3,s3,a4
 442:	fff94583          	lbu	a1,-1(s2)
 446:	8526                	mv	a0,s1
 448:	00000097          	auipc	ra,0x0
 44c:	f56080e7          	jalr	-170(ra) # 39e <putc>
 450:	197d                	addi	s2,s2,-1
 452:	ff3918e3          	bne	s2,s3,442 <printint+0x82>
 456:	70e2                	ld	ra,56(sp)
 458:	7442                	ld	s0,48(sp)
 45a:	74a2                	ld	s1,40(sp)
 45c:	7902                	ld	s2,32(sp)
 45e:	69e2                	ld	s3,24(sp)
 460:	6121                	addi	sp,sp,64
 462:	8082                	ret
 464:	40b005bb          	negw	a1,a1
 468:	4885                	li	a7,1
 46a:	bf85                	j	3da <printint+0x1a>

000000000000046c <vprintf>:
 46c:	715d                	addi	sp,sp,-80
 46e:	e486                	sd	ra,72(sp)
 470:	e0a2                	sd	s0,64(sp)
 472:	fc26                	sd	s1,56(sp)
 474:	f84a                	sd	s2,48(sp)
 476:	f44e                	sd	s3,40(sp)
 478:	f052                	sd	s4,32(sp)
 47a:	ec56                	sd	s5,24(sp)
 47c:	e85a                	sd	s6,16(sp)
 47e:	e45e                	sd	s7,8(sp)
 480:	e062                	sd	s8,0(sp)
 482:	0880                	addi	s0,sp,80
 484:	0005c903          	lbu	s2,0(a1)
 488:	18090c63          	beqz	s2,620 <vprintf+0x1b4>
 48c:	8aaa                	mv	s5,a0
 48e:	8bb2                	mv	s7,a2
 490:	00158493          	addi	s1,a1,1
 494:	4981                	li	s3,0
 496:	02500a13          	li	s4,37
 49a:	4b55                	li	s6,21
 49c:	a839                	j	4ba <vprintf+0x4e>
 49e:	85ca                	mv	a1,s2
 4a0:	8556                	mv	a0,s5
 4a2:	00000097          	auipc	ra,0x0
 4a6:	efc080e7          	jalr	-260(ra) # 39e <putc>
 4aa:	a019                	j	4b0 <vprintf+0x44>
 4ac:	01498d63          	beq	s3,s4,4c6 <vprintf+0x5a>
 4b0:	0485                	addi	s1,s1,1
 4b2:	fff4c903          	lbu	s2,-1(s1)
 4b6:	16090563          	beqz	s2,620 <vprintf+0x1b4>
 4ba:	fe0999e3          	bnez	s3,4ac <vprintf+0x40>
 4be:	ff4910e3          	bne	s2,s4,49e <vprintf+0x32>
 4c2:	89d2                	mv	s3,s4
 4c4:	b7f5                	j	4b0 <vprintf+0x44>
 4c6:	13490263          	beq	s2,s4,5ea <vprintf+0x17e>
 4ca:	f9d9079b          	addiw	a5,s2,-99
 4ce:	0ff7f793          	zext.b	a5,a5
 4d2:	12fb6563          	bltu	s6,a5,5fc <vprintf+0x190>
 4d6:	f9d9079b          	addiw	a5,s2,-99
 4da:	0ff7f713          	zext.b	a4,a5
 4de:	10eb6f63          	bltu	s6,a4,5fc <vprintf+0x190>
 4e2:	00271793          	slli	a5,a4,0x2
 4e6:	00000717          	auipc	a4,0x0
 4ea:	3a270713          	addi	a4,a4,930 # 888 <malloc+0x16a>
 4ee:	97ba                	add	a5,a5,a4
 4f0:	439c                	lw	a5,0(a5)
 4f2:	97ba                	add	a5,a5,a4
 4f4:	8782                	jr	a5
 4f6:	008b8913          	addi	s2,s7,8
 4fa:	4685                	li	a3,1
 4fc:	4629                	li	a2,10
 4fe:	000ba583          	lw	a1,0(s7)
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	ebc080e7          	jalr	-324(ra) # 3c0 <printint>
 50c:	8bca                	mv	s7,s2
 50e:	4981                	li	s3,0
 510:	b745                	j	4b0 <vprintf+0x44>
 512:	008b8913          	addi	s2,s7,8
 516:	4681                	li	a3,0
 518:	4629                	li	a2,10
 51a:	000ba583          	lw	a1,0(s7)
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	ea0080e7          	jalr	-352(ra) # 3c0 <printint>
 528:	8bca                	mv	s7,s2
 52a:	4981                	li	s3,0
 52c:	b751                	j	4b0 <vprintf+0x44>
 52e:	008b8913          	addi	s2,s7,8
 532:	4681                	li	a3,0
 534:	4641                	li	a2,16
 536:	000ba583          	lw	a1,0(s7)
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e84080e7          	jalr	-380(ra) # 3c0 <printint>
 544:	8bca                	mv	s7,s2
 546:	4981                	li	s3,0
 548:	b7a5                	j	4b0 <vprintf+0x44>
 54a:	008b8c13          	addi	s8,s7,8
 54e:	000bb983          	ld	s3,0(s7)
 552:	03000593          	li	a1,48
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	e46080e7          	jalr	-442(ra) # 39e <putc>
 560:	07800593          	li	a1,120
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e38080e7          	jalr	-456(ra) # 39e <putc>
 56e:	4941                	li	s2,16
 570:	00000b97          	auipc	s7,0x0
 574:	370b8b93          	addi	s7,s7,880 # 8e0 <digits>
 578:	03c9d793          	srli	a5,s3,0x3c
 57c:	97de                	add	a5,a5,s7
 57e:	0007c583          	lbu	a1,0(a5)
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	e1a080e7          	jalr	-486(ra) # 39e <putc>
 58c:	0992                	slli	s3,s3,0x4
 58e:	397d                	addiw	s2,s2,-1
 590:	fe0914e3          	bnez	s2,578 <vprintf+0x10c>
 594:	8be2                	mv	s7,s8
 596:	4981                	li	s3,0
 598:	bf21                	j	4b0 <vprintf+0x44>
 59a:	008b8993          	addi	s3,s7,8
 59e:	000bb903          	ld	s2,0(s7)
 5a2:	02090163          	beqz	s2,5c4 <vprintf+0x158>
 5a6:	00094583          	lbu	a1,0(s2)
 5aa:	c9a5                	beqz	a1,61a <vprintf+0x1ae>
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	df0080e7          	jalr	-528(ra) # 39e <putc>
 5b6:	0905                	addi	s2,s2,1
 5b8:	00094583          	lbu	a1,0(s2)
 5bc:	f9e5                	bnez	a1,5ac <vprintf+0x140>
 5be:	8bce                	mv	s7,s3
 5c0:	4981                	li	s3,0
 5c2:	b5fd                	j	4b0 <vprintf+0x44>
 5c4:	00000917          	auipc	s2,0x0
 5c8:	2bc90913          	addi	s2,s2,700 # 880 <malloc+0x162>
 5cc:	02800593          	li	a1,40
 5d0:	bff1                	j	5ac <vprintf+0x140>
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	000bc583          	lbu	a1,0(s7)
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	dc2080e7          	jalr	-574(ra) # 39e <putc>
 5e4:	8bca                	mv	s7,s2
 5e6:	4981                	li	s3,0
 5e8:	b5e1                	j	4b0 <vprintf+0x44>
 5ea:	02500593          	li	a1,37
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	dae080e7          	jalr	-594(ra) # 39e <putc>
 5f8:	4981                	li	s3,0
 5fa:	bd5d                	j	4b0 <vprintf+0x44>
 5fc:	02500593          	li	a1,37
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	d9c080e7          	jalr	-612(ra) # 39e <putc>
 60a:	85ca                	mv	a1,s2
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	d90080e7          	jalr	-624(ra) # 39e <putc>
 616:	4981                	li	s3,0
 618:	bd61                	j	4b0 <vprintf+0x44>
 61a:	8bce                	mv	s7,s3
 61c:	4981                	li	s3,0
 61e:	bd49                	j	4b0 <vprintf+0x44>
 620:	60a6                	ld	ra,72(sp)
 622:	6406                	ld	s0,64(sp)
 624:	74e2                	ld	s1,56(sp)
 626:	7942                	ld	s2,48(sp)
 628:	79a2                	ld	s3,40(sp)
 62a:	7a02                	ld	s4,32(sp)
 62c:	6ae2                	ld	s5,24(sp)
 62e:	6b42                	ld	s6,16(sp)
 630:	6ba2                	ld	s7,8(sp)
 632:	6c02                	ld	s8,0(sp)
 634:	6161                	addi	sp,sp,80
 636:	8082                	ret

0000000000000638 <fprintf>:
 638:	715d                	addi	sp,sp,-80
 63a:	ec06                	sd	ra,24(sp)
 63c:	e822                	sd	s0,16(sp)
 63e:	1000                	addi	s0,sp,32
 640:	e010                	sd	a2,0(s0)
 642:	e414                	sd	a3,8(s0)
 644:	e818                	sd	a4,16(s0)
 646:	ec1c                	sd	a5,24(s0)
 648:	03043023          	sd	a6,32(s0)
 64c:	03143423          	sd	a7,40(s0)
 650:	fe843423          	sd	s0,-24(s0)
 654:	8622                	mv	a2,s0
 656:	00000097          	auipc	ra,0x0
 65a:	e16080e7          	jalr	-490(ra) # 46c <vprintf>
 65e:	60e2                	ld	ra,24(sp)
 660:	6442                	ld	s0,16(sp)
 662:	6161                	addi	sp,sp,80
 664:	8082                	ret

0000000000000666 <printf>:
 666:	711d                	addi	sp,sp,-96
 668:	ec06                	sd	ra,24(sp)
 66a:	e822                	sd	s0,16(sp)
 66c:	1000                	addi	s0,sp,32
 66e:	e40c                	sd	a1,8(s0)
 670:	e810                	sd	a2,16(s0)
 672:	ec14                	sd	a3,24(s0)
 674:	f018                	sd	a4,32(s0)
 676:	f41c                	sd	a5,40(s0)
 678:	03043823          	sd	a6,48(s0)
 67c:	03143c23          	sd	a7,56(s0)
 680:	00840613          	addi	a2,s0,8
 684:	fec43423          	sd	a2,-24(s0)
 688:	85aa                	mv	a1,a0
 68a:	4505                	li	a0,1
 68c:	00000097          	auipc	ra,0x0
 690:	de0080e7          	jalr	-544(ra) # 46c <vprintf>
 694:	60e2                	ld	ra,24(sp)
 696:	6442                	ld	s0,16(sp)
 698:	6125                	addi	sp,sp,96
 69a:	8082                	ret

000000000000069c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69c:	1141                	addi	sp,sp,-16
 69e:	e422                	sd	s0,8(sp)
 6a0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a6:	00001797          	auipc	a5,0x1
 6aa:	95a7b783          	ld	a5,-1702(a5) # 1000 <freep>
 6ae:	a02d                	j	6d8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b0:	4618                	lw	a4,8(a2)
 6b2:	9f2d                	addw	a4,a4,a1
 6b4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	6398                	ld	a4,0(a5)
 6ba:	6310                	ld	a2,0(a4)
 6bc:	a83d                	j	6fa <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6be:	ff852703          	lw	a4,-8(a0)
 6c2:	9f31                	addw	a4,a4,a2
 6c4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6c6:	ff053683          	ld	a3,-16(a0)
 6ca:	a091                	j	70e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cc:	6398                	ld	a4,0(a5)
 6ce:	00e7e463          	bltu	a5,a4,6d6 <free+0x3a>
 6d2:	00e6ea63          	bltu	a3,a4,6e6 <free+0x4a>
{
 6d6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d8:	fed7fae3          	bgeu	a5,a3,6cc <free+0x30>
 6dc:	6398                	ld	a4,0(a5)
 6de:	00e6e463          	bltu	a3,a4,6e6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e2:	fee7eae3          	bltu	a5,a4,6d6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6e6:	ff852583          	lw	a1,-8(a0)
 6ea:	6390                	ld	a2,0(a5)
 6ec:	02059813          	slli	a6,a1,0x20
 6f0:	01c85713          	srli	a4,a6,0x1c
 6f4:	9736                	add	a4,a4,a3
 6f6:	fae60de3          	beq	a2,a4,6b0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6fa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6fe:	4790                	lw	a2,8(a5)
 700:	02061593          	slli	a1,a2,0x20
 704:	01c5d713          	srli	a4,a1,0x1c
 708:	973e                	add	a4,a4,a5
 70a:	fae68ae3          	beq	a3,a4,6be <free+0x22>
    p->s.ptr = bp->s.ptr;
 70e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 710:	00001717          	auipc	a4,0x1
 714:	8ef73823          	sd	a5,-1808(a4) # 1000 <freep>
}
 718:	6422                	ld	s0,8(sp)
 71a:	0141                	addi	sp,sp,16
 71c:	8082                	ret

000000000000071e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 71e:	7139                	addi	sp,sp,-64
 720:	fc06                	sd	ra,56(sp)
 722:	f822                	sd	s0,48(sp)
 724:	f426                	sd	s1,40(sp)
 726:	f04a                	sd	s2,32(sp)
 728:	ec4e                	sd	s3,24(sp)
 72a:	e852                	sd	s4,16(sp)
 72c:	e456                	sd	s5,8(sp)
 72e:	e05a                	sd	s6,0(sp)
 730:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 732:	02051493          	slli	s1,a0,0x20
 736:	9081                	srli	s1,s1,0x20
 738:	04bd                	addi	s1,s1,15
 73a:	8091                	srli	s1,s1,0x4
 73c:	0014899b          	addiw	s3,s1,1
 740:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 742:	00001517          	auipc	a0,0x1
 746:	8be53503          	ld	a0,-1858(a0) # 1000 <freep>
 74a:	c515                	beqz	a0,776 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 74e:	4798                	lw	a4,8(a5)
 750:	02977f63          	bgeu	a4,s1,78e <malloc+0x70>
  if(nu < 4096)
 754:	8a4e                	mv	s4,s3
 756:	0009871b          	sext.w	a4,s3
 75a:	6685                	lui	a3,0x1
 75c:	00d77363          	bgeu	a4,a3,762 <malloc+0x44>
 760:	6a05                	lui	s4,0x1
 762:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 766:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 76a:	00001917          	auipc	s2,0x1
 76e:	89690913          	addi	s2,s2,-1898 # 1000 <freep>
  if(p == (char*)-1)
 772:	5afd                	li	s5,-1
 774:	a895                	j	7e8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 776:	00001797          	auipc	a5,0x1
 77a:	89a78793          	addi	a5,a5,-1894 # 1010 <base>
 77e:	00001717          	auipc	a4,0x1
 782:	88f73123          	sd	a5,-1918(a4) # 1000 <freep>
 786:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 788:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 78c:	b7e1                	j	754 <malloc+0x36>
      if(p->s.size == nunits)
 78e:	02e48c63          	beq	s1,a4,7c6 <malloc+0xa8>
        p->s.size -= nunits;
 792:	4137073b          	subw	a4,a4,s3
 796:	c798                	sw	a4,8(a5)
        p += p->s.size;
 798:	02071693          	slli	a3,a4,0x20
 79c:	01c6d713          	srli	a4,a3,0x1c
 7a0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7a2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7a6:	00001717          	auipc	a4,0x1
 7aa:	84a73d23          	sd	a0,-1958(a4) # 1000 <freep>
      return (void*)(p + 1);
 7ae:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b2:	70e2                	ld	ra,56(sp)
 7b4:	7442                	ld	s0,48(sp)
 7b6:	74a2                	ld	s1,40(sp)
 7b8:	7902                	ld	s2,32(sp)
 7ba:	69e2                	ld	s3,24(sp)
 7bc:	6a42                	ld	s4,16(sp)
 7be:	6aa2                	ld	s5,8(sp)
 7c0:	6b02                	ld	s6,0(sp)
 7c2:	6121                	addi	sp,sp,64
 7c4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7c6:	6398                	ld	a4,0(a5)
 7c8:	e118                	sd	a4,0(a0)
 7ca:	bff1                	j	7a6 <malloc+0x88>
  hp->s.size = nu;
 7cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7d0:	0541                	addi	a0,a0,16
 7d2:	00000097          	auipc	ra,0x0
 7d6:	eca080e7          	jalr	-310(ra) # 69c <free>
  return freep;
 7da:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7de:	d971                	beqz	a0,7b2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e2:	4798                	lw	a4,8(a5)
 7e4:	fa9775e3          	bgeu	a4,s1,78e <malloc+0x70>
    if(p == freep)
 7e8:	00093703          	ld	a4,0(s2)
 7ec:	853e                	mv	a0,a5
 7ee:	fef719e3          	bne	a4,a5,7e0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7f2:	8552                	mv	a0,s4
 7f4:	00000097          	auipc	ra,0x0
 7f8:	b92080e7          	jalr	-1134(ra) # 386 <sbrk>
  if(p == (char*)-1)
 7fc:	fd5518e3          	bne	a0,s5,7cc <malloc+0xae>
        return 0;
 800:	4501                	li	a0,0
 802:	bf45                	j	7b2 <malloc+0x94>

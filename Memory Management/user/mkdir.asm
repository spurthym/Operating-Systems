
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	4785                	li	a5,1
   e:	02a7d763          	bge	a5,a0,3c <main+0x3c>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	33c080e7          	jalr	828(ra) # 364 <mkdir>
  30:	02054463          	bltz	a0,58 <main+0x58>
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
  3a:	a80d                	j	6c <main+0x6c>
  3c:	00000597          	auipc	a1,0x0
  40:	7d458593          	addi	a1,a1,2004 # 810 <malloc+0xf4>
  44:	4509                	li	a0,2
  46:	00000097          	auipc	ra,0x0
  4a:	5f0080e7          	jalr	1520(ra) # 636 <fprintf>
  4e:	4505                	li	a0,1
  50:	00000097          	auipc	ra,0x0
  54:	2ac080e7          	jalr	684(ra) # 2fc <exit>
  58:	6090                	ld	a2,0(s1)
  5a:	00000597          	auipc	a1,0x0
  5e:	7ce58593          	addi	a1,a1,1998 # 828 <malloc+0x10c>
  62:	4509                	li	a0,2
  64:	00000097          	auipc	ra,0x0
  68:	5d2080e7          	jalr	1490(ra) # 636 <fprintf>
  6c:	4501                	li	a0,0
  6e:	00000097          	auipc	ra,0x0
  72:	28e080e7          	jalr	654(ra) # 2fc <exit>

0000000000000076 <_main>:
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
  7e:	00000097          	auipc	ra,0x0
  82:	f82080e7          	jalr	-126(ra) # 0 <main>
  86:	4501                	li	a0,0
  88:	00000097          	auipc	ra,0x0
  8c:	274080e7          	jalr	628(ra) # 2fc <exit>

0000000000000090 <strcpy>:
  90:	1141                	addi	sp,sp,-16
  92:	e422                	sd	s0,8(sp)
  94:	0800                	addi	s0,sp,16
  96:	87aa                	mv	a5,a0
  98:	0585                	addi	a1,a1,1
  9a:	0785                	addi	a5,a5,1
  9c:	fff5c703          	lbu	a4,-1(a1)
  a0:	fee78fa3          	sb	a4,-1(a5)
  a4:	fb75                	bnez	a4,98 <strcpy+0x8>
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strcmp>:
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  b2:	00054783          	lbu	a5,0(a0)
  b6:	cb91                	beqz	a5,ca <strcmp+0x1e>
  b8:	0005c703          	lbu	a4,0(a1)
  bc:	00f71763          	bne	a4,a5,ca <strcmp+0x1e>
  c0:	0505                	addi	a0,a0,1
  c2:	0585                	addi	a1,a1,1
  c4:	00054783          	lbu	a5,0(a0)
  c8:	fbe5                	bnez	a5,b8 <strcmp+0xc>
  ca:	0005c503          	lbu	a0,0(a1)
  ce:	40a7853b          	subw	a0,a5,a0
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strlen>:
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  de:	00054783          	lbu	a5,0(a0)
  e2:	cf91                	beqz	a5,fe <strlen+0x26>
  e4:	0505                	addi	a0,a0,1
  e6:	87aa                	mv	a5,a0
  e8:	86be                	mv	a3,a5
  ea:	0785                	addi	a5,a5,1
  ec:	fff7c703          	lbu	a4,-1(a5)
  f0:	ff65                	bnez	a4,e8 <strlen+0x10>
  f2:	40a6853b          	subw	a0,a3,a0
  f6:	2505                	addiw	a0,a0,1
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret
  fe:	4501                	li	a0,0
 100:	bfe5                	j	f8 <strlen+0x20>

0000000000000102 <memset>:
 102:	1141                	addi	sp,sp,-16
 104:	e422                	sd	s0,8(sp)
 106:	0800                	addi	s0,sp,16
 108:	ca19                	beqz	a2,11e <memset+0x1c>
 10a:	87aa                	mv	a5,a0
 10c:	1602                	slli	a2,a2,0x20
 10e:	9201                	srli	a2,a2,0x20
 110:	00a60733          	add	a4,a2,a0
 114:	00b78023          	sb	a1,0(a5)
 118:	0785                	addi	a5,a5,1
 11a:	fee79de3          	bne	a5,a4,114 <memset+0x12>
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <strchr>:
 124:	1141                	addi	sp,sp,-16
 126:	e422                	sd	s0,8(sp)
 128:	0800                	addi	s0,sp,16
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cb99                	beqz	a5,144 <strchr+0x20>
 130:	00f58763          	beq	a1,a5,13e <strchr+0x1a>
 134:	0505                	addi	a0,a0,1
 136:	00054783          	lbu	a5,0(a0)
 13a:	fbfd                	bnez	a5,130 <strchr+0xc>
 13c:	4501                	li	a0,0
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
 144:	4501                	li	a0,0
 146:	bfe5                	j	13e <strchr+0x1a>

0000000000000148 <gets>:
 148:	711d                	addi	sp,sp,-96
 14a:	ec86                	sd	ra,88(sp)
 14c:	e8a2                	sd	s0,80(sp)
 14e:	e4a6                	sd	s1,72(sp)
 150:	e0ca                	sd	s2,64(sp)
 152:	fc4e                	sd	s3,56(sp)
 154:	f852                	sd	s4,48(sp)
 156:	f456                	sd	s5,40(sp)
 158:	f05a                	sd	s6,32(sp)
 15a:	ec5e                	sd	s7,24(sp)
 15c:	1080                	addi	s0,sp,96
 15e:	8baa                	mv	s7,a0
 160:	8a2e                	mv	s4,a1
 162:	892a                	mv	s2,a0
 164:	4481                	li	s1,0
 166:	4aa9                	li	s5,10
 168:	4b35                	li	s6,13
 16a:	89a6                	mv	s3,s1
 16c:	2485                	addiw	s1,s1,1
 16e:	0344d863          	bge	s1,s4,19e <gets+0x56>
 172:	4605                	li	a2,1
 174:	faf40593          	addi	a1,s0,-81
 178:	4501                	li	a0,0
 17a:	00000097          	auipc	ra,0x0
 17e:	19a080e7          	jalr	410(ra) # 314 <read>
 182:	00a05e63          	blez	a0,19e <gets+0x56>
 186:	faf44783          	lbu	a5,-81(s0)
 18a:	00f90023          	sb	a5,0(s2)
 18e:	01578763          	beq	a5,s5,19c <gets+0x54>
 192:	0905                	addi	s2,s2,1
 194:	fd679be3          	bne	a5,s6,16a <gets+0x22>
 198:	89a6                	mv	s3,s1
 19a:	a011                	j	19e <gets+0x56>
 19c:	89a6                	mv	s3,s1
 19e:	99de                	add	s3,s3,s7
 1a0:	00098023          	sb	zero,0(s3)
 1a4:	855e                	mv	a0,s7
 1a6:	60e6                	ld	ra,88(sp)
 1a8:	6446                	ld	s0,80(sp)
 1aa:	64a6                	ld	s1,72(sp)
 1ac:	6906                	ld	s2,64(sp)
 1ae:	79e2                	ld	s3,56(sp)
 1b0:	7a42                	ld	s4,48(sp)
 1b2:	7aa2                	ld	s5,40(sp)
 1b4:	7b02                	ld	s6,32(sp)
 1b6:	6be2                	ld	s7,24(sp)
 1b8:	6125                	addi	sp,sp,96
 1ba:	8082                	ret

00000000000001bc <stat>:
 1bc:	1101                	addi	sp,sp,-32
 1be:	ec06                	sd	ra,24(sp)
 1c0:	e822                	sd	s0,16(sp)
 1c2:	e426                	sd	s1,8(sp)
 1c4:	e04a                	sd	s2,0(sp)
 1c6:	1000                	addi	s0,sp,32
 1c8:	892e                	mv	s2,a1
 1ca:	4581                	li	a1,0
 1cc:	00000097          	auipc	ra,0x0
 1d0:	170080e7          	jalr	368(ra) # 33c <open>
 1d4:	02054563          	bltz	a0,1fe <stat+0x42>
 1d8:	84aa                	mv	s1,a0
 1da:	85ca                	mv	a1,s2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	178080e7          	jalr	376(ra) # 354 <fstat>
 1e4:	892a                	mv	s2,a0
 1e6:	8526                	mv	a0,s1
 1e8:	00000097          	auipc	ra,0x0
 1ec:	13c080e7          	jalr	316(ra) # 324 <close>
 1f0:	854a                	mv	a0,s2
 1f2:	60e2                	ld	ra,24(sp)
 1f4:	6442                	ld	s0,16(sp)
 1f6:	64a2                	ld	s1,8(sp)
 1f8:	6902                	ld	s2,0(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
 1fe:	597d                	li	s2,-1
 200:	bfc5                	j	1f0 <stat+0x34>

0000000000000202 <atoi>:
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
 208:	00054683          	lbu	a3,0(a0)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	4625                	li	a2,9
 216:	02f66863          	bltu	a2,a5,246 <atoi+0x44>
 21a:	872a                	mv	a4,a0
 21c:	4501                	li	a0,0
 21e:	0705                	addi	a4,a4,1
 220:	0025179b          	slliw	a5,a0,0x2
 224:	9fa9                	addw	a5,a5,a0
 226:	0017979b          	slliw	a5,a5,0x1
 22a:	9fb5                	addw	a5,a5,a3
 22c:	fd07851b          	addiw	a0,a5,-48
 230:	00074683          	lbu	a3,0(a4)
 234:	fd06879b          	addiw	a5,a3,-48
 238:	0ff7f793          	zext.b	a5,a5
 23c:	fef671e3          	bgeu	a2,a5,21e <atoi+0x1c>
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
 246:	4501                	li	a0,0
 248:	bfe5                	j	240 <atoi+0x3e>

000000000000024a <memmove>:
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
 250:	02b57463          	bgeu	a0,a1,278 <memmove+0x2e>
 254:	00c05f63          	blez	a2,272 <memmove+0x28>
 258:	1602                	slli	a2,a2,0x20
 25a:	9201                	srli	a2,a2,0x20
 25c:	00c507b3          	add	a5,a0,a2
 260:	872a                	mv	a4,a0
 262:	0585                	addi	a1,a1,1
 264:	0705                	addi	a4,a4,1
 266:	fff5c683          	lbu	a3,-1(a1)
 26a:	fed70fa3          	sb	a3,-1(a4)
 26e:	fee79ae3          	bne	a5,a4,262 <memmove+0x18>
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret
 278:	00c50733          	add	a4,a0,a2
 27c:	95b2                	add	a1,a1,a2
 27e:	fec05ae3          	blez	a2,272 <memmove+0x28>
 282:	fff6079b          	addiw	a5,a2,-1
 286:	1782                	slli	a5,a5,0x20
 288:	9381                	srli	a5,a5,0x20
 28a:	fff7c793          	not	a5,a5
 28e:	97ba                	add	a5,a5,a4
 290:	15fd                	addi	a1,a1,-1
 292:	177d                	addi	a4,a4,-1
 294:	0005c683          	lbu	a3,0(a1)
 298:	00d70023          	sb	a3,0(a4)
 29c:	fee79ae3          	bne	a5,a4,290 <memmove+0x46>
 2a0:	bfc9                	j	272 <memmove+0x28>

00000000000002a2 <memcmp>:
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
 2a8:	ca05                	beqz	a2,2d8 <memcmp+0x36>
 2aa:	fff6069b          	addiw	a3,a2,-1
 2ae:	1682                	slli	a3,a3,0x20
 2b0:	9281                	srli	a3,a3,0x20
 2b2:	0685                	addi	a3,a3,1
 2b4:	96aa                	add	a3,a3,a0
 2b6:	00054783          	lbu	a5,0(a0)
 2ba:	0005c703          	lbu	a4,0(a1)
 2be:	00e79863          	bne	a5,a4,2ce <memcmp+0x2c>
 2c2:	0505                	addi	a0,a0,1
 2c4:	0585                	addi	a1,a1,1
 2c6:	fed518e3          	bne	a0,a3,2b6 <memcmp+0x14>
 2ca:	4501                	li	a0,0
 2cc:	a019                	j	2d2 <memcmp+0x30>
 2ce:	40e7853b          	subw	a0,a5,a4
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
 2d8:	4501                	li	a0,0
 2da:	bfe5                	j	2d2 <memcmp+0x30>

00000000000002dc <memcpy>:
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
 2e4:	00000097          	auipc	ra,0x0
 2e8:	f66080e7          	jalr	-154(ra) # 24a <memmove>
 2ec:	60a2                	ld	ra,8(sp)
 2ee:	6402                	ld	s0,0(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <fork>:
 2f4:	4885                	li	a7,1
 2f6:	00000073          	ecall
 2fa:	8082                	ret

00000000000002fc <exit>:
 2fc:	4889                	li	a7,2
 2fe:	00000073          	ecall
 302:	8082                	ret

0000000000000304 <wait>:
 304:	488d                	li	a7,3
 306:	00000073          	ecall
 30a:	8082                	ret

000000000000030c <pipe>:
 30c:	4891                	li	a7,4
 30e:	00000073          	ecall
 312:	8082                	ret

0000000000000314 <read>:
 314:	4895                	li	a7,5
 316:	00000073          	ecall
 31a:	8082                	ret

000000000000031c <write>:
 31c:	48c1                	li	a7,16
 31e:	00000073          	ecall
 322:	8082                	ret

0000000000000324 <close>:
 324:	48d5                	li	a7,21
 326:	00000073          	ecall
 32a:	8082                	ret

000000000000032c <kill>:
 32c:	4899                	li	a7,6
 32e:	00000073          	ecall
 332:	8082                	ret

0000000000000334 <exec>:
 334:	489d                	li	a7,7
 336:	00000073          	ecall
 33a:	8082                	ret

000000000000033c <open>:
 33c:	48bd                	li	a7,15
 33e:	00000073          	ecall
 342:	8082                	ret

0000000000000344 <mknod>:
 344:	48c5                	li	a7,17
 346:	00000073          	ecall
 34a:	8082                	ret

000000000000034c <unlink>:
 34c:	48c9                	li	a7,18
 34e:	00000073          	ecall
 352:	8082                	ret

0000000000000354 <fstat>:
 354:	48a1                	li	a7,8
 356:	00000073          	ecall
 35a:	8082                	ret

000000000000035c <link>:
 35c:	48cd                	li	a7,19
 35e:	00000073          	ecall
 362:	8082                	ret

0000000000000364 <mkdir>:
 364:	48d1                	li	a7,20
 366:	00000073          	ecall
 36a:	8082                	ret

000000000000036c <chdir>:
 36c:	48a5                	li	a7,9
 36e:	00000073          	ecall
 372:	8082                	ret

0000000000000374 <dup>:
 374:	48a9                	li	a7,10
 376:	00000073          	ecall
 37a:	8082                	ret

000000000000037c <getpid>:
 37c:	48ad                	li	a7,11
 37e:	00000073          	ecall
 382:	8082                	ret

0000000000000384 <sbrk>:
 384:	48b1                	li	a7,12
 386:	00000073          	ecall
 38a:	8082                	ret

000000000000038c <sleep>:
 38c:	48b5                	li	a7,13
 38e:	00000073          	ecall
 392:	8082                	ret

0000000000000394 <uptime>:
 394:	48b9                	li	a7,14
 396:	00000073          	ecall
 39a:	8082                	ret

000000000000039c <putc>:
 39c:	1101                	addi	sp,sp,-32
 39e:	ec06                	sd	ra,24(sp)
 3a0:	e822                	sd	s0,16(sp)
 3a2:	1000                	addi	s0,sp,32
 3a4:	feb407a3          	sb	a1,-17(s0)
 3a8:	4605                	li	a2,1
 3aa:	fef40593          	addi	a1,s0,-17
 3ae:	00000097          	auipc	ra,0x0
 3b2:	f6e080e7          	jalr	-146(ra) # 31c <write>
 3b6:	60e2                	ld	ra,24(sp)
 3b8:	6442                	ld	s0,16(sp)
 3ba:	6105                	addi	sp,sp,32
 3bc:	8082                	ret

00000000000003be <printint>:
 3be:	7139                	addi	sp,sp,-64
 3c0:	fc06                	sd	ra,56(sp)
 3c2:	f822                	sd	s0,48(sp)
 3c4:	f426                	sd	s1,40(sp)
 3c6:	f04a                	sd	s2,32(sp)
 3c8:	ec4e                	sd	s3,24(sp)
 3ca:	0080                	addi	s0,sp,64
 3cc:	84aa                	mv	s1,a0
 3ce:	c299                	beqz	a3,3d4 <printint+0x16>
 3d0:	0805c963          	bltz	a1,462 <printint+0xa4>
 3d4:	2581                	sext.w	a1,a1
 3d6:	4881                	li	a7,0
 3d8:	fc040693          	addi	a3,s0,-64
 3dc:	4701                	li	a4,0
 3de:	2601                	sext.w	a2,a2
 3e0:	00000517          	auipc	a0,0x0
 3e4:	4c850513          	addi	a0,a0,1224 # 8a8 <digits>
 3e8:	883a                	mv	a6,a4
 3ea:	2705                	addiw	a4,a4,1
 3ec:	02c5f7bb          	remuw	a5,a1,a2
 3f0:	1782                	slli	a5,a5,0x20
 3f2:	9381                	srli	a5,a5,0x20
 3f4:	97aa                	add	a5,a5,a0
 3f6:	0007c783          	lbu	a5,0(a5)
 3fa:	00f68023          	sb	a5,0(a3)
 3fe:	0005879b          	sext.w	a5,a1
 402:	02c5d5bb          	divuw	a1,a1,a2
 406:	0685                	addi	a3,a3,1
 408:	fec7f0e3          	bgeu	a5,a2,3e8 <printint+0x2a>
 40c:	00088c63          	beqz	a7,424 <printint+0x66>
 410:	fd070793          	addi	a5,a4,-48
 414:	00878733          	add	a4,a5,s0
 418:	02d00793          	li	a5,45
 41c:	fef70823          	sb	a5,-16(a4)
 420:	0028071b          	addiw	a4,a6,2
 424:	02e05863          	blez	a4,454 <printint+0x96>
 428:	fc040793          	addi	a5,s0,-64
 42c:	00e78933          	add	s2,a5,a4
 430:	fff78993          	addi	s3,a5,-1
 434:	99ba                	add	s3,s3,a4
 436:	377d                	addiw	a4,a4,-1
 438:	1702                	slli	a4,a4,0x20
 43a:	9301                	srli	a4,a4,0x20
 43c:	40e989b3          	sub	s3,s3,a4
 440:	fff94583          	lbu	a1,-1(s2)
 444:	8526                	mv	a0,s1
 446:	00000097          	auipc	ra,0x0
 44a:	f56080e7          	jalr	-170(ra) # 39c <putc>
 44e:	197d                	addi	s2,s2,-1
 450:	ff3918e3          	bne	s2,s3,440 <printint+0x82>
 454:	70e2                	ld	ra,56(sp)
 456:	7442                	ld	s0,48(sp)
 458:	74a2                	ld	s1,40(sp)
 45a:	7902                	ld	s2,32(sp)
 45c:	69e2                	ld	s3,24(sp)
 45e:	6121                	addi	sp,sp,64
 460:	8082                	ret
 462:	40b005bb          	negw	a1,a1
 466:	4885                	li	a7,1
 468:	bf85                	j	3d8 <printint+0x1a>

000000000000046a <vprintf>:
 46a:	715d                	addi	sp,sp,-80
 46c:	e486                	sd	ra,72(sp)
 46e:	e0a2                	sd	s0,64(sp)
 470:	fc26                	sd	s1,56(sp)
 472:	f84a                	sd	s2,48(sp)
 474:	f44e                	sd	s3,40(sp)
 476:	f052                	sd	s4,32(sp)
 478:	ec56                	sd	s5,24(sp)
 47a:	e85a                	sd	s6,16(sp)
 47c:	e45e                	sd	s7,8(sp)
 47e:	e062                	sd	s8,0(sp)
 480:	0880                	addi	s0,sp,80
 482:	0005c903          	lbu	s2,0(a1)
 486:	18090c63          	beqz	s2,61e <vprintf+0x1b4>
 48a:	8aaa                	mv	s5,a0
 48c:	8bb2                	mv	s7,a2
 48e:	00158493          	addi	s1,a1,1
 492:	4981                	li	s3,0
 494:	02500a13          	li	s4,37
 498:	4b55                	li	s6,21
 49a:	a839                	j	4b8 <vprintf+0x4e>
 49c:	85ca                	mv	a1,s2
 49e:	8556                	mv	a0,s5
 4a0:	00000097          	auipc	ra,0x0
 4a4:	efc080e7          	jalr	-260(ra) # 39c <putc>
 4a8:	a019                	j	4ae <vprintf+0x44>
 4aa:	01498d63          	beq	s3,s4,4c4 <vprintf+0x5a>
 4ae:	0485                	addi	s1,s1,1
 4b0:	fff4c903          	lbu	s2,-1(s1)
 4b4:	16090563          	beqz	s2,61e <vprintf+0x1b4>
 4b8:	fe0999e3          	bnez	s3,4aa <vprintf+0x40>
 4bc:	ff4910e3          	bne	s2,s4,49c <vprintf+0x32>
 4c0:	89d2                	mv	s3,s4
 4c2:	b7f5                	j	4ae <vprintf+0x44>
 4c4:	13490263          	beq	s2,s4,5e8 <vprintf+0x17e>
 4c8:	f9d9079b          	addiw	a5,s2,-99
 4cc:	0ff7f793          	zext.b	a5,a5
 4d0:	12fb6563          	bltu	s6,a5,5fa <vprintf+0x190>
 4d4:	f9d9079b          	addiw	a5,s2,-99
 4d8:	0ff7f713          	zext.b	a4,a5
 4dc:	10eb6f63          	bltu	s6,a4,5fa <vprintf+0x190>
 4e0:	00271793          	slli	a5,a4,0x2
 4e4:	00000717          	auipc	a4,0x0
 4e8:	36c70713          	addi	a4,a4,876 # 850 <malloc+0x134>
 4ec:	97ba                	add	a5,a5,a4
 4ee:	439c                	lw	a5,0(a5)
 4f0:	97ba                	add	a5,a5,a4
 4f2:	8782                	jr	a5
 4f4:	008b8913          	addi	s2,s7,8
 4f8:	4685                	li	a3,1
 4fa:	4629                	li	a2,10
 4fc:	000ba583          	lw	a1,0(s7)
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	ebc080e7          	jalr	-324(ra) # 3be <printint>
 50a:	8bca                	mv	s7,s2
 50c:	4981                	li	s3,0
 50e:	b745                	j	4ae <vprintf+0x44>
 510:	008b8913          	addi	s2,s7,8
 514:	4681                	li	a3,0
 516:	4629                	li	a2,10
 518:	000ba583          	lw	a1,0(s7)
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	ea0080e7          	jalr	-352(ra) # 3be <printint>
 526:	8bca                	mv	s7,s2
 528:	4981                	li	s3,0
 52a:	b751                	j	4ae <vprintf+0x44>
 52c:	008b8913          	addi	s2,s7,8
 530:	4681                	li	a3,0
 532:	4641                	li	a2,16
 534:	000ba583          	lw	a1,0(s7)
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	e84080e7          	jalr	-380(ra) # 3be <printint>
 542:	8bca                	mv	s7,s2
 544:	4981                	li	s3,0
 546:	b7a5                	j	4ae <vprintf+0x44>
 548:	008b8c13          	addi	s8,s7,8
 54c:	000bb983          	ld	s3,0(s7)
 550:	03000593          	li	a1,48
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	e46080e7          	jalr	-442(ra) # 39c <putc>
 55e:	07800593          	li	a1,120
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	e38080e7          	jalr	-456(ra) # 39c <putc>
 56c:	4941                	li	s2,16
 56e:	00000b97          	auipc	s7,0x0
 572:	33ab8b93          	addi	s7,s7,826 # 8a8 <digits>
 576:	03c9d793          	srli	a5,s3,0x3c
 57a:	97de                	add	a5,a5,s7
 57c:	0007c583          	lbu	a1,0(a5)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e1a080e7          	jalr	-486(ra) # 39c <putc>
 58a:	0992                	slli	s3,s3,0x4
 58c:	397d                	addiw	s2,s2,-1
 58e:	fe0914e3          	bnez	s2,576 <vprintf+0x10c>
 592:	8be2                	mv	s7,s8
 594:	4981                	li	s3,0
 596:	bf21                	j	4ae <vprintf+0x44>
 598:	008b8993          	addi	s3,s7,8
 59c:	000bb903          	ld	s2,0(s7)
 5a0:	02090163          	beqz	s2,5c2 <vprintf+0x158>
 5a4:	00094583          	lbu	a1,0(s2)
 5a8:	c9a5                	beqz	a1,618 <vprintf+0x1ae>
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	df0080e7          	jalr	-528(ra) # 39c <putc>
 5b4:	0905                	addi	s2,s2,1
 5b6:	00094583          	lbu	a1,0(s2)
 5ba:	f9e5                	bnez	a1,5aa <vprintf+0x140>
 5bc:	8bce                	mv	s7,s3
 5be:	4981                	li	s3,0
 5c0:	b5fd                	j	4ae <vprintf+0x44>
 5c2:	00000917          	auipc	s2,0x0
 5c6:	28690913          	addi	s2,s2,646 # 848 <malloc+0x12c>
 5ca:	02800593          	li	a1,40
 5ce:	bff1                	j	5aa <vprintf+0x140>
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	000bc583          	lbu	a1,0(s7)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	dc2080e7          	jalr	-574(ra) # 39c <putc>
 5e2:	8bca                	mv	s7,s2
 5e4:	4981                	li	s3,0
 5e6:	b5e1                	j	4ae <vprintf+0x44>
 5e8:	02500593          	li	a1,37
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	dae080e7          	jalr	-594(ra) # 39c <putc>
 5f6:	4981                	li	s3,0
 5f8:	bd5d                	j	4ae <vprintf+0x44>
 5fa:	02500593          	li	a1,37
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	d9c080e7          	jalr	-612(ra) # 39c <putc>
 608:	85ca                	mv	a1,s2
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	d90080e7          	jalr	-624(ra) # 39c <putc>
 614:	4981                	li	s3,0
 616:	bd61                	j	4ae <vprintf+0x44>
 618:	8bce                	mv	s7,s3
 61a:	4981                	li	s3,0
 61c:	bd49                	j	4ae <vprintf+0x44>
 61e:	60a6                	ld	ra,72(sp)
 620:	6406                	ld	s0,64(sp)
 622:	74e2                	ld	s1,56(sp)
 624:	7942                	ld	s2,48(sp)
 626:	79a2                	ld	s3,40(sp)
 628:	7a02                	ld	s4,32(sp)
 62a:	6ae2                	ld	s5,24(sp)
 62c:	6b42                	ld	s6,16(sp)
 62e:	6ba2                	ld	s7,8(sp)
 630:	6c02                	ld	s8,0(sp)
 632:	6161                	addi	sp,sp,80
 634:	8082                	ret

0000000000000636 <fprintf>:
 636:	715d                	addi	sp,sp,-80
 638:	ec06                	sd	ra,24(sp)
 63a:	e822                	sd	s0,16(sp)
 63c:	1000                	addi	s0,sp,32
 63e:	e010                	sd	a2,0(s0)
 640:	e414                	sd	a3,8(s0)
 642:	e818                	sd	a4,16(s0)
 644:	ec1c                	sd	a5,24(s0)
 646:	03043023          	sd	a6,32(s0)
 64a:	03143423          	sd	a7,40(s0)
 64e:	fe843423          	sd	s0,-24(s0)
 652:	8622                	mv	a2,s0
 654:	00000097          	auipc	ra,0x0
 658:	e16080e7          	jalr	-490(ra) # 46a <vprintf>
 65c:	60e2                	ld	ra,24(sp)
 65e:	6442                	ld	s0,16(sp)
 660:	6161                	addi	sp,sp,80
 662:	8082                	ret

0000000000000664 <printf>:
 664:	711d                	addi	sp,sp,-96
 666:	ec06                	sd	ra,24(sp)
 668:	e822                	sd	s0,16(sp)
 66a:	1000                	addi	s0,sp,32
 66c:	e40c                	sd	a1,8(s0)
 66e:	e810                	sd	a2,16(s0)
 670:	ec14                	sd	a3,24(s0)
 672:	f018                	sd	a4,32(s0)
 674:	f41c                	sd	a5,40(s0)
 676:	03043823          	sd	a6,48(s0)
 67a:	03143c23          	sd	a7,56(s0)
 67e:	00840613          	addi	a2,s0,8
 682:	fec43423          	sd	a2,-24(s0)
 686:	85aa                	mv	a1,a0
 688:	4505                	li	a0,1
 68a:	00000097          	auipc	ra,0x0
 68e:	de0080e7          	jalr	-544(ra) # 46a <vprintf>
 692:	60e2                	ld	ra,24(sp)
 694:	6442                	ld	s0,16(sp)
 696:	6125                	addi	sp,sp,96
 698:	8082                	ret

000000000000069a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69a:	1141                	addi	sp,sp,-16
 69c:	e422                	sd	s0,8(sp)
 69e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a4:	00001797          	auipc	a5,0x1
 6a8:	95c7b783          	ld	a5,-1700(a5) # 1000 <freep>
 6ac:	a02d                	j	6d6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ae:	4618                	lw	a4,8(a2)
 6b0:	9f2d                	addw	a4,a4,a1
 6b2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b6:	6398                	ld	a4,0(a5)
 6b8:	6310                	ld	a2,0(a4)
 6ba:	a83d                	j	6f8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6bc:	ff852703          	lw	a4,-8(a0)
 6c0:	9f31                	addw	a4,a4,a2
 6c2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6c4:	ff053683          	ld	a3,-16(a0)
 6c8:	a091                	j	70c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ca:	6398                	ld	a4,0(a5)
 6cc:	00e7e463          	bltu	a5,a4,6d4 <free+0x3a>
 6d0:	00e6ea63          	bltu	a3,a4,6e4 <free+0x4a>
{
 6d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d6:	fed7fae3          	bgeu	a5,a3,6ca <free+0x30>
 6da:	6398                	ld	a4,0(a5)
 6dc:	00e6e463          	bltu	a3,a4,6e4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e0:	fee7eae3          	bltu	a5,a4,6d4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6e4:	ff852583          	lw	a1,-8(a0)
 6e8:	6390                	ld	a2,0(a5)
 6ea:	02059813          	slli	a6,a1,0x20
 6ee:	01c85713          	srli	a4,a6,0x1c
 6f2:	9736                	add	a4,a4,a3
 6f4:	fae60de3          	beq	a2,a4,6ae <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6fc:	4790                	lw	a2,8(a5)
 6fe:	02061593          	slli	a1,a2,0x20
 702:	01c5d713          	srli	a4,a1,0x1c
 706:	973e                	add	a4,a4,a5
 708:	fae68ae3          	beq	a3,a4,6bc <free+0x22>
    p->s.ptr = bp->s.ptr;
 70c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 70e:	00001717          	auipc	a4,0x1
 712:	8ef73923          	sd	a5,-1806(a4) # 1000 <freep>
}
 716:	6422                	ld	s0,8(sp)
 718:	0141                	addi	sp,sp,16
 71a:	8082                	ret

000000000000071c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 71c:	7139                	addi	sp,sp,-64
 71e:	fc06                	sd	ra,56(sp)
 720:	f822                	sd	s0,48(sp)
 722:	f426                	sd	s1,40(sp)
 724:	f04a                	sd	s2,32(sp)
 726:	ec4e                	sd	s3,24(sp)
 728:	e852                	sd	s4,16(sp)
 72a:	e456                	sd	s5,8(sp)
 72c:	e05a                	sd	s6,0(sp)
 72e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 730:	02051493          	slli	s1,a0,0x20
 734:	9081                	srli	s1,s1,0x20
 736:	04bd                	addi	s1,s1,15
 738:	8091                	srli	s1,s1,0x4
 73a:	0014899b          	addiw	s3,s1,1
 73e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 740:	00001517          	auipc	a0,0x1
 744:	8c053503          	ld	a0,-1856(a0) # 1000 <freep>
 748:	c515                	beqz	a0,774 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 74c:	4798                	lw	a4,8(a5)
 74e:	02977f63          	bgeu	a4,s1,78c <malloc+0x70>
  if(nu < 4096)
 752:	8a4e                	mv	s4,s3
 754:	0009871b          	sext.w	a4,s3
 758:	6685                	lui	a3,0x1
 75a:	00d77363          	bgeu	a4,a3,760 <malloc+0x44>
 75e:	6a05                	lui	s4,0x1
 760:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 764:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 768:	00001917          	auipc	s2,0x1
 76c:	89890913          	addi	s2,s2,-1896 # 1000 <freep>
  if(p == (char*)-1)
 770:	5afd                	li	s5,-1
 772:	a895                	j	7e6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 774:	00001797          	auipc	a5,0x1
 778:	89c78793          	addi	a5,a5,-1892 # 1010 <base>
 77c:	00001717          	auipc	a4,0x1
 780:	88f73223          	sd	a5,-1916(a4) # 1000 <freep>
 784:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 786:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 78a:	b7e1                	j	752 <malloc+0x36>
      if(p->s.size == nunits)
 78c:	02e48c63          	beq	s1,a4,7c4 <malloc+0xa8>
        p->s.size -= nunits;
 790:	4137073b          	subw	a4,a4,s3
 794:	c798                	sw	a4,8(a5)
        p += p->s.size;
 796:	02071693          	slli	a3,a4,0x20
 79a:	01c6d713          	srli	a4,a3,0x1c
 79e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7a0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7a4:	00001717          	auipc	a4,0x1
 7a8:	84a73e23          	sd	a0,-1956(a4) # 1000 <freep>
      return (void*)(p + 1);
 7ac:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b0:	70e2                	ld	ra,56(sp)
 7b2:	7442                	ld	s0,48(sp)
 7b4:	74a2                	ld	s1,40(sp)
 7b6:	7902                	ld	s2,32(sp)
 7b8:	69e2                	ld	s3,24(sp)
 7ba:	6a42                	ld	s4,16(sp)
 7bc:	6aa2                	ld	s5,8(sp)
 7be:	6b02                	ld	s6,0(sp)
 7c0:	6121                	addi	sp,sp,64
 7c2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7c4:	6398                	ld	a4,0(a5)
 7c6:	e118                	sd	a4,0(a0)
 7c8:	bff1                	j	7a4 <malloc+0x88>
  hp->s.size = nu;
 7ca:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ce:	0541                	addi	a0,a0,16
 7d0:	00000097          	auipc	ra,0x0
 7d4:	eca080e7          	jalr	-310(ra) # 69a <free>
  return freep;
 7d8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7dc:	d971                	beqz	a0,7b0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e0:	4798                	lw	a4,8(a5)
 7e2:	fa9775e3          	bgeu	a4,s1,78c <malloc+0x70>
    if(p == freep)
 7e6:	00093703          	ld	a4,0(s2)
 7ea:	853e                	mv	a0,a5
 7ec:	fef719e3          	bne	a4,a5,7de <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7f0:	8552                	mv	a0,s4
 7f2:	00000097          	auipc	ra,0x0
 7f6:	b92080e7          	jalr	-1134(ra) # 384 <sbrk>
  if(p == (char*)-1)
 7fa:	fd5518e3          	bne	a0,s5,7ca <malloc+0xae>
        return 0;
 7fe:	4501                	li	a0,0
 800:	bf45                	j	7b0 <malloc+0x94>

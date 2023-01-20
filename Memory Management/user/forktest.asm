
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
   c:	00000097          	auipc	ra,0x0
  10:	174080e7          	jalr	372(ra) # 180 <strlen>
  14:	0005061b          	sext.w	a2,a0
  18:	85a6                	mv	a1,s1
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	3a8080e7          	jalr	936(ra) # 3c4 <write>
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <forktest>:
  2e:	1101                	addi	sp,sp,-32
  30:	ec06                	sd	ra,24(sp)
  32:	e822                	sd	s0,16(sp)
  34:	e426                	sd	s1,8(sp)
  36:	e04a                	sd	s2,0(sp)
  38:	1000                	addi	s0,sp,32
  3a:	00000517          	auipc	a0,0x0
  3e:	40e50513          	addi	a0,a0,1038 # 448 <uptime+0xc>
  42:	00000097          	auipc	ra,0x0
  46:	fbe080e7          	jalr	-66(ra) # 0 <print>
  4a:	4481                	li	s1,0
  4c:	3e800913          	li	s2,1000
  50:	00000097          	auipc	ra,0x0
  54:	34c080e7          	jalr	844(ra) # 39c <fork>
  58:	02054763          	bltz	a0,86 <forktest+0x58>
  5c:	c10d                	beqz	a0,7e <forktest+0x50>
  5e:	2485                	addiw	s1,s1,1
  60:	ff2498e3          	bne	s1,s2,50 <forktest+0x22>
  64:	00000517          	auipc	a0,0x0
  68:	3f450513          	addi	a0,a0,1012 # 458 <uptime+0x1c>
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <print>
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	32e080e7          	jalr	814(ra) # 3a4 <exit>
  7e:	00000097          	auipc	ra,0x0
  82:	326080e7          	jalr	806(ra) # 3a4 <exit>
  86:	3e800793          	li	a5,1000
  8a:	fcf48de3          	beq	s1,a5,64 <forktest+0x36>
  8e:	00905b63          	blez	s1,a4 <forktest+0x76>
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	318080e7          	jalr	792(ra) # 3ac <wait>
  9c:	02054a63          	bltz	a0,d0 <forktest+0xa2>
  a0:	34fd                	addiw	s1,s1,-1
  a2:	f8e5                	bnez	s1,92 <forktest+0x64>
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	306080e7          	jalr	774(ra) # 3ac <wait>
  ae:	57fd                	li	a5,-1
  b0:	02f51d63          	bne	a0,a5,ea <forktest+0xbc>
  b4:	00000517          	auipc	a0,0x0
  b8:	3f450513          	addi	a0,a0,1012 # 4a8 <uptime+0x6c>
  bc:	00000097          	auipc	ra,0x0
  c0:	f44080e7          	jalr	-188(ra) # 0 <print>
  c4:	60e2                	ld	ra,24(sp)
  c6:	6442                	ld	s0,16(sp)
  c8:	64a2                	ld	s1,8(sp)
  ca:	6902                	ld	s2,0(sp)
  cc:	6105                	addi	sp,sp,32
  ce:	8082                	ret
  d0:	00000517          	auipc	a0,0x0
  d4:	3a850513          	addi	a0,a0,936 # 478 <uptime+0x3c>
  d8:	00000097          	auipc	ra,0x0
  dc:	f28080e7          	jalr	-216(ra) # 0 <print>
  e0:	4505                	li	a0,1
  e2:	00000097          	auipc	ra,0x0
  e6:	2c2080e7          	jalr	706(ra) # 3a4 <exit>
  ea:	00000517          	auipc	a0,0x0
  ee:	3a650513          	addi	a0,a0,934 # 490 <uptime+0x54>
  f2:	00000097          	auipc	ra,0x0
  f6:	f0e080e7          	jalr	-242(ra) # 0 <print>
  fa:	4505                	li	a0,1
  fc:	00000097          	auipc	ra,0x0
 100:	2a8080e7          	jalr	680(ra) # 3a4 <exit>

0000000000000104 <main>:
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
 10c:	00000097          	auipc	ra,0x0
 110:	f22080e7          	jalr	-222(ra) # 2e <forktest>
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	28e080e7          	jalr	654(ra) # 3a4 <exit>

000000000000011e <_main>:
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
 126:	00000097          	auipc	ra,0x0
 12a:	fde080e7          	jalr	-34(ra) # 104 <main>
 12e:	4501                	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	274080e7          	jalr	628(ra) # 3a4 <exit>

0000000000000138 <strcpy>:
 138:	1141                	addi	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	addi	s0,sp,16
 13e:	87aa                	mv	a5,a0
 140:	0585                	addi	a1,a1,1
 142:	0785                	addi	a5,a5,1
 144:	fff5c703          	lbu	a4,-1(a1)
 148:	fee78fa3          	sb	a4,-1(a5)
 14c:	fb75                	bnez	a4,140 <strcpy+0x8>
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strcmp>:
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cb91                	beqz	a5,172 <strcmp+0x1e>
 160:	0005c703          	lbu	a4,0(a1)
 164:	00f71763          	bne	a4,a5,172 <strcmp+0x1e>
 168:	0505                	addi	a0,a0,1
 16a:	0585                	addi	a1,a1,1
 16c:	00054783          	lbu	a5,0(a0)
 170:	fbe5                	bnez	a5,160 <strcmp+0xc>
 172:	0005c503          	lbu	a0,0(a1)
 176:	40a7853b          	subw	a0,a5,a0
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret

0000000000000180 <strlen>:
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
 186:	00054783          	lbu	a5,0(a0)
 18a:	cf91                	beqz	a5,1a6 <strlen+0x26>
 18c:	0505                	addi	a0,a0,1
 18e:	87aa                	mv	a5,a0
 190:	86be                	mv	a3,a5
 192:	0785                	addi	a5,a5,1
 194:	fff7c703          	lbu	a4,-1(a5)
 198:	ff65                	bnez	a4,190 <strlen+0x10>
 19a:	40a6853b          	subw	a0,a3,a0
 19e:	2505                	addiw	a0,a0,1
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret
 1a6:	4501                	li	a0,0
 1a8:	bfe5                	j	1a0 <strlen+0x20>

00000000000001aa <memset>:
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
 1b0:	ca19                	beqz	a2,1c6 <memset+0x1c>
 1b2:	87aa                	mv	a5,a0
 1b4:	1602                	slli	a2,a2,0x20
 1b6:	9201                	srli	a2,a2,0x20
 1b8:	00a60733          	add	a4,a2,a0
 1bc:	00b78023          	sb	a1,0(a5)
 1c0:	0785                	addi	a5,a5,1
 1c2:	fee79de3          	bne	a5,a4,1bc <memset+0x12>
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strchr>:
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cb99                	beqz	a5,1ec <strchr+0x20>
 1d8:	00f58763          	beq	a1,a5,1e6 <strchr+0x1a>
 1dc:	0505                	addi	a0,a0,1
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbfd                	bnez	a5,1d8 <strchr+0xc>
 1e4:	4501                	li	a0,0
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret
 1ec:	4501                	li	a0,0
 1ee:	bfe5                	j	1e6 <strchr+0x1a>

00000000000001f0 <gets>:
 1f0:	711d                	addi	sp,sp,-96
 1f2:	ec86                	sd	ra,88(sp)
 1f4:	e8a2                	sd	s0,80(sp)
 1f6:	e4a6                	sd	s1,72(sp)
 1f8:	e0ca                	sd	s2,64(sp)
 1fa:	fc4e                	sd	s3,56(sp)
 1fc:	f852                	sd	s4,48(sp)
 1fe:	f456                	sd	s5,40(sp)
 200:	f05a                	sd	s6,32(sp)
 202:	ec5e                	sd	s7,24(sp)
 204:	1080                	addi	s0,sp,96
 206:	8baa                	mv	s7,a0
 208:	8a2e                	mv	s4,a1
 20a:	892a                	mv	s2,a0
 20c:	4481                	li	s1,0
 20e:	4aa9                	li	s5,10
 210:	4b35                	li	s6,13
 212:	89a6                	mv	s3,s1
 214:	2485                	addiw	s1,s1,1
 216:	0344d863          	bge	s1,s4,246 <gets+0x56>
 21a:	4605                	li	a2,1
 21c:	faf40593          	addi	a1,s0,-81
 220:	4501                	li	a0,0
 222:	00000097          	auipc	ra,0x0
 226:	19a080e7          	jalr	410(ra) # 3bc <read>
 22a:	00a05e63          	blez	a0,246 <gets+0x56>
 22e:	faf44783          	lbu	a5,-81(s0)
 232:	00f90023          	sb	a5,0(s2)
 236:	01578763          	beq	a5,s5,244 <gets+0x54>
 23a:	0905                	addi	s2,s2,1
 23c:	fd679be3          	bne	a5,s6,212 <gets+0x22>
 240:	89a6                	mv	s3,s1
 242:	a011                	j	246 <gets+0x56>
 244:	89a6                	mv	s3,s1
 246:	99de                	add	s3,s3,s7
 248:	00098023          	sb	zero,0(s3)
 24c:	855e                	mv	a0,s7
 24e:	60e6                	ld	ra,88(sp)
 250:	6446                	ld	s0,80(sp)
 252:	64a6                	ld	s1,72(sp)
 254:	6906                	ld	s2,64(sp)
 256:	79e2                	ld	s3,56(sp)
 258:	7a42                	ld	s4,48(sp)
 25a:	7aa2                	ld	s5,40(sp)
 25c:	7b02                	ld	s6,32(sp)
 25e:	6be2                	ld	s7,24(sp)
 260:	6125                	addi	sp,sp,96
 262:	8082                	ret

0000000000000264 <stat>:
 264:	1101                	addi	sp,sp,-32
 266:	ec06                	sd	ra,24(sp)
 268:	e822                	sd	s0,16(sp)
 26a:	e426                	sd	s1,8(sp)
 26c:	e04a                	sd	s2,0(sp)
 26e:	1000                	addi	s0,sp,32
 270:	892e                	mv	s2,a1
 272:	4581                	li	a1,0
 274:	00000097          	auipc	ra,0x0
 278:	170080e7          	jalr	368(ra) # 3e4 <open>
 27c:	02054563          	bltz	a0,2a6 <stat+0x42>
 280:	84aa                	mv	s1,a0
 282:	85ca                	mv	a1,s2
 284:	00000097          	auipc	ra,0x0
 288:	178080e7          	jalr	376(ra) # 3fc <fstat>
 28c:	892a                	mv	s2,a0
 28e:	8526                	mv	a0,s1
 290:	00000097          	auipc	ra,0x0
 294:	13c080e7          	jalr	316(ra) # 3cc <close>
 298:	854a                	mv	a0,s2
 29a:	60e2                	ld	ra,24(sp)
 29c:	6442                	ld	s0,16(sp)
 29e:	64a2                	ld	s1,8(sp)
 2a0:	6902                	ld	s2,0(sp)
 2a2:	6105                	addi	sp,sp,32
 2a4:	8082                	ret
 2a6:	597d                	li	s2,-1
 2a8:	bfc5                	j	298 <stat+0x34>

00000000000002aa <atoi>:
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
 2b0:	00054683          	lbu	a3,0(a0)
 2b4:	fd06879b          	addiw	a5,a3,-48
 2b8:	0ff7f793          	zext.b	a5,a5
 2bc:	4625                	li	a2,9
 2be:	02f66863          	bltu	a2,a5,2ee <atoi+0x44>
 2c2:	872a                	mv	a4,a0
 2c4:	4501                	li	a0,0
 2c6:	0705                	addi	a4,a4,1
 2c8:	0025179b          	slliw	a5,a0,0x2
 2cc:	9fa9                	addw	a5,a5,a0
 2ce:	0017979b          	slliw	a5,a5,0x1
 2d2:	9fb5                	addw	a5,a5,a3
 2d4:	fd07851b          	addiw	a0,a5,-48
 2d8:	00074683          	lbu	a3,0(a4)
 2dc:	fd06879b          	addiw	a5,a3,-48
 2e0:	0ff7f793          	zext.b	a5,a5
 2e4:	fef671e3          	bgeu	a2,a5,2c6 <atoi+0x1c>
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
 2ee:	4501                	li	a0,0
 2f0:	bfe5                	j	2e8 <atoi+0x3e>

00000000000002f2 <memmove>:
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
 2f8:	02b57463          	bgeu	a0,a1,320 <memmove+0x2e>
 2fc:	00c05f63          	blez	a2,31a <memmove+0x28>
 300:	1602                	slli	a2,a2,0x20
 302:	9201                	srli	a2,a2,0x20
 304:	00c507b3          	add	a5,a0,a2
 308:	872a                	mv	a4,a0
 30a:	0585                	addi	a1,a1,1
 30c:	0705                	addi	a4,a4,1
 30e:	fff5c683          	lbu	a3,-1(a1)
 312:	fed70fa3          	sb	a3,-1(a4)
 316:	fee79ae3          	bne	a5,a4,30a <memmove+0x18>
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
 320:	00c50733          	add	a4,a0,a2
 324:	95b2                	add	a1,a1,a2
 326:	fec05ae3          	blez	a2,31a <memmove+0x28>
 32a:	fff6079b          	addiw	a5,a2,-1
 32e:	1782                	slli	a5,a5,0x20
 330:	9381                	srli	a5,a5,0x20
 332:	fff7c793          	not	a5,a5
 336:	97ba                	add	a5,a5,a4
 338:	15fd                	addi	a1,a1,-1
 33a:	177d                	addi	a4,a4,-1
 33c:	0005c683          	lbu	a3,0(a1)
 340:	00d70023          	sb	a3,0(a4)
 344:	fee79ae3          	bne	a5,a4,338 <memmove+0x46>
 348:	bfc9                	j	31a <memmove+0x28>

000000000000034a <memcmp>:
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
 350:	ca05                	beqz	a2,380 <memcmp+0x36>
 352:	fff6069b          	addiw	a3,a2,-1
 356:	1682                	slli	a3,a3,0x20
 358:	9281                	srli	a3,a3,0x20
 35a:	0685                	addi	a3,a3,1
 35c:	96aa                	add	a3,a3,a0
 35e:	00054783          	lbu	a5,0(a0)
 362:	0005c703          	lbu	a4,0(a1)
 366:	00e79863          	bne	a5,a4,376 <memcmp+0x2c>
 36a:	0505                	addi	a0,a0,1
 36c:	0585                	addi	a1,a1,1
 36e:	fed518e3          	bne	a0,a3,35e <memcmp+0x14>
 372:	4501                	li	a0,0
 374:	a019                	j	37a <memcmp+0x30>
 376:	40e7853b          	subw	a0,a5,a4
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
 380:	4501                	li	a0,0
 382:	bfe5                	j	37a <memcmp+0x30>

0000000000000384 <memcpy>:
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
 38c:	00000097          	auipc	ra,0x0
 390:	f66080e7          	jalr	-154(ra) # 2f2 <memmove>
 394:	60a2                	ld	ra,8(sp)
 396:	6402                	ld	s0,0(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret

000000000000039c <fork>:
 39c:	4885                	li	a7,1
 39e:	00000073          	ecall
 3a2:	8082                	ret

00000000000003a4 <exit>:
 3a4:	4889                	li	a7,2
 3a6:	00000073          	ecall
 3aa:	8082                	ret

00000000000003ac <wait>:
 3ac:	488d                	li	a7,3
 3ae:	00000073          	ecall
 3b2:	8082                	ret

00000000000003b4 <pipe>:
 3b4:	4891                	li	a7,4
 3b6:	00000073          	ecall
 3ba:	8082                	ret

00000000000003bc <read>:
 3bc:	4895                	li	a7,5
 3be:	00000073          	ecall
 3c2:	8082                	ret

00000000000003c4 <write>:
 3c4:	48c1                	li	a7,16
 3c6:	00000073          	ecall
 3ca:	8082                	ret

00000000000003cc <close>:
 3cc:	48d5                	li	a7,21
 3ce:	00000073          	ecall
 3d2:	8082                	ret

00000000000003d4 <kill>:
 3d4:	4899                	li	a7,6
 3d6:	00000073          	ecall
 3da:	8082                	ret

00000000000003dc <exec>:
 3dc:	489d                	li	a7,7
 3de:	00000073          	ecall
 3e2:	8082                	ret

00000000000003e4 <open>:
 3e4:	48bd                	li	a7,15
 3e6:	00000073          	ecall
 3ea:	8082                	ret

00000000000003ec <mknod>:
 3ec:	48c5                	li	a7,17
 3ee:	00000073          	ecall
 3f2:	8082                	ret

00000000000003f4 <unlink>:
 3f4:	48c9                	li	a7,18
 3f6:	00000073          	ecall
 3fa:	8082                	ret

00000000000003fc <fstat>:
 3fc:	48a1                	li	a7,8
 3fe:	00000073          	ecall
 402:	8082                	ret

0000000000000404 <link>:
 404:	48cd                	li	a7,19
 406:	00000073          	ecall
 40a:	8082                	ret

000000000000040c <mkdir>:
 40c:	48d1                	li	a7,20
 40e:	00000073          	ecall
 412:	8082                	ret

0000000000000414 <chdir>:
 414:	48a5                	li	a7,9
 416:	00000073          	ecall
 41a:	8082                	ret

000000000000041c <dup>:
 41c:	48a9                	li	a7,10
 41e:	00000073          	ecall
 422:	8082                	ret

0000000000000424 <getpid>:
 424:	48ad                	li	a7,11
 426:	00000073          	ecall
 42a:	8082                	ret

000000000000042c <sbrk>:
 42c:	48b1                	li	a7,12
 42e:	00000073          	ecall
 432:	8082                	ret

0000000000000434 <sleep>:
 434:	48b5                	li	a7,13
 436:	00000073          	ecall
 43a:	8082                	ret

000000000000043c <uptime>:
 43c:	48b9                	li	a7,14
 43e:	00000073          	ecall
 442:	8082                	ret


user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1c8080e7          	jalr	456(ra) # 1f0 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	2ea080e7          	jalr	746(ra) # 31a <kill>
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2aa080e7          	jalr	682(ra) # 2ea <exit>
  48:	00000597          	auipc	a1,0x0
  4c:	7a858593          	addi	a1,a1,1960 # 7f0 <malloc+0xe6>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	5d2080e7          	jalr	1490(ra) # 624 <fprintf>
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	28e080e7          	jalr	654(ra) # 2ea <exit>

0000000000000064 <_main>:
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <main>
  74:	4501                	li	a0,0
  76:	00000097          	auipc	ra,0x0
  7a:	274080e7          	jalr	628(ra) # 2ea <exit>

000000000000007e <strcpy>:
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
  84:	87aa                	mv	a5,a0
  86:	0585                	addi	a1,a1,1
  88:	0785                	addi	a5,a5,1
  8a:	fff5c703          	lbu	a4,-1(a1)
  8e:	fee78fa3          	sb	a4,-1(a5)
  92:	fb75                	bnez	a4,86 <strcpy+0x8>
  94:	6422                	ld	s0,8(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret

000000000000009a <strcmp>:
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  a0:	00054783          	lbu	a5,0(a0)
  a4:	cb91                	beqz	a5,b8 <strcmp+0x1e>
  a6:	0005c703          	lbu	a4,0(a1)
  aa:	00f71763          	bne	a4,a5,b8 <strcmp+0x1e>
  ae:	0505                	addi	a0,a0,1
  b0:	0585                	addi	a1,a1,1
  b2:	00054783          	lbu	a5,0(a0)
  b6:	fbe5                	bnez	a5,a6 <strcmp+0xc>
  b8:	0005c503          	lbu	a0,0(a1)
  bc:	40a7853b          	subw	a0,a5,a0
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cf91                	beqz	a5,ec <strlen+0x26>
  d2:	0505                	addi	a0,a0,1
  d4:	87aa                	mv	a5,a0
  d6:	86be                	mv	a3,a5
  d8:	0785                	addi	a5,a5,1
  da:	fff7c703          	lbu	a4,-1(a5)
  de:	ff65                	bnez	a4,d6 <strlen+0x10>
  e0:	40a6853b          	subw	a0,a3,a0
  e4:	2505                	addiw	a0,a0,1
  e6:	6422                	ld	s0,8(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret
  ec:	4501                	li	a0,0
  ee:	bfe5                	j	e6 <strlen+0x20>

00000000000000f0 <memset>:
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  f6:	ca19                	beqz	a2,10c <memset+0x1c>
  f8:	87aa                	mv	a5,a0
  fa:	1602                	slli	a2,a2,0x20
  fc:	9201                	srli	a2,a2,0x20
  fe:	00a60733          	add	a4,a2,a0
 102:	00b78023          	sb	a1,0(a5)
 106:	0785                	addi	a5,a5,1
 108:	fee79de3          	bne	a5,a4,102 <memset+0x12>
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strchr>:
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb99                	beqz	a5,132 <strchr+0x20>
 11e:	00f58763          	beq	a1,a5,12c <strchr+0x1a>
 122:	0505                	addi	a0,a0,1
 124:	00054783          	lbu	a5,0(a0)
 128:	fbfd                	bnez	a5,11e <strchr+0xc>
 12a:	4501                	li	a0,0
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret
 132:	4501                	li	a0,0
 134:	bfe5                	j	12c <strchr+0x1a>

0000000000000136 <gets>:
 136:	711d                	addi	sp,sp,-96
 138:	ec86                	sd	ra,88(sp)
 13a:	e8a2                	sd	s0,80(sp)
 13c:	e4a6                	sd	s1,72(sp)
 13e:	e0ca                	sd	s2,64(sp)
 140:	fc4e                	sd	s3,56(sp)
 142:	f852                	sd	s4,48(sp)
 144:	f456                	sd	s5,40(sp)
 146:	f05a                	sd	s6,32(sp)
 148:	ec5e                	sd	s7,24(sp)
 14a:	1080                	addi	s0,sp,96
 14c:	8baa                	mv	s7,a0
 14e:	8a2e                	mv	s4,a1
 150:	892a                	mv	s2,a0
 152:	4481                	li	s1,0
 154:	4aa9                	li	s5,10
 156:	4b35                	li	s6,13
 158:	89a6                	mv	s3,s1
 15a:	2485                	addiw	s1,s1,1
 15c:	0344d863          	bge	s1,s4,18c <gets+0x56>
 160:	4605                	li	a2,1
 162:	faf40593          	addi	a1,s0,-81
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	19a080e7          	jalr	410(ra) # 302 <read>
 170:	00a05e63          	blez	a0,18c <gets+0x56>
 174:	faf44783          	lbu	a5,-81(s0)
 178:	00f90023          	sb	a5,0(s2)
 17c:	01578763          	beq	a5,s5,18a <gets+0x54>
 180:	0905                	addi	s2,s2,1
 182:	fd679be3          	bne	a5,s6,158 <gets+0x22>
 186:	89a6                	mv	s3,s1
 188:	a011                	j	18c <gets+0x56>
 18a:	89a6                	mv	s3,s1
 18c:	99de                	add	s3,s3,s7
 18e:	00098023          	sb	zero,0(s3)
 192:	855e                	mv	a0,s7
 194:	60e6                	ld	ra,88(sp)
 196:	6446                	ld	s0,80(sp)
 198:	64a6                	ld	s1,72(sp)
 19a:	6906                	ld	s2,64(sp)
 19c:	79e2                	ld	s3,56(sp)
 19e:	7a42                	ld	s4,48(sp)
 1a0:	7aa2                	ld	s5,40(sp)
 1a2:	7b02                	ld	s6,32(sp)
 1a4:	6be2                	ld	s7,24(sp)
 1a6:	6125                	addi	sp,sp,96
 1a8:	8082                	ret

00000000000001aa <stat>:
 1aa:	1101                	addi	sp,sp,-32
 1ac:	ec06                	sd	ra,24(sp)
 1ae:	e822                	sd	s0,16(sp)
 1b0:	e426                	sd	s1,8(sp)
 1b2:	e04a                	sd	s2,0(sp)
 1b4:	1000                	addi	s0,sp,32
 1b6:	892e                	mv	s2,a1
 1b8:	4581                	li	a1,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	170080e7          	jalr	368(ra) # 32a <open>
 1c2:	02054563          	bltz	a0,1ec <stat+0x42>
 1c6:	84aa                	mv	s1,a0
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	178080e7          	jalr	376(ra) # 342 <fstat>
 1d2:	892a                	mv	s2,a0
 1d4:	8526                	mv	a0,s1
 1d6:	00000097          	auipc	ra,0x0
 1da:	13c080e7          	jalr	316(ra) # 312 <close>
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	64a2                	ld	s1,8(sp)
 1e6:	6902                	ld	s2,0(sp)
 1e8:	6105                	addi	sp,sp,32
 1ea:	8082                	ret
 1ec:	597d                	li	s2,-1
 1ee:	bfc5                	j	1de <stat+0x34>

00000000000001f0 <atoi>:
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
 1f6:	00054683          	lbu	a3,0(a0)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	4625                	li	a2,9
 204:	02f66863          	bltu	a2,a5,234 <atoi+0x44>
 208:	872a                	mv	a4,a0
 20a:	4501                	li	a0,0
 20c:	0705                	addi	a4,a4,1
 20e:	0025179b          	slliw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	slliw	a5,a5,0x1
 218:	9fb5                	addw	a5,a5,a3
 21a:	fd07851b          	addiw	a0,a5,-48
 21e:	00074683          	lbu	a3,0(a4)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	fef671e3          	bgeu	a2,a5,20c <atoi+0x1c>
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <atoi+0x3e>

0000000000000238 <memmove>:
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
 23e:	02b57463          	bgeu	a0,a1,266 <memmove+0x2e>
 242:	00c05f63          	blez	a2,260 <memmove+0x28>
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00c507b3          	add	a5,a0,a2
 24e:	872a                	mv	a4,a0
 250:	0585                	addi	a1,a1,1
 252:	0705                	addi	a4,a4,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed70fa3          	sb	a3,-1(a4)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x18>
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
 266:	00c50733          	add	a4,a0,a2
 26a:	95b2                	add	a1,a1,a2
 26c:	fec05ae3          	blez	a2,260 <memmove+0x28>
 270:	fff6079b          	addiw	a5,a2,-1
 274:	1782                	slli	a5,a5,0x20
 276:	9381                	srli	a5,a5,0x20
 278:	fff7c793          	not	a5,a5
 27c:	97ba                	add	a5,a5,a4
 27e:	15fd                	addi	a1,a1,-1
 280:	177d                	addi	a4,a4,-1
 282:	0005c683          	lbu	a3,0(a1)
 286:	00d70023          	sb	a3,0(a4)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x46>
 28e:	bfc9                	j	260 <memmove+0x28>

0000000000000290 <memcmp>:
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
 296:	ca05                	beqz	a2,2c6 <memcmp+0x36>
 298:	fff6069b          	addiw	a3,a2,-1
 29c:	1682                	slli	a3,a3,0x20
 29e:	9281                	srli	a3,a3,0x20
 2a0:	0685                	addi	a3,a3,1
 2a2:	96aa                	add	a3,a3,a0
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	0005c703          	lbu	a4,0(a1)
 2ac:	00e79863          	bne	a5,a4,2bc <memcmp+0x2c>
 2b0:	0505                	addi	a0,a0,1
 2b2:	0585                	addi	a1,a1,1
 2b4:	fed518e3          	bne	a0,a3,2a4 <memcmp+0x14>
 2b8:	4501                	li	a0,0
 2ba:	a019                	j	2c0 <memcmp+0x30>
 2bc:	40e7853b          	subw	a0,a5,a4
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <memcmp+0x30>

00000000000002ca <memcpy>:
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e406                	sd	ra,8(sp)
 2ce:	e022                	sd	s0,0(sp)
 2d0:	0800                	addi	s0,sp,16
 2d2:	00000097          	auipc	ra,0x0
 2d6:	f66080e7          	jalr	-154(ra) # 238 <memmove>
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <fork>:
 2e2:	4885                	li	a7,1
 2e4:	00000073          	ecall
 2e8:	8082                	ret

00000000000002ea <exit>:
 2ea:	4889                	li	a7,2
 2ec:	00000073          	ecall
 2f0:	8082                	ret

00000000000002f2 <wait>:
 2f2:	488d                	li	a7,3
 2f4:	00000073          	ecall
 2f8:	8082                	ret

00000000000002fa <pipe>:
 2fa:	4891                	li	a7,4
 2fc:	00000073          	ecall
 300:	8082                	ret

0000000000000302 <read>:
 302:	4895                	li	a7,5
 304:	00000073          	ecall
 308:	8082                	ret

000000000000030a <write>:
 30a:	48c1                	li	a7,16
 30c:	00000073          	ecall
 310:	8082                	ret

0000000000000312 <close>:
 312:	48d5                	li	a7,21
 314:	00000073          	ecall
 318:	8082                	ret

000000000000031a <kill>:
 31a:	4899                	li	a7,6
 31c:	00000073          	ecall
 320:	8082                	ret

0000000000000322 <exec>:
 322:	489d                	li	a7,7
 324:	00000073          	ecall
 328:	8082                	ret

000000000000032a <open>:
 32a:	48bd                	li	a7,15
 32c:	00000073          	ecall
 330:	8082                	ret

0000000000000332 <mknod>:
 332:	48c5                	li	a7,17
 334:	00000073          	ecall
 338:	8082                	ret

000000000000033a <unlink>:
 33a:	48c9                	li	a7,18
 33c:	00000073          	ecall
 340:	8082                	ret

0000000000000342 <fstat>:
 342:	48a1                	li	a7,8
 344:	00000073          	ecall
 348:	8082                	ret

000000000000034a <link>:
 34a:	48cd                	li	a7,19
 34c:	00000073          	ecall
 350:	8082                	ret

0000000000000352 <mkdir>:
 352:	48d1                	li	a7,20
 354:	00000073          	ecall
 358:	8082                	ret

000000000000035a <chdir>:
 35a:	48a5                	li	a7,9
 35c:	00000073          	ecall
 360:	8082                	ret

0000000000000362 <dup>:
 362:	48a9                	li	a7,10
 364:	00000073          	ecall
 368:	8082                	ret

000000000000036a <getpid>:
 36a:	48ad                	li	a7,11
 36c:	00000073          	ecall
 370:	8082                	ret

0000000000000372 <sbrk>:
 372:	48b1                	li	a7,12
 374:	00000073          	ecall
 378:	8082                	ret

000000000000037a <sleep>:
 37a:	48b5                	li	a7,13
 37c:	00000073          	ecall
 380:	8082                	ret

0000000000000382 <uptime>:
 382:	48b9                	li	a7,14
 384:	00000073          	ecall
 388:	8082                	ret

000000000000038a <putc>:
 38a:	1101                	addi	sp,sp,-32
 38c:	ec06                	sd	ra,24(sp)
 38e:	e822                	sd	s0,16(sp)
 390:	1000                	addi	s0,sp,32
 392:	feb407a3          	sb	a1,-17(s0)
 396:	4605                	li	a2,1
 398:	fef40593          	addi	a1,s0,-17
 39c:	00000097          	auipc	ra,0x0
 3a0:	f6e080e7          	jalr	-146(ra) # 30a <write>
 3a4:	60e2                	ld	ra,24(sp)
 3a6:	6442                	ld	s0,16(sp)
 3a8:	6105                	addi	sp,sp,32
 3aa:	8082                	ret

00000000000003ac <printint>:
 3ac:	7139                	addi	sp,sp,-64
 3ae:	fc06                	sd	ra,56(sp)
 3b0:	f822                	sd	s0,48(sp)
 3b2:	f426                	sd	s1,40(sp)
 3b4:	f04a                	sd	s2,32(sp)
 3b6:	ec4e                	sd	s3,24(sp)
 3b8:	0080                	addi	s0,sp,64
 3ba:	84aa                	mv	s1,a0
 3bc:	c299                	beqz	a3,3c2 <printint+0x16>
 3be:	0805c963          	bltz	a1,450 <printint+0xa4>
 3c2:	2581                	sext.w	a1,a1
 3c4:	4881                	li	a7,0
 3c6:	fc040693          	addi	a3,s0,-64
 3ca:	4701                	li	a4,0
 3cc:	2601                	sext.w	a2,a2
 3ce:	00000517          	auipc	a0,0x0
 3d2:	49a50513          	addi	a0,a0,1178 # 868 <digits>
 3d6:	883a                	mv	a6,a4
 3d8:	2705                	addiw	a4,a4,1
 3da:	02c5f7bb          	remuw	a5,a1,a2
 3de:	1782                	slli	a5,a5,0x20
 3e0:	9381                	srli	a5,a5,0x20
 3e2:	97aa                	add	a5,a5,a0
 3e4:	0007c783          	lbu	a5,0(a5)
 3e8:	00f68023          	sb	a5,0(a3)
 3ec:	0005879b          	sext.w	a5,a1
 3f0:	02c5d5bb          	divuw	a1,a1,a2
 3f4:	0685                	addi	a3,a3,1
 3f6:	fec7f0e3          	bgeu	a5,a2,3d6 <printint+0x2a>
 3fa:	00088c63          	beqz	a7,412 <printint+0x66>
 3fe:	fd070793          	addi	a5,a4,-48
 402:	00878733          	add	a4,a5,s0
 406:	02d00793          	li	a5,45
 40a:	fef70823          	sb	a5,-16(a4)
 40e:	0028071b          	addiw	a4,a6,2
 412:	02e05863          	blez	a4,442 <printint+0x96>
 416:	fc040793          	addi	a5,s0,-64
 41a:	00e78933          	add	s2,a5,a4
 41e:	fff78993          	addi	s3,a5,-1
 422:	99ba                	add	s3,s3,a4
 424:	377d                	addiw	a4,a4,-1
 426:	1702                	slli	a4,a4,0x20
 428:	9301                	srli	a4,a4,0x20
 42a:	40e989b3          	sub	s3,s3,a4
 42e:	fff94583          	lbu	a1,-1(s2)
 432:	8526                	mv	a0,s1
 434:	00000097          	auipc	ra,0x0
 438:	f56080e7          	jalr	-170(ra) # 38a <putc>
 43c:	197d                	addi	s2,s2,-1
 43e:	ff3918e3          	bne	s2,s3,42e <printint+0x82>
 442:	70e2                	ld	ra,56(sp)
 444:	7442                	ld	s0,48(sp)
 446:	74a2                	ld	s1,40(sp)
 448:	7902                	ld	s2,32(sp)
 44a:	69e2                	ld	s3,24(sp)
 44c:	6121                	addi	sp,sp,64
 44e:	8082                	ret
 450:	40b005bb          	negw	a1,a1
 454:	4885                	li	a7,1
 456:	bf85                	j	3c6 <printint+0x1a>

0000000000000458 <vprintf>:
 458:	715d                	addi	sp,sp,-80
 45a:	e486                	sd	ra,72(sp)
 45c:	e0a2                	sd	s0,64(sp)
 45e:	fc26                	sd	s1,56(sp)
 460:	f84a                	sd	s2,48(sp)
 462:	f44e                	sd	s3,40(sp)
 464:	f052                	sd	s4,32(sp)
 466:	ec56                	sd	s5,24(sp)
 468:	e85a                	sd	s6,16(sp)
 46a:	e45e                	sd	s7,8(sp)
 46c:	e062                	sd	s8,0(sp)
 46e:	0880                	addi	s0,sp,80
 470:	0005c903          	lbu	s2,0(a1)
 474:	18090c63          	beqz	s2,60c <vprintf+0x1b4>
 478:	8aaa                	mv	s5,a0
 47a:	8bb2                	mv	s7,a2
 47c:	00158493          	addi	s1,a1,1
 480:	4981                	li	s3,0
 482:	02500a13          	li	s4,37
 486:	4b55                	li	s6,21
 488:	a839                	j	4a6 <vprintf+0x4e>
 48a:	85ca                	mv	a1,s2
 48c:	8556                	mv	a0,s5
 48e:	00000097          	auipc	ra,0x0
 492:	efc080e7          	jalr	-260(ra) # 38a <putc>
 496:	a019                	j	49c <vprintf+0x44>
 498:	01498d63          	beq	s3,s4,4b2 <vprintf+0x5a>
 49c:	0485                	addi	s1,s1,1
 49e:	fff4c903          	lbu	s2,-1(s1)
 4a2:	16090563          	beqz	s2,60c <vprintf+0x1b4>
 4a6:	fe0999e3          	bnez	s3,498 <vprintf+0x40>
 4aa:	ff4910e3          	bne	s2,s4,48a <vprintf+0x32>
 4ae:	89d2                	mv	s3,s4
 4b0:	b7f5                	j	49c <vprintf+0x44>
 4b2:	13490263          	beq	s2,s4,5d6 <vprintf+0x17e>
 4b6:	f9d9079b          	addiw	a5,s2,-99
 4ba:	0ff7f793          	zext.b	a5,a5
 4be:	12fb6563          	bltu	s6,a5,5e8 <vprintf+0x190>
 4c2:	f9d9079b          	addiw	a5,s2,-99
 4c6:	0ff7f713          	zext.b	a4,a5
 4ca:	10eb6f63          	bltu	s6,a4,5e8 <vprintf+0x190>
 4ce:	00271793          	slli	a5,a4,0x2
 4d2:	00000717          	auipc	a4,0x0
 4d6:	33e70713          	addi	a4,a4,830 # 810 <malloc+0x106>
 4da:	97ba                	add	a5,a5,a4
 4dc:	439c                	lw	a5,0(a5)
 4de:	97ba                	add	a5,a5,a4
 4e0:	8782                	jr	a5
 4e2:	008b8913          	addi	s2,s7,8
 4e6:	4685                	li	a3,1
 4e8:	4629                	li	a2,10
 4ea:	000ba583          	lw	a1,0(s7)
 4ee:	8556                	mv	a0,s5
 4f0:	00000097          	auipc	ra,0x0
 4f4:	ebc080e7          	jalr	-324(ra) # 3ac <printint>
 4f8:	8bca                	mv	s7,s2
 4fa:	4981                	li	s3,0
 4fc:	b745                	j	49c <vprintf+0x44>
 4fe:	008b8913          	addi	s2,s7,8
 502:	4681                	li	a3,0
 504:	4629                	li	a2,10
 506:	000ba583          	lw	a1,0(s7)
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	ea0080e7          	jalr	-352(ra) # 3ac <printint>
 514:	8bca                	mv	s7,s2
 516:	4981                	li	s3,0
 518:	b751                	j	49c <vprintf+0x44>
 51a:	008b8913          	addi	s2,s7,8
 51e:	4681                	li	a3,0
 520:	4641                	li	a2,16
 522:	000ba583          	lw	a1,0(s7)
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	e84080e7          	jalr	-380(ra) # 3ac <printint>
 530:	8bca                	mv	s7,s2
 532:	4981                	li	s3,0
 534:	b7a5                	j	49c <vprintf+0x44>
 536:	008b8c13          	addi	s8,s7,8
 53a:	000bb983          	ld	s3,0(s7)
 53e:	03000593          	li	a1,48
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e46080e7          	jalr	-442(ra) # 38a <putc>
 54c:	07800593          	li	a1,120
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e38080e7          	jalr	-456(ra) # 38a <putc>
 55a:	4941                	li	s2,16
 55c:	00000b97          	auipc	s7,0x0
 560:	30cb8b93          	addi	s7,s7,780 # 868 <digits>
 564:	03c9d793          	srli	a5,s3,0x3c
 568:	97de                	add	a5,a5,s7
 56a:	0007c583          	lbu	a1,0(a5)
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e1a080e7          	jalr	-486(ra) # 38a <putc>
 578:	0992                	slli	s3,s3,0x4
 57a:	397d                	addiw	s2,s2,-1
 57c:	fe0914e3          	bnez	s2,564 <vprintf+0x10c>
 580:	8be2                	mv	s7,s8
 582:	4981                	li	s3,0
 584:	bf21                	j	49c <vprintf+0x44>
 586:	008b8993          	addi	s3,s7,8
 58a:	000bb903          	ld	s2,0(s7)
 58e:	02090163          	beqz	s2,5b0 <vprintf+0x158>
 592:	00094583          	lbu	a1,0(s2)
 596:	c9a5                	beqz	a1,606 <vprintf+0x1ae>
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	df0080e7          	jalr	-528(ra) # 38a <putc>
 5a2:	0905                	addi	s2,s2,1
 5a4:	00094583          	lbu	a1,0(s2)
 5a8:	f9e5                	bnez	a1,598 <vprintf+0x140>
 5aa:	8bce                	mv	s7,s3
 5ac:	4981                	li	s3,0
 5ae:	b5fd                	j	49c <vprintf+0x44>
 5b0:	00000917          	auipc	s2,0x0
 5b4:	25890913          	addi	s2,s2,600 # 808 <malloc+0xfe>
 5b8:	02800593          	li	a1,40
 5bc:	bff1                	j	598 <vprintf+0x140>
 5be:	008b8913          	addi	s2,s7,8
 5c2:	000bc583          	lbu	a1,0(s7)
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	dc2080e7          	jalr	-574(ra) # 38a <putc>
 5d0:	8bca                	mv	s7,s2
 5d2:	4981                	li	s3,0
 5d4:	b5e1                	j	49c <vprintf+0x44>
 5d6:	02500593          	li	a1,37
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	dae080e7          	jalr	-594(ra) # 38a <putc>
 5e4:	4981                	li	s3,0
 5e6:	bd5d                	j	49c <vprintf+0x44>
 5e8:	02500593          	li	a1,37
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	d9c080e7          	jalr	-612(ra) # 38a <putc>
 5f6:	85ca                	mv	a1,s2
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	d90080e7          	jalr	-624(ra) # 38a <putc>
 602:	4981                	li	s3,0
 604:	bd61                	j	49c <vprintf+0x44>
 606:	8bce                	mv	s7,s3
 608:	4981                	li	s3,0
 60a:	bd49                	j	49c <vprintf+0x44>
 60c:	60a6                	ld	ra,72(sp)
 60e:	6406                	ld	s0,64(sp)
 610:	74e2                	ld	s1,56(sp)
 612:	7942                	ld	s2,48(sp)
 614:	79a2                	ld	s3,40(sp)
 616:	7a02                	ld	s4,32(sp)
 618:	6ae2                	ld	s5,24(sp)
 61a:	6b42                	ld	s6,16(sp)
 61c:	6ba2                	ld	s7,8(sp)
 61e:	6c02                	ld	s8,0(sp)
 620:	6161                	addi	sp,sp,80
 622:	8082                	ret

0000000000000624 <fprintf>:
 624:	715d                	addi	sp,sp,-80
 626:	ec06                	sd	ra,24(sp)
 628:	e822                	sd	s0,16(sp)
 62a:	1000                	addi	s0,sp,32
 62c:	e010                	sd	a2,0(s0)
 62e:	e414                	sd	a3,8(s0)
 630:	e818                	sd	a4,16(s0)
 632:	ec1c                	sd	a5,24(s0)
 634:	03043023          	sd	a6,32(s0)
 638:	03143423          	sd	a7,40(s0)
 63c:	fe843423          	sd	s0,-24(s0)
 640:	8622                	mv	a2,s0
 642:	00000097          	auipc	ra,0x0
 646:	e16080e7          	jalr	-490(ra) # 458 <vprintf>
 64a:	60e2                	ld	ra,24(sp)
 64c:	6442                	ld	s0,16(sp)
 64e:	6161                	addi	sp,sp,80
 650:	8082                	ret

0000000000000652 <printf>:
 652:	711d                	addi	sp,sp,-96
 654:	ec06                	sd	ra,24(sp)
 656:	e822                	sd	s0,16(sp)
 658:	1000                	addi	s0,sp,32
 65a:	e40c                	sd	a1,8(s0)
 65c:	e810                	sd	a2,16(s0)
 65e:	ec14                	sd	a3,24(s0)
 660:	f018                	sd	a4,32(s0)
 662:	f41c                	sd	a5,40(s0)
 664:	03043823          	sd	a6,48(s0)
 668:	03143c23          	sd	a7,56(s0)
 66c:	00840613          	addi	a2,s0,8
 670:	fec43423          	sd	a2,-24(s0)
 674:	85aa                	mv	a1,a0
 676:	4505                	li	a0,1
 678:	00000097          	auipc	ra,0x0
 67c:	de0080e7          	jalr	-544(ra) # 458 <vprintf>
 680:	60e2                	ld	ra,24(sp)
 682:	6442                	ld	s0,16(sp)
 684:	6125                	addi	sp,sp,96
 686:	8082                	ret

0000000000000688 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 688:	1141                	addi	sp,sp,-16
 68a:	e422                	sd	s0,8(sp)
 68c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 692:	00001797          	auipc	a5,0x1
 696:	96e7b783          	ld	a5,-1682(a5) # 1000 <freep>
 69a:	a02d                	j	6c4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 69c:	4618                	lw	a4,8(a2)
 69e:	9f2d                	addw	a4,a4,a1
 6a0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a4:	6398                	ld	a4,0(a5)
 6a6:	6310                	ld	a2,0(a4)
 6a8:	a83d                	j	6e6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6aa:	ff852703          	lw	a4,-8(a0)
 6ae:	9f31                	addw	a4,a4,a2
 6b0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6b2:	ff053683          	ld	a3,-16(a0)
 6b6:	a091                	j	6fa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b8:	6398                	ld	a4,0(a5)
 6ba:	00e7e463          	bltu	a5,a4,6c2 <free+0x3a>
 6be:	00e6ea63          	bltu	a3,a4,6d2 <free+0x4a>
{
 6c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c4:	fed7fae3          	bgeu	a5,a3,6b8 <free+0x30>
 6c8:	6398                	ld	a4,0(a5)
 6ca:	00e6e463          	bltu	a3,a4,6d2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ce:	fee7eae3          	bltu	a5,a4,6c2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6d2:	ff852583          	lw	a1,-8(a0)
 6d6:	6390                	ld	a2,0(a5)
 6d8:	02059813          	slli	a6,a1,0x20
 6dc:	01c85713          	srli	a4,a6,0x1c
 6e0:	9736                	add	a4,a4,a3
 6e2:	fae60de3          	beq	a2,a4,69c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6e6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ea:	4790                	lw	a2,8(a5)
 6ec:	02061593          	slli	a1,a2,0x20
 6f0:	01c5d713          	srli	a4,a1,0x1c
 6f4:	973e                	add	a4,a4,a5
 6f6:	fae68ae3          	beq	a3,a4,6aa <free+0x22>
    p->s.ptr = bp->s.ptr;
 6fa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6fc:	00001717          	auipc	a4,0x1
 700:	90f73223          	sd	a5,-1788(a4) # 1000 <freep>
}
 704:	6422                	ld	s0,8(sp)
 706:	0141                	addi	sp,sp,16
 708:	8082                	ret

000000000000070a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 70a:	7139                	addi	sp,sp,-64
 70c:	fc06                	sd	ra,56(sp)
 70e:	f822                	sd	s0,48(sp)
 710:	f426                	sd	s1,40(sp)
 712:	f04a                	sd	s2,32(sp)
 714:	ec4e                	sd	s3,24(sp)
 716:	e852                	sd	s4,16(sp)
 718:	e456                	sd	s5,8(sp)
 71a:	e05a                	sd	s6,0(sp)
 71c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71e:	02051493          	slli	s1,a0,0x20
 722:	9081                	srli	s1,s1,0x20
 724:	04bd                	addi	s1,s1,15
 726:	8091                	srli	s1,s1,0x4
 728:	0014899b          	addiw	s3,s1,1
 72c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 72e:	00001517          	auipc	a0,0x1
 732:	8d253503          	ld	a0,-1838(a0) # 1000 <freep>
 736:	c515                	beqz	a0,762 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 738:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 73a:	4798                	lw	a4,8(a5)
 73c:	02977f63          	bgeu	a4,s1,77a <malloc+0x70>
  if(nu < 4096)
 740:	8a4e                	mv	s4,s3
 742:	0009871b          	sext.w	a4,s3
 746:	6685                	lui	a3,0x1
 748:	00d77363          	bgeu	a4,a3,74e <malloc+0x44>
 74c:	6a05                	lui	s4,0x1
 74e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 752:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 756:	00001917          	auipc	s2,0x1
 75a:	8aa90913          	addi	s2,s2,-1878 # 1000 <freep>
  if(p == (char*)-1)
 75e:	5afd                	li	s5,-1
 760:	a895                	j	7d4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 762:	00001797          	auipc	a5,0x1
 766:	8ae78793          	addi	a5,a5,-1874 # 1010 <base>
 76a:	00001717          	auipc	a4,0x1
 76e:	88f73b23          	sd	a5,-1898(a4) # 1000 <freep>
 772:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 774:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 778:	b7e1                	j	740 <malloc+0x36>
      if(p->s.size == nunits)
 77a:	02e48c63          	beq	s1,a4,7b2 <malloc+0xa8>
        p->s.size -= nunits;
 77e:	4137073b          	subw	a4,a4,s3
 782:	c798                	sw	a4,8(a5)
        p += p->s.size;
 784:	02071693          	slli	a3,a4,0x20
 788:	01c6d713          	srli	a4,a3,0x1c
 78c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 78e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 792:	00001717          	auipc	a4,0x1
 796:	86a73723          	sd	a0,-1938(a4) # 1000 <freep>
      return (void*)(p + 1);
 79a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 79e:	70e2                	ld	ra,56(sp)
 7a0:	7442                	ld	s0,48(sp)
 7a2:	74a2                	ld	s1,40(sp)
 7a4:	7902                	ld	s2,32(sp)
 7a6:	69e2                	ld	s3,24(sp)
 7a8:	6a42                	ld	s4,16(sp)
 7aa:	6aa2                	ld	s5,8(sp)
 7ac:	6b02                	ld	s6,0(sp)
 7ae:	6121                	addi	sp,sp,64
 7b0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7b2:	6398                	ld	a4,0(a5)
 7b4:	e118                	sd	a4,0(a0)
 7b6:	bff1                	j	792 <malloc+0x88>
  hp->s.size = nu;
 7b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7bc:	0541                	addi	a0,a0,16
 7be:	00000097          	auipc	ra,0x0
 7c2:	eca080e7          	jalr	-310(ra) # 688 <free>
  return freep;
 7c6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ca:	d971                	beqz	a0,79e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ce:	4798                	lw	a4,8(a5)
 7d0:	fa9775e3          	bgeu	a4,s1,77a <malloc+0x70>
    if(p == freep)
 7d4:	00093703          	ld	a4,0(s2)
 7d8:	853e                	mv	a0,a5
 7da:	fef719e3          	bne	a4,a5,7cc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7de:	8552                	mv	a0,s4
 7e0:	00000097          	auipc	ra,0x0
 7e4:	b92080e7          	jalr	-1134(ra) # 372 <sbrk>
  if(p == (char*)-1)
 7e8:	fd5518e3          	bne	a0,s5,7b8 <malloc+0xae>
        return 0;
 7ec:	4501                	li	a0,0
 7ee:	bf45                	j	79e <malloc+0x94>

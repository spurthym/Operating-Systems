
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  10:	00000097          	auipc	ra,0x0
  14:	324080e7          	jalr	804(ra) # 334 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
  36:	00178493          	addi	s1,a5,1
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2f8080e7          	jalr	760(ra) # 334 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2d6080e7          	jalr	726(ra) # 334 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	faa98993          	addi	s3,s3,-86 # 1010 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	430080e7          	jalr	1072(ra) # 4a6 <memmove>
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2b4080e7          	jalr	692(ra) # 334 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2a6080e7          	jalr	678(ra) # 334 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2b6080e7          	jalr	694(ra) # 35e <memset>
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	4be080e7          	jalr	1214(ra) # 598 <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	4c4080e7          	jalr	1220(ra) # 5b0 <fstat>
  f4:	08054163          	bltz	a0,176 <ls+0xc2>
  f8:	da041783          	lh	a5,-608(s0)
  fc:	4705                	li	a4,1
  fe:	08e78c63          	beq	a5,a4,196 <ls+0xe2>
 102:	37f9                	addiw	a5,a5,-2
 104:	17c2                	slli	a5,a5,0x30
 106:	93c1                	srli	a5,a5,0x30
 108:	02f76663          	bltu	a4,a5,134 <ls+0x80>
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <fmtname>
 116:	85aa                	mv	a1,a0
 118:	da843703          	ld	a4,-600(s0)
 11c:	d9c42683          	lw	a3,-612(s0)
 120:	da041603          	lh	a2,-608(s0)
 124:	00001517          	auipc	a0,0x1
 128:	96c50513          	addi	a0,a0,-1684 # a90 <malloc+0x118>
 12c:	00000097          	auipc	ra,0x0
 130:	794080e7          	jalr	1940(ra) # 8c0 <printf>
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	44a080e7          	jalr	1098(ra) # 580 <close>
 13e:	26813083          	ld	ra,616(sp)
 142:	26013403          	ld	s0,608(sp)
 146:	25813483          	ld	s1,600(sp)
 14a:	25013903          	ld	s2,592(sp)
 14e:	24813983          	ld	s3,584(sp)
 152:	24013a03          	ld	s4,576(sp)
 156:	23813a83          	ld	s5,568(sp)
 15a:	27010113          	addi	sp,sp,624
 15e:	8082                	ret
 160:	864a                	mv	a2,s2
 162:	00001597          	auipc	a1,0x1
 166:	8fe58593          	addi	a1,a1,-1794 # a60 <malloc+0xe8>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	726080e7          	jalr	1830(ra) # 892 <fprintf>
 174:	b7e9                	j	13e <ls+0x8a>
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	90058593          	addi	a1,a1,-1792 # a78 <malloc+0x100>
 180:	4509                	li	a0,2
 182:	00000097          	auipc	ra,0x0
 186:	710080e7          	jalr	1808(ra) # 892 <fprintf>
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	3f4080e7          	jalr	1012(ra) # 580 <close>
 194:	b76d                	j	13e <ls+0x8a>
 196:	854a                	mv	a0,s2
 198:	00000097          	auipc	ra,0x0
 19c:	19c080e7          	jalr	412(ra) # 334 <strlen>
 1a0:	2541                	addiw	a0,a0,16
 1a2:	20000793          	li	a5,512
 1a6:	00a7fb63          	bgeu	a5,a0,1bc <ls+0x108>
 1aa:	00001517          	auipc	a0,0x1
 1ae:	8f650513          	addi	a0,a0,-1802 # aa0 <malloc+0x128>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	70e080e7          	jalr	1806(ra) # 8c0 <printf>
 1ba:	bfad                	j	134 <ls+0x80>
 1bc:	85ca                	mv	a1,s2
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	12a080e7          	jalr	298(ra) # 2ec <strcpy>
 1ca:	dc040513          	addi	a0,s0,-576
 1ce:	00000097          	auipc	ra,0x0
 1d2:	166080e7          	jalr	358(ra) # 334 <strlen>
 1d6:	1502                	slli	a0,a0,0x20
 1d8:	9101                	srli	a0,a0,0x20
 1da:	dc040793          	addi	a5,s0,-576
 1de:	00a78933          	add	s2,a5,a0
 1e2:	00190993          	addi	s3,s2,1
 1e6:	02f00793          	li	a5,47
 1ea:	00f90023          	sb	a5,0(s2)
 1ee:	00001a17          	auipc	s4,0x1
 1f2:	8caa0a13          	addi	s4,s4,-1846 # ab8 <malloc+0x140>
 1f6:	00001a97          	auipc	s5,0x1
 1fa:	882a8a93          	addi	s5,s5,-1918 # a78 <malloc+0x100>
 1fe:	a801                	j	20e <ls+0x15a>
 200:	dc040593          	addi	a1,s0,-576
 204:	8556                	mv	a0,s5
 206:	00000097          	auipc	ra,0x0
 20a:	6ba080e7          	jalr	1722(ra) # 8c0 <printf>
 20e:	4641                	li	a2,16
 210:	db040593          	addi	a1,s0,-592
 214:	8526                	mv	a0,s1
 216:	00000097          	auipc	ra,0x0
 21a:	35a080e7          	jalr	858(ra) # 570 <read>
 21e:	47c1                	li	a5,16
 220:	f0f51ae3          	bne	a0,a5,134 <ls+0x80>
 224:	db045783          	lhu	a5,-592(s0)
 228:	d3fd                	beqz	a5,20e <ls+0x15a>
 22a:	4639                	li	a2,14
 22c:	db240593          	addi	a1,s0,-590
 230:	854e                	mv	a0,s3
 232:	00000097          	auipc	ra,0x0
 236:	274080e7          	jalr	628(ra) # 4a6 <memmove>
 23a:	000907a3          	sb	zero,15(s2)
 23e:	d9840593          	addi	a1,s0,-616
 242:	dc040513          	addi	a0,s0,-576
 246:	00000097          	auipc	ra,0x0
 24a:	1d2080e7          	jalr	466(ra) # 418 <stat>
 24e:	fa0549e3          	bltz	a0,200 <ls+0x14c>
 252:	dc040513          	addi	a0,s0,-576
 256:	00000097          	auipc	ra,0x0
 25a:	daa080e7          	jalr	-598(ra) # 0 <fmtname>
 25e:	85aa                	mv	a1,a0
 260:	da843703          	ld	a4,-600(s0)
 264:	d9c42683          	lw	a3,-612(s0)
 268:	da041603          	lh	a2,-608(s0)
 26c:	8552                	mv	a0,s4
 26e:	00000097          	auipc	ra,0x0
 272:	652080e7          	jalr	1618(ra) # 8c0 <printf>
 276:	bf61                	j	20e <ls+0x15a>

0000000000000278 <main>:
 278:	1101                	addi	sp,sp,-32
 27a:	ec06                	sd	ra,24(sp)
 27c:	e822                	sd	s0,16(sp)
 27e:	e426                	sd	s1,8(sp)
 280:	e04a                	sd	s2,0(sp)
 282:	1000                	addi	s0,sp,32
 284:	4785                	li	a5,1
 286:	02a7d963          	bge	a5,a0,2b8 <main+0x40>
 28a:	00858493          	addi	s1,a1,8
 28e:	ffe5091b          	addiw	s2,a0,-2
 292:	02091793          	slli	a5,s2,0x20
 296:	01d7d913          	srli	s2,a5,0x1d
 29a:	05c1                	addi	a1,a1,16
 29c:	992e                	add	s2,s2,a1
 29e:	6088                	ld	a0,0(s1)
 2a0:	00000097          	auipc	ra,0x0
 2a4:	e14080e7          	jalr	-492(ra) # b4 <ls>
 2a8:	04a1                	addi	s1,s1,8
 2aa:	ff249ae3          	bne	s1,s2,29e <main+0x26>
 2ae:	4501                	li	a0,0
 2b0:	00000097          	auipc	ra,0x0
 2b4:	2a8080e7          	jalr	680(ra) # 558 <exit>
 2b8:	00001517          	auipc	a0,0x1
 2bc:	81050513          	addi	a0,a0,-2032 # ac8 <malloc+0x150>
 2c0:	00000097          	auipc	ra,0x0
 2c4:	df4080e7          	jalr	-524(ra) # b4 <ls>
 2c8:	4501                	li	a0,0
 2ca:	00000097          	auipc	ra,0x0
 2ce:	28e080e7          	jalr	654(ra) # 558 <exit>

00000000000002d2 <_main>:
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
 2da:	00000097          	auipc	ra,0x0
 2de:	f9e080e7          	jalr	-98(ra) # 278 <main>
 2e2:	4501                	li	a0,0
 2e4:	00000097          	auipc	ra,0x0
 2e8:	274080e7          	jalr	628(ra) # 558 <exit>

00000000000002ec <strcpy>:
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
 2f2:	87aa                	mv	a5,a0
 2f4:	0585                	addi	a1,a1,1
 2f6:	0785                	addi	a5,a5,1
 2f8:	fff5c703          	lbu	a4,-1(a1)
 2fc:	fee78fa3          	sb	a4,-1(a5)
 300:	fb75                	bnez	a4,2f4 <strcpy+0x8>
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <strcmp>:
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
 30e:	00054783          	lbu	a5,0(a0)
 312:	cb91                	beqz	a5,326 <strcmp+0x1e>
 314:	0005c703          	lbu	a4,0(a1)
 318:	00f71763          	bne	a4,a5,326 <strcmp+0x1e>
 31c:	0505                	addi	a0,a0,1
 31e:	0585                	addi	a1,a1,1
 320:	00054783          	lbu	a5,0(a0)
 324:	fbe5                	bnez	a5,314 <strcmp+0xc>
 326:	0005c503          	lbu	a0,0(a1)
 32a:	40a7853b          	subw	a0,a5,a0
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret

0000000000000334 <strlen>:
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
 33a:	00054783          	lbu	a5,0(a0)
 33e:	cf91                	beqz	a5,35a <strlen+0x26>
 340:	0505                	addi	a0,a0,1
 342:	87aa                	mv	a5,a0
 344:	86be                	mv	a3,a5
 346:	0785                	addi	a5,a5,1
 348:	fff7c703          	lbu	a4,-1(a5)
 34c:	ff65                	bnez	a4,344 <strlen+0x10>
 34e:	40a6853b          	subw	a0,a3,a0
 352:	2505                	addiw	a0,a0,1
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <strlen+0x20>

000000000000035e <memset>:
 35e:	1141                	addi	sp,sp,-16
 360:	e422                	sd	s0,8(sp)
 362:	0800                	addi	s0,sp,16
 364:	ca19                	beqz	a2,37a <memset+0x1c>
 366:	87aa                	mv	a5,a0
 368:	1602                	slli	a2,a2,0x20
 36a:	9201                	srli	a2,a2,0x20
 36c:	00a60733          	add	a4,a2,a0
 370:	00b78023          	sb	a1,0(a5)
 374:	0785                	addi	a5,a5,1
 376:	fee79de3          	bne	a5,a4,370 <memset+0x12>
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <strchr>:
 380:	1141                	addi	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	addi	s0,sp,16
 386:	00054783          	lbu	a5,0(a0)
 38a:	cb99                	beqz	a5,3a0 <strchr+0x20>
 38c:	00f58763          	beq	a1,a5,39a <strchr+0x1a>
 390:	0505                	addi	a0,a0,1
 392:	00054783          	lbu	a5,0(a0)
 396:	fbfd                	bnez	a5,38c <strchr+0xc>
 398:	4501                	li	a0,0
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret
 3a0:	4501                	li	a0,0
 3a2:	bfe5                	j	39a <strchr+0x1a>

00000000000003a4 <gets>:
 3a4:	711d                	addi	sp,sp,-96
 3a6:	ec86                	sd	ra,88(sp)
 3a8:	e8a2                	sd	s0,80(sp)
 3aa:	e4a6                	sd	s1,72(sp)
 3ac:	e0ca                	sd	s2,64(sp)
 3ae:	fc4e                	sd	s3,56(sp)
 3b0:	f852                	sd	s4,48(sp)
 3b2:	f456                	sd	s5,40(sp)
 3b4:	f05a                	sd	s6,32(sp)
 3b6:	ec5e                	sd	s7,24(sp)
 3b8:	1080                	addi	s0,sp,96
 3ba:	8baa                	mv	s7,a0
 3bc:	8a2e                	mv	s4,a1
 3be:	892a                	mv	s2,a0
 3c0:	4481                	li	s1,0
 3c2:	4aa9                	li	s5,10
 3c4:	4b35                	li	s6,13
 3c6:	89a6                	mv	s3,s1
 3c8:	2485                	addiw	s1,s1,1
 3ca:	0344d863          	bge	s1,s4,3fa <gets+0x56>
 3ce:	4605                	li	a2,1
 3d0:	faf40593          	addi	a1,s0,-81
 3d4:	4501                	li	a0,0
 3d6:	00000097          	auipc	ra,0x0
 3da:	19a080e7          	jalr	410(ra) # 570 <read>
 3de:	00a05e63          	blez	a0,3fa <gets+0x56>
 3e2:	faf44783          	lbu	a5,-81(s0)
 3e6:	00f90023          	sb	a5,0(s2)
 3ea:	01578763          	beq	a5,s5,3f8 <gets+0x54>
 3ee:	0905                	addi	s2,s2,1
 3f0:	fd679be3          	bne	a5,s6,3c6 <gets+0x22>
 3f4:	89a6                	mv	s3,s1
 3f6:	a011                	j	3fa <gets+0x56>
 3f8:	89a6                	mv	s3,s1
 3fa:	99de                	add	s3,s3,s7
 3fc:	00098023          	sb	zero,0(s3)
 400:	855e                	mv	a0,s7
 402:	60e6                	ld	ra,88(sp)
 404:	6446                	ld	s0,80(sp)
 406:	64a6                	ld	s1,72(sp)
 408:	6906                	ld	s2,64(sp)
 40a:	79e2                	ld	s3,56(sp)
 40c:	7a42                	ld	s4,48(sp)
 40e:	7aa2                	ld	s5,40(sp)
 410:	7b02                	ld	s6,32(sp)
 412:	6be2                	ld	s7,24(sp)
 414:	6125                	addi	sp,sp,96
 416:	8082                	ret

0000000000000418 <stat>:
 418:	1101                	addi	sp,sp,-32
 41a:	ec06                	sd	ra,24(sp)
 41c:	e822                	sd	s0,16(sp)
 41e:	e426                	sd	s1,8(sp)
 420:	e04a                	sd	s2,0(sp)
 422:	1000                	addi	s0,sp,32
 424:	892e                	mv	s2,a1
 426:	4581                	li	a1,0
 428:	00000097          	auipc	ra,0x0
 42c:	170080e7          	jalr	368(ra) # 598 <open>
 430:	02054563          	bltz	a0,45a <stat+0x42>
 434:	84aa                	mv	s1,a0
 436:	85ca                	mv	a1,s2
 438:	00000097          	auipc	ra,0x0
 43c:	178080e7          	jalr	376(ra) # 5b0 <fstat>
 440:	892a                	mv	s2,a0
 442:	8526                	mv	a0,s1
 444:	00000097          	auipc	ra,0x0
 448:	13c080e7          	jalr	316(ra) # 580 <close>
 44c:	854a                	mv	a0,s2
 44e:	60e2                	ld	ra,24(sp)
 450:	6442                	ld	s0,16(sp)
 452:	64a2                	ld	s1,8(sp)
 454:	6902                	ld	s2,0(sp)
 456:	6105                	addi	sp,sp,32
 458:	8082                	ret
 45a:	597d                	li	s2,-1
 45c:	bfc5                	j	44c <stat+0x34>

000000000000045e <atoi>:
 45e:	1141                	addi	sp,sp,-16
 460:	e422                	sd	s0,8(sp)
 462:	0800                	addi	s0,sp,16
 464:	00054683          	lbu	a3,0(a0)
 468:	fd06879b          	addiw	a5,a3,-48
 46c:	0ff7f793          	zext.b	a5,a5
 470:	4625                	li	a2,9
 472:	02f66863          	bltu	a2,a5,4a2 <atoi+0x44>
 476:	872a                	mv	a4,a0
 478:	4501                	li	a0,0
 47a:	0705                	addi	a4,a4,1
 47c:	0025179b          	slliw	a5,a0,0x2
 480:	9fa9                	addw	a5,a5,a0
 482:	0017979b          	slliw	a5,a5,0x1
 486:	9fb5                	addw	a5,a5,a3
 488:	fd07851b          	addiw	a0,a5,-48
 48c:	00074683          	lbu	a3,0(a4)
 490:	fd06879b          	addiw	a5,a3,-48
 494:	0ff7f793          	zext.b	a5,a5
 498:	fef671e3          	bgeu	a2,a5,47a <atoi+0x1c>
 49c:	6422                	ld	s0,8(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
 4a2:	4501                	li	a0,0
 4a4:	bfe5                	j	49c <atoi+0x3e>

00000000000004a6 <memmove>:
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e422                	sd	s0,8(sp)
 4aa:	0800                	addi	s0,sp,16
 4ac:	02b57463          	bgeu	a0,a1,4d4 <memmove+0x2e>
 4b0:	00c05f63          	blez	a2,4ce <memmove+0x28>
 4b4:	1602                	slli	a2,a2,0x20
 4b6:	9201                	srli	a2,a2,0x20
 4b8:	00c507b3          	add	a5,a0,a2
 4bc:	872a                	mv	a4,a0
 4be:	0585                	addi	a1,a1,1
 4c0:	0705                	addi	a4,a4,1
 4c2:	fff5c683          	lbu	a3,-1(a1)
 4c6:	fed70fa3          	sb	a3,-1(a4)
 4ca:	fee79ae3          	bne	a5,a4,4be <memmove+0x18>
 4ce:	6422                	ld	s0,8(sp)
 4d0:	0141                	addi	sp,sp,16
 4d2:	8082                	ret
 4d4:	00c50733          	add	a4,a0,a2
 4d8:	95b2                	add	a1,a1,a2
 4da:	fec05ae3          	blez	a2,4ce <memmove+0x28>
 4de:	fff6079b          	addiw	a5,a2,-1
 4e2:	1782                	slli	a5,a5,0x20
 4e4:	9381                	srli	a5,a5,0x20
 4e6:	fff7c793          	not	a5,a5
 4ea:	97ba                	add	a5,a5,a4
 4ec:	15fd                	addi	a1,a1,-1
 4ee:	177d                	addi	a4,a4,-1
 4f0:	0005c683          	lbu	a3,0(a1)
 4f4:	00d70023          	sb	a3,0(a4)
 4f8:	fee79ae3          	bne	a5,a4,4ec <memmove+0x46>
 4fc:	bfc9                	j	4ce <memmove+0x28>

00000000000004fe <memcmp>:
 4fe:	1141                	addi	sp,sp,-16
 500:	e422                	sd	s0,8(sp)
 502:	0800                	addi	s0,sp,16
 504:	ca05                	beqz	a2,534 <memcmp+0x36>
 506:	fff6069b          	addiw	a3,a2,-1
 50a:	1682                	slli	a3,a3,0x20
 50c:	9281                	srli	a3,a3,0x20
 50e:	0685                	addi	a3,a3,1
 510:	96aa                	add	a3,a3,a0
 512:	00054783          	lbu	a5,0(a0)
 516:	0005c703          	lbu	a4,0(a1)
 51a:	00e79863          	bne	a5,a4,52a <memcmp+0x2c>
 51e:	0505                	addi	a0,a0,1
 520:	0585                	addi	a1,a1,1
 522:	fed518e3          	bne	a0,a3,512 <memcmp+0x14>
 526:	4501                	li	a0,0
 528:	a019                	j	52e <memcmp+0x30>
 52a:	40e7853b          	subw	a0,a5,a4
 52e:	6422                	ld	s0,8(sp)
 530:	0141                	addi	sp,sp,16
 532:	8082                	ret
 534:	4501                	li	a0,0
 536:	bfe5                	j	52e <memcmp+0x30>

0000000000000538 <memcpy>:
 538:	1141                	addi	sp,sp,-16
 53a:	e406                	sd	ra,8(sp)
 53c:	e022                	sd	s0,0(sp)
 53e:	0800                	addi	s0,sp,16
 540:	00000097          	auipc	ra,0x0
 544:	f66080e7          	jalr	-154(ra) # 4a6 <memmove>
 548:	60a2                	ld	ra,8(sp)
 54a:	6402                	ld	s0,0(sp)
 54c:	0141                	addi	sp,sp,16
 54e:	8082                	ret

0000000000000550 <fork>:
 550:	4885                	li	a7,1
 552:	00000073          	ecall
 556:	8082                	ret

0000000000000558 <exit>:
 558:	4889                	li	a7,2
 55a:	00000073          	ecall
 55e:	8082                	ret

0000000000000560 <wait>:
 560:	488d                	li	a7,3
 562:	00000073          	ecall
 566:	8082                	ret

0000000000000568 <pipe>:
 568:	4891                	li	a7,4
 56a:	00000073          	ecall
 56e:	8082                	ret

0000000000000570 <read>:
 570:	4895                	li	a7,5
 572:	00000073          	ecall
 576:	8082                	ret

0000000000000578 <write>:
 578:	48c1                	li	a7,16
 57a:	00000073          	ecall
 57e:	8082                	ret

0000000000000580 <close>:
 580:	48d5                	li	a7,21
 582:	00000073          	ecall
 586:	8082                	ret

0000000000000588 <kill>:
 588:	4899                	li	a7,6
 58a:	00000073          	ecall
 58e:	8082                	ret

0000000000000590 <exec>:
 590:	489d                	li	a7,7
 592:	00000073          	ecall
 596:	8082                	ret

0000000000000598 <open>:
 598:	48bd                	li	a7,15
 59a:	00000073          	ecall
 59e:	8082                	ret

00000000000005a0 <mknod>:
 5a0:	48c5                	li	a7,17
 5a2:	00000073          	ecall
 5a6:	8082                	ret

00000000000005a8 <unlink>:
 5a8:	48c9                	li	a7,18
 5aa:	00000073          	ecall
 5ae:	8082                	ret

00000000000005b0 <fstat>:
 5b0:	48a1                	li	a7,8
 5b2:	00000073          	ecall
 5b6:	8082                	ret

00000000000005b8 <link>:
 5b8:	48cd                	li	a7,19
 5ba:	00000073          	ecall
 5be:	8082                	ret

00000000000005c0 <mkdir>:
 5c0:	48d1                	li	a7,20
 5c2:	00000073          	ecall
 5c6:	8082                	ret

00000000000005c8 <chdir>:
 5c8:	48a5                	li	a7,9
 5ca:	00000073          	ecall
 5ce:	8082                	ret

00000000000005d0 <dup>:
 5d0:	48a9                	li	a7,10
 5d2:	00000073          	ecall
 5d6:	8082                	ret

00000000000005d8 <getpid>:
 5d8:	48ad                	li	a7,11
 5da:	00000073          	ecall
 5de:	8082                	ret

00000000000005e0 <sbrk>:
 5e0:	48b1                	li	a7,12
 5e2:	00000073          	ecall
 5e6:	8082                	ret

00000000000005e8 <sleep>:
 5e8:	48b5                	li	a7,13
 5ea:	00000073          	ecall
 5ee:	8082                	ret

00000000000005f0 <uptime>:
 5f0:	48b9                	li	a7,14
 5f2:	00000073          	ecall
 5f6:	8082                	ret

00000000000005f8 <putc>:
 5f8:	1101                	addi	sp,sp,-32
 5fa:	ec06                	sd	ra,24(sp)
 5fc:	e822                	sd	s0,16(sp)
 5fe:	1000                	addi	s0,sp,32
 600:	feb407a3          	sb	a1,-17(s0)
 604:	4605                	li	a2,1
 606:	fef40593          	addi	a1,s0,-17
 60a:	00000097          	auipc	ra,0x0
 60e:	f6e080e7          	jalr	-146(ra) # 578 <write>
 612:	60e2                	ld	ra,24(sp)
 614:	6442                	ld	s0,16(sp)
 616:	6105                	addi	sp,sp,32
 618:	8082                	ret

000000000000061a <printint>:
 61a:	7139                	addi	sp,sp,-64
 61c:	fc06                	sd	ra,56(sp)
 61e:	f822                	sd	s0,48(sp)
 620:	f426                	sd	s1,40(sp)
 622:	f04a                	sd	s2,32(sp)
 624:	ec4e                	sd	s3,24(sp)
 626:	0080                	addi	s0,sp,64
 628:	84aa                	mv	s1,a0
 62a:	c299                	beqz	a3,630 <printint+0x16>
 62c:	0805c963          	bltz	a1,6be <printint+0xa4>
 630:	2581                	sext.w	a1,a1
 632:	4881                	li	a7,0
 634:	fc040693          	addi	a3,s0,-64
 638:	4701                	li	a4,0
 63a:	2601                	sext.w	a2,a2
 63c:	00000517          	auipc	a0,0x0
 640:	4f450513          	addi	a0,a0,1268 # b30 <digits>
 644:	883a                	mv	a6,a4
 646:	2705                	addiw	a4,a4,1
 648:	02c5f7bb          	remuw	a5,a1,a2
 64c:	1782                	slli	a5,a5,0x20
 64e:	9381                	srli	a5,a5,0x20
 650:	97aa                	add	a5,a5,a0
 652:	0007c783          	lbu	a5,0(a5)
 656:	00f68023          	sb	a5,0(a3)
 65a:	0005879b          	sext.w	a5,a1
 65e:	02c5d5bb          	divuw	a1,a1,a2
 662:	0685                	addi	a3,a3,1
 664:	fec7f0e3          	bgeu	a5,a2,644 <printint+0x2a>
 668:	00088c63          	beqz	a7,680 <printint+0x66>
 66c:	fd070793          	addi	a5,a4,-48
 670:	00878733          	add	a4,a5,s0
 674:	02d00793          	li	a5,45
 678:	fef70823          	sb	a5,-16(a4)
 67c:	0028071b          	addiw	a4,a6,2
 680:	02e05863          	blez	a4,6b0 <printint+0x96>
 684:	fc040793          	addi	a5,s0,-64
 688:	00e78933          	add	s2,a5,a4
 68c:	fff78993          	addi	s3,a5,-1
 690:	99ba                	add	s3,s3,a4
 692:	377d                	addiw	a4,a4,-1
 694:	1702                	slli	a4,a4,0x20
 696:	9301                	srli	a4,a4,0x20
 698:	40e989b3          	sub	s3,s3,a4
 69c:	fff94583          	lbu	a1,-1(s2)
 6a0:	8526                	mv	a0,s1
 6a2:	00000097          	auipc	ra,0x0
 6a6:	f56080e7          	jalr	-170(ra) # 5f8 <putc>
 6aa:	197d                	addi	s2,s2,-1
 6ac:	ff3918e3          	bne	s2,s3,69c <printint+0x82>
 6b0:	70e2                	ld	ra,56(sp)
 6b2:	7442                	ld	s0,48(sp)
 6b4:	74a2                	ld	s1,40(sp)
 6b6:	7902                	ld	s2,32(sp)
 6b8:	69e2                	ld	s3,24(sp)
 6ba:	6121                	addi	sp,sp,64
 6bc:	8082                	ret
 6be:	40b005bb          	negw	a1,a1
 6c2:	4885                	li	a7,1
 6c4:	bf85                	j	634 <printint+0x1a>

00000000000006c6 <vprintf>:
 6c6:	715d                	addi	sp,sp,-80
 6c8:	e486                	sd	ra,72(sp)
 6ca:	e0a2                	sd	s0,64(sp)
 6cc:	fc26                	sd	s1,56(sp)
 6ce:	f84a                	sd	s2,48(sp)
 6d0:	f44e                	sd	s3,40(sp)
 6d2:	f052                	sd	s4,32(sp)
 6d4:	ec56                	sd	s5,24(sp)
 6d6:	e85a                	sd	s6,16(sp)
 6d8:	e45e                	sd	s7,8(sp)
 6da:	e062                	sd	s8,0(sp)
 6dc:	0880                	addi	s0,sp,80
 6de:	0005c903          	lbu	s2,0(a1)
 6e2:	18090c63          	beqz	s2,87a <vprintf+0x1b4>
 6e6:	8aaa                	mv	s5,a0
 6e8:	8bb2                	mv	s7,a2
 6ea:	00158493          	addi	s1,a1,1
 6ee:	4981                	li	s3,0
 6f0:	02500a13          	li	s4,37
 6f4:	4b55                	li	s6,21
 6f6:	a839                	j	714 <vprintf+0x4e>
 6f8:	85ca                	mv	a1,s2
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	efc080e7          	jalr	-260(ra) # 5f8 <putc>
 704:	a019                	j	70a <vprintf+0x44>
 706:	01498d63          	beq	s3,s4,720 <vprintf+0x5a>
 70a:	0485                	addi	s1,s1,1
 70c:	fff4c903          	lbu	s2,-1(s1)
 710:	16090563          	beqz	s2,87a <vprintf+0x1b4>
 714:	fe0999e3          	bnez	s3,706 <vprintf+0x40>
 718:	ff4910e3          	bne	s2,s4,6f8 <vprintf+0x32>
 71c:	89d2                	mv	s3,s4
 71e:	b7f5                	j	70a <vprintf+0x44>
 720:	13490263          	beq	s2,s4,844 <vprintf+0x17e>
 724:	f9d9079b          	addiw	a5,s2,-99
 728:	0ff7f793          	zext.b	a5,a5
 72c:	12fb6563          	bltu	s6,a5,856 <vprintf+0x190>
 730:	f9d9079b          	addiw	a5,s2,-99
 734:	0ff7f713          	zext.b	a4,a5
 738:	10eb6f63          	bltu	s6,a4,856 <vprintf+0x190>
 73c:	00271793          	slli	a5,a4,0x2
 740:	00000717          	auipc	a4,0x0
 744:	39870713          	addi	a4,a4,920 # ad8 <malloc+0x160>
 748:	97ba                	add	a5,a5,a4
 74a:	439c                	lw	a5,0(a5)
 74c:	97ba                	add	a5,a5,a4
 74e:	8782                	jr	a5
 750:	008b8913          	addi	s2,s7,8
 754:	4685                	li	a3,1
 756:	4629                	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	ebc080e7          	jalr	-324(ra) # 61a <printint>
 766:	8bca                	mv	s7,s2
 768:	4981                	li	s3,0
 76a:	b745                	j	70a <vprintf+0x44>
 76c:	008b8913          	addi	s2,s7,8
 770:	4681                	li	a3,0
 772:	4629                	li	a2,10
 774:	000ba583          	lw	a1,0(s7)
 778:	8556                	mv	a0,s5
 77a:	00000097          	auipc	ra,0x0
 77e:	ea0080e7          	jalr	-352(ra) # 61a <printint>
 782:	8bca                	mv	s7,s2
 784:	4981                	li	s3,0
 786:	b751                	j	70a <vprintf+0x44>
 788:	008b8913          	addi	s2,s7,8
 78c:	4681                	li	a3,0
 78e:	4641                	li	a2,16
 790:	000ba583          	lw	a1,0(s7)
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	e84080e7          	jalr	-380(ra) # 61a <printint>
 79e:	8bca                	mv	s7,s2
 7a0:	4981                	li	s3,0
 7a2:	b7a5                	j	70a <vprintf+0x44>
 7a4:	008b8c13          	addi	s8,s7,8
 7a8:	000bb983          	ld	s3,0(s7)
 7ac:	03000593          	li	a1,48
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e46080e7          	jalr	-442(ra) # 5f8 <putc>
 7ba:	07800593          	li	a1,120
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	e38080e7          	jalr	-456(ra) # 5f8 <putc>
 7c8:	4941                	li	s2,16
 7ca:	00000b97          	auipc	s7,0x0
 7ce:	366b8b93          	addi	s7,s7,870 # b30 <digits>
 7d2:	03c9d793          	srli	a5,s3,0x3c
 7d6:	97de                	add	a5,a5,s7
 7d8:	0007c583          	lbu	a1,0(a5)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e1a080e7          	jalr	-486(ra) # 5f8 <putc>
 7e6:	0992                	slli	s3,s3,0x4
 7e8:	397d                	addiw	s2,s2,-1
 7ea:	fe0914e3          	bnez	s2,7d2 <vprintf+0x10c>
 7ee:	8be2                	mv	s7,s8
 7f0:	4981                	li	s3,0
 7f2:	bf21                	j	70a <vprintf+0x44>
 7f4:	008b8993          	addi	s3,s7,8
 7f8:	000bb903          	ld	s2,0(s7)
 7fc:	02090163          	beqz	s2,81e <vprintf+0x158>
 800:	00094583          	lbu	a1,0(s2)
 804:	c9a5                	beqz	a1,874 <vprintf+0x1ae>
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	df0080e7          	jalr	-528(ra) # 5f8 <putc>
 810:	0905                	addi	s2,s2,1
 812:	00094583          	lbu	a1,0(s2)
 816:	f9e5                	bnez	a1,806 <vprintf+0x140>
 818:	8bce                	mv	s7,s3
 81a:	4981                	li	s3,0
 81c:	b5fd                	j	70a <vprintf+0x44>
 81e:	00000917          	auipc	s2,0x0
 822:	2b290913          	addi	s2,s2,690 # ad0 <malloc+0x158>
 826:	02800593          	li	a1,40
 82a:	bff1                	j	806 <vprintf+0x140>
 82c:	008b8913          	addi	s2,s7,8
 830:	000bc583          	lbu	a1,0(s7)
 834:	8556                	mv	a0,s5
 836:	00000097          	auipc	ra,0x0
 83a:	dc2080e7          	jalr	-574(ra) # 5f8 <putc>
 83e:	8bca                	mv	s7,s2
 840:	4981                	li	s3,0
 842:	b5e1                	j	70a <vprintf+0x44>
 844:	02500593          	li	a1,37
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	dae080e7          	jalr	-594(ra) # 5f8 <putc>
 852:	4981                	li	s3,0
 854:	bd5d                	j	70a <vprintf+0x44>
 856:	02500593          	li	a1,37
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	d9c080e7          	jalr	-612(ra) # 5f8 <putc>
 864:	85ca                	mv	a1,s2
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	d90080e7          	jalr	-624(ra) # 5f8 <putc>
 870:	4981                	li	s3,0
 872:	bd61                	j	70a <vprintf+0x44>
 874:	8bce                	mv	s7,s3
 876:	4981                	li	s3,0
 878:	bd49                	j	70a <vprintf+0x44>
 87a:	60a6                	ld	ra,72(sp)
 87c:	6406                	ld	s0,64(sp)
 87e:	74e2                	ld	s1,56(sp)
 880:	7942                	ld	s2,48(sp)
 882:	79a2                	ld	s3,40(sp)
 884:	7a02                	ld	s4,32(sp)
 886:	6ae2                	ld	s5,24(sp)
 888:	6b42                	ld	s6,16(sp)
 88a:	6ba2                	ld	s7,8(sp)
 88c:	6c02                	ld	s8,0(sp)
 88e:	6161                	addi	sp,sp,80
 890:	8082                	ret

0000000000000892 <fprintf>:
 892:	715d                	addi	sp,sp,-80
 894:	ec06                	sd	ra,24(sp)
 896:	e822                	sd	s0,16(sp)
 898:	1000                	addi	s0,sp,32
 89a:	e010                	sd	a2,0(s0)
 89c:	e414                	sd	a3,8(s0)
 89e:	e818                	sd	a4,16(s0)
 8a0:	ec1c                	sd	a5,24(s0)
 8a2:	03043023          	sd	a6,32(s0)
 8a6:	03143423          	sd	a7,40(s0)
 8aa:	fe843423          	sd	s0,-24(s0)
 8ae:	8622                	mv	a2,s0
 8b0:	00000097          	auipc	ra,0x0
 8b4:	e16080e7          	jalr	-490(ra) # 6c6 <vprintf>
 8b8:	60e2                	ld	ra,24(sp)
 8ba:	6442                	ld	s0,16(sp)
 8bc:	6161                	addi	sp,sp,80
 8be:	8082                	ret

00000000000008c0 <printf>:
 8c0:	711d                	addi	sp,sp,-96
 8c2:	ec06                	sd	ra,24(sp)
 8c4:	e822                	sd	s0,16(sp)
 8c6:	1000                	addi	s0,sp,32
 8c8:	e40c                	sd	a1,8(s0)
 8ca:	e810                	sd	a2,16(s0)
 8cc:	ec14                	sd	a3,24(s0)
 8ce:	f018                	sd	a4,32(s0)
 8d0:	f41c                	sd	a5,40(s0)
 8d2:	03043823          	sd	a6,48(s0)
 8d6:	03143c23          	sd	a7,56(s0)
 8da:	00840613          	addi	a2,s0,8
 8de:	fec43423          	sd	a2,-24(s0)
 8e2:	85aa                	mv	a1,a0
 8e4:	4505                	li	a0,1
 8e6:	00000097          	auipc	ra,0x0
 8ea:	de0080e7          	jalr	-544(ra) # 6c6 <vprintf>
 8ee:	60e2                	ld	ra,24(sp)
 8f0:	6442                	ld	s0,16(sp)
 8f2:	6125                	addi	sp,sp,96
 8f4:	8082                	ret

00000000000008f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f6:	1141                	addi	sp,sp,-16
 8f8:	e422                	sd	s0,8(sp)
 8fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8fc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 900:	00000797          	auipc	a5,0x0
 904:	7007b783          	ld	a5,1792(a5) # 1000 <freep>
 908:	a02d                	j	932 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 90a:	4618                	lw	a4,8(a2)
 90c:	9f2d                	addw	a4,a4,a1
 90e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 912:	6398                	ld	a4,0(a5)
 914:	6310                	ld	a2,0(a4)
 916:	a83d                	j	954 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 918:	ff852703          	lw	a4,-8(a0)
 91c:	9f31                	addw	a4,a4,a2
 91e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 920:	ff053683          	ld	a3,-16(a0)
 924:	a091                	j	968 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 926:	6398                	ld	a4,0(a5)
 928:	00e7e463          	bltu	a5,a4,930 <free+0x3a>
 92c:	00e6ea63          	bltu	a3,a4,940 <free+0x4a>
{
 930:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 932:	fed7fae3          	bgeu	a5,a3,926 <free+0x30>
 936:	6398                	ld	a4,0(a5)
 938:	00e6e463          	bltu	a3,a4,940 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93c:	fee7eae3          	bltu	a5,a4,930 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 940:	ff852583          	lw	a1,-8(a0)
 944:	6390                	ld	a2,0(a5)
 946:	02059813          	slli	a6,a1,0x20
 94a:	01c85713          	srli	a4,a6,0x1c
 94e:	9736                	add	a4,a4,a3
 950:	fae60de3          	beq	a2,a4,90a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 954:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 958:	4790                	lw	a2,8(a5)
 95a:	02061593          	slli	a1,a2,0x20
 95e:	01c5d713          	srli	a4,a1,0x1c
 962:	973e                	add	a4,a4,a5
 964:	fae68ae3          	beq	a3,a4,918 <free+0x22>
    p->s.ptr = bp->s.ptr;
 968:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 96a:	00000717          	auipc	a4,0x0
 96e:	68f73b23          	sd	a5,1686(a4) # 1000 <freep>
}
 972:	6422                	ld	s0,8(sp)
 974:	0141                	addi	sp,sp,16
 976:	8082                	ret

0000000000000978 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 978:	7139                	addi	sp,sp,-64
 97a:	fc06                	sd	ra,56(sp)
 97c:	f822                	sd	s0,48(sp)
 97e:	f426                	sd	s1,40(sp)
 980:	f04a                	sd	s2,32(sp)
 982:	ec4e                	sd	s3,24(sp)
 984:	e852                	sd	s4,16(sp)
 986:	e456                	sd	s5,8(sp)
 988:	e05a                	sd	s6,0(sp)
 98a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 98c:	02051493          	slli	s1,a0,0x20
 990:	9081                	srli	s1,s1,0x20
 992:	04bd                	addi	s1,s1,15
 994:	8091                	srli	s1,s1,0x4
 996:	0014899b          	addiw	s3,s1,1
 99a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 99c:	00000517          	auipc	a0,0x0
 9a0:	66453503          	ld	a0,1636(a0) # 1000 <freep>
 9a4:	c515                	beqz	a0,9d0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a8:	4798                	lw	a4,8(a5)
 9aa:	02977f63          	bgeu	a4,s1,9e8 <malloc+0x70>
  if(nu < 4096)
 9ae:	8a4e                	mv	s4,s3
 9b0:	0009871b          	sext.w	a4,s3
 9b4:	6685                	lui	a3,0x1
 9b6:	00d77363          	bgeu	a4,a3,9bc <malloc+0x44>
 9ba:	6a05                	lui	s4,0x1
 9bc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c4:	00000917          	auipc	s2,0x0
 9c8:	63c90913          	addi	s2,s2,1596 # 1000 <freep>
  if(p == (char*)-1)
 9cc:	5afd                	li	s5,-1
 9ce:	a895                	j	a42 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9d0:	00000797          	auipc	a5,0x0
 9d4:	65078793          	addi	a5,a5,1616 # 1020 <base>
 9d8:	00000717          	auipc	a4,0x0
 9dc:	62f73423          	sd	a5,1576(a4) # 1000 <freep>
 9e0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9e2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9e6:	b7e1                	j	9ae <malloc+0x36>
      if(p->s.size == nunits)
 9e8:	02e48c63          	beq	s1,a4,a20 <malloc+0xa8>
        p->s.size -= nunits;
 9ec:	4137073b          	subw	a4,a4,s3
 9f0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9f2:	02071693          	slli	a3,a4,0x20
 9f6:	01c6d713          	srli	a4,a3,0x1c
 9fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a00:	00000717          	auipc	a4,0x0
 a04:	60a73023          	sd	a0,1536(a4) # 1000 <freep>
      return (void*)(p + 1);
 a08:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a0c:	70e2                	ld	ra,56(sp)
 a0e:	7442                	ld	s0,48(sp)
 a10:	74a2                	ld	s1,40(sp)
 a12:	7902                	ld	s2,32(sp)
 a14:	69e2                	ld	s3,24(sp)
 a16:	6a42                	ld	s4,16(sp)
 a18:	6aa2                	ld	s5,8(sp)
 a1a:	6b02                	ld	s6,0(sp)
 a1c:	6121                	addi	sp,sp,64
 a1e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a20:	6398                	ld	a4,0(a5)
 a22:	e118                	sd	a4,0(a0)
 a24:	bff1                	j	a00 <malloc+0x88>
  hp->s.size = nu;
 a26:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a2a:	0541                	addi	a0,a0,16
 a2c:	00000097          	auipc	ra,0x0
 a30:	eca080e7          	jalr	-310(ra) # 8f6 <free>
  return freep;
 a34:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a38:	d971                	beqz	a0,a0c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3c:	4798                	lw	a4,8(a5)
 a3e:	fa9775e3          	bgeu	a4,s1,9e8 <malloc+0x70>
    if(p == freep)
 a42:	00093703          	ld	a4,0(s2)
 a46:	853e                	mv	a0,a5
 a48:	fef719e3          	bne	a4,a5,a3a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a4c:	8552                	mv	a0,s4
 a4e:	00000097          	auipc	ra,0x0
 a52:	b92080e7          	jalr	-1134(ra) # 5e0 <sbrk>
  if(p == (char*)-1)
 a56:	fd5518e3          	bne	a0,s5,a26 <malloc+0xae>
        return 0;
 a5a:	4501                	li	a0,0
 a5c:	bf45                	j	a0c <malloc+0x94>

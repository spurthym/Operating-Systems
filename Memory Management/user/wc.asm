
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  26:	4901                	li	s2,0
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
  36:	4aa9                	li	s5,10
  38:	00001a17          	auipc	s4,0x1
  3c:	8e8a0a13          	addi	s4,s4,-1816 # 920 <malloc+0xf0>
  40:	4b81                	li	s7,0
  42:	a805                	j	72 <wc+0x72>
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1f2080e7          	jalr	498(ra) # 238 <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
  50:	895e                	mv	s2,s7
  52:	0485                	addi	s1,s1,1
  54:	00998d63          	beq	s3,s1,6e <wc+0x6e>
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
  60:	2c05                	addiw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
  68:	2c85                	addiw	s9,s9,1
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ab0d3b          	addw	s10,s6,s10
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3ac080e7          	jalr	940(ra) # 428 <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
  8a:	00001497          	auipc	s1,0x1
  8e:	f8648493          	addi	s1,s1,-122 # 1010 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	89250513          	addi	a0,a0,-1902 # 938 <malloc+0x108>
  ae:	00000097          	auipc	ra,0x0
  b2:	6ca080e7          	jalr	1738(ra) # 778 <printf>
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
  d4:	00001517          	auipc	a0,0x1
  d8:	85450513          	addi	a0,a0,-1964 # 928 <malloc+0xf8>
  dc:	00000097          	auipc	ra,0x0
  e0:	69c080e7          	jalr	1692(ra) # 778 <printf>
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	32a080e7          	jalr	810(ra) # 410 <exit>

00000000000000ee <main>:
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	ec26                	sd	s1,24(sp)
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
  fa:	1800                	addi	s0,sp,48
  fc:	4785                	li	a5,1
  fe:	04a7d963          	bge	a5,a0,150 <main+0x62>
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	334080e7          	jalr	820(ra) # 450 <open>
 124:	84aa                	mv	s1,a0
 126:	04054363          	bltz	a0,16c <main+0x7e>
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	300080e7          	jalr	768(ra) # 438 <close>
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2c8080e7          	jalr	712(ra) # 410 <exit>
 150:	00000597          	auipc	a1,0x0
 154:	7f858593          	addi	a1,a1,2040 # 948 <malloc+0x118>
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	ea6080e7          	jalr	-346(ra) # 0 <wc>
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	2ac080e7          	jalr	684(ra) # 410 <exit>
 16c:	00093583          	ld	a1,0(s2)
 170:	00000517          	auipc	a0,0x0
 174:	7e050513          	addi	a0,a0,2016 # 950 <malloc+0x120>
 178:	00000097          	auipc	ra,0x0
 17c:	600080e7          	jalr	1536(ra) # 778 <printf>
 180:	4505                	li	a0,1
 182:	00000097          	auipc	ra,0x0
 186:	28e080e7          	jalr	654(ra) # 410 <exit>

000000000000018a <_main>:
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
 192:	00000097          	auipc	ra,0x0
 196:	f5c080e7          	jalr	-164(ra) # ee <main>
 19a:	4501                	li	a0,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	274080e7          	jalr	628(ra) # 410 <exit>

00000000000001a4 <strcpy>:
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
 1aa:	87aa                	mv	a5,a0
 1ac:	0585                	addi	a1,a1,1
 1ae:	0785                	addi	a5,a5,1
 1b0:	fff5c703          	lbu	a4,-1(a1)
 1b4:	fee78fa3          	sb	a4,-1(a5)
 1b8:	fb75                	bnez	a4,1ac <strcpy+0x8>
 1ba:	6422                	ld	s0,8(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret

00000000000001c0 <strcmp>:
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e422                	sd	s0,8(sp)
 1c4:	0800                	addi	s0,sp,16
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cb91                	beqz	a5,1de <strcmp+0x1e>
 1cc:	0005c703          	lbu	a4,0(a1)
 1d0:	00f71763          	bne	a4,a5,1de <strcmp+0x1e>
 1d4:	0505                	addi	a0,a0,1
 1d6:	0585                	addi	a1,a1,1
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	fbe5                	bnez	a5,1cc <strcmp+0xc>
 1de:	0005c503          	lbu	a0,0(a1)
 1e2:	40a7853b          	subw	a0,a5,a0
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strlen>:
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cf91                	beqz	a5,212 <strlen+0x26>
 1f8:	0505                	addi	a0,a0,1
 1fa:	87aa                	mv	a5,a0
 1fc:	86be                	mv	a3,a5
 1fe:	0785                	addi	a5,a5,1
 200:	fff7c703          	lbu	a4,-1(a5)
 204:	ff65                	bnez	a4,1fc <strlen+0x10>
 206:	40a6853b          	subw	a0,a3,a0
 20a:	2505                	addiw	a0,a0,1
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
 212:	4501                	li	a0,0
 214:	bfe5                	j	20c <strlen+0x20>

0000000000000216 <memset>:
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
 21c:	ca19                	beqz	a2,232 <memset+0x1c>
 21e:	87aa                	mv	a5,a0
 220:	1602                	slli	a2,a2,0x20
 222:	9201                	srli	a2,a2,0x20
 224:	00a60733          	add	a4,a2,a0
 228:	00b78023          	sb	a1,0(a5)
 22c:	0785                	addi	a5,a5,1
 22e:	fee79de3          	bne	a5,a4,228 <memset+0x12>
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret

0000000000000238 <strchr>:
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
 23e:	00054783          	lbu	a5,0(a0)
 242:	cb99                	beqz	a5,258 <strchr+0x20>
 244:	00f58763          	beq	a1,a5,252 <strchr+0x1a>
 248:	0505                	addi	a0,a0,1
 24a:	00054783          	lbu	a5,0(a0)
 24e:	fbfd                	bnez	a5,244 <strchr+0xc>
 250:	4501                	li	a0,0
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <strchr+0x1a>

000000000000025c <gets>:
 25c:	711d                	addi	sp,sp,-96
 25e:	ec86                	sd	ra,88(sp)
 260:	e8a2                	sd	s0,80(sp)
 262:	e4a6                	sd	s1,72(sp)
 264:	e0ca                	sd	s2,64(sp)
 266:	fc4e                	sd	s3,56(sp)
 268:	f852                	sd	s4,48(sp)
 26a:	f456                	sd	s5,40(sp)
 26c:	f05a                	sd	s6,32(sp)
 26e:	ec5e                	sd	s7,24(sp)
 270:	1080                	addi	s0,sp,96
 272:	8baa                	mv	s7,a0
 274:	8a2e                	mv	s4,a1
 276:	892a                	mv	s2,a0
 278:	4481                	li	s1,0
 27a:	4aa9                	li	s5,10
 27c:	4b35                	li	s6,13
 27e:	89a6                	mv	s3,s1
 280:	2485                	addiw	s1,s1,1
 282:	0344d863          	bge	s1,s4,2b2 <gets+0x56>
 286:	4605                	li	a2,1
 288:	faf40593          	addi	a1,s0,-81
 28c:	4501                	li	a0,0
 28e:	00000097          	auipc	ra,0x0
 292:	19a080e7          	jalr	410(ra) # 428 <read>
 296:	00a05e63          	blez	a0,2b2 <gets+0x56>
 29a:	faf44783          	lbu	a5,-81(s0)
 29e:	00f90023          	sb	a5,0(s2)
 2a2:	01578763          	beq	a5,s5,2b0 <gets+0x54>
 2a6:	0905                	addi	s2,s2,1
 2a8:	fd679be3          	bne	a5,s6,27e <gets+0x22>
 2ac:	89a6                	mv	s3,s1
 2ae:	a011                	j	2b2 <gets+0x56>
 2b0:	89a6                	mv	s3,s1
 2b2:	99de                	add	s3,s3,s7
 2b4:	00098023          	sb	zero,0(s3)
 2b8:	855e                	mv	a0,s7
 2ba:	60e6                	ld	ra,88(sp)
 2bc:	6446                	ld	s0,80(sp)
 2be:	64a6                	ld	s1,72(sp)
 2c0:	6906                	ld	s2,64(sp)
 2c2:	79e2                	ld	s3,56(sp)
 2c4:	7a42                	ld	s4,48(sp)
 2c6:	7aa2                	ld	s5,40(sp)
 2c8:	7b02                	ld	s6,32(sp)
 2ca:	6be2                	ld	s7,24(sp)
 2cc:	6125                	addi	sp,sp,96
 2ce:	8082                	ret

00000000000002d0 <stat>:
 2d0:	1101                	addi	sp,sp,-32
 2d2:	ec06                	sd	ra,24(sp)
 2d4:	e822                	sd	s0,16(sp)
 2d6:	e426                	sd	s1,8(sp)
 2d8:	e04a                	sd	s2,0(sp)
 2da:	1000                	addi	s0,sp,32
 2dc:	892e                	mv	s2,a1
 2de:	4581                	li	a1,0
 2e0:	00000097          	auipc	ra,0x0
 2e4:	170080e7          	jalr	368(ra) # 450 <open>
 2e8:	02054563          	bltz	a0,312 <stat+0x42>
 2ec:	84aa                	mv	s1,a0
 2ee:	85ca                	mv	a1,s2
 2f0:	00000097          	auipc	ra,0x0
 2f4:	178080e7          	jalr	376(ra) # 468 <fstat>
 2f8:	892a                	mv	s2,a0
 2fa:	8526                	mv	a0,s1
 2fc:	00000097          	auipc	ra,0x0
 300:	13c080e7          	jalr	316(ra) # 438 <close>
 304:	854a                	mv	a0,s2
 306:	60e2                	ld	ra,24(sp)
 308:	6442                	ld	s0,16(sp)
 30a:	64a2                	ld	s1,8(sp)
 30c:	6902                	ld	s2,0(sp)
 30e:	6105                	addi	sp,sp,32
 310:	8082                	ret
 312:	597d                	li	s2,-1
 314:	bfc5                	j	304 <stat+0x34>

0000000000000316 <atoi>:
 316:	1141                	addi	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	addi	s0,sp,16
 31c:	00054683          	lbu	a3,0(a0)
 320:	fd06879b          	addiw	a5,a3,-48
 324:	0ff7f793          	zext.b	a5,a5
 328:	4625                	li	a2,9
 32a:	02f66863          	bltu	a2,a5,35a <atoi+0x44>
 32e:	872a                	mv	a4,a0
 330:	4501                	li	a0,0
 332:	0705                	addi	a4,a4,1
 334:	0025179b          	slliw	a5,a0,0x2
 338:	9fa9                	addw	a5,a5,a0
 33a:	0017979b          	slliw	a5,a5,0x1
 33e:	9fb5                	addw	a5,a5,a3
 340:	fd07851b          	addiw	a0,a5,-48
 344:	00074683          	lbu	a3,0(a4)
 348:	fd06879b          	addiw	a5,a3,-48
 34c:	0ff7f793          	zext.b	a5,a5
 350:	fef671e3          	bgeu	a2,a5,332 <atoi+0x1c>
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <atoi+0x3e>

000000000000035e <memmove>:
 35e:	1141                	addi	sp,sp,-16
 360:	e422                	sd	s0,8(sp)
 362:	0800                	addi	s0,sp,16
 364:	02b57463          	bgeu	a0,a1,38c <memmove+0x2e>
 368:	00c05f63          	blez	a2,386 <memmove+0x28>
 36c:	1602                	slli	a2,a2,0x20
 36e:	9201                	srli	a2,a2,0x20
 370:	00c507b3          	add	a5,a0,a2
 374:	872a                	mv	a4,a0
 376:	0585                	addi	a1,a1,1
 378:	0705                	addi	a4,a4,1
 37a:	fff5c683          	lbu	a3,-1(a1)
 37e:	fed70fa3          	sb	a3,-1(a4)
 382:	fee79ae3          	bne	a5,a4,376 <memmove+0x18>
 386:	6422                	ld	s0,8(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
 38c:	00c50733          	add	a4,a0,a2
 390:	95b2                	add	a1,a1,a2
 392:	fec05ae3          	blez	a2,386 <memmove+0x28>
 396:	fff6079b          	addiw	a5,a2,-1
 39a:	1782                	slli	a5,a5,0x20
 39c:	9381                	srli	a5,a5,0x20
 39e:	fff7c793          	not	a5,a5
 3a2:	97ba                	add	a5,a5,a4
 3a4:	15fd                	addi	a1,a1,-1
 3a6:	177d                	addi	a4,a4,-1
 3a8:	0005c683          	lbu	a3,0(a1)
 3ac:	00d70023          	sb	a3,0(a4)
 3b0:	fee79ae3          	bne	a5,a4,3a4 <memmove+0x46>
 3b4:	bfc9                	j	386 <memmove+0x28>

00000000000003b6 <memcmp>:
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e422                	sd	s0,8(sp)
 3ba:	0800                	addi	s0,sp,16
 3bc:	ca05                	beqz	a2,3ec <memcmp+0x36>
 3be:	fff6069b          	addiw	a3,a2,-1
 3c2:	1682                	slli	a3,a3,0x20
 3c4:	9281                	srli	a3,a3,0x20
 3c6:	0685                	addi	a3,a3,1
 3c8:	96aa                	add	a3,a3,a0
 3ca:	00054783          	lbu	a5,0(a0)
 3ce:	0005c703          	lbu	a4,0(a1)
 3d2:	00e79863          	bne	a5,a4,3e2 <memcmp+0x2c>
 3d6:	0505                	addi	a0,a0,1
 3d8:	0585                	addi	a1,a1,1
 3da:	fed518e3          	bne	a0,a3,3ca <memcmp+0x14>
 3de:	4501                	li	a0,0
 3e0:	a019                	j	3e6 <memcmp+0x30>
 3e2:	40e7853b          	subw	a0,a5,a4
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
 3ec:	4501                	li	a0,0
 3ee:	bfe5                	j	3e6 <memcmp+0x30>

00000000000003f0 <memcpy>:
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e406                	sd	ra,8(sp)
 3f4:	e022                	sd	s0,0(sp)
 3f6:	0800                	addi	s0,sp,16
 3f8:	00000097          	auipc	ra,0x0
 3fc:	f66080e7          	jalr	-154(ra) # 35e <memmove>
 400:	60a2                	ld	ra,8(sp)
 402:	6402                	ld	s0,0(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret

0000000000000408 <fork>:
 408:	4885                	li	a7,1
 40a:	00000073          	ecall
 40e:	8082                	ret

0000000000000410 <exit>:
 410:	4889                	li	a7,2
 412:	00000073          	ecall
 416:	8082                	ret

0000000000000418 <wait>:
 418:	488d                	li	a7,3
 41a:	00000073          	ecall
 41e:	8082                	ret

0000000000000420 <pipe>:
 420:	4891                	li	a7,4
 422:	00000073          	ecall
 426:	8082                	ret

0000000000000428 <read>:
 428:	4895                	li	a7,5
 42a:	00000073          	ecall
 42e:	8082                	ret

0000000000000430 <write>:
 430:	48c1                	li	a7,16
 432:	00000073          	ecall
 436:	8082                	ret

0000000000000438 <close>:
 438:	48d5                	li	a7,21
 43a:	00000073          	ecall
 43e:	8082                	ret

0000000000000440 <kill>:
 440:	4899                	li	a7,6
 442:	00000073          	ecall
 446:	8082                	ret

0000000000000448 <exec>:
 448:	489d                	li	a7,7
 44a:	00000073          	ecall
 44e:	8082                	ret

0000000000000450 <open>:
 450:	48bd                	li	a7,15
 452:	00000073          	ecall
 456:	8082                	ret

0000000000000458 <mknod>:
 458:	48c5                	li	a7,17
 45a:	00000073          	ecall
 45e:	8082                	ret

0000000000000460 <unlink>:
 460:	48c9                	li	a7,18
 462:	00000073          	ecall
 466:	8082                	ret

0000000000000468 <fstat>:
 468:	48a1                	li	a7,8
 46a:	00000073          	ecall
 46e:	8082                	ret

0000000000000470 <link>:
 470:	48cd                	li	a7,19
 472:	00000073          	ecall
 476:	8082                	ret

0000000000000478 <mkdir>:
 478:	48d1                	li	a7,20
 47a:	00000073          	ecall
 47e:	8082                	ret

0000000000000480 <chdir>:
 480:	48a5                	li	a7,9
 482:	00000073          	ecall
 486:	8082                	ret

0000000000000488 <dup>:
 488:	48a9                	li	a7,10
 48a:	00000073          	ecall
 48e:	8082                	ret

0000000000000490 <getpid>:
 490:	48ad                	li	a7,11
 492:	00000073          	ecall
 496:	8082                	ret

0000000000000498 <sbrk>:
 498:	48b1                	li	a7,12
 49a:	00000073          	ecall
 49e:	8082                	ret

00000000000004a0 <sleep>:
 4a0:	48b5                	li	a7,13
 4a2:	00000073          	ecall
 4a6:	8082                	ret

00000000000004a8 <uptime>:
 4a8:	48b9                	li	a7,14
 4aa:	00000073          	ecall
 4ae:	8082                	ret

00000000000004b0 <putc>:
 4b0:	1101                	addi	sp,sp,-32
 4b2:	ec06                	sd	ra,24(sp)
 4b4:	e822                	sd	s0,16(sp)
 4b6:	1000                	addi	s0,sp,32
 4b8:	feb407a3          	sb	a1,-17(s0)
 4bc:	4605                	li	a2,1
 4be:	fef40593          	addi	a1,s0,-17
 4c2:	00000097          	auipc	ra,0x0
 4c6:	f6e080e7          	jalr	-146(ra) # 430 <write>
 4ca:	60e2                	ld	ra,24(sp)
 4cc:	6442                	ld	s0,16(sp)
 4ce:	6105                	addi	sp,sp,32
 4d0:	8082                	ret

00000000000004d2 <printint>:
 4d2:	7139                	addi	sp,sp,-64
 4d4:	fc06                	sd	ra,56(sp)
 4d6:	f822                	sd	s0,48(sp)
 4d8:	f426                	sd	s1,40(sp)
 4da:	f04a                	sd	s2,32(sp)
 4dc:	ec4e                	sd	s3,24(sp)
 4de:	0080                	addi	s0,sp,64
 4e0:	84aa                	mv	s1,a0
 4e2:	c299                	beqz	a3,4e8 <printint+0x16>
 4e4:	0805c963          	bltz	a1,576 <printint+0xa4>
 4e8:	2581                	sext.w	a1,a1
 4ea:	4881                	li	a7,0
 4ec:	fc040693          	addi	a3,s0,-64
 4f0:	4701                	li	a4,0
 4f2:	2601                	sext.w	a2,a2
 4f4:	00000517          	auipc	a0,0x0
 4f8:	4d450513          	addi	a0,a0,1236 # 9c8 <digits>
 4fc:	883a                	mv	a6,a4
 4fe:	2705                	addiw	a4,a4,1
 500:	02c5f7bb          	remuw	a5,a1,a2
 504:	1782                	slli	a5,a5,0x20
 506:	9381                	srli	a5,a5,0x20
 508:	97aa                	add	a5,a5,a0
 50a:	0007c783          	lbu	a5,0(a5)
 50e:	00f68023          	sb	a5,0(a3)
 512:	0005879b          	sext.w	a5,a1
 516:	02c5d5bb          	divuw	a1,a1,a2
 51a:	0685                	addi	a3,a3,1
 51c:	fec7f0e3          	bgeu	a5,a2,4fc <printint+0x2a>
 520:	00088c63          	beqz	a7,538 <printint+0x66>
 524:	fd070793          	addi	a5,a4,-48
 528:	00878733          	add	a4,a5,s0
 52c:	02d00793          	li	a5,45
 530:	fef70823          	sb	a5,-16(a4)
 534:	0028071b          	addiw	a4,a6,2
 538:	02e05863          	blez	a4,568 <printint+0x96>
 53c:	fc040793          	addi	a5,s0,-64
 540:	00e78933          	add	s2,a5,a4
 544:	fff78993          	addi	s3,a5,-1
 548:	99ba                	add	s3,s3,a4
 54a:	377d                	addiw	a4,a4,-1
 54c:	1702                	slli	a4,a4,0x20
 54e:	9301                	srli	a4,a4,0x20
 550:	40e989b3          	sub	s3,s3,a4
 554:	fff94583          	lbu	a1,-1(s2)
 558:	8526                	mv	a0,s1
 55a:	00000097          	auipc	ra,0x0
 55e:	f56080e7          	jalr	-170(ra) # 4b0 <putc>
 562:	197d                	addi	s2,s2,-1
 564:	ff3918e3          	bne	s2,s3,554 <printint+0x82>
 568:	70e2                	ld	ra,56(sp)
 56a:	7442                	ld	s0,48(sp)
 56c:	74a2                	ld	s1,40(sp)
 56e:	7902                	ld	s2,32(sp)
 570:	69e2                	ld	s3,24(sp)
 572:	6121                	addi	sp,sp,64
 574:	8082                	ret
 576:	40b005bb          	negw	a1,a1
 57a:	4885                	li	a7,1
 57c:	bf85                	j	4ec <printint+0x1a>

000000000000057e <vprintf>:
 57e:	715d                	addi	sp,sp,-80
 580:	e486                	sd	ra,72(sp)
 582:	e0a2                	sd	s0,64(sp)
 584:	fc26                	sd	s1,56(sp)
 586:	f84a                	sd	s2,48(sp)
 588:	f44e                	sd	s3,40(sp)
 58a:	f052                	sd	s4,32(sp)
 58c:	ec56                	sd	s5,24(sp)
 58e:	e85a                	sd	s6,16(sp)
 590:	e45e                	sd	s7,8(sp)
 592:	e062                	sd	s8,0(sp)
 594:	0880                	addi	s0,sp,80
 596:	0005c903          	lbu	s2,0(a1)
 59a:	18090c63          	beqz	s2,732 <vprintf+0x1b4>
 59e:	8aaa                	mv	s5,a0
 5a0:	8bb2                	mv	s7,a2
 5a2:	00158493          	addi	s1,a1,1
 5a6:	4981                	li	s3,0
 5a8:	02500a13          	li	s4,37
 5ac:	4b55                	li	s6,21
 5ae:	a839                	j	5cc <vprintf+0x4e>
 5b0:	85ca                	mv	a1,s2
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	efc080e7          	jalr	-260(ra) # 4b0 <putc>
 5bc:	a019                	j	5c2 <vprintf+0x44>
 5be:	01498d63          	beq	s3,s4,5d8 <vprintf+0x5a>
 5c2:	0485                	addi	s1,s1,1
 5c4:	fff4c903          	lbu	s2,-1(s1)
 5c8:	16090563          	beqz	s2,732 <vprintf+0x1b4>
 5cc:	fe0999e3          	bnez	s3,5be <vprintf+0x40>
 5d0:	ff4910e3          	bne	s2,s4,5b0 <vprintf+0x32>
 5d4:	89d2                	mv	s3,s4
 5d6:	b7f5                	j	5c2 <vprintf+0x44>
 5d8:	13490263          	beq	s2,s4,6fc <vprintf+0x17e>
 5dc:	f9d9079b          	addiw	a5,s2,-99
 5e0:	0ff7f793          	zext.b	a5,a5
 5e4:	12fb6563          	bltu	s6,a5,70e <vprintf+0x190>
 5e8:	f9d9079b          	addiw	a5,s2,-99
 5ec:	0ff7f713          	zext.b	a4,a5
 5f0:	10eb6f63          	bltu	s6,a4,70e <vprintf+0x190>
 5f4:	00271793          	slli	a5,a4,0x2
 5f8:	00000717          	auipc	a4,0x0
 5fc:	37870713          	addi	a4,a4,888 # 970 <malloc+0x140>
 600:	97ba                	add	a5,a5,a4
 602:	439c                	lw	a5,0(a5)
 604:	97ba                	add	a5,a5,a4
 606:	8782                	jr	a5
 608:	008b8913          	addi	s2,s7,8
 60c:	4685                	li	a3,1
 60e:	4629                	li	a2,10
 610:	000ba583          	lw	a1,0(s7)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	ebc080e7          	jalr	-324(ra) # 4d2 <printint>
 61e:	8bca                	mv	s7,s2
 620:	4981                	li	s3,0
 622:	b745                	j	5c2 <vprintf+0x44>
 624:	008b8913          	addi	s2,s7,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000ba583          	lw	a1,0(s7)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	ea0080e7          	jalr	-352(ra) # 4d2 <printint>
 63a:	8bca                	mv	s7,s2
 63c:	4981                	li	s3,0
 63e:	b751                	j	5c2 <vprintf+0x44>
 640:	008b8913          	addi	s2,s7,8
 644:	4681                	li	a3,0
 646:	4641                	li	a2,16
 648:	000ba583          	lw	a1,0(s7)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e84080e7          	jalr	-380(ra) # 4d2 <printint>
 656:	8bca                	mv	s7,s2
 658:	4981                	li	s3,0
 65a:	b7a5                	j	5c2 <vprintf+0x44>
 65c:	008b8c13          	addi	s8,s7,8
 660:	000bb983          	ld	s3,0(s7)
 664:	03000593          	li	a1,48
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e46080e7          	jalr	-442(ra) # 4b0 <putc>
 672:	07800593          	li	a1,120
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e38080e7          	jalr	-456(ra) # 4b0 <putc>
 680:	4941                	li	s2,16
 682:	00000b97          	auipc	s7,0x0
 686:	346b8b93          	addi	s7,s7,838 # 9c8 <digits>
 68a:	03c9d793          	srli	a5,s3,0x3c
 68e:	97de                	add	a5,a5,s7
 690:	0007c583          	lbu	a1,0(a5)
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	e1a080e7          	jalr	-486(ra) # 4b0 <putc>
 69e:	0992                	slli	s3,s3,0x4
 6a0:	397d                	addiw	s2,s2,-1
 6a2:	fe0914e3          	bnez	s2,68a <vprintf+0x10c>
 6a6:	8be2                	mv	s7,s8
 6a8:	4981                	li	s3,0
 6aa:	bf21                	j	5c2 <vprintf+0x44>
 6ac:	008b8993          	addi	s3,s7,8
 6b0:	000bb903          	ld	s2,0(s7)
 6b4:	02090163          	beqz	s2,6d6 <vprintf+0x158>
 6b8:	00094583          	lbu	a1,0(s2)
 6bc:	c9a5                	beqz	a1,72c <vprintf+0x1ae>
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	df0080e7          	jalr	-528(ra) # 4b0 <putc>
 6c8:	0905                	addi	s2,s2,1
 6ca:	00094583          	lbu	a1,0(s2)
 6ce:	f9e5                	bnez	a1,6be <vprintf+0x140>
 6d0:	8bce                	mv	s7,s3
 6d2:	4981                	li	s3,0
 6d4:	b5fd                	j	5c2 <vprintf+0x44>
 6d6:	00000917          	auipc	s2,0x0
 6da:	29290913          	addi	s2,s2,658 # 968 <malloc+0x138>
 6de:	02800593          	li	a1,40
 6e2:	bff1                	j	6be <vprintf+0x140>
 6e4:	008b8913          	addi	s2,s7,8
 6e8:	000bc583          	lbu	a1,0(s7)
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	dc2080e7          	jalr	-574(ra) # 4b0 <putc>
 6f6:	8bca                	mv	s7,s2
 6f8:	4981                	li	s3,0
 6fa:	b5e1                	j	5c2 <vprintf+0x44>
 6fc:	02500593          	li	a1,37
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	dae080e7          	jalr	-594(ra) # 4b0 <putc>
 70a:	4981                	li	s3,0
 70c:	bd5d                	j	5c2 <vprintf+0x44>
 70e:	02500593          	li	a1,37
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	d9c080e7          	jalr	-612(ra) # 4b0 <putc>
 71c:	85ca                	mv	a1,s2
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	d90080e7          	jalr	-624(ra) # 4b0 <putc>
 728:	4981                	li	s3,0
 72a:	bd61                	j	5c2 <vprintf+0x44>
 72c:	8bce                	mv	s7,s3
 72e:	4981                	li	s3,0
 730:	bd49                	j	5c2 <vprintf+0x44>
 732:	60a6                	ld	ra,72(sp)
 734:	6406                	ld	s0,64(sp)
 736:	74e2                	ld	s1,56(sp)
 738:	7942                	ld	s2,48(sp)
 73a:	79a2                	ld	s3,40(sp)
 73c:	7a02                	ld	s4,32(sp)
 73e:	6ae2                	ld	s5,24(sp)
 740:	6b42                	ld	s6,16(sp)
 742:	6ba2                	ld	s7,8(sp)
 744:	6c02                	ld	s8,0(sp)
 746:	6161                	addi	sp,sp,80
 748:	8082                	ret

000000000000074a <fprintf>:
 74a:	715d                	addi	sp,sp,-80
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	e010                	sd	a2,0(s0)
 754:	e414                	sd	a3,8(s0)
 756:	e818                	sd	a4,16(s0)
 758:	ec1c                	sd	a5,24(s0)
 75a:	03043023          	sd	a6,32(s0)
 75e:	03143423          	sd	a7,40(s0)
 762:	fe843423          	sd	s0,-24(s0)
 766:	8622                	mv	a2,s0
 768:	00000097          	auipc	ra,0x0
 76c:	e16080e7          	jalr	-490(ra) # 57e <vprintf>
 770:	60e2                	ld	ra,24(sp)
 772:	6442                	ld	s0,16(sp)
 774:	6161                	addi	sp,sp,80
 776:	8082                	ret

0000000000000778 <printf>:
 778:	711d                	addi	sp,sp,-96
 77a:	ec06                	sd	ra,24(sp)
 77c:	e822                	sd	s0,16(sp)
 77e:	1000                	addi	s0,sp,32
 780:	e40c                	sd	a1,8(s0)
 782:	e810                	sd	a2,16(s0)
 784:	ec14                	sd	a3,24(s0)
 786:	f018                	sd	a4,32(s0)
 788:	f41c                	sd	a5,40(s0)
 78a:	03043823          	sd	a6,48(s0)
 78e:	03143c23          	sd	a7,56(s0)
 792:	00840613          	addi	a2,s0,8
 796:	fec43423          	sd	a2,-24(s0)
 79a:	85aa                	mv	a1,a0
 79c:	4505                	li	a0,1
 79e:	00000097          	auipc	ra,0x0
 7a2:	de0080e7          	jalr	-544(ra) # 57e <vprintf>
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6442                	ld	s0,16(sp)
 7aa:	6125                	addi	sp,sp,96
 7ac:	8082                	ret

00000000000007ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ae:	1141                	addi	sp,sp,-16
 7b0:	e422                	sd	s0,8(sp)
 7b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	00001797          	auipc	a5,0x1
 7bc:	8487b783          	ld	a5,-1976(a5) # 1000 <freep>
 7c0:	a02d                	j	7ea <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c2:	4618                	lw	a4,8(a2)
 7c4:	9f2d                	addw	a4,a4,a1
 7c6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ca:	6398                	ld	a4,0(a5)
 7cc:	6310                	ld	a2,0(a4)
 7ce:	a83d                	j	80c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d0:	ff852703          	lw	a4,-8(a0)
 7d4:	9f31                	addw	a4,a4,a2
 7d6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d8:	ff053683          	ld	a3,-16(a0)
 7dc:	a091                	j	820 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7de:	6398                	ld	a4,0(a5)
 7e0:	00e7e463          	bltu	a5,a4,7e8 <free+0x3a>
 7e4:	00e6ea63          	bltu	a3,a4,7f8 <free+0x4a>
{
 7e8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	fed7fae3          	bgeu	a5,a3,7de <free+0x30>
 7ee:	6398                	ld	a4,0(a5)
 7f0:	00e6e463          	bltu	a3,a4,7f8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f4:	fee7eae3          	bltu	a5,a4,7e8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7f8:	ff852583          	lw	a1,-8(a0)
 7fc:	6390                	ld	a2,0(a5)
 7fe:	02059813          	slli	a6,a1,0x20
 802:	01c85713          	srli	a4,a6,0x1c
 806:	9736                	add	a4,a4,a3
 808:	fae60de3          	beq	a2,a4,7c2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 810:	4790                	lw	a2,8(a5)
 812:	02061593          	slli	a1,a2,0x20
 816:	01c5d713          	srli	a4,a1,0x1c
 81a:	973e                	add	a4,a4,a5
 81c:	fae68ae3          	beq	a3,a4,7d0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 820:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 822:	00000717          	auipc	a4,0x0
 826:	7cf73f23          	sd	a5,2014(a4) # 1000 <freep>
}
 82a:	6422                	ld	s0,8(sp)
 82c:	0141                	addi	sp,sp,16
 82e:	8082                	ret

0000000000000830 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 830:	7139                	addi	sp,sp,-64
 832:	fc06                	sd	ra,56(sp)
 834:	f822                	sd	s0,48(sp)
 836:	f426                	sd	s1,40(sp)
 838:	f04a                	sd	s2,32(sp)
 83a:	ec4e                	sd	s3,24(sp)
 83c:	e852                	sd	s4,16(sp)
 83e:	e456                	sd	s5,8(sp)
 840:	e05a                	sd	s6,0(sp)
 842:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 844:	02051493          	slli	s1,a0,0x20
 848:	9081                	srli	s1,s1,0x20
 84a:	04bd                	addi	s1,s1,15
 84c:	8091                	srli	s1,s1,0x4
 84e:	0014899b          	addiw	s3,s1,1
 852:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 854:	00000517          	auipc	a0,0x0
 858:	7ac53503          	ld	a0,1964(a0) # 1000 <freep>
 85c:	c515                	beqz	a0,888 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 860:	4798                	lw	a4,8(a5)
 862:	02977f63          	bgeu	a4,s1,8a0 <malloc+0x70>
  if(nu < 4096)
 866:	8a4e                	mv	s4,s3
 868:	0009871b          	sext.w	a4,s3
 86c:	6685                	lui	a3,0x1
 86e:	00d77363          	bgeu	a4,a3,874 <malloc+0x44>
 872:	6a05                	lui	s4,0x1
 874:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 878:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87c:	00000917          	auipc	s2,0x0
 880:	78490913          	addi	s2,s2,1924 # 1000 <freep>
  if(p == (char*)-1)
 884:	5afd                	li	s5,-1
 886:	a895                	j	8fa <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 888:	00001797          	auipc	a5,0x1
 88c:	98878793          	addi	a5,a5,-1656 # 1210 <base>
 890:	00000717          	auipc	a4,0x0
 894:	76f73823          	sd	a5,1904(a4) # 1000 <freep>
 898:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 89e:	b7e1                	j	866 <malloc+0x36>
      if(p->s.size == nunits)
 8a0:	02e48c63          	beq	s1,a4,8d8 <malloc+0xa8>
        p->s.size -= nunits;
 8a4:	4137073b          	subw	a4,a4,s3
 8a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8aa:	02071693          	slli	a3,a4,0x20
 8ae:	01c6d713          	srli	a4,a3,0x1c
 8b2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b8:	00000717          	auipc	a4,0x0
 8bc:	74a73423          	sd	a0,1864(a4) # 1000 <freep>
      return (void*)(p + 1);
 8c0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c4:	70e2                	ld	ra,56(sp)
 8c6:	7442                	ld	s0,48(sp)
 8c8:	74a2                	ld	s1,40(sp)
 8ca:	7902                	ld	s2,32(sp)
 8cc:	69e2                	ld	s3,24(sp)
 8ce:	6a42                	ld	s4,16(sp)
 8d0:	6aa2                	ld	s5,8(sp)
 8d2:	6b02                	ld	s6,0(sp)
 8d4:	6121                	addi	sp,sp,64
 8d6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8d8:	6398                	ld	a4,0(a5)
 8da:	e118                	sd	a4,0(a0)
 8dc:	bff1                	j	8b8 <malloc+0x88>
  hp->s.size = nu;
 8de:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e2:	0541                	addi	a0,a0,16
 8e4:	00000097          	auipc	ra,0x0
 8e8:	eca080e7          	jalr	-310(ra) # 7ae <free>
  return freep;
 8ec:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f0:	d971                	beqz	a0,8c4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f4:	4798                	lw	a4,8(a5)
 8f6:	fa9775e3          	bgeu	a4,s1,8a0 <malloc+0x70>
    if(p == freep)
 8fa:	00093703          	ld	a4,0(s2)
 8fe:	853e                	mv	a0,a5
 900:	fef719e3          	bne	a4,a5,8f2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 904:	8552                	mv	a0,s4
 906:	00000097          	auipc	ra,0x0
 90a:	b92080e7          	jalr	-1134(ra) # 498 <sbrk>
  if(p == (char*)-1)
 90e:	fd5518e3          	bne	a0,s5,8de <malloc+0xae>
        return 0;
 912:	4501                	li	a0,0
 914:	bf45                	j	8c4 <malloc+0x94>

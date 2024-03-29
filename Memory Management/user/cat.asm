
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	39a080e7          	jalr	922(ra) # 3ba <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	38e080e7          	jalr	910(ra) # 3c2 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	87058593          	addi	a1,a1,-1936 # 8b0 <malloc+0xee>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	692080e7          	jalr	1682(ra) # 6dc <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	34e080e7          	jalr	846(ra) # 3a2 <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	85a58593          	addi	a1,a1,-1958 # 8c8 <malloc+0x106>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	664080e7          	jalr	1636(ra) # 6dc <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	320080e7          	jalr	800(ra) # 3a2 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  98:	4785                	li	a5,1
  9a:	04a7d763          	bge	a5,a0,e8 <main+0x5e>
  9e:	00858913          	addi	s2,a1,8
  a2:	ffe5099b          	addiw	s3,a0,-2
  a6:	02099793          	slli	a5,s3,0x20
  aa:	01d7d993          	srli	s3,a5,0x1d
  ae:	05c1                	addi	a1,a1,16
  b0:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b2:	4581                	li	a1,0
  b4:	00093503          	ld	a0,0(s2) # 1010 <buf>
  b8:	00000097          	auipc	ra,0x0
  bc:	32a080e7          	jalr	810(ra) # 3e2 <open>
  c0:	84aa                	mv	s1,a0
  c2:	02054d63          	bltz	a0,fc <main+0x72>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	2fa080e7          	jalr	762(ra) # 3ca <close>
  for(i = 1; i < argc; i++){
  d8:	0921                	addi	s2,s2,8
  da:	fd391ce3          	bne	s2,s3,b2 <main+0x28>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2c2080e7          	jalr	706(ra) # 3a2 <exit>
    cat(0);
  e8:	4501                	li	a0,0
  ea:	00000097          	auipc	ra,0x0
  ee:	f16080e7          	jalr	-234(ra) # 0 <cat>
    exit(0);
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	2ae080e7          	jalr	686(ra) # 3a2 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fc:	00093603          	ld	a2,0(s2)
 100:	00000597          	auipc	a1,0x0
 104:	7e058593          	addi	a1,a1,2016 # 8e0 <malloc+0x11e>
 108:	4509                	li	a0,2
 10a:	00000097          	auipc	ra,0x0
 10e:	5d2080e7          	jalr	1490(ra) # 6dc <fprintf>
      exit(1);
 112:	4505                	li	a0,1
 114:	00000097          	auipc	ra,0x0
 118:	28e080e7          	jalr	654(ra) # 3a2 <exit>

000000000000011c <_main>:
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
 124:	00000097          	auipc	ra,0x0
 128:	f66080e7          	jalr	-154(ra) # 8a <main>
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	274080e7          	jalr	628(ra) # 3a2 <exit>

0000000000000136 <strcpy>:
 136:	1141                	addi	sp,sp,-16
 138:	e422                	sd	s0,8(sp)
 13a:	0800                	addi	s0,sp,16
 13c:	87aa                	mv	a5,a0
 13e:	0585                	addi	a1,a1,1
 140:	0785                	addi	a5,a5,1
 142:	fff5c703          	lbu	a4,-1(a1)
 146:	fee78fa3          	sb	a4,-1(a5)
 14a:	fb75                	bnez	a4,13e <strcpy+0x8>
 14c:	6422                	ld	s0,8(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret

0000000000000152 <strcmp>:
 152:	1141                	addi	sp,sp,-16
 154:	e422                	sd	s0,8(sp)
 156:	0800                	addi	s0,sp,16
 158:	00054783          	lbu	a5,0(a0)
 15c:	cb91                	beqz	a5,170 <strcmp+0x1e>
 15e:	0005c703          	lbu	a4,0(a1)
 162:	00f71763          	bne	a4,a5,170 <strcmp+0x1e>
 166:	0505                	addi	a0,a0,1
 168:	0585                	addi	a1,a1,1
 16a:	00054783          	lbu	a5,0(a0)
 16e:	fbe5                	bnez	a5,15e <strcmp+0xc>
 170:	0005c503          	lbu	a0,0(a1)
 174:	40a7853b          	subw	a0,a5,a0
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strlen>:
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
 184:	00054783          	lbu	a5,0(a0)
 188:	cf91                	beqz	a5,1a4 <strlen+0x26>
 18a:	0505                	addi	a0,a0,1
 18c:	87aa                	mv	a5,a0
 18e:	86be                	mv	a3,a5
 190:	0785                	addi	a5,a5,1
 192:	fff7c703          	lbu	a4,-1(a5)
 196:	ff65                	bnez	a4,18e <strlen+0x10>
 198:	40a6853b          	subw	a0,a3,a0
 19c:	2505                	addiw	a0,a0,1
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret
 1a4:	4501                	li	a0,0
 1a6:	bfe5                	j	19e <strlen+0x20>

00000000000001a8 <memset>:
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
 1ae:	ca19                	beqz	a2,1c4 <memset+0x1c>
 1b0:	87aa                	mv	a5,a0
 1b2:	1602                	slli	a2,a2,0x20
 1b4:	9201                	srli	a2,a2,0x20
 1b6:	00a60733          	add	a4,a2,a0
 1ba:	00b78023          	sb	a1,0(a5)
 1be:	0785                	addi	a5,a5,1
 1c0:	fee79de3          	bne	a5,a4,1ba <memset+0x12>
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret

00000000000001ca <strchr>:
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e422                	sd	s0,8(sp)
 1ce:	0800                	addi	s0,sp,16
 1d0:	00054783          	lbu	a5,0(a0)
 1d4:	cb99                	beqz	a5,1ea <strchr+0x20>
 1d6:	00f58763          	beq	a1,a5,1e4 <strchr+0x1a>
 1da:	0505                	addi	a0,a0,1
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	fbfd                	bnez	a5,1d6 <strchr+0xc>
 1e2:	4501                	li	a0,0
 1e4:	6422                	ld	s0,8(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret
 1ea:	4501                	li	a0,0
 1ec:	bfe5                	j	1e4 <strchr+0x1a>

00000000000001ee <gets>:
 1ee:	711d                	addi	sp,sp,-96
 1f0:	ec86                	sd	ra,88(sp)
 1f2:	e8a2                	sd	s0,80(sp)
 1f4:	e4a6                	sd	s1,72(sp)
 1f6:	e0ca                	sd	s2,64(sp)
 1f8:	fc4e                	sd	s3,56(sp)
 1fa:	f852                	sd	s4,48(sp)
 1fc:	f456                	sd	s5,40(sp)
 1fe:	f05a                	sd	s6,32(sp)
 200:	ec5e                	sd	s7,24(sp)
 202:	1080                	addi	s0,sp,96
 204:	8baa                	mv	s7,a0
 206:	8a2e                	mv	s4,a1
 208:	892a                	mv	s2,a0
 20a:	4481                	li	s1,0
 20c:	4aa9                	li	s5,10
 20e:	4b35                	li	s6,13
 210:	89a6                	mv	s3,s1
 212:	2485                	addiw	s1,s1,1
 214:	0344d863          	bge	s1,s4,244 <gets+0x56>
 218:	4605                	li	a2,1
 21a:	faf40593          	addi	a1,s0,-81
 21e:	4501                	li	a0,0
 220:	00000097          	auipc	ra,0x0
 224:	19a080e7          	jalr	410(ra) # 3ba <read>
 228:	00a05e63          	blez	a0,244 <gets+0x56>
 22c:	faf44783          	lbu	a5,-81(s0)
 230:	00f90023          	sb	a5,0(s2)
 234:	01578763          	beq	a5,s5,242 <gets+0x54>
 238:	0905                	addi	s2,s2,1
 23a:	fd679be3          	bne	a5,s6,210 <gets+0x22>
 23e:	89a6                	mv	s3,s1
 240:	a011                	j	244 <gets+0x56>
 242:	89a6                	mv	s3,s1
 244:	99de                	add	s3,s3,s7
 246:	00098023          	sb	zero,0(s3)
 24a:	855e                	mv	a0,s7
 24c:	60e6                	ld	ra,88(sp)
 24e:	6446                	ld	s0,80(sp)
 250:	64a6                	ld	s1,72(sp)
 252:	6906                	ld	s2,64(sp)
 254:	79e2                	ld	s3,56(sp)
 256:	7a42                	ld	s4,48(sp)
 258:	7aa2                	ld	s5,40(sp)
 25a:	7b02                	ld	s6,32(sp)
 25c:	6be2                	ld	s7,24(sp)
 25e:	6125                	addi	sp,sp,96
 260:	8082                	ret

0000000000000262 <stat>:
 262:	1101                	addi	sp,sp,-32
 264:	ec06                	sd	ra,24(sp)
 266:	e822                	sd	s0,16(sp)
 268:	e426                	sd	s1,8(sp)
 26a:	e04a                	sd	s2,0(sp)
 26c:	1000                	addi	s0,sp,32
 26e:	892e                	mv	s2,a1
 270:	4581                	li	a1,0
 272:	00000097          	auipc	ra,0x0
 276:	170080e7          	jalr	368(ra) # 3e2 <open>
 27a:	02054563          	bltz	a0,2a4 <stat+0x42>
 27e:	84aa                	mv	s1,a0
 280:	85ca                	mv	a1,s2
 282:	00000097          	auipc	ra,0x0
 286:	178080e7          	jalr	376(ra) # 3fa <fstat>
 28a:	892a                	mv	s2,a0
 28c:	8526                	mv	a0,s1
 28e:	00000097          	auipc	ra,0x0
 292:	13c080e7          	jalr	316(ra) # 3ca <close>
 296:	854a                	mv	a0,s2
 298:	60e2                	ld	ra,24(sp)
 29a:	6442                	ld	s0,16(sp)
 29c:	64a2                	ld	s1,8(sp)
 29e:	6902                	ld	s2,0(sp)
 2a0:	6105                	addi	sp,sp,32
 2a2:	8082                	ret
 2a4:	597d                	li	s2,-1
 2a6:	bfc5                	j	296 <stat+0x34>

00000000000002a8 <atoi>:
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
 2ae:	00054683          	lbu	a3,0(a0)
 2b2:	fd06879b          	addiw	a5,a3,-48
 2b6:	0ff7f793          	zext.b	a5,a5
 2ba:	4625                	li	a2,9
 2bc:	02f66863          	bltu	a2,a5,2ec <atoi+0x44>
 2c0:	872a                	mv	a4,a0
 2c2:	4501                	li	a0,0
 2c4:	0705                	addi	a4,a4,1
 2c6:	0025179b          	slliw	a5,a0,0x2
 2ca:	9fa9                	addw	a5,a5,a0
 2cc:	0017979b          	slliw	a5,a5,0x1
 2d0:	9fb5                	addw	a5,a5,a3
 2d2:	fd07851b          	addiw	a0,a5,-48
 2d6:	00074683          	lbu	a3,0(a4)
 2da:	fd06879b          	addiw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	fef671e3          	bgeu	a2,a5,2c4 <atoi+0x1c>
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
 2ec:	4501                	li	a0,0
 2ee:	bfe5                	j	2e6 <atoi+0x3e>

00000000000002f0 <memmove>:
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
 2f6:	02b57463          	bgeu	a0,a1,31e <memmove+0x2e>
 2fa:	00c05f63          	blez	a2,318 <memmove+0x28>
 2fe:	1602                	slli	a2,a2,0x20
 300:	9201                	srli	a2,a2,0x20
 302:	00c507b3          	add	a5,a0,a2
 306:	872a                	mv	a4,a0
 308:	0585                	addi	a1,a1,1
 30a:	0705                	addi	a4,a4,1
 30c:	fff5c683          	lbu	a3,-1(a1)
 310:	fed70fa3          	sb	a3,-1(a4)
 314:	fee79ae3          	bne	a5,a4,308 <memmove+0x18>
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
 31e:	00c50733          	add	a4,a0,a2
 322:	95b2                	add	a1,a1,a2
 324:	fec05ae3          	blez	a2,318 <memmove+0x28>
 328:	fff6079b          	addiw	a5,a2,-1
 32c:	1782                	slli	a5,a5,0x20
 32e:	9381                	srli	a5,a5,0x20
 330:	fff7c793          	not	a5,a5
 334:	97ba                	add	a5,a5,a4
 336:	15fd                	addi	a1,a1,-1
 338:	177d                	addi	a4,a4,-1
 33a:	0005c683          	lbu	a3,0(a1)
 33e:	00d70023          	sb	a3,0(a4)
 342:	fee79ae3          	bne	a5,a4,336 <memmove+0x46>
 346:	bfc9                	j	318 <memmove+0x28>

0000000000000348 <memcmp>:
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
 34e:	ca05                	beqz	a2,37e <memcmp+0x36>
 350:	fff6069b          	addiw	a3,a2,-1
 354:	1682                	slli	a3,a3,0x20
 356:	9281                	srli	a3,a3,0x20
 358:	0685                	addi	a3,a3,1
 35a:	96aa                	add	a3,a3,a0
 35c:	00054783          	lbu	a5,0(a0)
 360:	0005c703          	lbu	a4,0(a1)
 364:	00e79863          	bne	a5,a4,374 <memcmp+0x2c>
 368:	0505                	addi	a0,a0,1
 36a:	0585                	addi	a1,a1,1
 36c:	fed518e3          	bne	a0,a3,35c <memcmp+0x14>
 370:	4501                	li	a0,0
 372:	a019                	j	378 <memcmp+0x30>
 374:	40e7853b          	subw	a0,a5,a4
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
 37e:	4501                	li	a0,0
 380:	bfe5                	j	378 <memcmp+0x30>

0000000000000382 <memcpy>:
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
 38a:	00000097          	auipc	ra,0x0
 38e:	f66080e7          	jalr	-154(ra) # 2f0 <memmove>
 392:	60a2                	ld	ra,8(sp)
 394:	6402                	ld	s0,0(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret

000000000000039a <fork>:
 39a:	4885                	li	a7,1
 39c:	00000073          	ecall
 3a0:	8082                	ret

00000000000003a2 <exit>:
 3a2:	4889                	li	a7,2
 3a4:	00000073          	ecall
 3a8:	8082                	ret

00000000000003aa <wait>:
 3aa:	488d                	li	a7,3
 3ac:	00000073          	ecall
 3b0:	8082                	ret

00000000000003b2 <pipe>:
 3b2:	4891                	li	a7,4
 3b4:	00000073          	ecall
 3b8:	8082                	ret

00000000000003ba <read>:
 3ba:	4895                	li	a7,5
 3bc:	00000073          	ecall
 3c0:	8082                	ret

00000000000003c2 <write>:
 3c2:	48c1                	li	a7,16
 3c4:	00000073          	ecall
 3c8:	8082                	ret

00000000000003ca <close>:
 3ca:	48d5                	li	a7,21
 3cc:	00000073          	ecall
 3d0:	8082                	ret

00000000000003d2 <kill>:
 3d2:	4899                	li	a7,6
 3d4:	00000073          	ecall
 3d8:	8082                	ret

00000000000003da <exec>:
 3da:	489d                	li	a7,7
 3dc:	00000073          	ecall
 3e0:	8082                	ret

00000000000003e2 <open>:
 3e2:	48bd                	li	a7,15
 3e4:	00000073          	ecall
 3e8:	8082                	ret

00000000000003ea <mknod>:
 3ea:	48c5                	li	a7,17
 3ec:	00000073          	ecall
 3f0:	8082                	ret

00000000000003f2 <unlink>:
 3f2:	48c9                	li	a7,18
 3f4:	00000073          	ecall
 3f8:	8082                	ret

00000000000003fa <fstat>:
 3fa:	48a1                	li	a7,8
 3fc:	00000073          	ecall
 400:	8082                	ret

0000000000000402 <link>:
 402:	48cd                	li	a7,19
 404:	00000073          	ecall
 408:	8082                	ret

000000000000040a <mkdir>:
 40a:	48d1                	li	a7,20
 40c:	00000073          	ecall
 410:	8082                	ret

0000000000000412 <chdir>:
 412:	48a5                	li	a7,9
 414:	00000073          	ecall
 418:	8082                	ret

000000000000041a <dup>:
 41a:	48a9                	li	a7,10
 41c:	00000073          	ecall
 420:	8082                	ret

0000000000000422 <getpid>:
 422:	48ad                	li	a7,11
 424:	00000073          	ecall
 428:	8082                	ret

000000000000042a <sbrk>:
 42a:	48b1                	li	a7,12
 42c:	00000073          	ecall
 430:	8082                	ret

0000000000000432 <sleep>:
 432:	48b5                	li	a7,13
 434:	00000073          	ecall
 438:	8082                	ret

000000000000043a <uptime>:
 43a:	48b9                	li	a7,14
 43c:	00000073          	ecall
 440:	8082                	ret

0000000000000442 <putc>:
 442:	1101                	addi	sp,sp,-32
 444:	ec06                	sd	ra,24(sp)
 446:	e822                	sd	s0,16(sp)
 448:	1000                	addi	s0,sp,32
 44a:	feb407a3          	sb	a1,-17(s0)
 44e:	4605                	li	a2,1
 450:	fef40593          	addi	a1,s0,-17
 454:	00000097          	auipc	ra,0x0
 458:	f6e080e7          	jalr	-146(ra) # 3c2 <write>
 45c:	60e2                	ld	ra,24(sp)
 45e:	6442                	ld	s0,16(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret

0000000000000464 <printint>:
 464:	7139                	addi	sp,sp,-64
 466:	fc06                	sd	ra,56(sp)
 468:	f822                	sd	s0,48(sp)
 46a:	f426                	sd	s1,40(sp)
 46c:	f04a                	sd	s2,32(sp)
 46e:	ec4e                	sd	s3,24(sp)
 470:	0080                	addi	s0,sp,64
 472:	84aa                	mv	s1,a0
 474:	c299                	beqz	a3,47a <printint+0x16>
 476:	0805c963          	bltz	a1,508 <printint+0xa4>
 47a:	2581                	sext.w	a1,a1
 47c:	4881                	li	a7,0
 47e:	fc040693          	addi	a3,s0,-64
 482:	4701                	li	a4,0
 484:	2601                	sext.w	a2,a2
 486:	00000517          	auipc	a0,0x0
 48a:	4d250513          	addi	a0,a0,1234 # 958 <digits>
 48e:	883a                	mv	a6,a4
 490:	2705                	addiw	a4,a4,1
 492:	02c5f7bb          	remuw	a5,a1,a2
 496:	1782                	slli	a5,a5,0x20
 498:	9381                	srli	a5,a5,0x20
 49a:	97aa                	add	a5,a5,a0
 49c:	0007c783          	lbu	a5,0(a5)
 4a0:	00f68023          	sb	a5,0(a3)
 4a4:	0005879b          	sext.w	a5,a1
 4a8:	02c5d5bb          	divuw	a1,a1,a2
 4ac:	0685                	addi	a3,a3,1
 4ae:	fec7f0e3          	bgeu	a5,a2,48e <printint+0x2a>
 4b2:	00088c63          	beqz	a7,4ca <printint+0x66>
 4b6:	fd070793          	addi	a5,a4,-48
 4ba:	00878733          	add	a4,a5,s0
 4be:	02d00793          	li	a5,45
 4c2:	fef70823          	sb	a5,-16(a4)
 4c6:	0028071b          	addiw	a4,a6,2
 4ca:	02e05863          	blez	a4,4fa <printint+0x96>
 4ce:	fc040793          	addi	a5,s0,-64
 4d2:	00e78933          	add	s2,a5,a4
 4d6:	fff78993          	addi	s3,a5,-1
 4da:	99ba                	add	s3,s3,a4
 4dc:	377d                	addiw	a4,a4,-1
 4de:	1702                	slli	a4,a4,0x20
 4e0:	9301                	srli	a4,a4,0x20
 4e2:	40e989b3          	sub	s3,s3,a4
 4e6:	fff94583          	lbu	a1,-1(s2)
 4ea:	8526                	mv	a0,s1
 4ec:	00000097          	auipc	ra,0x0
 4f0:	f56080e7          	jalr	-170(ra) # 442 <putc>
 4f4:	197d                	addi	s2,s2,-1
 4f6:	ff3918e3          	bne	s2,s3,4e6 <printint+0x82>
 4fa:	70e2                	ld	ra,56(sp)
 4fc:	7442                	ld	s0,48(sp)
 4fe:	74a2                	ld	s1,40(sp)
 500:	7902                	ld	s2,32(sp)
 502:	69e2                	ld	s3,24(sp)
 504:	6121                	addi	sp,sp,64
 506:	8082                	ret
 508:	40b005bb          	negw	a1,a1
 50c:	4885                	li	a7,1
 50e:	bf85                	j	47e <printint+0x1a>

0000000000000510 <vprintf>:
 510:	715d                	addi	sp,sp,-80
 512:	e486                	sd	ra,72(sp)
 514:	e0a2                	sd	s0,64(sp)
 516:	fc26                	sd	s1,56(sp)
 518:	f84a                	sd	s2,48(sp)
 51a:	f44e                	sd	s3,40(sp)
 51c:	f052                	sd	s4,32(sp)
 51e:	ec56                	sd	s5,24(sp)
 520:	e85a                	sd	s6,16(sp)
 522:	e45e                	sd	s7,8(sp)
 524:	e062                	sd	s8,0(sp)
 526:	0880                	addi	s0,sp,80
 528:	0005c903          	lbu	s2,0(a1)
 52c:	18090c63          	beqz	s2,6c4 <vprintf+0x1b4>
 530:	8aaa                	mv	s5,a0
 532:	8bb2                	mv	s7,a2
 534:	00158493          	addi	s1,a1,1
 538:	4981                	li	s3,0
 53a:	02500a13          	li	s4,37
 53e:	4b55                	li	s6,21
 540:	a839                	j	55e <vprintf+0x4e>
 542:	85ca                	mv	a1,s2
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	efc080e7          	jalr	-260(ra) # 442 <putc>
 54e:	a019                	j	554 <vprintf+0x44>
 550:	01498d63          	beq	s3,s4,56a <vprintf+0x5a>
 554:	0485                	addi	s1,s1,1
 556:	fff4c903          	lbu	s2,-1(s1)
 55a:	16090563          	beqz	s2,6c4 <vprintf+0x1b4>
 55e:	fe0999e3          	bnez	s3,550 <vprintf+0x40>
 562:	ff4910e3          	bne	s2,s4,542 <vprintf+0x32>
 566:	89d2                	mv	s3,s4
 568:	b7f5                	j	554 <vprintf+0x44>
 56a:	13490263          	beq	s2,s4,68e <vprintf+0x17e>
 56e:	f9d9079b          	addiw	a5,s2,-99
 572:	0ff7f793          	zext.b	a5,a5
 576:	12fb6563          	bltu	s6,a5,6a0 <vprintf+0x190>
 57a:	f9d9079b          	addiw	a5,s2,-99
 57e:	0ff7f713          	zext.b	a4,a5
 582:	10eb6f63          	bltu	s6,a4,6a0 <vprintf+0x190>
 586:	00271793          	slli	a5,a4,0x2
 58a:	00000717          	auipc	a4,0x0
 58e:	37670713          	addi	a4,a4,886 # 900 <malloc+0x13e>
 592:	97ba                	add	a5,a5,a4
 594:	439c                	lw	a5,0(a5)
 596:	97ba                	add	a5,a5,a4
 598:	8782                	jr	a5
 59a:	008b8913          	addi	s2,s7,8
 59e:	4685                	li	a3,1
 5a0:	4629                	li	a2,10
 5a2:	000ba583          	lw	a1,0(s7)
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	ebc080e7          	jalr	-324(ra) # 464 <printint>
 5b0:	8bca                	mv	s7,s2
 5b2:	4981                	li	s3,0
 5b4:	b745                	j	554 <vprintf+0x44>
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	ea0080e7          	jalr	-352(ra) # 464 <printint>
 5cc:	8bca                	mv	s7,s2
 5ce:	4981                	li	s3,0
 5d0:	b751                	j	554 <vprintf+0x44>
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4641                	li	a2,16
 5da:	000ba583          	lw	a1,0(s7)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e84080e7          	jalr	-380(ra) # 464 <printint>
 5e8:	8bca                	mv	s7,s2
 5ea:	4981                	li	s3,0
 5ec:	b7a5                	j	554 <vprintf+0x44>
 5ee:	008b8c13          	addi	s8,s7,8
 5f2:	000bb983          	ld	s3,0(s7)
 5f6:	03000593          	li	a1,48
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e46080e7          	jalr	-442(ra) # 442 <putc>
 604:	07800593          	li	a1,120
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e38080e7          	jalr	-456(ra) # 442 <putc>
 612:	4941                	li	s2,16
 614:	00000b97          	auipc	s7,0x0
 618:	344b8b93          	addi	s7,s7,836 # 958 <digits>
 61c:	03c9d793          	srli	a5,s3,0x3c
 620:	97de                	add	a5,a5,s7
 622:	0007c583          	lbu	a1,0(a5)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e1a080e7          	jalr	-486(ra) # 442 <putc>
 630:	0992                	slli	s3,s3,0x4
 632:	397d                	addiw	s2,s2,-1
 634:	fe0914e3          	bnez	s2,61c <vprintf+0x10c>
 638:	8be2                	mv	s7,s8
 63a:	4981                	li	s3,0
 63c:	bf21                	j	554 <vprintf+0x44>
 63e:	008b8993          	addi	s3,s7,8
 642:	000bb903          	ld	s2,0(s7)
 646:	02090163          	beqz	s2,668 <vprintf+0x158>
 64a:	00094583          	lbu	a1,0(s2)
 64e:	c9a5                	beqz	a1,6be <vprintf+0x1ae>
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	df0080e7          	jalr	-528(ra) # 442 <putc>
 65a:	0905                	addi	s2,s2,1
 65c:	00094583          	lbu	a1,0(s2)
 660:	f9e5                	bnez	a1,650 <vprintf+0x140>
 662:	8bce                	mv	s7,s3
 664:	4981                	li	s3,0
 666:	b5fd                	j	554 <vprintf+0x44>
 668:	00000917          	auipc	s2,0x0
 66c:	29090913          	addi	s2,s2,656 # 8f8 <malloc+0x136>
 670:	02800593          	li	a1,40
 674:	bff1                	j	650 <vprintf+0x140>
 676:	008b8913          	addi	s2,s7,8
 67a:	000bc583          	lbu	a1,0(s7)
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	dc2080e7          	jalr	-574(ra) # 442 <putc>
 688:	8bca                	mv	s7,s2
 68a:	4981                	li	s3,0
 68c:	b5e1                	j	554 <vprintf+0x44>
 68e:	02500593          	li	a1,37
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	dae080e7          	jalr	-594(ra) # 442 <putc>
 69c:	4981                	li	s3,0
 69e:	bd5d                	j	554 <vprintf+0x44>
 6a0:	02500593          	li	a1,37
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	d9c080e7          	jalr	-612(ra) # 442 <putc>
 6ae:	85ca                	mv	a1,s2
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	d90080e7          	jalr	-624(ra) # 442 <putc>
 6ba:	4981                	li	s3,0
 6bc:	bd61                	j	554 <vprintf+0x44>
 6be:	8bce                	mv	s7,s3
 6c0:	4981                	li	s3,0
 6c2:	bd49                	j	554 <vprintf+0x44>
 6c4:	60a6                	ld	ra,72(sp)
 6c6:	6406                	ld	s0,64(sp)
 6c8:	74e2                	ld	s1,56(sp)
 6ca:	7942                	ld	s2,48(sp)
 6cc:	79a2                	ld	s3,40(sp)
 6ce:	7a02                	ld	s4,32(sp)
 6d0:	6ae2                	ld	s5,24(sp)
 6d2:	6b42                	ld	s6,16(sp)
 6d4:	6ba2                	ld	s7,8(sp)
 6d6:	6c02                	ld	s8,0(sp)
 6d8:	6161                	addi	sp,sp,80
 6da:	8082                	ret

00000000000006dc <fprintf>:
 6dc:	715d                	addi	sp,sp,-80
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	addi	s0,sp,32
 6e4:	e010                	sd	a2,0(s0)
 6e6:	e414                	sd	a3,8(s0)
 6e8:	e818                	sd	a4,16(s0)
 6ea:	ec1c                	sd	a5,24(s0)
 6ec:	03043023          	sd	a6,32(s0)
 6f0:	03143423          	sd	a7,40(s0)
 6f4:	fe843423          	sd	s0,-24(s0)
 6f8:	8622                	mv	a2,s0
 6fa:	00000097          	auipc	ra,0x0
 6fe:	e16080e7          	jalr	-490(ra) # 510 <vprintf>
 702:	60e2                	ld	ra,24(sp)
 704:	6442                	ld	s0,16(sp)
 706:	6161                	addi	sp,sp,80
 708:	8082                	ret

000000000000070a <printf>:
 70a:	711d                	addi	sp,sp,-96
 70c:	ec06                	sd	ra,24(sp)
 70e:	e822                	sd	s0,16(sp)
 710:	1000                	addi	s0,sp,32
 712:	e40c                	sd	a1,8(s0)
 714:	e810                	sd	a2,16(s0)
 716:	ec14                	sd	a3,24(s0)
 718:	f018                	sd	a4,32(s0)
 71a:	f41c                	sd	a5,40(s0)
 71c:	03043823          	sd	a6,48(s0)
 720:	03143c23          	sd	a7,56(s0)
 724:	00840613          	addi	a2,s0,8
 728:	fec43423          	sd	a2,-24(s0)
 72c:	85aa                	mv	a1,a0
 72e:	4505                	li	a0,1
 730:	00000097          	auipc	ra,0x0
 734:	de0080e7          	jalr	-544(ra) # 510 <vprintf>
 738:	60e2                	ld	ra,24(sp)
 73a:	6442                	ld	s0,16(sp)
 73c:	6125                	addi	sp,sp,96
 73e:	8082                	ret

0000000000000740 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 740:	1141                	addi	sp,sp,-16
 742:	e422                	sd	s0,8(sp)
 744:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 746:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74a:	00001797          	auipc	a5,0x1
 74e:	8b67b783          	ld	a5,-1866(a5) # 1000 <freep>
 752:	a02d                	j	77c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 754:	4618                	lw	a4,8(a2)
 756:	9f2d                	addw	a4,a4,a1
 758:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 75c:	6398                	ld	a4,0(a5)
 75e:	6310                	ld	a2,0(a4)
 760:	a83d                	j	79e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 762:	ff852703          	lw	a4,-8(a0)
 766:	9f31                	addw	a4,a4,a2
 768:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 76a:	ff053683          	ld	a3,-16(a0)
 76e:	a091                	j	7b2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	6398                	ld	a4,0(a5)
 772:	00e7e463          	bltu	a5,a4,77a <free+0x3a>
 776:	00e6ea63          	bltu	a3,a4,78a <free+0x4a>
{
 77a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77c:	fed7fae3          	bgeu	a5,a3,770 <free+0x30>
 780:	6398                	ld	a4,0(a5)
 782:	00e6e463          	bltu	a3,a4,78a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 786:	fee7eae3          	bltu	a5,a4,77a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 78a:	ff852583          	lw	a1,-8(a0)
 78e:	6390                	ld	a2,0(a5)
 790:	02059813          	slli	a6,a1,0x20
 794:	01c85713          	srli	a4,a6,0x1c
 798:	9736                	add	a4,a4,a3
 79a:	fae60de3          	beq	a2,a4,754 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a2:	4790                	lw	a2,8(a5)
 7a4:	02061593          	slli	a1,a2,0x20
 7a8:	01c5d713          	srli	a4,a1,0x1c
 7ac:	973e                	add	a4,a4,a5
 7ae:	fae68ae3          	beq	a3,a4,762 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7b2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b4:	00001717          	auipc	a4,0x1
 7b8:	84f73623          	sd	a5,-1972(a4) # 1000 <freep>
}
 7bc:	6422                	ld	s0,8(sp)
 7be:	0141                	addi	sp,sp,16
 7c0:	8082                	ret

00000000000007c2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c2:	7139                	addi	sp,sp,-64
 7c4:	fc06                	sd	ra,56(sp)
 7c6:	f822                	sd	s0,48(sp)
 7c8:	f426                	sd	s1,40(sp)
 7ca:	f04a                	sd	s2,32(sp)
 7cc:	ec4e                	sd	s3,24(sp)
 7ce:	e852                	sd	s4,16(sp)
 7d0:	e456                	sd	s5,8(sp)
 7d2:	e05a                	sd	s6,0(sp)
 7d4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d6:	02051493          	slli	s1,a0,0x20
 7da:	9081                	srli	s1,s1,0x20
 7dc:	04bd                	addi	s1,s1,15
 7de:	8091                	srli	s1,s1,0x4
 7e0:	0014899b          	addiw	s3,s1,1
 7e4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7e6:	00001517          	auipc	a0,0x1
 7ea:	81a53503          	ld	a0,-2022(a0) # 1000 <freep>
 7ee:	c515                	beqz	a0,81a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f2:	4798                	lw	a4,8(a5)
 7f4:	02977f63          	bgeu	a4,s1,832 <malloc+0x70>
  if(nu < 4096)
 7f8:	8a4e                	mv	s4,s3
 7fa:	0009871b          	sext.w	a4,s3
 7fe:	6685                	lui	a3,0x1
 800:	00d77363          	bgeu	a4,a3,806 <malloc+0x44>
 804:	6a05                	lui	s4,0x1
 806:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 80a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 80e:	00000917          	auipc	s2,0x0
 812:	7f290913          	addi	s2,s2,2034 # 1000 <freep>
  if(p == (char*)-1)
 816:	5afd                	li	s5,-1
 818:	a895                	j	88c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 81a:	00001797          	auipc	a5,0x1
 81e:	9f678793          	addi	a5,a5,-1546 # 1210 <base>
 822:	00000717          	auipc	a4,0x0
 826:	7cf73f23          	sd	a5,2014(a4) # 1000 <freep>
 82a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 82c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 830:	b7e1                	j	7f8 <malloc+0x36>
      if(p->s.size == nunits)
 832:	02e48c63          	beq	s1,a4,86a <malloc+0xa8>
        p->s.size -= nunits;
 836:	4137073b          	subw	a4,a4,s3
 83a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 83c:	02071693          	slli	a3,a4,0x20
 840:	01c6d713          	srli	a4,a3,0x1c
 844:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 846:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 84a:	00000717          	auipc	a4,0x0
 84e:	7aa73b23          	sd	a0,1974(a4) # 1000 <freep>
      return (void*)(p + 1);
 852:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 856:	70e2                	ld	ra,56(sp)
 858:	7442                	ld	s0,48(sp)
 85a:	74a2                	ld	s1,40(sp)
 85c:	7902                	ld	s2,32(sp)
 85e:	69e2                	ld	s3,24(sp)
 860:	6a42                	ld	s4,16(sp)
 862:	6aa2                	ld	s5,8(sp)
 864:	6b02                	ld	s6,0(sp)
 866:	6121                	addi	sp,sp,64
 868:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 86a:	6398                	ld	a4,0(a5)
 86c:	e118                	sd	a4,0(a0)
 86e:	bff1                	j	84a <malloc+0x88>
  hp->s.size = nu;
 870:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 874:	0541                	addi	a0,a0,16
 876:	00000097          	auipc	ra,0x0
 87a:	eca080e7          	jalr	-310(ra) # 740 <free>
  return freep;
 87e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 882:	d971                	beqz	a0,856 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 886:	4798                	lw	a4,8(a5)
 888:	fa9775e3          	bgeu	a4,s1,832 <malloc+0x70>
    if(p == freep)
 88c:	00093703          	ld	a4,0(s2)
 890:	853e                	mv	a0,a5
 892:	fef719e3          	bne	a4,a5,884 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 896:	8552                	mv	a0,s4
 898:	00000097          	auipc	ra,0x0
 89c:	b92080e7          	jalr	-1134(ra) # 42a <sbrk>
  if(p == (char*)-1)
 8a0:	fd5518e3          	bne	a0,s5,870 <malloc+0xae>
        return 0;
 8a4:	4501                	li	a0,0
 8a6:	bf45                	j	856 <malloc+0x94>

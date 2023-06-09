glabel RaceSequence
/* 00202C 8000142C 27BDFFD8 */  addiu $sp, $sp, -0x28
/* 002030 80001430 3C018015 */  lui   $at, %hi(gMatrixCount) # $at, 0x8015
/* 002034 80001434 AFB0001C */  sw    $s0, 0x1c($sp)
/* 002038 80001438 A4200112 */  sh    $zero, %lo(gMatrixCount)($at)
/* 00203C 8000143C 3C10800E */  lui   $s0, %hi(gPauseFlag) # $s0, 0x800e
/* 002040 80001440 3C018016 */  lui   $at, %hi(gEffectCount) # $at, 0x8016
/* 002044 80001444 2610C5FC */  addiu $s0, %lo(gPauseFlag) # addiu $s0, $s0, -0x3a04
/* 002048 80001448 A4204AF0 */  sh    $zero, %lo(gEffectCount)($at)
/* 00204C 8000144C 960E0000 */  lhu   $t6, ($s0)
/* 002050 80001450 AFBF0024 */  sw    $ra, 0x24($sp)
/* 002054 80001454 AFB10020 */  sw    $s1, 0x20($sp)
/* 002058 80001458 11C00003 */  beqz  $t6, .L80001468
/* 00205C 8000145C F7B40010 */   sdc1  $f20, 0x10($sp)
/* 002060 80001460 0C0A42C5 */  jal   PauseSequence
/* 002064 80001464 00000000 */   nop   
.L80001468:
/* 002068 80001468 3C0F800E */  lui   $t7, %hi(gFadeoutFlag) # $t7, 0x800e
/* 00206C 8000146C 95EFC5C0 */  lhu   $t7, %lo(gFadeoutFlag)($t7)
/* 002070 80001470 3C03800E */  lui   $v1, %hi(gVideoFrame) # $v1, 0x800e
/* 002074 80001474 2463C58C */  addiu $v1, %lo(gVideoFrame) # addiu $v1, $v1, -0x3a74
/* 002078 80001478 51E00006 */  beql  $t7, $zero, .L80001494
/* 00207C 8000147C 84620000 */   lh    $v0, ($v1)
/* 002080 80001480 0C0A8E2D */  jal   FadeoutSequence
/* 002084 80001484 00000000 */   nop   
/* 002088 80001488 1000028B */  b     .L80001EB8
/* 00208C 8000148C 8FBF0024 */   lw    $ra, 0x24($sp)
/* 002090 80001490 84620000 */  lh    $v0, ($v1)
.L80001494:
/* 002094 80001494 24180005 */  li    $t8, 5
/* 002098 80001498 24190001 */  li    $t9, 1
/* 00209C 8000149C 28410006 */  slti  $at, $v0, 6
/* 0020A0 800014A0 14200003 */  bnez  $at, .L800014B0
/* 0020A4 800014A4 00000000 */   nop   
/* 0020A8 800014A8 A4780000 */  sh    $t8, ($v1)
/* 0020AC 800014AC 84620000 */  lh    $v0, ($v1)
.L800014B0:
/* 0020B0 800014B0 04410002 */  bgez  $v0, .L800014BC
/* 0020B4 800014B4 00000000 */   nop   
/* 0020B8 800014B8 A4790000 */  sh    $t9, ($v1)
.L800014BC:
/* 0020BC 800014BC 0C0A93BD */  jal   SetupPerspective
/* 0020C0 800014C0 00000000 */   nop   
/* 0020C4 800014C4 3C02800E */  lui   $v0, %hi(gScreenMode) # $v0, 0x800e
/* 0020C8 800014C8 8C42C52C */  lw    $v0, %lo(gScreenMode)($v0)
/* 0020CC 800014CC 24090002 */  li    $t1, 2
/* 0020D0 800014D0 3C018015 */  lui   $at, %hi(gFramerate) # $at, 0x8015
/* 0020D4 800014D4 1040000D */  beqz  $v0, .L8000150C
/* 0020D8 800014D8 00000000 */   nop   
/* 0020DC 800014DC 24010001 */  li    $at, 1
/* 0020E0 800014E0 10410117 */  beq   $v0, $at, .L80001940
/* 0020E4 800014E4 3C0B800E */   lui   $t3, 0x800e
/* 0020E8 800014E8 24040002 */  li    $a0, 2
/* 0020EC 800014EC 104400AB */  beq   $v0, $a0, .L8000179C
/* 0020F0 800014F0 3C0B800E */   lui   $t3, 0x800e
/* 0020F4 800014F4 24030003 */  li    $v1, 3
/* 0020F8 800014F8 1043017B */  beq   $v0, $v1, .L80001AE8
/* 0020FC 800014FC 3C0C800E */   lui   $t4, 0x800e
/* 002100 80001500 3C04800E */  lui   $a0, %hi(gDebugFlag) # $a0, 0x800e
/* 002104 80001504 1000022F */  b     .L80001DC4
/* 002108 80001508 9484C520 */   lhu   $a0, %lo(gDebugFlag)($a0)
.L8000150C:
/* 00210C 8000150C 0C0017D1 */  jal   KeyDataControl
/* 002110 80001510 AC290114 */   sw    $t1, %lo(gFramerate)($at)
/* 002114 80001514 960A0000 */  lhu   $t2, ($s0)
/* 002118 80001518 3C0B8015 */  lui   $t3, %hi(gFramerate) # $t3, 0x8015
/* 00211C 8000151C 15400033 */  bnez  $t2, .L800015EC
/* 002120 80001520 00000000 */   nop   
/* 002124 80001524 8D6B0114 */  lw    $t3, %lo(gFramerate)($t3)
/* 002128 80001528 00008025 */  move  $s0, $zero
/* 00212C 8000152C 3C01800F */  lui   $at, %hi(D_800EB5F8)
/* 002130 80001530 1960002C */  blez  $t3, .L800015E4
/* 002134 80001534 3C11800E */   lui   $s1, %hi(gRaceTimer) # $s1, 0x800e
/* 002138 80001538 D434B5F8 */  ldc1  $f20, %lo(D_800EB5F8)($at)
/* 00213C 8000153C 2631C598 */  addiu $s1, %lo(gRaceTimer) # addiu $s1, $s1, -0x3a68
.L80001540:
/* 002140 80001540 3C0C8015 */  lui   $t4, %hi(gTimeFlag) # $t4, 0x8015
/* 002144 80001544 958C011E */  lhu   $t4, %lo(gTimeFlag)($t4)
/* 002148 80001548 11800006 */  beqz  $t4, .L80001564
/* 00214C 8000154C 00000000 */   nop   
/* 002150 80001550 C6240000 */  lwc1  $f4, ($s1)
/* 002154 80001554 460021A1 */  cvt.d.s $f6, $f4
/* 002158 80001558 46343200 */  add.d $f8, $f6, $f20
/* 00215C 8000155C 462042A0 */  cvt.s.d $f10, $f8
/* 002160 80001560 E62A0000 */  swc1  $f10, ($s1)
.L80001564:
/* 002164 80001564 0C0A427C */  jal   CollisionKartToKart
/* 002168 80001568 00000000 */   nop   
/* 00216C 8000156C 0C0A8355 */  jal   CollisionObjectToKart
/* 002170 80001570 00000000 */   nop   
/* 002174 80001574 0C00E0B7 */  jal   DriveStickControl
/* 002178 80001578 00000000 */   nop   
/* 00217C 8000157C 3C04800E */  lui   $a0, %hi(gMyKart1) # $a0, 0x800e
/* 002180 80001580 3C05800E */  lui   $a1, %hi(gCamera1) # $a1, 0x800e
/* 002184 80001584 8CA5DB40 */  lw    $a1, %lo(gCamera1)($a1)
/* 002188 80001588 8C84C4FC */  lw    $a0, %lo(gMyKart1)($a0)
/* 00218C 8000158C 0C007BA6 */  jal   CameraControl
/* 002190 80001590 00003025 */   move  $a2, $zero
/* 002194 80001594 0C00A3DC */  jal   KartPosControlFull
/* 002198 80001598 00000000 */   nop   
/* 00219C 8000159C 0C0A3D1D */  jal   EnemyControl
/* 0021A0 800015A0 00000000 */   nop   
/* 0021A4 800015A4 0C0166B2 */  jal   KWVideoFramesYori
/* 0021A8 800015A8 00000000 */   nop   
/* 0021AC 800015AC 0C0A8D52 */  jal   ObjectStrategy1
/* 0021B0 800015B0 00000000 */   nop   
/* 0021B4 800015B4 0C0A59A8 */  jal   MapStrategy
/* 0021B8 800015B8 00000000 */   nop   
/* 0021BC 800015BC 0C0A3F2F */  jal   RaceControl
/* 0021C0 800015C0 00000000 */   nop   
/* 0021C4 800015C4 3C0F8015 */  lui   $t7, %hi(gFramerate) # $t7, 0x8015
/* 0021C8 800015C8 8DEF0114 */  lw    $t7, %lo(gFramerate)($t7)
/* 0021CC 800015CC 26100001 */  addiu $s0, $s0, 1
/* 0021D0 800015D0 00106C00 */  sll   $t5, $s0, 0x10
/* 0021D4 800015D4 000D8403 */  sra   $s0, $t5, 0x10
/* 0021D8 800015D8 020F082A */  slt   $at, $s0, $t7
/* 0021DC 800015DC 1420FFD8 */  bnez  $at, .L80001540
/* 0021E0 800015E0 00000000 */   nop   
.L800015E4:
/* 0021E4 800015E4 0C0089D1 */  jal   KenStartegy
/* 0021E8 800015E8 00000000 */   nop   
.L800015EC:
/* 0021EC 800015EC 0C01681C */  jal   KWGameFramesYori
/* 0021F0 800015F0 00000000 */   nop   
/* 0021F4 800015F4 3C01800E */  lui   $at, %hi(gVideoFrame) # $at, 0x800e
/* 0021F8 800015F8 A420C58C */  sh    $zero, %lo(gVideoFrame)($at)
/* 0021FC 800015FC 0C000D54 */  jal   SetGraphCPUTime
/* 002200 80001600 24040001 */   li    $a0, 1
/* 002204 80001604 3C018016 */  lui   $at, %hi(gScreenCounter) # $at, 0x8016
/* 002208 80001608 0C0A9669 */  jal   DrawFullScreen
/* 00220C 8000160C AC20F788 */   sw    $zero, %lo(gScreenCounter)($at)
/* 002210 80001610 3C04800E */  lui   $a0, %hi(gDebugFlag) # $a0, 0x800e
/* 002214 80001614 9484C520 */  lhu   $a0, %lo(gDebugFlag)($a0)
/* 002218 80001618 3C05800E */  lui   $a1, %hi(gDispAreaFlag) # $a1, 0x800e
/* 00221C 8000161C 24A5C514 */  addiu $a1, %lo(gDispAreaFlag) # addiu $a1, $a1, -0x3aec
/* 002220 80001620 54800006 */  bnel  $a0, $zero, .L8000163C
/* 002224 80001624 94B80000 */   lhu   $t8, ($a1)
/* 002228 80001628 3C05800E */  lui   $a1, %hi(gDispAreaFlag) # $a1, 0x800e
/* 00222C 8000162C 24A5C514 */  addiu $a1, %lo(gDispAreaFlag) # addiu $a1, $a1, -0x3aec
/* 002230 80001630 100001E4 */  b     .L80001DC4
/* 002234 80001634 A4A00000 */   sh    $zero, ($a1)
/* 002238 80001638 94B80000 */  lhu   $t8, ($a1)
.L8000163C:
/* 00223C 8000163C 3C088016 */  lui   $t0, %hi(gDispPoint) # $t0, 0x8016
/* 002240 80001640 3C0C800E */  lui   $t4, %hi(gCamera1) # $t4, 0x800e
/* 002244 80001644 13000048 */  beqz  $t8, .L80001768
/* 002248 80001648 3C03800E */   lui   $v1, 0x800e
/* 00224C 8000164C 3C03800E */  lui   $v1, %hi(gCont1P) # $v1, 0x800e
/* 002250 80001650 8C63C4BC */  lw    $v1, %lo(gCont1P)($v1)
/* 002254 80001654 3C06800F */  lui   $a2, %hi(D_800EB5D0) # $a2, 0x800f
/* 002258 80001658 24C6B5D0 */  addiu $a2, %lo(D_800EB5D0) # addiu $a2, $a2, -0x4a30
/* 00225C 8000165C 94790006 */  lhu   $t9, 6($v1)
/* 002260 80001660 24040028 */  li    $a0, 40
/* 002264 80001664 33290010 */  andi  $t1, $t9, 0x10
/* 002268 80001668 11200008 */  beqz  $t1, .L8000168C
/* 00226C 8000166C 00000000 */   nop   
/* 002270 80001670 94620004 */  lhu   $v0, 4($v1)
/* 002274 80001674 304A8000 */  andi  $t2, $v0, 0x8000
/* 002278 80001678 11400004 */  beqz  $t2, .L8000168C
/* 00227C 8000167C 304B4000 */   andi  $t3, $v0, 0x4000
/* 002280 80001680 11600002 */  beqz  $t3, .L8000168C
/* 002284 80001684 00000000 */   nop   
/* 002288 80001688 A4A00000 */  sh    $zero, ($a1)
.L8000168C:
/* 00228C 8000168C 8D8CDB40 */  lw    $t4, %lo(gCamera1)($t4)
/* 002290 80001690 3C0D800E */  lui   $t5, %hi(gScreen1) # $t5, 0x800e
/* 002294 80001694 8DADC5EC */  lw    $t5, %lo(gScreen1)($t5)
/* 002298 80001698 95820026 */  lhu   $v0, 0x26($t4)
/* 00229C 8000169C 250825E8 */  addiu $t0, %lo(gDispPoint) # addiu $t0, $t0, 0x25e8
/* 0022A0 800016A0 85AE0038 */  lh    $t6, 0x38($t5)
/* 0022A4 800016A4 28412000 */  slti  $at, $v0, 0x2000
/* 0022A8 800016A8 10200006 */  beqz  $at, .L800016C4
/* 0022AC 800016AC A50E0000 */   sh    $t6, ($t0)
/* 0022B0 800016B0 24050064 */  li    $a1, 100
/* 0022B4 800016B4 0C015E94 */  jal   KWFPrintUD
/* 0022B8 800016B8 85070000 */   lh    $a3, ($t0)
/* 0022BC 800016BC 10000027 */  b     .L8000175C
/* 0022C0 800016C0 00000000 */   nop   
.L800016C4:
/* 0022C4 800016C4 28416000 */  slti  $at, $v0, 0x6000
/* 0022C8 800016C8 10200008 */  beqz  $at, .L800016EC
/* 0022CC 800016CC 24040028 */   li    $a0, 40
/* 0022D0 800016D0 3C06800F */  lui   $a2, %hi(D_800EB5D8) # $a2, 0x800f
/* 0022D4 800016D4 24C6B5D8 */  addiu $a2, %lo(D_800EB5D8) # addiu $a2, $a2, -0x4a28
/* 0022D8 800016D8 24050064 */  li    $a1, 100
/* 0022DC 800016DC 0C015E94 */  jal   KWFPrintUD
/* 0022E0 800016E0 85070000 */   lh    $a3, ($t0)
/* 0022E4 800016E4 1000001D */  b     .L8000175C
/* 0022E8 800016E8 00000000 */   nop   
.L800016EC:
/* 0022EC 800016EC 3401A000 */  li    $at, 40960
/* 0022F0 800016F0 0041082A */  slt   $at, $v0, $at
/* 0022F4 800016F4 10200008 */  beqz  $at, .L80001718
/* 0022F8 800016F8 24040028 */   li    $a0, 40
/* 0022FC 800016FC 3C06800F */  lui   $a2, %hi(D_800EB5E0) # $a2, 0x800f
/* 002300 80001700 24C6B5E0 */  addiu $a2, %lo(D_800EB5E0) # addiu $a2, $a2, -0x4a20
/* 002304 80001704 24050064 */  li    $a1, 100
/* 002308 80001708 0C015E94 */  jal   KWFPrintUD
/* 00230C 8000170C 85070000 */   lh    $a3, ($t0)
/* 002310 80001710 10000012 */  b     .L8000175C
/* 002314 80001714 00000000 */   nop   
.L80001718:
/* 002318 80001718 3401E000 */  li    $at, 57344
/* 00231C 8000171C 0041082A */  slt   $at, $v0, $at
/* 002320 80001720 10200009 */  beqz  $at, .L80001748
/* 002324 80001724 24040028 */   li    $a0, 40
/* 002328 80001728 3C06800F */  lui   $a2, %hi(D_800EB5E8) # $a2, 0x800f
/* 00232C 8000172C 24C6B5E8 */  addiu $a2, %lo(D_800EB5E8) # addiu $a2, $a2, -0x4a18
/* 002330 80001730 24040028 */  li    $a0, 40
/* 002334 80001734 24050064 */  li    $a1, 100
/* 002338 80001738 0C015E94 */  jal   KWFPrintUD
/* 00233C 8000173C 85070000 */   lh    $a3, ($t0)
/* 002340 80001740 10000006 */  b     .L8000175C
/* 002344 80001744 00000000 */   nop   
.L80001748:
/* 002348 80001748 3C06800F */  lui   $a2, %hi(D_800EB5F0) # $a2, 0x800f
/* 00234C 8000174C 24C6B5F0 */  addiu $a2, %lo(D_800EB5F0) # addiu $a2, $a2, -0x4a10
/* 002350 80001750 24050064 */  li    $a1, 100
/* 002354 80001754 0C015E94 */  jal   KWFPrintUD
/* 002358 80001758 85070000 */   lh    $a3, ($t0)
.L8000175C:
/* 00235C 8000175C 3C04800E */  lui   $a0, %hi(gDebugFlag) # $a0, 0x800e
/* 002360 80001760 10000198 */  b     .L80001DC4
/* 002364 80001764 9484C520 */   lhu   $a0, %lo(gDebugFlag)($a0)
.L80001768:
/* 002368 80001768 8C63C4BC */  lw    $v1, -0x3b44($v1)
/* 00236C 8000176C 946F0006 */  lhu   $t7, 6($v1)
/* 002370 80001770 31F80020 */  andi  $t8, $t7, 0x20
/* 002374 80001774 13000193 */  beqz  $t8, .L80001DC4
/* 002378 80001778 00000000 */   nop   
/* 00237C 8000177C 94620004 */  lhu   $v0, 4($v1)
/* 002380 80001780 30598000 */  andi  $t9, $v0, 0x8000
/* 002384 80001784 1320018F */  beqz  $t9, .L80001DC4
/* 002388 80001788 30494000 */   andi  $t1, $v0, 0x4000
/* 00238C 8000178C 1120018D */  beqz  $t1, .L80001DC4
/* 002390 80001790 240A0001 */   li    $t2, 1
/* 002394 80001794 1000018B */  b     .L80001DC4
/* 002398 80001798 A4AA0000 */   sh    $t2, ($a1)
.L8000179C:
/* 00239C 8000179C 856BC5A0 */  lh    $t3, -0x3a60($t3)
/* 0023A0 800017A0 24010012 */  li    $at, 18
/* 0023A4 800017A4 24030003 */  li    $v1, 3
/* 0023A8 800017A8 15610004 */  bne   $t3, $at, .L800017BC
/* 0023AC 800017AC 3C0D8015 */   lui   $t5, %hi(gFramerate) # $t5, 0x8015
/* 0023B0 800017B0 3C018015 */  lui   $at, %hi(gFramerate) # $at, 0x8015
/* 0023B4 800017B4 10000003 */  b     .L800017C4
/* 0023B8 800017B8 AC230114 */   sw    $v1, %lo(gFramerate)($at)
.L800017BC:
/* 0023BC 800017BC 3C018015 */  lui   $at, %hi(gFramerate) # $at, 0x8015
/* 0023C0 800017C0 AC240114 */  sw    $a0, %lo(gFramerate)($at)
.L800017C4:
/* 0023C4 800017C4 960C0000 */  lhu   $t4, ($s0)
/* 0023C8 800017C8 1580003B */  bnez  $t4, .L800018B8
/* 0023CC 800017CC 00000000 */   nop   
/* 0023D0 800017D0 8DAD0114 */  lw    $t5, %lo(gFramerate)($t5)
/* 0023D4 800017D4 00008025 */  move  $s0, $zero
/* 0023D8 800017D8 3C01800F */  lui   $at, %hi(D_800EB600)
/* 0023DC 800017DC 19A00034 */  blez  $t5, .L800018B0
/* 0023E0 800017E0 3C11800E */   lui   $s1, %hi(gRaceTimer) # $s1, 0x800e
/* 0023E4 800017E4 D434B600 */  ldc1  $f20, %lo(D_800EB600)($at)
/* 0023E8 800017E8 2631C598 */  addiu $s1, %lo(gRaceTimer) # addiu $s1, $s1, -0x3a68
.L800017EC:
/* 0023EC 800017EC 3C0E8015 */  lui   $t6, %hi(gTimeFlag) # $t6, 0x8015
/* 0023F0 800017F0 95CE011E */  lhu   $t6, %lo(gTimeFlag)($t6)
/* 0023F4 800017F4 11C00006 */  beqz  $t6, .L80001810
/* 0023F8 800017F8 00000000 */   nop   
/* 0023FC 800017FC C6300000 */  lwc1  $f16, ($s1)
/* 002400 80001800 460084A1 */  cvt.d.s $f18, $f16
/* 002404 80001804 46349100 */  add.d $f4, $f18, $f20
/* 002408 80001808 462021A0 */  cvt.s.d $f6, $f4
/* 00240C 8000180C E6260000 */  swc1  $f6, ($s1)
.L80001810:
/* 002410 80001810 0C0A427C */  jal   CollisionKartToKart
/* 002414 80001814 00000000 */   nop   
/* 002418 80001818 0C0A8355 */  jal   CollisionObjectToKart
/* 00241C 8000181C 00000000 */   nop   
/* 002420 80001820 0C00E0B7 */  jal   DriveStickControl
/* 002424 80001824 00000000 */   nop   
/* 002428 80001828 3C04800E */  lui   $a0, %hi(gMyKart1) # $a0, 0x800e
/* 00242C 8000182C 3C05800E */  lui   $a1, %hi(gCamera1) # $a1, 0x800e
/* 002430 80001830 8CA5DB40 */  lw    $a1, %lo(gCamera1)($a1)
/* 002434 80001834 8C84C4FC */  lw    $a0, %lo(gMyKart1)($a0)
/* 002438 80001838 0C007BA6 */  jal   CameraControl
/* 00243C 8000183C 00003025 */   move  $a2, $zero
/* 002440 80001840 0C00A418 */  jal   KartPosControlRU
/* 002444 80001844 00000000 */   nop   
/* 002448 80001848 3C04800E */  lui   $a0, %hi(gMyKart2) # $a0, 0x800e
/* 00244C 8000184C 3C05800E */  lui   $a1, %hi(gCamera2) # $a1, 0x800e
/* 002450 80001850 8CA5DB44 */  lw    $a1, %lo(gCamera2)($a1)
/* 002454 80001854 8C84C500 */  lw    $a0, %lo(gMyKart2)($a0)
/* 002458 80001858 0C007BA6 */  jal   CameraControl
/* 00245C 8000185C 24060001 */   li    $a2, 1
/* 002460 80001860 0C00A454 */  jal   KartPosControlLD
/* 002464 80001864 00000000 */   nop   
/* 002468 80001868 0C0A3D1D */  jal   EnemyControl
/* 00246C 8000186C 00000000 */   nop   
/* 002470 80001870 0C0166B2 */  jal   KWVideoFramesYori
/* 002474 80001874 00000000 */   nop   
/* 002478 80001878 0C0A8D52 */  jal   ObjectStrategy1
/* 00247C 8000187C 00000000 */   nop   
/* 002480 80001880 0C0A59A8 */  jal   MapStrategy
/* 002484 80001884 00000000 */   nop   
/* 002488 80001888 0C0A3F2F */  jal   RaceControl
/* 00248C 8000188C 00000000 */   nop   
/* 002490 80001890 3C198015 */  lui   $t9, %hi(gFramerate) # $t9, 0x8015
/* 002494 80001894 8F390114 */  lw    $t9, %lo(gFramerate)($t9)
/* 002498 80001898 26100001 */  addiu $s0, $s0, 1
/* 00249C 8000189C 00107C00 */  sll   $t7, $s0, 0x10
/* 0024A0 800018A0 000F8403 */  sra   $s0, $t7, 0x10
/* 0024A4 800018A4 0219082A */  slt   $at, $s0, $t9
/* 0024A8 800018A8 1420FFD0 */  bnez  $at, .L800017EC
/* 0024AC 800018AC 00000000 */   nop   
.L800018B0:
/* 0024B0 800018B0 0C0089D1 */  jal   KenStartegy
/* 0024B4 800018B4 00000000 */   nop   
.L800018B8:
/* 0024B8 800018B8 0C01681C */  jal   KWGameFramesYori
/* 0024BC 800018BC 00000000 */   nop   
/* 0024C0 800018C0 0C000D54 */  jal   SetGraphCPUTime
/* 0024C4 800018C4 24040001 */   li    $a0, 1
/* 0024C8 800018C8 3C01800E */  lui   $at, %hi(gVideoFrame) # $at, 0x800e
/* 0024CC 800018CC 0C0A9F02 */  jal   StoreSegments
/* 0024D0 800018D0 A420C58C */   sh    $zero, %lo(gVideoFrame)($at)
/* 0024D4 800018D4 0C0A8F8F */  jal   InitRDP
/* 0024D8 800018D8 00000000 */   nop   
/* 0024DC 800018DC 3C09800E */  lui   $t1, %hi(gClearCFBFlag) # $t1, 0x800e
/* 0024E0 800018E0 9529C5B0 */  lhu   $t1, %lo(gClearCFBFlag)($t1)
/* 0024E4 800018E4 11200003 */  beqz  $t1, .L800018F4
/* 0024E8 800018E8 00000000 */   nop   
/* 0024EC 800018EC 0C0A9075 */  jal   ClearFrameBuffer
/* 0024F0 800018F0 00000000 */   nop   
.L800018F4:
/* 0024F4 800018F4 3C0A800E */  lui   $t2, %hi(gWinKart) # $t2, 0x800e
/* 0024F8 800018F8 8D4AC5E8 */  lw    $t2, %lo(gWinKart)($t2)
/* 0024FC 800018FC 3C018016 */  lui   $at, %hi(gScreenCounter) # $at, 0x8016
/* 002500 80001900 AC20F788 */  sw    $zero, %lo(gScreenCounter)($at)
/* 002504 80001904 15400007 */  bnez  $t2, .L80001924
/* 002508 80001908 00000000 */   nop   
/* 00250C 8000190C 0C0A97EB */  jal   DrawRightScreen
/* 002510 80001910 00000000 */   nop   
/* 002514 80001914 0C0A972D */  jal   DrawLeftScreen
/* 002518 80001918 00000000 */   nop   
/* 00251C 8000191C 10000005 */  b     .L80001934
/* 002520 80001920 00000000 */   nop   
.L80001924:
/* 002524 80001924 0C0A972D */  jal   DrawLeftScreen
/* 002528 80001928 00000000 */   nop   
/* 00252C 8000192C 0C0A97EB */  jal   DrawRightScreen
/* 002530 80001930 00000000 */   nop   
.L80001934:
/* 002534 80001934 3C04800E */  lui   $a0, %hi(gDebugFlag) # $a0, 0x800e
/* 002538 80001938 10000122 */  b     .L80001DC4
/* 00253C 8000193C 9484C520 */   lhu   $a0, %lo(gDebugFlag)($a0)
.L80001940:
/* 002540 80001940 856BC5A0 */  lh    $t3, -0x3a60($t3)
/* 002544 80001944 24010012 */  li    $at, 18
/* 002548 80001948 24030003 */  li    $v1, 3
/* 00254C 8000194C 15610004 */  bne   $t3, $at, .L80001960
/* 002550 80001950 240C0002 */   li    $t4, 2
/* 002554 80001954 3C018015 */  lui   $at, %hi(gFramerate) # $at, 0x8015
/* 002558 80001958 10000003 */  b     .L80001968
/* 00255C 8000195C AC230114 */   sw    $v1, %lo(gFramerate)($at)
.L80001960:
/* 002560 80001960 3C018015 */  lui   $at, %hi(gFramerate) # $at, 0x8015
/* 002564 80001964 AC2C0114 */  sw    $t4, %lo(gFramerate)($at)
.L80001968:
/* 002568 80001968 960D0000 */  lhu   $t5, ($s0)
/* 00256C 8000196C 3C0E8015 */  lui   $t6, %hi(gFramerate) # $t6, 0x8015
/* 002570 80001970 15A0003B */  bnez  $t5, .L80001A60
/* 002574 80001974 00000000 */   nop   
/* 002578 80001978 8DCE0114 */  lw    $t6, %lo(gFramerate)($t6)
/* 00257C 8000197C 00008025 */  move  $s0, $zero
/* 002580 80001980 3C01800F */  lui   $at, %hi(D_800EB608)
/* 002584 80001984 19C00034 */  blez  $t6, .L80001A58
/* 002588 80001988 3C11800E */   lui   $s1, %hi(gRaceTimer) # $s1, 0x800e
/* 00258C 8000198C D434B608 */  ldc1  $f20, %lo(D_800EB608)($at)
/* 002590 80001990 2631C598 */  addiu $s1, %lo(gRaceTimer) # addiu $s1, $s1, -0x3a68
.L80001994:
/* 002594 80001994 3C0F8015 */  lui   $t7, %hi(gTimeFlag) # $t7, 0x8015
/* 002598 80001998 95EF011E */  lhu   $t7, %lo(gTimeFlag)($t7)
/* 00259C 8000199C 11E00006 */  beqz  $t7, .L800019B8
/* 0025A0 800019A0 00000000 */   nop   
/* 0025A4 800019A4 C6280000 */  lwc1  $f8, ($s1)
/* 0025A8 800019A8 460042A1 */  cvt.d.s $f10, $f8
/* 0025AC 800019AC 46345400 */  add.d $f16, $f10, $f20
/* 0025B0 800019B0 462084A0 */  cvt.s.d $f18, $f16
/* 0025B4 800019B4 E6320000 */  swc1  $f18, ($s1)
.L800019B8:
/* 0025B8 800019B8 0C0A427C */  jal   CollisionKartToKart
/* 0025BC 800019BC 00000000 */   nop   
/* 0025C0 800019C0 0C0A8355 */  jal   CollisionObjectToKart
/* 0025C4 800019C4 00000000 */   nop   
/* 0025C8 800019C8 0C00E0B7 */  jal   DriveStickControl
/* 0025CC 800019CC 00000000 */   nop   
/* 0025D0 800019D0 3C04800E */  lui   $a0, %hi(gMyKart1) # $a0, 0x800e
/* 0025D4 800019D4 3C05800E */  lui   $a1, %hi(gCamera1) # $a1, 0x800e
/* 0025D8 800019D8 8CA5DB40 */  lw    $a1, %lo(gCamera1)($a1)
/* 0025DC 800019DC 8C84C4FC */  lw    $a0, %lo(gMyKart1)($a0)
/* 0025E0 800019E0 0C007BA6 */  jal   CameraControl
/* 0025E4 800019E4 00003025 */   move  $a2, $zero
/* 0025E8 800019E8 0C00A418 */  jal   KartPosControlRU
/* 0025EC 800019EC 00000000 */   nop   
/* 0025F0 800019F0 3C04800E */  lui   $a0, %hi(gMyKart2) # $a0, 0x800e
/* 0025F4 800019F4 3C05800E */  lui   $a1, %hi(gCamera2) # $a1, 0x800e
/* 0025F8 800019F8 8CA5DB44 */  lw    $a1, %lo(gCamera2)($a1)
/* 0025FC 800019FC 8C84C500 */  lw    $a0, %lo(gMyKart2)($a0)
/* 002600 80001A00 0C007BA6 */  jal   CameraControl
/* 002604 80001A04 24060001 */   li    $a2, 1
/* 002608 80001A08 0C00A454 */  jal   KartPosControlLD
/* 00260C 80001A0C 00000000 */   nop   
/* 002610 80001A10 0C0A3D1D */  jal   EnemyControl
/* 002614 80001A14 00000000 */   nop   
/* 002618 80001A18 0C0166B2 */  jal   KWVideoFramesYori
/* 00261C 80001A1C 00000000 */   nop   
/* 002620 80001A20 0C0A8D52 */  jal   ObjectStrategy1
/* 002624 80001A24 00000000 */   nop   
/* 002628 80001A28 0C0A59A8 */  jal   MapStrategy
/* 00262C 80001A2C 00000000 */   nop   
/* 002630 80001A30 0C0A3F2F */  jal   RaceControl
/* 002634 80001A34 00000000 */   nop   
/* 002638 80001A38 3C098015 */  lui   $t1, %hi(gFramerate) # $t1, 0x8015
/* 00263C 80001A3C 8D290114 */  lw    $t1, %lo(gFramerate)($t1)
/* 002640 80001A40 26100001 */  addiu $s0, $s0, 1
/* 002644 80001A44 0010C400 */  sll   $t8, $s0, 0x10
/* 002648 80001A48 00188403 */  sra   $s0, $t8, 0x10
/* 00264C 80001A4C 0209082A */  slt   $at, $s0, $t1
/* 002650 80001A50 1420FFD0 */  bnez  $at, .L80001994
/* 002654 80001A54 00000000 */   nop   
.L80001A58:
/* 002658 80001A58 0C0089D1 */  jal   KenStartegy
/* 00265C 80001A5C 00000000 */   nop   
.L80001A60:
/* 002660 80001A60 0C000D54 */  jal   SetGraphCPUTime
/* 002664 80001A64 24040001 */   li    $a0, 1
/* 002668 80001A68 3C01800E */  lui   $at, %hi(gVideoFrame) # $at, 0x800e
/* 00266C 80001A6C 0C01681C */  jal   KWGameFramesYori
/* 002670 80001A70 A420C58C */   sh    $zero, %lo(gVideoFrame)($at)
/* 002674 80001A74 0C0A9F02 */  jal   StoreSegments
/* 002678 80001A78 00000000 */   nop   
/* 00267C 80001A7C 0C0A8F8F */  jal   InitRDP
/* 002680 80001A80 00000000 */   nop   
/* 002684 80001A84 3C0A800E */  lui   $t2, %hi(gClearCFBFlag) # $t2, 0x800e
/* 002688 80001A88 954AC5B0 */  lhu   $t2, %lo(gClearCFBFlag)($t2)
/* 00268C 80001A8C 11400003 */  beqz  $t2, .L80001A9C
/* 002690 80001A90 00000000 */   nop   
/* 002694 80001A94 0C0A9075 */  jal   ClearFrameBuffer
/* 002698 80001A98 00000000 */   nop   
.L80001A9C:
/* 00269C 80001A9C 3C0B800E */  lui   $t3, %hi(gWinKart) # $t3, 0x800e
/* 0026A0 80001AA0 8D6BC5E8 */  lw    $t3, %lo(gWinKart)($t3)
/* 0026A4 80001AA4 3C018016 */  lui   $at, %hi(gScreenCounter) # $at, 0x8016
/* 0026A8 80001AA8 AC20F788 */  sw    $zero, %lo(gScreenCounter)($at)
/* 0026AC 80001AAC 15600007 */  bnez  $t3, .L80001ACC
/* 0026B0 80001AB0 00000000 */   nop   
/* 0026B4 80001AB4 0C0A996E */  jal   DrawDownScreen
/* 0026B8 80001AB8 00000000 */   nop   
/* 0026BC 80001ABC 0C0A98A9 */  jal   DrawUpScreen
/* 0026C0 80001AC0 00000000 */   nop   
/* 0026C4 80001AC4 10000005 */  b     .L80001ADC
/* 0026C8 80001AC8 00000000 */   nop   
.L80001ACC:
/* 0026CC 80001ACC 0C0A98A9 */  jal   DrawUpScreen
/* 0026D0 80001AD0 00000000 */   nop   
/* 0026D4 80001AD4 0C0A996E */  jal   DrawDownScreen
/* 0026D8 80001AD8 00000000 */   nop   
.L80001ADC:
/* 0026DC 80001ADC 3C04800E */  lui   $a0, %hi(gDebugFlag) # $a0, 0x800e
/* 0026E0 80001AE0 100000B8 */  b     .L80001DC4
/* 0026E4 80001AE4 9484C520 */   lhu   $a0, %lo(gDebugFlag)($a0)
.L80001AE8:
/* 0026E8 80001AE8 8D8CC538 */  lw    $t4, -0x3ac8($t4)
/* 0026EC 80001AEC 3C02800E */  lui   $v0, 0x800e
/* 0026F0 80001AF0 3C0F8015 */  lui   $t7, %hi(gFramerate) # $t7, 0x8015
/* 0026F4 80001AF4 146C0011 */  bne   $v1, $t4, .L80001B3C
/* 0026F8 80001AF8 00000000 */   nop   
/* 0026FC 80001AFC 3C02800E */  lui   $v0, %hi(gMapNumber) # $v0, 0x800e
/* 002700 80001B00 8442C5A0 */  lh    $v0, %lo(gMapNumber)($v0)
/* 002704 80001B04 24010009 */  li    $at, 9
/* 002708 80001B08 10440009 */  beq   $v0, $a0, .L80001B30
/* 00270C 80001B0C 00000000 */   nop   
/* 002710 80001B10 10410007 */  beq   $v0, $at, .L80001B30
/* 002714 80001B14 24010010 */   li    $at, 16
/* 002718 80001B18 10410005 */  beq   $v0, $at, .L80001B30
/* 00271C 80001B1C 24010012 */   li    $at, 18
/* 002720 80001B20 10410003 */  beq   $v0, $at, .L80001B30
/* 002724 80001B24 3C018015 */   lui   $at, %hi(gFramerate) # $at, 0x8015
/* 002728 80001B28 10000016 */  b     .L80001B84
/* 00272C 80001B2C AC240114 */   sw    $a0, %lo(gFramerate)($at)
.L80001B30:
/* 002730 80001B30 3C018015 */  lui   $at, %hi(gFramerate) # $at, 0x8015
/* 002734 80001B34 10000013 */  b     .L80001B84
/* 002738 80001B38 AC230114 */   sw    $v1, %lo(gFramerate)($at)
.L80001B3C:
/* 00273C 80001B3C 8442C5A0 */  lh    $v0, %lo(gMapNumber)($v0)
/* 002740 80001B40 2401000F */  li    $at, 15
/* 002744 80001B44 1041000A */  beq   $v0, $at, .L80001B70
/* 002748 80001B48 24010011 */   li    $at, 17
/* 00274C 80001B4C 10410008 */  beq   $v0, $at, .L80001B70
/* 002750 80001B50 24010012 */   li    $at, 18
/* 002754 80001B54 10410009 */  beq   $v0, $at, .L80001B7C
/* 002758 80001B58 240D0004 */   li    $t5, 4
/* 00275C 80001B5C 24010013 */  li    $at, 19
/* 002760 80001B60 10410003 */  beq   $v0, $at, .L80001B70
/* 002764 80001B64 3C018015 */   lui   $at, %hi(gFramerate) # $at, 0x8015
/* 002768 80001B68 10000006 */  b     .L80001B84
/* 00276C 80001B6C AC230114 */   sw    $v1, %lo(gFramerate)($at)
.L80001B70:
/* 002770 80001B70 3C018015 */  lui   $at, %hi(gFramerate) # $at, 0x8015
/* 002774 80001B74 10000003 */  b     .L80001B84
/* 002778 80001B78 AC240114 */   sw    $a0, %lo(gFramerate)($at)
.L80001B7C:
/* 00277C 80001B7C 3C018015 */  lui   $at, %hi(gFramerate) # $at, 0x8015
/* 002780 80001B80 AC2D0114 */  sw    $t5, %lo(gFramerate)($at)
.L80001B84:
/* 002784 80001B84 960E0000 */  lhu   $t6, ($s0)
/* 002788 80001B88 15C0004B */  bnez  $t6, .L80001CB8
/* 00278C 80001B8C 00000000 */   nop   
/* 002790 80001B90 8DEF0114 */  lw    $t7, %lo(gFramerate)($t7)
/* 002794 80001B94 00008025 */  move  $s0, $zero
/* 002798 80001B98 3C01800F */  lui   $at, %hi(D_800EB610)
/* 00279C 80001B9C 19E00044 */  blez  $t7, .L80001CB0
/* 0027A0 80001BA0 3C11800E */   lui   $s1, %hi(gRaceTimer) # $s1, 0x800e
/* 0027A4 80001BA4 D434B610 */  ldc1  $f20, %lo(D_800EB610)($at)
/* 0027A8 80001BA8 2631C598 */  addiu $s1, %lo(gRaceTimer) # addiu $s1, $s1, -0x3a68
.L80001BAC:
/* 0027AC 80001BAC 3C188015 */  lui   $t8, %hi(gTimeFlag) # $t8, 0x8015
/* 0027B0 80001BB0 9718011E */  lhu   $t8, %lo(gTimeFlag)($t8)
/* 0027B4 80001BB4 13000006 */  beqz  $t8, .L80001BD0
/* 0027B8 80001BB8 00000000 */   nop   
/* 0027BC 80001BBC C6240000 */  lwc1  $f4, ($s1)
/* 0027C0 80001BC0 460021A1 */  cvt.d.s $f6, $f4
/* 0027C4 80001BC4 46343200 */  add.d $f8, $f6, $f20
/* 0027C8 80001BC8 462042A0 */  cvt.s.d $f10, $f8
/* 0027CC 80001BCC E62A0000 */  swc1  $f10, ($s1)
.L80001BD0:
/* 0027D0 80001BD0 0C0A427C */  jal   CollisionKartToKart
/* 0027D4 80001BD4 00000000 */   nop   
/* 0027D8 80001BD8 0C0A8355 */  jal   CollisionObjectToKart
/* 0027DC 80001BDC 00000000 */   nop   
/* 0027E0 80001BE0 0C00E0B7 */  jal   DriveStickControl
/* 0027E4 80001BE4 00000000 */   nop   
/* 0027E8 80001BE8 3C04800E */  lui   $a0, %hi(gMyKart1) # $a0, 0x800e
/* 0027EC 80001BEC 3C05800E */  lui   $a1, %hi(gCamera1) # $a1, 0x800e
/* 0027F0 80001BF0 8CA5DB40 */  lw    $a1, %lo(gCamera1)($a1)
/* 0027F4 80001BF4 8C84C4FC */  lw    $a0, %lo(gMyKart1)($a0)
/* 0027F8 80001BF8 0C007BA6 */  jal   CameraControl
/* 0027FC 80001BFC 00003025 */   move  $a2, $zero
/* 002800 80001C00 0C00A456 */  jal   KartPosControl1P
/* 002804 80001C04 00000000 */   nop   
/* 002808 80001C08 3C04800E */  lui   $a0, %hi(gKart2) # $a0, 0x800e
/* 00280C 80001C0C 3C05800E */  lui   $a1, %hi(gCamera2) # $a1, 0x800e
/* 002810 80001C10 8CA5DB44 */  lw    $a1, %lo(gCamera2)($a1)
/* 002814 80001C14 8C84C4E0 */  lw    $a0, %lo(gKart2)($a0)
/* 002818 80001C18 0C007BA6 */  jal   CameraControl
/* 00281C 80001C1C 24060001 */   li    $a2, 1
/* 002820 80001C20 0C00A47A */  jal   KartPosControl2P
/* 002824 80001C24 00000000 */   nop   
/* 002828 80001C28 3C04800E */  lui   $a0, %hi(gKart3) # $a0, 0x800e
/* 00282C 80001C2C 3C05800E */  lui   $a1, %hi(gCamera3) # $a1, 0x800e
/* 002830 80001C30 8CA5DB48 */  lw    $a1, %lo(gCamera3)($a1)
/* 002834 80001C34 8C84C4E4 */  lw    $a0, %lo(gKart3)($a0)
/* 002838 80001C38 0C007BA6 */  jal   CameraControl
/* 00283C 80001C3C 24060002 */   li    $a2, 2
/* 002840 80001C40 0C00A47C */  jal   KartPosControl3P
/* 002844 80001C44 00000000 */   nop   
/* 002848 80001C48 3C04800E */  lui   $a0, %hi(gKart4) # $a0, 0x800e
/* 00284C 80001C4C 3C05800E */  lui   $a1, %hi(gCamera4) # $a1, 0x800e
/* 002850 80001C50 8CA5DB4C */  lw    $a1, %lo(gCamera4)($a1)
/* 002854 80001C54 8C84C4E8 */  lw    $a0, %lo(gKart4)($a0)
/* 002858 80001C58 0C007BA6 */  jal   CameraControl
/* 00285C 80001C5C 24060003 */   li    $a2, 3
/* 002860 80001C60 0C00A47E */  jal   KartPosControl4P
/* 002864 80001C64 00000000 */   nop   
/* 002868 80001C68 0C0A3D1D */  jal   EnemyControl
/* 00286C 80001C6C 00000000 */   nop   
/* 002870 80001C70 0C0166B2 */  jal   KWVideoFramesYori
/* 002874 80001C74 00000000 */   nop   
/* 002878 80001C78 0C0A8D52 */  jal   ObjectStrategy1
/* 00287C 80001C7C 00000000 */   nop   
/* 002880 80001C80 0C0A59A8 */  jal   MapStrategy
/* 002884 80001C84 00000000 */   nop   
/* 002888 80001C88 0C0A3F2F */  jal   RaceControl
/* 00288C 80001C8C 00000000 */   nop   
/* 002890 80001C90 3C0A8015 */  lui   $t2, %hi(gFramerate) # $t2, 0x8015
/* 002894 80001C94 8D4A0114 */  lw    $t2, %lo(gFramerate)($t2)
/* 002898 80001C98 26100001 */  addiu $s0, $s0, 1
/* 00289C 80001C9C 0010CC00 */  sll   $t9, $s0, 0x10
/* 0028A0 80001CA0 00198403 */  sra   $s0, $t9, 0x10
/* 0028A4 80001CA4 020A082A */  slt   $at, $s0, $t2
/* 0028A8 80001CA8 1420FFC0 */  bnez  $at, .L80001BAC
/* 0028AC 80001CAC 00000000 */   nop   
.L80001CB0:
/* 0028B0 80001CB0 0C0089D1 */  jal   KenStartegy
/* 0028B4 80001CB4 00000000 */   nop   
.L80001CB8:
/* 0028B8 80001CB8 0C01681C */  jal   KWGameFramesYori
/* 0028BC 80001CBC 00000000 */   nop   
/* 0028C0 80001CC0 3C01800E */  lui   $at, %hi(gVideoFrame) # $at, 0x800e
/* 0028C4 80001CC4 A420C58C */  sh    $zero, %lo(gVideoFrame)($at)
/* 0028C8 80001CC8 0C000D54 */  jal   SetGraphCPUTime
/* 0028CC 80001CCC 24040001 */   li    $a0, 1
/* 0028D0 80001CD0 0C0A9F02 */  jal   StoreSegments
/* 0028D4 80001CD4 00000000 */   nop   
/* 0028D8 80001CD8 0C0A8F8F */  jal   InitRDP
/* 0028DC 80001CDC 00000000 */   nop   
/* 0028E0 80001CE0 3C0B800E */  lui   $t3, %hi(gClearCFBFlag) # $t3, 0x800e
/* 0028E4 80001CE4 956BC5B0 */  lhu   $t3, %lo(gClearCFBFlag)($t3)
/* 0028E8 80001CE8 11600003 */  beqz  $t3, .L80001CF8
/* 0028EC 80001CEC 00000000 */   nop   
/* 0028F0 80001CF0 0C0A9075 */  jal   ClearFrameBuffer
/* 0028F4 80001CF4 00000000 */   nop   
.L80001CF8:
/* 0028F8 80001CF8 3C02800E */  lui   $v0, %hi(gWinKart) # $v0, 0x800e
/* 0028FC 80001CFC 8C42C5E8 */  lw    $v0, %lo(gWinKart)($v0)
/* 002900 80001D00 3C018016 */  lui   $at, %hi(gScreenCounter) # $at, 0x8016
/* 002904 80001D04 AC20F788 */  sw    $zero, %lo(gScreenCounter)($at)
/* 002908 80001D08 1440000B */  bnez  $v0, .L80001D38
/* 00290C 80001D0C 24010001 */   li    $at, 1
/* 002910 80001D10 0C0A9AEC */  jal   DrawUpRightScreen
/* 002914 80001D14 00000000 */   nop   
/* 002918 80001D18 0C0A9BA5 */  jal   DrawDownLeftScreen
/* 00291C 80001D1C 00000000 */   nop   
/* 002920 80001D20 0C0A9C5E */  jal   DrawDownRightScreen
/* 002924 80001D24 00000000 */   nop   
/* 002928 80001D28 0C0A9A33 */  jal   DrawUpLeftScreen
/* 00292C 80001D2C 00000000 */   nop   
/* 002930 80001D30 10000022 */  b     .L80001DBC
/* 002934 80001D34 00000000 */   nop   
.L80001D38:
/* 002938 80001D38 5441000C */  bnel  $v0, $at, .L80001D6C
/* 00293C 80001D3C 24010002 */   li    $at, 2
/* 002940 80001D40 0C0A9A33 */  jal   DrawUpLeftScreen
/* 002944 80001D44 00000000 */   nop   
/* 002948 80001D48 0C0A9BA5 */  jal   DrawDownLeftScreen
/* 00294C 80001D4C 00000000 */   nop   
/* 002950 80001D50 0C0A9C5E */  jal   DrawDownRightScreen
/* 002954 80001D54 00000000 */   nop   
/* 002958 80001D58 0C0A9AEC */  jal   DrawUpRightScreen
/* 00295C 80001D5C 00000000 */   nop   
/* 002960 80001D60 10000016 */  b     .L80001DBC
/* 002964 80001D64 00000000 */   nop   
/* 002968 80001D68 24010002 */  li    $at, 2
.L80001D6C:
/* 00296C 80001D6C 1441000B */  bne   $v0, $at, .L80001D9C
/* 002970 80001D70 00000000 */   nop   
/* 002974 80001D74 0C0A9A33 */  jal   DrawUpLeftScreen
/* 002978 80001D78 00000000 */   nop   
/* 00297C 80001D7C 0C0A9AEC */  jal   DrawUpRightScreen
/* 002980 80001D80 00000000 */   nop   
/* 002984 80001D84 0C0A9C5E */  jal   DrawDownRightScreen
/* 002988 80001D88 00000000 */   nop   
/* 00298C 80001D8C 0C0A9BA5 */  jal   DrawDownLeftScreen
/* 002990 80001D90 00000000 */   nop   
/* 002994 80001D94 10000009 */  b     .L80001DBC
/* 002998 80001D98 00000000 */   nop   
.L80001D9C:
/* 00299C 80001D9C 0C0A9A33 */  jal   DrawUpLeftScreen
/* 0029A0 80001DA0 00000000 */   nop   
/* 0029A4 80001DA4 0C0A9AEC */  jal   DrawUpRightScreen
/* 0029A8 80001DA8 00000000 */   nop   
/* 0029AC 80001DAC 0C0A9BA5 */  jal   DrawDownLeftScreen
/* 0029B0 80001DB0 00000000 */   nop   
/* 0029B4 80001DB4 0C0A9C5E */  jal   DrawDownRightScreen
/* 0029B8 80001DB8 00000000 */   nop   
.L80001DBC:
/* 0029BC 80001DBC 3C04800E */  lui   $a0, %hi(gDebugFlag) # $a0, 0x800e
/* 0029C0 80001DC0 9484C520 */  lhu   $a0, %lo(gDebugFlag)($a0)
.L80001DC4:
/* 0029C4 80001DC4 14800005 */  bnez  $a0, .L80001DDC
/* 0029C8 80001DC8 3C10800E */   lui   $s0, %hi(gEnableResourceMeters)
/* 0029CC 80001DCC 3C10800E */  lui   $s0, %hi(gEnableResourceMeters) # $s0, 0x800e
/* 0029D0 80001DD0 2610C660 */  addiu $s0, %lo(gEnableResourceMeters) # addiu $s0, $s0, -0x39a0
/* 0029D4 80001DD4 10000023 */  b     .L80001E64
/* 0029D8 80001DD8 AE000000 */   sw    $zero, ($s0)
.L80001DDC:
/* 0029DC 80001DDC 2610C660 */  addiu $s0, $s0, %lo(gEnableResourceMeters)
/* 0029E0 80001DE0 8E0C0000 */  lw    $t4, ($s0)
/* 0029E4 80001DE4 3C03800E */  lui   $v1, %hi(gCont1P)
/* 0029E8 80001DE8 11800011 */  beqz  $t4, .L80001E30
/* 0029EC 80001DEC 00000000 */   nop   
/* 0029F0 80001DF0 0C000FF5 */  jal   resource_display
/* 0029F4 80001DF4 00000000 */   nop   
/* 0029F8 80001DF8 3C03800E */  lui   $v1, %hi(gCont1P) # $v1, 0x800e
/* 0029FC 80001DFC 8C63C4BC */  lw    $v1, %lo(gCont1P)($v1)
/* 002A00 80001E00 94620004 */  lhu   $v0, 4($v1)
/* 002A04 80001E04 304D0020 */  andi  $t5, $v0, 0x20
/* 002A08 80001E08 15A00016 */  bnez  $t5, .L80001E64
/* 002A0C 80001E0C 304E0010 */   andi  $t6, $v0, 0x10
/* 002A10 80001E10 11C00014 */  beqz  $t6, .L80001E64
/* 002A14 80001E14 00000000 */   nop   
/* 002A18 80001E18 946F0006 */  lhu   $t7, 6($v1)
/* 002A1C 80001E1C 31F84000 */  andi  $t8, $t7, 0x4000
/* 002A20 80001E20 13000010 */  beqz  $t8, .L80001E64
/* 002A24 80001E24 00000000 */   nop   
/* 002A28 80001E28 1000000E */  b     .L80001E64
/* 002A2C 80001E2C AE000000 */   sw    $zero, ($s0)
.L80001E30:
/* 002A30 80001E30 8C63C4BC */  lw    $v1, %lo(gCont1P)($v1)
/* 002A34 80001E34 94620004 */  lhu   $v0, 4($v1)
/* 002A38 80001E38 30590020 */  andi  $t9, $v0, 0x20
/* 002A3C 80001E3C 17200009 */  bnez  $t9, .L80001E64
/* 002A40 80001E40 30490010 */   andi  $t1, $v0, 0x10
/* 002A44 80001E44 11200007 */  beqz  $t1, .L80001E64
/* 002A48 80001E48 00000000 */   nop   
/* 002A4C 80001E4C 946A0006 */  lhu   $t2, 6($v1)
/* 002A50 80001E50 240C0001 */  li    $t4, 1
/* 002A54 80001E54 314B4000 */  andi  $t3, $t2, 0x4000
/* 002A58 80001E58 11600002 */  beqz  $t3, .L80001E64
/* 002A5C 80001E5C 00000000 */   nop   
/* 002A60 80001E60 AE0C0000 */  sw    $t4, ($s0)
.L80001E64:
/* 002A64 80001E64 0C0A90C0 */  jal   MakeBorder
/* 002A68 80001E68 00000000 */   nop   
/* 002A6C 80001E6C 0C01646D */  jal   KWDisplayToppri
/* 002A70 80001E70 00000000 */   nop   
/* 002A74 80001E74 0C024F88 */  jal   KawanoDrawFinal
/* 002A78 80001E78 00000000 */   nop   
/* 002A7C 80001E7C 3C058015 */  lui   $a1, %hi(gGraphPtr) # $a1, 0x8015
/* 002A80 80001E80 24A50298 */  addiu $a1, %lo(gGraphPtr) # addiu $a1, $a1, 0x298
/* 002A84 80001E84 8CA20000 */  lw    $v0, ($a1)
/* 002A88 80001E88 3C0EE900 */  lui   $t6, 0xe900
/* 002A8C 80001E8C 3C18B800 */  lui   $t8, 0xb800
/* 002A90 80001E90 244D0008 */  addiu $t5, $v0, 8
/* 002A94 80001E94 ACAD0000 */  sw    $t5, ($a1)
/* 002A98 80001E98 AC400004 */  sw    $zero, 4($v0)
/* 002A9C 80001E9C AC4E0000 */  sw    $t6, ($v0)
/* 002AA0 80001EA0 8CA20000 */  lw    $v0, ($a1)
/* 002AA4 80001EA4 244F0008 */  addiu $t7, $v0, 8
/* 002AA8 80001EA8 ACAF0000 */  sw    $t7, ($a1)
/* 002AAC 80001EAC AC400004 */  sw    $zero, 4($v0)
/* 002AB0 80001EB0 AC580000 */  sw    $t8, ($v0)
/* 002AB4 80001EB4 8FBF0024 */  lw    $ra, 0x24($sp)
.L80001EB8:
/* 002AB8 80001EB8 D7B40010 */  ldc1  $f20, 0x10($sp)
/* 002ABC 80001EBC 8FB0001C */  lw    $s0, 0x1c($sp)
/* 002AC0 80001EC0 8FB10020 */  lw    $s1, 0x20($sp)
/* 002AC4 80001EC4 03E00008 */  jr    $ra
/* 002AC8 80001EC8 27BD0028 */   addiu $sp, $sp, 0x28

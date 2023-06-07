glabel thread5_game_logic
/* 00337C 8000277C 27BDFFE0 */  addiu $sp, $sp, -0x20
/* 003380 80002780 AFA40020 */  sw    $a0, 0x20($sp)
/* 003384 80002784 AFBF001C */  sw    $ra, 0x1c($sp)
/* 003388 80002788 3C048015 */  lui   $a0, %hi(gRdpMessageQ) # $a0, 0x8015
/* 00338C 8000278C 3C058015 */  lui   $a1, %hi(gRdpMessageBuf) # $a1, 0x8015
/* 003390 80002790 AFB10018 */  sw    $s1, 0x18($sp)
/* 003394 80002794 AFB00014 */  sw    $s0, 0x14($sp)
/* 003398 80002798 24A5F00C */  addiu $a1, %lo(gRdpMessageBuf) # addiu $a1, $a1, -0xff4
/* 00339C 8000279C 2484EF88 */  addiu $a0, %lo(gRdpMessageQ) # addiu $a0, $a0, -0x1078
/* 0033A0 800027A0 0C033358 */  jal   osCreateMesgQueue
/* 0033A4 800027A4 24060001 */   li    $a2, 1
/* 0033A8 800027A8 3C108015 */  lui   $s0, %hi(gRtcMessageQ) # $s0, 0x8015
/* 0033AC 800027AC 2610EF70 */  addiu $s0, %lo(gRtcMessageQ) # addiu $s0, $s0, -0x1090
/* 0033B0 800027B0 3C058015 */  lui   $a1, %hi(gRtcMessageBuf) # $a1, 0x8015
/* 0033B4 800027B4 24A5F008 */  addiu $a1, %lo(gRtcMessageBuf) # addiu $a1, $a1, -0xff8
/* 0033B8 800027B8 02002025 */  move  $a0, $s0
/* 0033BC 800027BC 0C033358 */  jal   osCreateMesgQueue
/* 0033C0 800027C0 24060001 */   li    $a2, 1
/* 0033C4 800027C4 0C000229 */  jal   InitalizeController
/* 0033C8 800027C8 00000000 */   nop   
/* 0033CC 800027CC 3C0E8015 */  lui   $t6, %hi(gResetType) # $t6, 0x8015
/* 0033D0 800027D0 95CE011C */  lhu   $t6, %lo(gResetType)($t6)
/* 0033D4 800027D4 15C00003 */  bnez  $t6, .L800027E4
/* 0033D8 800027D8 00000000 */   nop   
/* 0033DC 800027DC 0C000C04 */  jal   InitializeFirstOnce
/* 0033E0 800027E0 00000000 */   nop   
.L800027E4:
/* 0033E4 800027E4 3C058015 */  lui   $a1, %hi(gGfxClient) # $a1, 0x8015
/* 0033E8 800027E8 24A5EF48 */  addiu $a1, %lo(gGfxClient) # addiu $a1, $a1, -0x10b8
/* 0033EC 800027EC 24040002 */  li    $a0, 2
/* 0033F0 800027F0 02003025 */  move  $a2, $s0
/* 0033F4 800027F4 0C000836 */  jal   SetClient
/* 0033F8 800027F8 24070001 */   li    $a3, 1
/* 0033FC 800027FC 3C02800E */  lui   $v0, %hi(gSaveBuffer) # $v0, 0x800e
/* 003400 80002800 8C42C600 */  lw    $v0, %lo(gSaveBuffer)($v0)
/* 003404 80002804 3C018016 */  lui   $at, %hi(gWinCount2p) # $at, 0x8016
/* 003408 80002808 AC22F8B8 */  sw    $v0, %lo(gWinCount2p)($at)
/* 00340C 8000280C 3C018016 */  lui   $at, %hi(gWinCount3p) # $at, 0x8016
/* 003410 80002810 244F0002 */  addiu $t7, $v0, 2
/* 003414 80002814 AC2FF8BC */  sw    $t7, %lo(gWinCount3p)($at)
/* 003418 80002818 3C018016 */  lui   $at, %hi(gWincount4p) # $at, 0x8016
/* 00341C 8000281C 2458000B */  addiu $t8, $v0, 0xb
/* 003420 80002820 AC38F8C0 */  sw    $t8, %lo(gWincount4p)($at)
/* 003424 80002824 3C018016 */  lui   $at, %hi(gBattleWinCount2P) # $at, 0x8016
/* 003428 80002828 24590017 */  addiu $t9, $v0, 0x17
/* 00342C 8000282C AC39F8C4 */  sw    $t9, %lo(gBattleWinCount2P)($at)
/* 003430 80002830 3C018016 */  lui   $at, %hi(gBattleWinCount3P) # $at, 0x8016
/* 003434 80002834 24480019 */  addiu $t0, $v0, 0x19
/* 003438 80002838 AC28F8C8 */  sw    $t0, %lo(gBattleWinCount3P)($at)
/* 00343C 8000283C 3C018016 */  lui   $at, %hi(gBattleWinCount4P) # $at, 0x8016
/* 003440 80002840 2449001C */  addiu $t1, $v0, 0x1c
/* 003444 80002844 0C000380 */  jal   InitialGameframe
/* 003448 80002848 AC29F8CC */   sw    $t1, %lo(gBattleWinCount4P)($at)
/* 00344C 8000284C 0C00028A */  jal   ReadController
/* 003450 80002850 00000000 */   nop   
/* 003454 80002854 0C03172E */  jal   NaSeSeqStart
/* 003458 80002858 00000000 */   nop   
/* 00345C 8000285C 3C11800E */  lui   $s1, %hi(gNewSequenceMode) # $s1, 0x800e
/* 003460 80002860 3C10800E */  lui   $s0, %hi(gSequenceMode) # $s0, 0x800e
/* 003464 80002864 2610C50C */  addiu $s0, %lo(gSequenceMode) # addiu $s0, $s0, -0x3af4
/* 003468 80002868 2631C524 */  addiu $s1, %lo(gNewSequenceMode) # addiu $s1, $s1, -0x3adc
.L8000286C:
/* 00346C 8000286C 0C032CB1 */  jal   NasAudioInput
/* 003470 80002870 00000000 */   nop   
/* 003474 80002874 8E220000 */  lw    $v0, ($s1)
/* 003478 80002878 8E0A0000 */  lw    $t2, ($s0)
/* 00347C 8000287C 11420003 */  beq   $t2, $v0, .L8000288C
/* 003480 80002880 00000000 */   nop   
/* 003484 80002884 0C0009A1 */  jal   InitializeSequence
/* 003488 80002888 AE020000 */   sw    $v0, ($s0)
.L8000288C:
/* 00348C 8000288C 0C000D54 */  jal   SetGraphCPUTime
/* 003490 80002890 00002025 */   move  $a0, $zero
/* 003494 80002894 0C0003AD */  jal   BeginGameframe
/* 003498 80002898 00000000 */   nop   
/* 00349C 8000289C 0C00028A */  jal   ReadController
/* 0034A0 800028A0 00000000 */   nop   
/* 0034A4 800028A4 0C0007B3 */  jal   ExecuteSequence
/* 0034A8 800028A8 00000000 */   nop   
/* 0034AC 800028AC 0C00033A */  jal   EndDrawing
/* 0034B0 800028B0 00000000 */   nop   
/* 0034B4 800028B4 0C0003CD */  jal   FlushDisplayList
/* 0034B8 800028B8 00000000 */   nop   
/* 0034BC 800028BC 1000FFEB */  b     .L8000286C
/* 0034C0 800028C0 00000000 */   nop   
/* 0034C4 800028C4 00000000 */  nop   
/* 0034C8 800028C8 00000000 */  nop   
/* 0034CC 800028CC 00000000 */  nop   
/* 0034D0 800028D0 8FBF001C */  lw    $ra, 0x1c($sp)
/* 0034D4 800028D4 8FB00014 */  lw    $s0, 0x14($sp)
/* 0034D8 800028D8 8FB10018 */  lw    $s1, 0x18($sp)
/* 0034DC 800028DC 03E00008 */  jr    $ra
/* 0034E0 800028E0 27BD0020 */   addiu $sp, $sp, 0x20

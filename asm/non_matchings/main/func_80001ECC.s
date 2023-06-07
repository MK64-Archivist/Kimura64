glabel ExecuteSequence
/* 002ACC 80001ECC 3C0E800E */  lui   $t6, %hi(gSequenceMode) # $t6, 0x800e
/* 002AD0 80001ED0 8DCEC50C */  lw    $t6, %lo(gSequenceMode)($t6)
/* 002AD4 80001ED4 27BDFFE8 */  addiu $sp, $sp, -0x18
/* 002AD8 80001ED8 AFBF0014 */  sw    $ra, 0x14($sp)
/* 002ADC 80001EDC 2DC1000A */  sltiu $at, $t6, 0xa
/* 002AE0 80001EE0 1020001F */  beqz  $at, .L80001F60
/* 002AE4 80001EE4 000E7080 */   sll   $t6, $t6, 2
/* 002AE8 80001EE8 3C01800F */  lui   $at, %hi(D_800EB618)
/* 002AEC 80001EEC 002E0821 */  addu  $at, $at, $t6
/* 002AF0 80001EF0 8C2EB618 */  lw    $t6, %lo(D_800EB618)($at)
/* 002AF4 80001EF4 01C00008 */  jr    $t6
/* 002AF8 80001EF8 00000000 */   nop
glabel L80001EFC
/* 002AFC 80001EFC 0C000501 */  jal   BootSequence
/* 002B00 80001F00 00000000 */   nop
/* 002B04 80001F04 10000017 */  b     .L80001F64
/* 002B08 80001F08 8FBF0014 */   lw    $ra, 0x14($sp)
glabel L80001F0C
/* 002B0C 80001F0C 0C033230 */  jal   osViBlack
/* 002B10 80001F10 00002025 */   move  $a0, $zero
/* 002B14 80001F14 0C02C0D4 */  jal   UpdateController
/* 002B18 80001F18 00000000 */   nop
/* 002B1C 80001F1C 0C00032A */  jal   BeginDrawing
/* 002B20 80001F20 00000000 */   nop
/* 002B24 80001F24 3C048015 */  lui   $a0, %hi(gDynamicIcp) # $a0, 0x8015
/* 002B28 80001F28 0C025299 */  jal   DoGameSelect
/* 002B2C 80001F2C 8C84EF40 */   lw    $a0, %lo(gDynamicIcp)($a0)
/* 002B30 80001F30 1000000C */  b     .L80001F64
/* 002B34 80001F34 8FBF0014 */   lw    $ra, 0x14($sp)
glabel L80001F38
/* 002B38 80001F38 0C00050B */  jal   RaceSequence
/* 002B3C 80001F3C 00000000 */   nop
/* 002B40 80001F40 10000008 */  b     .L80001F64
/* 002B44 80001F44 8FBF0014 */   lw    $ra, 0x14($sp)
glabel L80001F48
/* 002B48 80001F48 0C0A0552 */  jal   ResultSequence
/* 002B4C 80001F4C 00000000 */   nop
/* 002B50 80001F50 10000004 */  b     .L80001F64
/* 002B54 80001F54 8FBF0014 */   lw    $ra, 0x14($sp)
glabel L80001F58
/* 002B58 80001F58 0C0A00AB */  jal   EndingSequence
/* 002B5C 80001F5C 00000000 */   nop
.L80001F60:
glabel L80001F60
/* 002B60 80001F60 8FBF0014 */  lw    $ra, 0x14($sp)
.L80001F64:
/* 002B64 80001F64 27BD0018 */  addiu $sp, $sp, 0x18
/* 002B68 80001F68 03E00008 */  jr    $ra
/* 002B6C 80001F6C 00000000 */   nop

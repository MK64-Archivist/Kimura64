glabel PercialDMA
/* 001D58 80001158 27BDFFC0 */  addiu $sp, $sp, -0x40
/* 001D5C 8000115C AFB2002C */  sw    $s2, 0x2c($sp)
/* 001D60 80001160 00A09025 */  move  $s2, $a1
/* 001D64 80001164 AFBF003C */  sw    $ra, 0x3c($sp)
/* 001D68 80001168 AFB10028 */  sw    $s1, 0x28($sp)
/* 001D6C 8000116C AFB00024 */  sw    $s0, 0x24($sp)
/* 001D70 80001170 00C08025 */  move  $s0, $a2
/* 001D74 80001174 00808825 */  move  $s1, $a0
/* 001D78 80001178 AFB50038 */  sw    $s5, 0x38($sp)
/* 001D7C 8000117C AFB40034 */  sw    $s4, 0x34($sp)
/* 001D80 80001180 AFB30030 */  sw    $s3, 0x30($sp)
/* 001D84 80001184 0C0336E0 */  jal   osInvalDCache
/* 001D88 80001188 00C02825 */   move  $a1, $a2
/* 001D8C 8000118C 2E010101 */  sltiu $at, $s0, 0x101
/* 001D90 80001190 14200018 */  bnez  $at, .L800011F4
/* 001D94 80001194 3C158015 */   lui   $s5, %hi(gDummyMessage) # $s5, 0x8015
/* 001D98 80001198 3C148015 */  lui   $s4, %hi(gDMAIOMessageBuf) # $s4, 0x8015
/* 001D9C 8000119C 3C138015 */  lui   $s3, %hi(gDMAMessageQ) # $s3, 0x8015
/* 001DA0 800011A0 2673EF58 */  addiu $s3, %lo(gDMAMessageQ) # addiu $s3, $s3, -0x10a8
/* 001DA4 800011A4 2694F0A0 */  addiu $s4, %lo(gDMAIOMessageBuf) # addiu $s4, $s4, -0xf60
/* 001DA8 800011A8 26B5F098 */  addiu $s5, %lo(gDummyMessage) # addiu $s5, $s5, -0xf68
.L800011AC:
/* 001DAC 800011AC 240E0100 */  li    $t6, 256
/* 001DB0 800011B0 AFAE0014 */  sw    $t6, 0x14($sp)
/* 001DB4 800011B4 02802025 */  move  $a0, $s4
/* 001DB8 800011B8 00002825 */  move  $a1, $zero
/* 001DBC 800011BC 00003025 */  move  $a2, $zero
/* 001DC0 800011C0 02403825 */  move  $a3, $s2
/* 001DC4 800011C4 AFB10010 */  sw    $s1, 0x10($sp)
/* 001DC8 800011C8 0C03370C */  jal   osPiStartDma
/* 001DCC 800011CC AFB30018 */   sw    $s3, 0x18($sp)
/* 001DD0 800011D0 02602025 */  move  $a0, $s3
/* 001DD4 800011D4 02A02825 */  move  $a1, $s5
/* 001DD8 800011D8 0C0335D4 */  jal   osRecvMesg
/* 001DDC 800011DC 24060001 */   li    $a2, 1
/* 001DE0 800011E0 2610FF00 */  addiu $s0, $s0, -0x100
/* 001DE4 800011E4 2E010101 */  sltiu $at, $s0, 0x101
/* 001DE8 800011E8 26520100 */  addiu $s2, $s2, 0x100
/* 001DEC 800011EC 1020FFEF */  beqz  $at, .L800011AC
/* 001DF0 800011F0 26310100 */   addiu $s1, $s1, 0x100
.L800011F4:
/* 001DF4 800011F4 3C138015 */  lui   $s3, %hi(gDMAMessageQ) # $s3, 0x8015
/* 001DF8 800011F8 3C148015 */  lui   $s4, %hi(gDMAIOMessageBuf) # $s4, 0x8015
/* 001DFC 800011FC 3C158015 */  lui   $s5, %hi(gDummyMessage) # $s5, 0x8015
/* 001E00 80001200 26B5F098 */  addiu $s5, %lo(gDummyMessage) # addiu $s5, $s5, -0xf68
/* 001E04 80001204 2694F0A0 */  addiu $s4, %lo(gDMAIOMessageBuf) # addiu $s4, $s4, -0xf60
/* 001E08 80001208 1200000D */  beqz  $s0, .L80001240
/* 001E0C 8000120C 2673EF58 */   addiu $s3, %lo(gDMAMessageQ) # addiu $s3, $s3, -0x10a8
/* 001E10 80001210 02802025 */  move  $a0, $s4
/* 001E14 80001214 00002825 */  move  $a1, $zero
/* 001E18 80001218 00003025 */  move  $a2, $zero
/* 001E1C 8000121C 02403825 */  move  $a3, $s2
/* 001E20 80001220 AFB10010 */  sw    $s1, 0x10($sp)
/* 001E24 80001224 AFB00014 */  sw    $s0, 0x14($sp)
/* 001E28 80001228 0C03370C */  jal   osPiStartDma
/* 001E2C 8000122C AFB30018 */   sw    $s3, 0x18($sp)
/* 001E30 80001230 02602025 */  move  $a0, $s3
/* 001E34 80001234 02A02825 */  move  $a1, $s5
/* 001E38 80001238 0C0335D4 */  jal   osRecvMesg
/* 001E3C 8000123C 24060001 */   li    $a2, 1
.L80001240:
/* 001E40 80001240 8FBF003C */  lw    $ra, 0x3c($sp)
/* 001E44 80001244 8FB00024 */  lw    $s0, 0x24($sp)
/* 001E48 80001248 8FB10028 */  lw    $s1, 0x28($sp)
/* 001E4C 8000124C 8FB2002C */  lw    $s2, 0x2c($sp)
/* 001E50 80001250 8FB30030 */  lw    $s3, 0x30($sp)
/* 001E54 80001254 8FB40034 */  lw    $s4, 0x34($sp)
/* 001E58 80001258 8FB50038 */  lw    $s5, 0x38($sp)
/* 001E5C 8000125C 03E00008 */  jr    $ra
/* 001E60 80001260 27BD0040 */   addiu $sp, $sp, 0x40

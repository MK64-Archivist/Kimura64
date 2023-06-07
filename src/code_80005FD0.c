#include <ultra64.h>
#include <macros.h>

extern u32 CalcDirection(void);
extern s32 gScreenFlip;

s16 CalcDirection(void) {
    s16 temp_ret;
    s16 phi_v1;

    temp_ret = CalcDirection();
    phi_v1 = temp_ret;
    if (gScreenFlip != 0) {
        phi_v1 = -temp_ret;
    }
    return phi_v1;
}

GLOBAL_ASM("asm/non_matchings/code_80005FD0.s")

#include <ultra64.h>
#include <macros.h>

extern void NaMusicVolume(u16 arg0);
extern u16 gVolumeToggle;

void SetMusicVolume(void) {
    switch(gVolumeToggle) {
        case 0:
            NaMusicVolume(127);
            break;
        case 1:
            NaMusicVolume(75);
            break;
        case 2:
            NaMusicVolume(0);
            break;
    }
}

GLOBAL_ASM("asm/non_matchings/code_800029B0.s")

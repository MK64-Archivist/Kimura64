#include <ultra64.h>
#include <macros.h>
#include "types.h"
#include "config.h"
#include "profiler.h"

// Declarations (not in this file)
void func_8008C214(UNUSED int);
void InitKawanoSelect(void);
void InitialPerspective(void);
void StoreSegments(void);
void InitRDP(void);
void InitRSP(void);
void ClearFrameBuffer(void);
void ClearZBuffer(void);
void NasInitAudio();
void SetGraphicRCPTime(enum ProfilerGfxEvent eventID);
void profiler_log_vblank_time(void);
void SysCreateThread(OSThread *thread, OSId id, void (*entry)(void *), void *arg, void *sp, OSPri pri);
void create_debug_thread(void);
void start_debug_thread(void);
struct SPTask *NasAudioMain(void);

extern s32 gNewSequenceMode;
extern s32 gScreenMode;
extern OSThread D_801524C0;
extern OSThread D_80154670;
extern OSViMode D_800EA6C0, D_800EAF80;
extern s32 D_80000300;
extern s16 gResetType;
extern OSMesgQueue D_8015F460;
extern OSMesg D_8015F3E0;
extern s32 D_8000030C;
extern s32 D_80156820;
extern struct SPTask *gCurrentTask;
extern s16 gVideoFrame;
extern f32 gTimer;
extern struct SPTask *gAudioTask;
extern struct SPTask *gGameTask;
extern struct VblankHandler *gAudioClient;
extern struct VblankHandler *gGraphClient;
extern const f64 D_800EB640;
extern struct VblankHandler sSoundVblankHandler;
extern struct SPTask *gTListP;
extern OSMesgQueue gDMAMessageQ, gRdpMessageQ, gTaskMessageQ, gIrqMessageQ;
extern OSMesgQueue sSoundMesgQueue;
extern OSMesg sSoundMesgBuf;
extern OSMesg gDmaMessageBuf, gTaskMessageBuf, gIrqMessageBuf;
extern Gfx *gGraphPtr;

extern u64 rspbootTextStart[], rspbootTextEnd[];
extern u64 gspF3DEXTextStart[], gspF3DEXTextEnd[];
extern u64 gspF3DLXTextStart[], gspF3DLXTextEnd[];
extern u64 gspF3DEXDataStart[];
extern u64 gspF3DLXDataStart[];

extern u32 gPlayerNumber;
extern u32 gSequenceMode;

extern u32 gGfxSPTaskStack;
extern u64 gGfxSPTaskOutputBuffer[];
extern u32 gGfxSPTaskOutputBufferSize;
extern u8 gGfxSPTaskYieldBuffer[];

#define GFX_POOL_SIZE 6400
struct GfxPool {
    Gfx buffer[GFX_POOL_SIZE];
    struct SPTask spTask;
};

extern struct GfxPool *gDynamicIcp;

// Declarations (in this file)
void thread1_idle(void *arg0);
void MainProc(void *arg0);

// Message IDs
#define MESG_SP_COMPLETE 100
#define MESG_DP_COMPLETE 101
#define MESG_VI_VBLANK 102
#define MESG_StartGFXTask 103
#define MESG_NMI_REQUEST 104

void SysCreateThread(OSThread *thread, OSId id, void (*entry)(void *), void *arg, void *sp, OSPri pri) {
    thread->next = NULL;
    thread->queue = NULL;
    osCreateThread(thread, id, entry, arg, sp, pri);
}

void main_func(void) {
    osInitialize();
    SysCreateThread(&D_801524C0, 1, thread1_idle, NULL, &D_80154670, 100);
    osStartThread(&D_801524C0);
}

void thread1_idle(void *arg0) {
    osCreateViManager(OS_PRIORITY_VIMGR);
    if (D_80000300 == 1) {
        osViSetMode(&D_800EA6C0);
    } else {
        osViSetMode(&D_800EAF80);
    }
    osViBlack(TRUE);
    osViSetSpecialFeatures(OS_VI_GAMMA_OFF);
    osCreatePiManager(OS_PRIORITY_PIMGR, &D_8015F460, &D_8015F3E0, 0x20);
    gResetType = (s16) D_8000030C;
    create_debug_thread();
    start_debug_thread();
    SysCreateThread(&D_80154670, 3, &MainProc, arg0, &D_80156820, 100);
    osStartThread(&D_80154670);
    osSetThreadPri(NULL, 0);

    // halt
    while (1) {
        ;
    }
}

void SetupMessageQueue(void) {
    osCreateMesgQueue(&gDMAMessageQ, &gDmaMessageBuf, 1);
    osCreateMesgQueue(&gTaskMessageQ, &gTaskMessageBuf, 0x10);
    osCreateMesgQueue(&gIrqMessageQ, &gIrqMessageBuf, 0x10);
    osViSetEvent(&gIrqMessageQ, (OSMesg) 0x66, 1);
    osSetEventMesg(4, &gIrqMessageQ, (OSMesg) 0x64);
    osSetEventMesg(9, &gIrqMessageQ, (OSMesg) 0x65);
}

void StartRSPTask(s32 taskType) {
    if (taskType == M_AUDTASK) {
        gCurrentTask = gAudioTask;
    } else {
        gCurrentTask = gGameTask;
    }
    osSpTaskLoad(&gCurrentTask->task);
    osSpTaskStartGo(&gCurrentTask->task);
    gCurrentTask->state = SPTASK_STATE_RUNNING;
}

// Most similar to create_task_structure from SM64, with additional provisions
// to load both F3DEX and F3DLX, depending on the number of players

#ifdef NON_MATCHING
void BuildGraphicsTask(void) {

    gTListP->msgqueue = &gRdpMessageQ;
    gTListP->msg = (OSMesg) 2;
    gTListP->task.t.type = M_GFXTASK;
    gTListP->task.t.flags = 2;
    gTListP->task.t.ucode_boot = rspbootTextStart;
    gTListP->task.t.ucode_boot_size = ((u8 *) rspbootTextEnd - (u8 *) rspbootTextStart);
    if (gSequenceMode == 4 && gPlayerNumber == 1) {
        gTListP->task.t.ucode = gspF3DEXTextStart;
        gTListP->task.t.ucode_data = gspF3DEXDataStart;
    } else {
        gTListP->task.t.ucode = gspF3DLXTextStart;
        gTListP->task.t.ucode_data = gspF3DLXDataStart;
    }
    gTListP->task.t.flags = 0;
    gTListP->task.t.flags = 2;
    gTListP->task.t.ucode_size = 0x1000;
    gTListP->task.t.ucode_data_size = 0x800;
    gTListP->task.t.dram_stack = (u64 *) gGfxSPTaskStack;
    gTListP->task.t.dram_stack_size = 0x400;
    gTListP->task.t.output_buff = (u64 *) gGfxSPTaskOutputBuffer;
    gTListP->task.t.output_buff_size = (u64 *) gGfxSPTaskOutputBufferSize;
    gTListP->task.t.data_ptr = (u64 *) (gDynamicIcp + 0x1A0C0);
    gTListP->task.t.data_size = (gGraphPtr - gDynamicIcp->buffer) * sizeof(Gfx);
    func_8008C214(2);
    gTListP->task.t.yield_data_ptr = (u64 *) gGfxSPTaskYieldBuffer;
    gTListP->task.t.yield_data_size = 0xD00;
}
#else
GLOBAL_ASM("asm/non_matchings/main/BuildGraphicsTask.s")
#endif

#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
void InitalizeController(void) {
    osCreateMesgQueue(&gIntMesgQueue, &gIntMesgBuf, 3);
    osSetEventMesg(5, &gIntMesgQueue, (OSMesg) 0x33333333);
    osContInit(&gIntMesgQueue, &gPattern, &gSData);
    if ((gPattern & 1) == 0) {
        gDeadControl = (u16)1;
        return;
    }
    *(void *)0x80160000 = (u16)0;
}
#else
GLOBAL_ASM("asm/non_matchings/main/InitalizeController.s")
#endif

#ifdef MIPS_TO_C
//generated by mips_to_c commit ffee479fae41a1cdc3e454e9b9d75bbd226a160f
void CheckController(s32 arg0) {
    s32 temp_a2;
    u16 temp_a1;
    u16 temp_t4;
    void *temp_v0;
    void *temp_v1;
    u16 phi_a1;
    u16 phi_a0;
    u16 phi_a0_2;
    u16 phi_a0_3;
    u16 phi_a0_4;

    if (gDeadControl == 0) {
        // potantial sizeof structs?
        temp_v1 = (arg0 * 6) + &gRData;
        temp_v0 = (arg0 * 0x10) + &gPlayer1Controller;
        temp_v0->unk0 = (s16) temp_v1->unk2;
        temp_v0->unk2 = (s16) temp_v1->unk3;
        temp_t4 = temp_v1->unk0 | 0x2000;
        phi_a1 = temp_v1->unk0;
        if ((temp_v1->unk0 & 4) != 0) {
            temp_v1->unk0 = temp_t4;
            phi_a1 = temp_t4 & 0xFFFF;
        }
        temp_v0->unk6 = (s16) ((phi_a1 ^ temp_v0->unk4) & phi_a1);
        temp_v0->unk8 = (s16) ((temp_v1->unk0 ^ temp_v0->unk4) & temp_v0->unk4);
        temp_v0->unk4 = (u16) temp_v1->unk0;
        phi_a0_4 = (u16)0U;
        if ((s32) temp_v0->unk0 < -0x32) {
            phi_a0_4 = (u16)0x200U;
        }
        phi_a0_3 = phi_a0_4;
        if ((s32) temp_v0->unk0 >= 0x33) {
            phi_a0_3 = (phi_a0_4 | 0x100) & 0xFFFF;
        }
        phi_a0_2 = phi_a0_3;
        if ((s32) temp_v0->unk2 < -0x32) {
            phi_a0_2 = (phi_a0_3 | 0x400) & 0xFFFF;
        }
        phi_a0 = phi_a0_2;
        if ((s32) temp_v0->unk2 >= 0x33) {
            phi_a0 = (phi_a0_2 | 0x800) & 0xFFFF;
        }
        temp_a1 = temp_v0->unkA;
        temp_v0->unkA = phi_a0;
        temp_a2 = phi_a0 ^ temp_a1;
        temp_v0->unkC = (s16) (phi_a0 & temp_a2);
        temp_v0->unkE = (s16) (temp_a1 & temp_a2);
    }
}
#else
GLOBAL_ASM("asm/non_matchings/main/CheckController.s")
#endif

#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
void *ReadController(void) {
    ? sp1C;

    osContStartReadData(&gIntMesgQueue);
    osRecvMesg(&gIntMesgQueue, &sp1C, 1);
    osContGetReadData(&gRData);
    CheckController(0);
    CheckController(1);
    CheckController(2);
    CheckController(3);
    gContOR->unk4 = (s16) (((gCont1P->unk4 | gCont2P->unk4) | gCont3P->unk4) | gCont4P->unk4);
    gContOR->unk6 = (s16) (((gCont1P->unk6 | gCont2P->unk6) | gCont3P->unk6) | gCont4P->unk6);
    gContOR->unk8 = (s16) (((gCont1P->unk8 | gCont2P->unk8) | gCont3P->unk8) | gCont4P->unk8);
    gContOR->unkA = (s16) (((gCont1P->unkA | gCont2P->unkA) | gCont3P->unkA) | gCont4P->unkA);
    gContOR->unkC = (s16) (((gCont1P->unkC | gCont2P->unkC) | gCont3P->unkC) | gCont4P->unkC);
    gContOR->unkE = (s16) (((gCont1P->unkE | gCont2P->unkE) | gCont3P->unkE) | gCont4P->unkE);
    return &gContOR;
}
#else
GLOBAL_ASM("asm/non_matchings/main/ReadController.s")
#endif

#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
void AllocDepthBuffer(void) {
    *(void *)0x801502B4 = (s32) ((s32) &gDepthBuffer & 0x1FFFFFFF);
}
#else
GLOBAL_ASM("asm/non_matchings/main/AllocDepthBuffer.s")
#endif

// send_sp_task_message from SM64
void SetRSPTask(OSMesg arg0) {
    osWritebackDCacheAll();
    osSendMesg(&gTaskMessageQ, arg0, OS_MESG_NOBLOCK);
}

// similar to send_display_list from SM64
#ifdef MIPS_TO_C
void StartGraphicTask(struct SPTask *spTask) {
    osWritebackDCacheAll();
    spTask->state = 0;
    if (gGameTask == NULL) {
        gGameTask = spTask;
        gGameNext = NULL;
        osSendMesg(&gIrqMessageQ, 0x67, 0, spTask);
    }
    *(void *)0x800E0000 = spTask;
}
#else
GLOBAL_ASM("asm/non_matchings/main/StartGraphicTask.s")
#endif

void BeginDrawing(void) {
    StoreSegments();
    InitRDP();
    InitRSP();
    ClearFrameBuffer();
    ClearZBuffer();
}

// Similar to end_master_display_list in SM64
void EndDrawing(void) {
    gDPFullSync(gGraphPtr++);
    gSPEndDisplayList(gGraphPtr++);

    BuildGraphicsTask();
}

// clear_frame_buffer from SM64, with a few edits
#ifdef NON_MATCHING
void SoftwareBlanking(s32 arg0) {
    gDPPipeSync(gGraphPtr++);

    gDPSetRenderMode(gGraphPtr++, G_RM_OPA_SURF, G_RM_OPA_SURF2);
    gDPSetCycleType(gGraphPtr++, G_CYC_FILL);

    gDPSetFillColor(gGraphPtr++, arg0);
    gDPFillRectangle(gGraphPtr++, 0, 0, SCREEN_WIDTH - 1,
                     SCREEN_HEIGHT - 1);

    gDPPipeSync(gGraphPtr++);

    gDPSetCycleType(gGraphPtr++, G_CYC_1CYCLE);
}
#else
GLOBAL_ASM("asm/non_matchings/main/SoftwareBlanking.s")
#endif

// likely rendering_init from SM64
#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
void *InitialGameframe(void) {
    gDynamicIcp = 0x800FD860;
    SetSegment(1, 0x800FD860);
    gTListP = (s32) (gDynamicIcp + 0x28B20);
    gGraphPtr = (s32) (gDynamicIcp + 0x1A0C0);
    BeginDrawing();
    SoftwareBlanking(0);
    EndDrawing();
    StartGraphicTask(gDynamicIcp + 0x28B20);
    gDrawFrame = (u16) (gDrawFrame + 1);
    gFrameCounter = (s32) (gFrameCounter + 1);
    return &gDrawFrame;
}
#else
GLOBAL_ASM("asm/non_matchings/main/InitialGameframe.s")
#endif

// likely config_gfx_pool from SM64
#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
s32 BeginGameframe(void) {
    void *temp_a1;

    temp_a1 = ((gFrameCounter & 1) * 0x28B70) + &D_800FD860;
    gDynamicIcp = temp_a1;
    SetSegment(1, temp_a1);
    gGraphPtr = (s32) (gDynamicIcp + 0x1A0C0);
    gTListP = (s32) (gDynamicIcp + 0x28B20);
    return gDynamicIcp;
}
#else
GLOBAL_ASM("asm/non_matchings/main/BeginGameframe.s")
#endif

// likely display_and_vsync from SM64
#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
void *FlushDisplayList(void) {
    u16 temp_t2;
    u16 temp_t5;

    SetGraphCPUTime(2);
    osRecvMesg(&gRdpMessageQ, &gDummyMessage, 1);
    StartGraphicTask(gDynamicIcp + 0x28B20);
    SetGraphCPUTime(3);
    osRecvMesg(&gRtcMessageQ, &gDummyMessage, 1);
    osViSwapBuffer(((gDispFrame * 4) + 0x80150000)->unk2A8 | 0x80000000);
    SetGraphCPUTime(4);
    osRecvMesg(&gRtcMessageQ, &gDummyMessage, 1);
    SetFaultFrameBuffer(((gDispFrame * 4) + 0x80150000)->unk2A8);
    temp_t2 = gDispFrame + 1;
    gDispFrame = temp_t2;
    if (3 == (temp_t2 & 0xFFFF)) {
        gDispFrame = (u16)0U;
    }
    temp_t5 = gDrawFrame + 1;
    gDrawFrame = temp_t5;
    if (3 == (temp_t5 & 0xFFFF)) {
        gDrawFrame = (u16)0U;
    }
    gFrameCounter = (s32) (gFrameCounter + 1);
    return &gFrameCounter;
}
#else
GLOBAL_ASM("asm/non_matchings/main/FlushDisplayList.s")
#endif

// Code segment loading functions (relatively similar to SM64 in structure)
#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
void InitExCode(void) {
    bzero(0x80280000, 0xDF00);
    osWritebackDCacheAll();
    PercialDMA(0x80280000, &_code_80280000SegmentRomStart, ((&_code_80280000SegmentRomEnd - &_code_80280000SegmentRomStart) + 0xF) & -0x10);
    osInvalCache(0x80280000, 0xDF00);
    osInvalDCache(0x80280000, 0xDF00);
}
#else
GLOBAL_ASM("asm/non_matchings/main/InitExCode.s")
#endif

#ifdef MIPS_TO_C
//generated by mips_to_c commit ffee479fae41a1cdc3e454e9b9d75bbd226a160f
void InitMKCode(void) {
    bzero(0x8028DF00, 0x2C470);
    osWritebackDCacheAll();
    PercialDMA(0x8028DF00, &_code_8028DF00SegmentRomStart, ((&_code_8028DF00SegmentRomEnd - &_code_8028DF00SegmentRomStart) + 0xF) & -0x10);
    osInvalCache(0x8028DF00, 0x2C470);
    osInvalDCache(0x8028DF00, 0x2C470);
}
#else
GLOBAL_ASM("asm/non_matchings/main/InitMKCode.s")
#endif

// Similar to dma_read in SM64
#ifdef MIPS_TO_C
//generated by mips_to_c commit ffee479fae41a1cdc3e454e9b9d75bbd226a160f
void PercialDMA(s32 arg0, s32 arg1, u32 arg2) {
    s32 temp_s1;
    s32 temp_s2;
    u32 temp_s0;
    s32 phi_s2;
    s32 phi_s1;
    u32 phi_s0;
    u32 phi_s0_2;
    s32 phi_s2_2;
    s32 phi_s1_2;

    osInvalDCache(arg2);
    phi_s0_2 = arg2;
    phi_s2_2 = arg1;
    phi_s1_2 = arg0;
    if (arg2 >= 0x101U) {
        phi_s2 = arg1;
        phi_s1 = arg0;
        phi_s0 = arg2;
loop_2:
        osPiStartDma(&gDMAIOMessageBuf, 0, 0, phi_s2, phi_s1, 0x100, &gDMAMessageQ);
        osRecvMesg(&gDMAMessageQ, &gDummyMessage, 1);
        temp_s0 = phi_s0 - 0x100;
        temp_s2 = phi_s2 + 0x100;
        temp_s1 = phi_s1 + 0x100;
        phi_s2 = temp_s2;
        phi_s1 = temp_s1;
        phi_s0 = temp_s0;
        phi_s0_2 = temp_s0;
        phi_s2_2 = temp_s2;
        phi_s1_2 = temp_s1;
        if (temp_s0 >= 0x101U) {
            goto loop_2;
        }
    }
    if (phi_s0_2 != 0) {
        osPiStartDma(&gDMAIOMessageBuf, 0, 0, phi_s2_2, phi_s1_2, phi_s0_2, &gDMAMessageQ);
        osRecvMesg(&gDMAMessageQ, &gDummyMessage, 1);
    }
}
#else
GLOBAL_ASM("asm/non_matchings/main/PercialDMA.s")
#endif

// Resembles setup_game_memory from SM64
#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
void InitializeSystemWorks(void) {
    s32 sp40;
    s32 sp38;
    void *sp2C;
    s32 temp_t2;
    s32 temp_t7;
    void *temp_t0;

    InitMKCode();
    gLastMemoryPointer = 0x8028DF00;
    SetSegment(0, 0x80000000);
    InitialFreeMemory(&D_801978D0, 0x80242F00);
    AllocDepthBuffer();
    osInvalDCache(0x802BA370, 0x5810);
    osPiStartDma(&gDMAIOMessageBuf, 0, 0, &_data_802BA370SegmentRomStart, 0x802BA370, 0x5810, &gDMAMessageQ);
    osRecvMesg(&gDMAMessageQ, &gDummyMessage, 1);
    SetSegment(2, LoadData(&_data_segment2SegmentRomStart, &_data_segment2SegmentRomEnd));
    temp_t2 = ((&_common_texturesSegmentRomEnd - &_common_texturesSegmentRomStart) + 0xF) & -0x10;
    temp_t0 = 0x8028DF00 - temp_t2;
    sp2C = temp_t0;
    osPiStartDma(&gDMAIOMessageBuf, 0, 0, &_common_texturesSegmentRomStart, temp_t0, temp_t2, &gDMAMessageQ);
    osRecvMesg(&gDMAMessageQ, &gDummyMessage, 1);
    sp38 = gFreeMemoryPointer;
    sp40 = (sp2C->unk4 + 0xF) & -0x10;
    SlideC1(sp2C, gFreeMemoryPointer);
    SetSegment(0xD, gFreeMemoryPointer);
    temp_t7 = gFreeMemoryPointer + sp40;
    gFreeMemoryPointer = temp_t7;
    gStaticMemoryPointer = temp_t7;
}
#else
GLOBAL_ASM("asm/non_matchings/main/InitializeSystemWorks.s")
#endif

void BootSequence(void) {
    gNewSequenceMode = 0;
    SoftwareBlanking(0);
}

#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
void *RaceSequence(void) {
    s32 temp_s0;
    s32 temp_s0_2;
    s32 temp_s0_3;
    s32 temp_s0_4;
    void *temp_v0;
    void *temp_v0_2;
    s32 phi_s0;
    s32 phi_s0_2;
    s32 phi_s0_3;
    s32 phi_s0_4;
    u16 phi_a0;

    gMatrixCount = (u16)0;
    gEffectCount = (u16)0;
    if (gPauseFlag != 0) {
        PauseSequence();
    }
    if (gFadeoutFlag != 0) {
        return FadeoutSequence();
    }
    if ((s32) gVideoFrame >= 6) {
        gVideoFrame = (u16)5;
    }
    if ((s32) gVideoFrame < 0) {
        gVideoFrame = (u16)1;
    }
    SetupPerspective();
    if (gScreenMode != 0) {
        if (gScreenMode != 1) {
            if (gScreenMode != 2) {
                if (gScreenMode != 3) {

                } else {
                    if (3 == *(void *)0x800DC538) {
                        if (gMapNumber != 2) {
                            if (gMapNumber != 9) {
                                if (gMapNumber != 0x10) {
                                    if (gMapNumber != 0x12) {
                                        gFramerate = 2;
                                    } else {
block_79:
                                        gFramerate = 3;
                                    }
                                } else {
                                    goto block_79;
                                }
                            } else {
                                goto block_79;
                            }
                        } else {
                            goto block_79;
                        }
                    } else {
                        if (*(void *)0x800E0000 != 0xF) {
                            if (*(void *)0x800E0000 != 0x11) {
                                if (*(void *)0x800E0000 != 0x12) {
                                    if (*(void *)0x800E0000 != 0x13) {
                                        gFramerate = 3;
                                    } else {
block_85:
                                        gFramerate = 2;
                                    }
                                } else {
                                    gFramerate = 4;
                                }
                            } else {
                                goto block_85;
                            }
                        } else {
                            goto block_85;
                        }
                    }
                    if (gPauseFlag == 0) {
                        if (gFramerate > 0) {
                            phi_s0 = 0;
loop_90:
                            if (gTimeFlag != 0) {
                                gRaceTimer = (f32) ((f64) gRaceTimer + D_800EB610);
                            }
                            CollisionKartToKart();
                            CollisionObjectToKart();
                            DriveStickControl();
                            CameraControl(gMyKart1, gCamera1, 0);
                            KartPosControl1P();
                            CameraControl(gKart2, gCamera2, 1);
                            KartPosControl2P();
                            CameraControl(gKart3, gCamera3, 2);
                            KartPosControl3P();
                            CameraControl(gKart4, gCamera4, 3);
                            KartPosControl4P();
                            EnemyControl();
                            KWVideoFramesYori();
                            ObjectStrategy1();
                            MapStrategy();
                            RaceControl();
                            temp_s0 = (s32) ((phi_s0 + 1) << 0x10) >> 0x10;
                            phi_s0 = temp_s0;
                            if (temp_s0 < gFramerate) {
                                goto loop_90;
                            }
                        }
                        KenStartegy();
                    }
                    KWGameFramesYori();
                    gVideoFrame = (u16)0;
                    SetGraphCPUTime(1);
                    StoreSegments();
                    InitRDP();
                    if (gClearCFBFlag != 0) {
                        ClearFrameBuffer();
                    }
                    gScreenCounter = 0;
                    if (gWinKart == 0) {
                        DrawUpRightScreen();
                        DrawDownLeftScreen();
                        DrawDownRightScreen();
                        Drag();
                    } else {
                        if (gWinKart == 1) {
                            DrawUpLeftScreen();
                            DrawDownLeftScreen();
                            DrawDownRightScreen();
                            DrawUpRightScreen();
                        } else {
                            if (gWinKart == 2) {
                                DrawUpLeftScreen();
                                DrawUpRightScreen();
                                DrawDownRightScreen();
                                DrawDownLeftScreen();
                            } else {
                                DrawUpLeftScreen();
                                DrawUpRightScreen();
                                DrawDownLeftScreen();
                                DrawDownRightScreen();
                            }
                        }
                    }
                }
            } else {
                if (*(void *)0x800DC5A0 == 0x12) {
                    gFramerate = 3;
                } else {
                    gFramerate = 2;
                }
                if (gPauseFlag == 0) {
                    if (gFramerate > 0) {
                        phi_s0_2 = 0;
loop_47:
                        if (gTimeFlag != 0) {
                            gRaceTimer = (f32) ((f64) gRaceTimer + D_800EB600);
                        }
                        CollisionKartToKart();
                        CollisionObjectToKart();
                        DriveStickControl();
                        CameraControl(gMyKart1, gCamera1, 0);
                        KartPosControlRU();
                        CameraControl(gMyKart2, gCamera2, 1);
                        KartPosControlLD();
                        EnemyControl();
                        KWVideoFramesYori();
                        ObjectStrategy1();
                        MapStrategy();
                        RaceControl();
                        temp_s0_2 = (s32) ((phi_s0_2 + 1) << 0x10) >> 0x10;
                        phi_s0_2 = temp_s0_2;
                        if (temp_s0_2 < gFramerate) {
                            goto loop_47;
                        }
                    }
                    KenStartegy();
                }
                KWGameFramesYori();
                SetGraphCPUTime(1);
                gVideoFrame = (u16)0;
                StoreSegments();
                InitRDP();
                if (gClearCFBFlag != 0) {
                    ClearFrameBuffer();
                }
                gScreenCounter = 0;
                if (gWinKart == 0) {
                    DrawRightScreen();
                    DrawLeftScreen();
                } else {
                    DrawLeftScreen();
                    DrawRightScreen();
                }
            }
        } else {
            if (*(void *)0x800DC5A0 == 0x12) {
                gFramerate = 3;
            } else {
                gFramerate = 2;
            }
            if (gPauseFlag == 0) {
                if (gFramerate > 0) {
                    phi_s0_3 = 0;
loop_63:
                    if (gTimeFlag != 0) {
                        gRaceTimer = (f32) ((f64) gRaceTimer + D_800EB608);
                    }
                    CollisionKartToKart();
                    CollisionObjectToKart();
                    DriveStickControl();
                    CameraControl(gMyKart1, gCamera1, 0);
                    KartPosControlRU();
                    CameraControl(gMyKart2, gCamera2, 1);
                    KartPosControlLD();
                    EnemyControl();
                    KWVideoFramesYori();
                    ObjectStrategy1();
                    MapStrategy();
                    RaceControl();
                    temp_s0_3 = (s32) ((phi_s0_3 + 1) << 0x10) >> 0x10;
                    phi_s0_3 = temp_s0_3;
                    if (temp_s0_3 < gFramerate) {
                        goto loop_63;
                    }
                }
                KenStartegy();
            }
            SetGraphCPUTime(1);
            gVideoFrame = (u16)0;
            KWGameFramesYori();
            StoreSegments();
            InitRDP();
            if (gClearCFBFlag != 0) {
                ClearFrameBuffer();
            }
            gScreenCounter = 0;
            if (gWinKart == 0) {
                DrawDownScreen();
                DrawUpScreen();
            } else {
                DrawUpScreen();
                DrawDownScreen();
            }
        }
block_104:
        phi_a0 = gDebugFlag;
    } else {
        gFramerate = 2;
        KeyDataControl();
        if (gPauseFlag == 0) {
            if (gFramerate > 0) {
                phi_s0_4 = 0;
loop_16:
                if (gTimeFlag != 0) {
                    gRaceTimer = (f32) ((f64) gRaceTimer + D_800EB5F8);
                }
                CollisionKartToKart();
                CollisionObjectToKart();
                DriveStickControl();
                CameraControl(gMyKart1, gCamera1, 0);
                KartPosControlFull();
                EnemyControl();
                KWVideoFramesYori();
                ObjectStrategy1();
                MapStrategy();
                RaceControl();
                temp_s0_4 = (s32) ((phi_s0_4 + 1) << 0x10) >> 0x10;
                phi_s0_4 = temp_s0_4;
                if (temp_s0_4 < gFramerate) {
                    goto loop_16;
                }
            }
            KenStartegy();
        }
        KWGameFramesYori();
        gVideoFrame = (u16)0;
        SetGraphCPUTime(1);
        gScreenCounter = 0;
        DrawFullScreen();
        if (gDebugFlag == 0) {
            gDispAreaFlag = (u16)0;
            phi_a0 = gDebugFlag;
        } else {
            if (gDispAreaFlag != 0) {
                if ((gCont1P->unk6 & 0x10) != 0) {
                    if ((gCont1P->unk4 & 0x8000) != 0) {
                        if ((gCont1P->unk4 & 0x4000) != 0) {
                            gDispAreaFlag = (u16)0U;
                        }
                    }
                }
                gDispPoint = (s16) gScreen1->unk38;
                if ((s32) gCamera1->unk26 < 0x2000) {
                    KWFPrintUD(0x28, 0x64, &D_800EB5D0, gDispPoint);
                } else {
                    if ((s32) gCamera1->unk26 < 0x6000) {
                        KWFPrintUD(0x28, 0x64, &D_800EB5D8, gDispPoint);
                    } else {
                        if ((s32) gCamera1->unk26 < 0xA000) {
                            KWFPrintUD(0x28, 0x64, &D_800EB5E0, gDispPoint);
                        } else {
                            if ((s32) gCamera1->unk26 < 0xE000) {
                                KWFPrintUD(0x28, 0x64, &D_800EB5E8, gDispPoint);
                            } else {
                                KWFPrintUD(0x28, 0x64, &D_800EB5F0, gDispPoint);
                            }
                        }
                    }
                }
                goto block_104;
            } else {
                phi_a0 = gDebugFlag;
                if (((*(void *)0x800DC4BC)->unk6 & 0x20) != 0) {
                    phi_a0 = gDebugFlag;
                    if (((*(void *)0x800DC4BC)->unk4 & 0x8000) != 0) {
                        phi_a0 = gDebugFlag;
                        if (((*(void *)0x800DC4BC)->unk4 & 0x4000) != 0) {
                            gDispAreaFlag = (u16)1U;
                            phi_a0 = gDebugFlag;
                        }
                    }
                }
            }
        }
    }
    if (phi_a0 == 0) {
        gEnableResourceMeters = 0;
    } else {
        if (gEnableResourceMeters != 0) {
            resource_display(phi_a0);
            if ((gCont1P->unk4 & 0x20) == 0) {
                if ((gCont1P->unk4 & 0x10) != 0) {
                    if ((gCont1P->unk6 & 0x4000) != 0) {
                        gEnableResourceMeters = 0;
                    }
                }
            }
        } else {
            if ((gCont1P->unk4 & 0x20) == 0) {
                if ((gCont1P->unk4 & 0x10) != 0) {
                    if ((gCont1P->unk6 & 0x4000) != 0) {
                        gEnableResourceMeters = 1;
                    }
                }
            }
        }
    }
    MakeBorder();
    KWDisplayToppri();
    KawanoDrawFinal();
    temp_v0 = gGraphPtr;
    gGraphPtr = (void *) (temp_v0 + 8);
    temp_v0->unk4 = 0;
    temp_v0->unk0 = 0xE9000000;
    temp_v0_2 = gGraphPtr;
    gGraphPtr = (void *) (temp_v0_2 + 8);
    temp_v0_2->unk4 = 0;
    temp_v0_2->unk0 = 0xB8000000;
    return temp_v0_2;
}
#else
GLOBAL_ASM("asm/non_matchings/main/RaceSequence.s")
#endif

#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
// TODO: implement jtables
#else
GLOBAL_ASM("asm/non_matchings/main/ExecuteSequence.s")
#endif

void YieldRSPTask(void) {
    if (gCurrentTask->task.t.type == M_GFXTASK) {
        gCurrentTask->state = SPTASK_STATE_INTERRUPTED;
        osSpTaskYield();
    }
}

// likely receive_new_tasks from SM64
#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
s32 GetTaskMessage(void) {
    void *sp40;
    s32 temp_ret;
    s32 temp_ret_2;
    s32 temp_v0;
    s32 temp_v0_2;
    s32 phi_return;

    temp_ret = osRecvMesg(&gTaskMessageQ, &sp40, 0);
    phi_return = temp_ret;
    if (temp_ret != -1) {
loop_2:
        sp40->unk48 = 0;
        if (sp40->unk0 != 1) {
            if (sp40->unk0 == 2) {
                D_800DC4B4 = sp40;
            }
        } else {
            gGameNext = sp40;
        }
        temp_ret_2 = osRecvMesg(&gTaskMessageQ, &sp40, 0);
        phi_return = temp_ret_2;
        if (temp_ret_2 != -1) {
            goto loop_2;
        }
    }
    if (gAudioTask == 0) {
        temp_v0 = D_800DC4B4;
        phi_return = temp_v0;
        if (temp_v0 != 0) {
            gAudioTask = temp_v0;
            D_800DC4B4 = 0;
            phi_return = temp_v0;
        }
    }
    if (gGameTask == 0) {
        temp_v0_2 = gGameNext;
        phi_return = temp_v0_2;
        if (temp_v0_2 != 0) {
            gGameTask = temp_v0_2;
            gGameNext = 0;
            phi_return = temp_v0_2;
        }
    }
    return phi_return;
}
#else
// suppress warning until matching
s32 GetTaskMessage(void);

GLOBAL_ASM("asm/non_matchings/main/GetTaskMessage.s")
#endif

// likely set_vblank_handler from SM64
void SetClient(s32 arg0, struct VblankHandler *arg1, OSMesgQueue *arg2, OSMesg *arg3) {
    arg1->queue = arg2;
    arg1->msg = arg3;
    switch (arg0) {
        case 1:
            gAudioClient = arg1;
            break;
        case 2:
            gGraphClient = arg1;
            break;
    }
}

void StartGFXTask(void) {
    if (gCurrentTask == NULL && gGameTask != NULL
        && gGameTask->state == SPTASK_STATE_NOT_STARTED) {
        SetGraphicRCPTime(TASKS_QUEUED);
        StartRSPTask(M_GFXTASK);
    }
}

// Similar to handle_vblank from SM64
void InterruptSequence(void) {
    gTimer += D_800EB640;
    gVideoFrame++;

    GetTaskMessage();

    if (gAudioTask != NULL) {
        if (gCurrentTask != NULL) {
            YieldRSPTask();
        } else {
            profiler_log_vblank_time();
            StartRSPTask(M_AUDTASK);
        }
    } else {
        if (gCurrentTask == NULL && gGameTask != NULL
                && gGameTask->state != 3) {
                    SetGraphicRCPTime(0);
                    StartRSPTask(M_GFXTASK);
                }
            }
    if (gAudioClient != NULL) {
        osSendMesg(gAudioClient->queue, gAudioClient->msg, 0);
    }
    if (gGraphClient != NULL) {
        osSendMesg(gGraphClient->queue, gGraphClient->msg, 0);
    }
}

// likely handle_dp_complete from SM64
void RPDDoneSequence(void) {
    if (gGameTask->msgqueue != 0) {
        osSendMesg(gGameTask->msgqueue, gGameTask->msg, OS_MESG_NOBLOCK);
    }
    SetGraphicRCPTime(RDP_COMPLETE);
    gGameTask->state = SPTASK_STATE_FINISHED_DP;
    gGameTask = NULL;
}

#ifdef MIPS_TO_C
//generated by mips_to_c commit ffee479fae41a1cdc3e454e9b9d75bbd226a160f
void *RSPDoneSequence(void) {
    void *sp1C;
    s32 temp_a0;
    void *temp_a3;
    void *phi_a3;
    void *phi_return;

    temp_a3 = gCurrentTask;
    gCurrentTask = NULL;
    if (temp_a3->unk48 == 2) {
        sp1C = temp_a3;
        if (func_800CDD60(temp_a3, temp_a3) == 0) {
            temp_a3->unk48 = 3;
            SetGraphicRCPTime(1, temp_a3);
        }
        profiler_log_vblank_time();
        return StartRSPTask(2);
    }
    temp_a3->unk48 = 3;
    if (temp_a3->unk0 == 2) {
        sp1C = temp_a3;
        profiler_log_vblank_time(temp_a3, temp_a3);
        phi_a3 = temp_a3;
        phi_return = gGameTask;
        if (gGameTask != 0) {
            phi_a3 = temp_a3;
            phi_return = gGameTask;
            if (gGameTask->unk48 != 3) {
                if (gGameTask->unk48 != 2) {
                    sp1C = temp_a3;
                    SetGraphicRCPTime(0, temp_a3);
                }
                sp1C = temp_a3;
                phi_a3 = temp_a3;
                phi_return = StartRSPTask(1, temp_a3);
            }
        }
        gAudioTask = 0;
        temp_a0 = phi_a3->unk40;
        if (temp_a0 != 0) {
            return osSendMesg(temp_a0, phi_a3->unk44, 0, phi_a3);
        }
    } else {
        phi_return = SetGraphicRCPTime(1, temp_a3);
    }
    return phi_return;
}
#else
GLOBAL_ASM("asm/non_matchings/main/RSPDoneSequence.s")
#endif

#ifdef MIPS_TO_C
// generated by mips_to_c commit cae1414eb1bf34873a831a523692fe29870a6f3b
void MainProc(void *arg0) {
    void *temp_v0;
    void *phi_v0;

    gCfbPtrs.unk0 = &gCfb16a;
    gCfbPtrs.unk4 = &gCfb16b;
    gCfbPtrs.unk8 = &gCfb16c;
    phi_v0 = &gCfb16b;
loop_1:
    // potential unrolled loop?
    temp_v0 = phi_v0 + 0x20;
    temp_v0->unk-4 = 0;
    temp_v0->unk-8 = 0;
    temp_v0->unk-C = 0;
    temp_v0->unk-10 = 0;
    temp_v0->unk-14 = 0;
    temp_v0->unk-18 = 0;
    temp_v0->unk-1C = 0;
    temp_v0->unk-20 = 0;
    phi_v0 = temp_v0;
    if (temp_v0 != &gCfb16c) {
        goto loop_1;
    }
    SetupMessageQueue();
    InitializeSystemWorks();
    SysCreateThread(&gAudioThread, 4, &AudioProc, 0, &gAudioThreadStack, 0x14);
    osStartThread(&gAudioThread);
    SysCreateThread(&gGameThread, 5, &thread5_game_logic, 0, &gAudioThread, 0xA);
    osStartThread(&gGameThread);

    // manual work
    while (1) {
        OSMesg msg;
        osRecvMesg(&gIrqMessageQ, &msg, OS_MESG_BLOCK);
        switch (msg) {
            case MESG_SP_COMPLETE:
                RSPDoneSequence();
                break;
            case MESG_DP_COMPLETE:
                RPDDoneSequence();
                break;
            case MESG_VI_VBLANK:
                InterruptSequence();
                break;
            case MESG_StartGFXTask:
                StartGFXTask();
                break;
        }
    }
}
#else
GLOBAL_ASM("asm/non_matchings/main/MainProc.s")
#endif

void InitialGameselectSequence(void) {
    InitKawanoSelect();
    gScreenMode = 0;
    InitialPerspective();
}

void InitialKartselectSequence(void) {
    InitKawanoSelect();
    gScreenMode = 0;
    InitialPerspective();
}

void InitialMapselectSequence(void) {
    InitKawanoSelect();
    gScreenMode = 0;
    InitialPerspective();
}

void InitialTitleSequence(void) {
    InitKawanoSelect();
    gScreenMode = 0;
    InitialPerspective();
}

#ifdef MIPS_TO_C
// TODO: implement jtables
#else
GLOBAL_ASM("asm/non_matchings/main/InitializeSequence.s")
#endif

#ifdef MIPS_TO_C
//generated by mips_to_c commit ffee479fae41a1cdc3e454e9b9d75bbd226a160f
void thread5_game_logic(s32 arg0) {
    osCreateMesgQueue(&gRdpMessageQ, &gRdpMessageBuf, 1);
    osCreateMesgQueue(&gRtcMessageQ, &gRtcMessageBuf, 1);
    InitalizeController();
    if (gResetType == 0) {
        InitializeFirstOnce();
    }
    SetClient(2, &gGfxClient, &gRtcMessageQ, (OSMesg) 1);
    gWinCount2p = (s32) gSaveBuffer;
    gWinCount3p = (s32) (gSaveBuffer + 2);
    gWincount4p = (s32) (gSaveBuffer + 0xB);
    gBattleWinCount2P = (s32) (gSaveBuffer + 0x17);
    gBattleWinCount3P = (s32) (gSaveBuffer + 0x19);
    gBattleWinCount4P = (s32) (gSaveBuffer + 0x1C);
    InitialGameframe();
    ReadController();
    NaSeSeqStart();
loop_3:
    NasAudioInput();
    if (gSequenceMode != gNewSequenceMode) {
        gSequenceMode = (s32) gNewSequenceMode;
        InitializeSequence();
    }
    SetGraphCPUTime(0);
    BeginGameframe();
    ReadController();
    ExecuteSequence();
    EndDrawing();
    FlushDisplayList();
    goto loop_3;
}
#else
GLOBAL_ASM("asm/non_matchings/main/thread5_game_logic.s")
#endif

void AudioProc(UNUSED s32 arg0) {
    UNUSED u32 unused[3];
    NasInitAudio();
    osCreateMesgQueue(&sSoundMesgQueue, &sSoundMesgBuf, 1);
    SetClient(1, &sSoundVblankHandler, &sSoundMesgQueue, (OSMesg) 0x200);
    while (TRUE) {
        OSMesg msg;
        struct SPTask *spTask;

        osRecvMesg(&sSoundMesgQueue, &msg, 1);
        SetAudioCPUTime();
        spTask = NasAudioMain();
        if (spTask != NULL) {
            SetRSPTask(spTask);
        }
        SetAudioCPUTime();
    }
}

; Startup code for cc65 and Shiru's NES library
; based on code by Groepaz/Hitmen <groepaz@gmx.net>, Ullrich von Bassewitz <uz@cc65.org>
; edited by Steven Hugg (remove integrated Famitone2 library, add NMICallback)

	.export _exit,__STARTUP__:absolute=1
	.import initlib,push0,popa,popax,_main,zerobss,copydata

	; Linker generated symbols
	.import __RAM_START__   ,__RAM_SIZE__
	.import __ROM0_START__  ,__ROM0_SIZE__
	.import __STARTUP_LOAD__,__STARTUP_RUN__,__STARTUP_SIZE__
	.import	__CODE_LOAD__   ,__CODE_RUN__   ,__CODE_SIZE__
	.import	__RODATA_LOAD__ ,__RODATA_RUN__ ,__RODATA_SIZE__
	.import NES_MAPPER,NES_PRG_BANKS,NES_CHR_BANKS,NES_MIRRORING

	.include "zeropage.inc"
	.include "nes.inc"

FT_BASE_ADR		=$0100	;page in RAM, should be $xx00

.define FT_THREAD       1	;undefine if you call sound effects in the same thread as sound update
.define FT_PAL_SUPPORT	1   ;undefine to exclude PAL support
.define FT_NTSC_SUPPORT	1   ;undefine to exclude NTSC support

.segment "ZEROPAGE"

NTSC_MODE: 		.res 1
FRAME_CNT1: 		.res 1
FRAME_CNT2: 		.res 1
VRAM_UPDATE: 		.res 1
NAME_UPD_ADR: 		.res 2
NAME_UPD_ENABLE: 	.res 1
PAL_UPDATE: 		.res 1
PAL_BG_PTR: 		.res 2
PAL_SPR_PTR: 		.res 2
SCROLL_X: 		.res 1
SCROLL_Y: 		.res 1
SCROLL_X1: 		.res 1
SCROLL_Y1: 		.res 1
PPU_CTRL_VAR:		.res 1
PPU_CTRL_VAR1:		.res 1
PPU_MASK_VAR: 		.res 1
;;FT_TEMP: 		.res 3
_oam_off:		.res 1
NMICallback:		.res 3

TEMP: 			.res 11

.exportzp NTSC_MODE, FRAME_CNT1, FRAME_CNT2, VRAM_UPDATE
.exportzp NAME_UPD_ADR, NAME_UPD_ENABLE
.exportzp PAL_UPDATE, PAL_BG_PTR, PAL_SPR_PTR
.exportzp SCROLL_X, SCROLL_Y, SCROLL_X1, SCROLL_Y1
.exportzp PPU_CTRL_VAR, PPU_CTRL_VAR1, PPU_MASK_VAR
.exportzp _oam_off, NMICallback
.exportzp TEMP

.include "zpvars.inc"

.segment "STARTUP"

; startup values for the 8 MMC3 registers
mmc3_register_init:
.byte $00 ; 2KB CHR $0000
.byte $02 ; 2KB CHR $0800
.byte $04 ; 1KB CHR $1000
.byte $05 ; 1KB CHR $1500
.byte $06 ; 1KB CHR $1800
.byte $07 ; 1KB CHR $1C00
.byte $00 ; 4KB PRG $8000
.byte $01 ; 4KB PRG $A000

start:
_exit:

    sei
    ldx #$ff
    txs
    inx
    stx PPU_MASK
    stx DMC_FREQ
    stx PPU_CTRL		;no NMI

	; initialize all registers of MMC3
initMMC3:
	lda #0
	sta $E000 ; IRQ disable
	sta $A000 ; mirroring init
	tax
:
	stx $8000 ; select register
	lda mmc3_register_init, X
	sta $8001 ; initialize regiter
	inx
	cpx #8
	bcc :-

initPPU:

    bit PPU_STATUS
@1:
    bit PPU_STATUS
    bpl @1
@2:
    bit PPU_STATUS
    bpl @2

; no APU frame counter IRQs
	lda #$40
	sta PPU_FRAMECNT

clearPalette:

	lda #$3f
	sta PPU_ADDR
	stx PPU_ADDR
	lda #$0f
	ldx #$20
@1:
	sta PPU_DATA
	dex
	bne @1

clearVRAM:

	txa
	ldy #$20
	sty PPU_ADDR
	sta PPU_ADDR
	ldy #$10
@1:
	sta PPU_DATA
	inx
	bne @1
	dey
	bne @1

clearRAM:

    txa
@1:
    sta $000,x
    sta $100,x
    sta $200,x
    sta $300,x
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    inx
    bne @1

	lda #4
	jsr _pal_bright
	jsr _pal_clear
	jsr _oam_clear

    jsr	zerobss
	jsr	copydata

    lda #<(__RAM_START__+__RAM_SIZE__)
    sta	sp
    lda	#>(__RAM_START__+__RAM_SIZE__)
    sta	sp+1            ; Set argument stack ptr

	jsr	initlib

; setup NMICallback trampoline to NOP
	lda #$4C	;JMP xxxx
	sta NMICallback
	lda #<HandyRTS
	sta NMICallback+1
	lda #>HandyRTS
	sta NMICallback+2

	lda #%10000000
	sta <PPU_CTRL_VAR
	sta PPU_CTRL		;enable NMI
	lda #%00000110
	sta <PPU_MASK_VAR

waitSync3:
	lda <FRAME_CNT1
@1:
	cmp <FRAME_CNT1
	beq @1

detectNTSC:
	ldx #52				;blargg's code
	ldy #24
@1:
	dex
	bne @1
	dey
	bne @1

	lda PPU_STATUS
	and #$80
	sta <NTSC_MODE

	jsr _ppu_off

	lda #0
	sta PPU_SCROLL
	sta PPU_SCROLL
	sta PPU_OAM_ADDR

	jmp _main			;no parameters

	.include "neslib.sinc"

.segment "CHARS"
	;;

.segment "SAMPLES"
	;;

.segment "VECTORS"

	.word nmi	;$fffa vblank nmi
	.word start	;$fffc reset
	.word irq	;$fffe irq / brk


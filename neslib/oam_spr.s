
.importzp TEMP, _oam_off, sp
.import popa, popax
.include "nes.inc"
.include "zpvars.inc"

;unsigned char __fastcall__ oam_spr(unsigned char x,unsigned char y,unsigned char chrnum,unsigned char attr,unsigned char sprid);

.export _oam_spr

_oam_spr:

	tax

	ldy #0		;four popa calls replacement
	lda (sp),y
	iny
	sta OAM_BUF+2,x
	lda (sp),y
	iny
	sta OAM_BUF+1,x
	lda (sp),y
	iny
	sta OAM_BUF+0,x
	lda (sp),y
	sta OAM_BUF+3,x

	lda <sp
	clc
	adc #4
	sta <sp
	bcc @1
	inc <sp+1

@1:

	txa
	clc
	adc #4
	ldx #$00
	rts


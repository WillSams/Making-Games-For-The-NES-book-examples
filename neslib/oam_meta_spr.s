
.importzp TEMP, _oam_off, sp
.import popa, popax
.include "nes.inc"
.include "zpvars.inc"

;unsigned char __fastcall__ oam_meta_spr(unsigned char x,unsigned char y,unsigned char sprid,const unsigned char *data);
.export _oam_meta_spr

_oam_meta_spr:

	sta <PTR
	stx <PTR+1

	ldy #2		;three popa calls replacement, performed in reversed order
	lda (sp),y
	dey
	sta <SCRX
	lda (sp),y
	dey
	sta <SCRY
	lda (sp),y
	tax

@1:

	lda (PTR),y		;x offset
	cmp #$80
	beq @2
	iny
	clc
	adc <SCRX
	sta OAM_BUF+3,x
	lda (PTR),y		;y offset
	iny
	clc
	adc <SCRY
	sta OAM_BUF+0,x
	lda (PTR),y		;tile
	iny
	sta OAM_BUF+1,x
	lda (PTR),y		;attribute
	iny
	sta OAM_BUF+2,x
	inx
	inx
	inx
	inx
	jmp @1

@2:

	lda <sp
	adc #2			;carry is always set here, so it adds 3
	sta <sp
	bcc @3
	inc <sp+1

@3:

	txa
	ldx #$00
	rts


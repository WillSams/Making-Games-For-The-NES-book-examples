
.importzp TEMP, _oam_off
.import popa, popax
.include "nes.inc"
.include "zpvars.inc"

;void __fastcall__ oam_meta_spr_clip(signed int x,unsigned char y,const unsigned char *metasprite);

.segment "ZEROPAGE"

SPR_XOFF:	.res 1
SPR_YOFF:	.res 1

.segment "CODE"

.export _oam_meta_spr_clip

_oam_meta_spr_clip:

	sta <PTR
	stx <PTR+1

	jsr popa			;y
	sta <SCRY
	
	jsr popax			;x
	sta <SCRX
	stx <DST			;this is X MSB, repurposing RAM variable name

	ldx _oam_off
	ldy #0

@1:

	lda (PTR),y			;x offset
	cmp #$80
	beq @2
	iny

	sta <SPR_XOFF+0
	clc
	adc <SCRX
	sta <SPR_XOFF+1

	lda <SPR_XOFF+0
	ora #$7f
	bmi :+
	lda #0
:

	adc <DST
	bne @skip

	lda <SPR_XOFF+1
	sta OAM_BUF+3,x
	lda (PTR),y			;y offset
	iny
	clc
	adc <SCRY
	sta OAM_BUF+0,x
	lda (PTR),y			;tile
	iny
	sta OAM_BUF+1,x
	lda (PTR),y			;attribute
	iny
	sta OAM_BUF+2,x
	inx
	inx
	inx
	inx
	jmp @1
	
@skip:

	iny
	iny
	iny
	jmp @1

@2:

	stx _oam_off
	
	rts
	
	; static unsigned char sx,sy,tile,pal,off;
	; static signed int sxx;

	; off=0;

	; while(1)
	; {
		; sx=metasprite[off++];

		; if(sx==128) return;

		; sxx =x+(signed char)sx;
		; sy  =metasprite[off++]+y;
		; tile=metasprite[off++];
		; pal =metasprite[off++];

		; if(!(sxx&0xff00))
		; {
			; oam_spr(sxx,sy,tile,pal,oam_off);
			; oam_off+=4;
		; }
	; }

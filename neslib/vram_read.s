
.importzp TEMP
.import popa, popax
.include "nes.inc"
.include "zpvars.inc"
.export _vram_read

;void __fastcall__ vram_read(unsigned char *dst,unsigned int size);

_vram_read:

	sta <TEMP
	stx <TEMP+1

	jsr popax
	sta <TEMP+2
	stx <TEMP+3

	lda PPU_DATA

	ldy #0

@1:

	lda PPU_DATA
	sta (TEMP+2),y
	inc <TEMP+2
	bne @2
	inc <TEMP+3

@2:

	lda <TEMP
	bne @3
	dec <TEMP+1

@3:

	dec <TEMP
	lda <TEMP
	ora <TEMP+1
	bne @1

	rts




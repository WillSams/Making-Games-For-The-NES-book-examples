
.include "nes.inc"
.segment "CODE"

;void __fastcall__ oam_clear_fast(void);

.export _oam_clear_fast		;make this function accessible to C code

_oam_clear_fast:

	lda #240

	.repeat 64,I
	sta OAM_BUF+I*4
	.endrepeat

	rts

	
	

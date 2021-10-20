

.importzp TEMP, PPU_CTRL_VAR, PPU_CTRL_VAR1, SCROLL_X1
.import popax
.include "nes.inc"
.include "zpvars.inc"
.export _split

;;void __fastcall__ split(unsigned int x,unsigned int y);

_split:

	jsr popax
	sta <SCROLL_X1
	txa
	and #$01
	sta <TEMP
	lda <PPU_CTRL_VAR
	and #$fc
	ora <TEMP
	sta <PPU_CTRL_VAR1

@3:

	bit PPU_STATUS
	bvs @3

@4:

	bit PPU_STATUS
	bvc @4

	lda <SCROLL_X1
	sta PPU_SCROLL
	lda #0
	sta PPU_SCROLL
	lda <PPU_CTRL_VAR1
	sta PPU_CTRL

	rts


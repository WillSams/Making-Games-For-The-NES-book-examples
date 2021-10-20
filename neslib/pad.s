
.segment "ZEROPAGE"

PAD_STATE: 		.res 2		;one byte per controller
PAD_STATEP: 		.res 2
PAD_STATET: 		.res 2

.importzp		TEMP
PAD_BUF			=TEMP+1

.include "nes.inc"
.segment "CODE"
.export _pad_poll, _pad_trigger, _pad_state

;unsigned char __fastcall__ pad_poll(unsigned char pad);

_pad_poll:

	tay
	ldx #0

@padPollPort:

	lda #1
	sta CTRL_PORT1
	lda #0
	sta CTRL_PORT1
	lda #8
	sta <TEMP

@padPollLoop:

	lda CTRL_PORT1,y
	lsr a
	ror <PAD_BUF,x
	dec <TEMP
	bne @padPollLoop

	inx
	cpx #3
	bne @padPollPort

	lda <PAD_BUF
	cmp <PAD_BUF+1
	beq @done
	cmp <PAD_BUF+2
	beq @done
	lda <PAD_BUF+1

@done:

	sta <PAD_STATE,y
	tax
	eor <PAD_STATEP,y
	and <PAD_STATE ,y
	sta <PAD_STATET,y
	txa
	sta <PAD_STATEP,y

	ldx #$00
	rts



;unsigned char __fastcall__ pad_trigger(unsigned char pad);

_pad_trigger:

	pha
	jsr _pad_poll
	pla
	tax
	lda <PAD_STATET,x
	ldx #$00
	rts



;unsigned char __fastcall__ pad_state(unsigned char pad);

_pad_state:

	tax
	lda <PAD_STATE,x
	ldx #$00
	rts




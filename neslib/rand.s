
.segment "ZEROPAGE"

RAND_SEED: 		.res 2

.segment "CODE"
.export _rand8,_rand16,_set_rand
.exportzp RAND_SEED

;unsigned char __fastcall__ rand8(void);
;Galois random generator, found somewhere
;out: A random number 0..255

rand1:

	lda <RAND_SEED
	beq @z1
	asl a
	bcc @1
@z1:	eor #$cf

@1:

	sta <RAND_SEED
	rts

rand2:

	lda <RAND_SEED+1
	beq @z2
	asl a
	bcc @1
@z2:	eor #$d7

@1:

	sta <RAND_SEED+1
	rts

_rand8:

	jsr rand1
	jsr rand2
	adc <RAND_SEED
	ldx #$00
	rts



;unsigned int __fastcall__ rand16(void);

_rand16:

	jsr rand1
	tax
	jsr rand2

	rts


;void __fastcall__ set_rand(unsigned char seed);

_set_rand:
	ora #1
	sta <RAND_SEED
	stx <RAND_SEED+1

	rts




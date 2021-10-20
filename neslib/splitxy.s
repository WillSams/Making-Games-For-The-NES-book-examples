
.importzp TEMP, PPU_CTRL_VAR, PPU_CTRL_VAR1, SCROLL_X1, SCROLL_Y1
.import popax
.include "nes.inc"
.include "zpvars.inc"
.export _splitxy

;;void __fastcall__ splitxy(unsigned int x,unsigned int y);

WRITE1=TEMP+1
WRITE2=TEMP+2

_splitxy:

   ; Extract SCROLL_Y1, SCROLL_X1, WRITE1 from parameters.

   sta <TEMP

   txa
   bne @1
   lda <TEMP
   cmp #240
   bcs @1
   sta <SCROLL_Y1
   lda #0
   sta <TEMP
   beq @2   ;bra

@1:
   sec
   lda <TEMP
   sbc #240
   sta <SCROLL_Y1
   lda #8               ;; Bit 3
   sta <TEMP
@2:

   jsr popax
   sta <SCROLL_X1
   txa
   and #$01
   asl a
   asl a                ;; Bit 2
   ora <TEMP               ;; From Y
   sta <WRITE1            ;; Store!

   ; Calculate WRITE2 = ((Y & $F8) << 2) | (X >> 3)

   lda <SCROLL_Y1
   and #$F8
   asl a
   asl a
   sta <TEMP             ;; TEMP = (Y & $F8) << 2
   lda <SCROLL_X1
   lsr a
   lsr a
   lsr a                ;; A = (X >> 3)
   ora <TEMP             ;; A = (X >> 3) | ((Y & $F8) << 2)
   sta <WRITE2            ;; Store!

   ; Wait for sprite 0 hit

@3:
   bit PPU_STATUS
   bvs @3
@4:
   bit PPU_STATUS
   bvc @4

   ; Set scroll value
   lda PPU_STATUS
   lda <WRITE1
   sta PPU_ADDR
   lda <SCROLL_Y1
   sta PPU_SCROLL
   lda <SCROLL_X1
   ldx <WRITE2
   sta PPU_SCROLL
   stx PPU_ADDR
   
   rts

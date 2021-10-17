/*
Unpacks a RLE-compressed nametable+attribute table into VRAM.
Also uses the pal_bright() function to fade in the palette.
*/

#include <stdint.h>

// include NESLIB header
#include "./../includes/neslib.h"

typedef uint8_t u8;

#pragma bss-name(push, "ZEROPAGE")
#pragma data-name(push, "ZEROPAGE")

u8 oam_off;

#pragma data-name(pop)
#pragma bss-name(pop)

extern const byte climbr_title_pal[16];
extern const byte climbr_title_rle[];

void fade_in() {
  byte vb;
  for (vb=0; vb<=4; vb++) {
    // set virtual bright value
    pal_bright(vb);
    // wait for 4/60 sec
    ppu_wait_frame();
    ppu_wait_frame();
    ppu_wait_frame();
    ppu_wait_frame();
  }
}

void show_title_screen(const byte* pal, const byte* rle) {
  // disable rendering
  ppu_off();
  // set palette, virtual bright to 0 (total black)
  pal_bg(pal);
  pal_bright(0);
  // unpack nametable into the VRAM
  vram_adr(0x2000);
  vram_unrle(rle);
  // enable rendering
  ppu_on_all();
  // fade in from black
  fade_in();
}

void main(void)
{
  show_title_screen(climbr_title_pal, climbr_title_rle);
  while(1);//do nothing, infinite loop
}
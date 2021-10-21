/*
Demonstrates the PPU's tint and monochrome bits.
Use the controller to see different combinations.
*/

#include <stdlib.h>
#include <string.h>

// include NESLIB header
#include "./../neslib/neslib.h"

/*{pal:"nes",layout:"nes"}*/
const char PALETTE[32] = {
    0x2D, // screen color

    0x00, 0x30, 0x30, 0x00, // background palette 0
    0x0C, 0x20, 0x2C, 0x00, // background palette 1
    0x14, 0x10, 0x25, 0x00, // background palette 2
    0x17, 0x16, 0x28, 0x00, // background palette 3

    0x16, 0x35, 0x24, 0x00, // sprite palette 0
    0x00, 0x37, 0x25, 0x00, // sprite palette 1
    0x0D, 0x2D, 0x3A, 0x00, // sprite palette 2
    0x0D, 0x27, 0x2A        // sprite palette 3
};

// setup PPU and tables
void setup_graphics()
{
  // clear sprites
  oam_clear();
  // set palette colors
  pal_all(PALETTE);
}

void main(void)
{
  byte i;
  setup_graphics();
  // draw message
  for (i = 0; i < 30; i++)
  {
    vram_adr(NTADR_A(1, i));
    //    vram_write("\x18\x18 USE CONTROLLER FOR TINT \x18\x18\x18", 30);
    vram_write(" A:red B:green \x1e\x1f:blue \x1c\x1d:mono", 30);
  }
  // attributes
  vram_adr(0x23c0);
  vram_fill(0x00, 8);
  vram_fill(0x55, 8);
  vram_fill(0xaa, 8);
  vram_fill(0xff, 8);
  vram_fill(0x11, 8);
  vram_fill(0x33, 8);
  vram_fill(0xdd, 8);
  // enable rendering
  ppu_on_all();
  // infinite loop
  while (1)
  {
    byte pad = pad_poll(0);
    byte mask = MASK_BG;
    if (pad & PAD_A)
      mask |= MASK_TINT_RED;
    if (pad & PAD_B)
      mask |= MASK_TINT_GREEN;
    if (pad & (PAD_LEFT | PAD_RIGHT))
      mask |= MASK_TINT_BLUE;
    if (pad & (PAD_UP | PAD_DOWN))
      mask |= MASK_MONO;
    ppu_mask(mask);
  }
}


/*
Scrolling demo.
We've selected horizontal mirroring as the default, so
nametables A and C are stacked on top of each other.
The vertical scroll area is 480 pixels high; note how
the nametables wrap around.
*/
#include <stdint.h>
#include <string.h>

#include "./../includes/neslib.h"

typedef uint8_t u8;

#pragma bss-name (push,"ZEROPAGE")
#pragma data-name (push,"ZEROPAGE")

u8 oam_off;

#pragma data-name(pop)
#pragma bss-name (pop)

// function to write a string into the name table
//   adr = start address in name table
//   str = pointer to string
void put_str(unsigned int adr, const char *str) {
  vram_adr(adr);        // set PPU read/write address
  vram_write(str, strlen(str)); // write bytes to PPU
}

// function to scroll window up and down until end
void scroll_demo() {
  int x = 0;   // x scroll position
  int y = 0;   // y scroll position
  int dy = 1;  // y scroll direction
  // infinite loop
  while (1) {
    // wait for next frame
    ppu_wait_frame();
    // update y variable
    y += dy;
    // change direction when hitting either edge of scroll area
    if (y >= 479) dy = -1;
    if (y == 0) dy = 1;
    // set scroll register
    scroll(x, y);
  }
}

// main function, run after console reset
void main(void) {
  // set palette colors
  pal_col(0,0x02);	// set screen to dark blue
  pal_col(1,0x14);	// pink
  pal_col(2,0x20);	// grey
  pal_col(3,0x30);	// white

  // write text to name table
  put_str(NTADR_A(2,0), "nametable a, line 0");
  put_str(NTADR_A(2,15), "nametable a, line 15");
  put_str(NTADR_A(2,29),"nametable a, line 29");
  put_str(NTADR_C(2,0), "nametable c, line 0");
  put_str(NTADR_C(2,15), "nametable c, line 15");
  put_str(NTADR_C(2,29),"nametable c, line 29");

  // enable PPU rendering (turn on screen)
  ppu_on_all();

  // scroll window back and forth
  scroll_demo();
}

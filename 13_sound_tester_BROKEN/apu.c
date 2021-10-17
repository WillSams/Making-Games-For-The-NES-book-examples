#include <string.h>

#include "apu.h"

const unsigned char APUINIT[0x13] = {
  0x30,0x08,0x00,0x00,
  0x30,0x08,0x00,0x00,
  0x80,0x00,0x00,0x00,
  0x30,0x00,0x00,0x00,
  0x00,0x00,0x00
};

void apu_init() {
  // from https://wiki.nesdev.com/w/index.php/APU_basics
  memcpy((void*)0x4000, APUINIT, sizeof(APUINIT));
  APU.fcontrol = 0x40; // frame counter 5-step
  APU.status = 0x0f; // turn on all channels except DMC
}
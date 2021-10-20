.PHONY: all clean

CC65DIR=/usr/bin
#CC65DIR=/data/data/com.termux/files/home/6502/cc65-master

all: crt0.o neslib2.lib
	# cp crt0.o neslib2.lib ~/8bitworkshop/src/worker/lib/nes/
	# cp neslib.h ~/8bitworkshop/presets/nes/

neslib2.lib: lz4vram.o pad.o rand.o memfill.o vram_read.o vram_unrle.o oam_meta_spr_clip.o oam_meta_spr_pal.o oam_meta_spr.o oam_spr.o oam_clear_fast.o split.o splitxy.o
	$(CC65DIR)/ar65 a neslib2.lib $^

%.o: %.s $(wildcard *.s *.sinc)
	$(CC65DIR)/cl65 --verbose --listing $*.lst -t nes -Oisr -g -c $*.s 

clean:
	rm -f *.o *.lst neslib2.lib


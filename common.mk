#!/bin/sh

BIN	= $(NAME).nes

CC65_DIR = /usr/share/cc65

CC  = cl65
AS	= ca65
LD	= ld65 
DA  = da65
OD  = od65

extract = ./tools/nesextract
radare2 = ./tools/rasm2

INCLUDES_DIR=./../neslib

LDFLAGS = -C nes.cfg -t nes -Oisr -m $(NAME).map -Ln $(NAME).labels -vm --include-dir $(INCLUDES_DIR)
OBJDUMP = od65
DEBUGGER = fceux

SRC=$(wildcard *.c)
SRC+=$(wildcard *.s)
SRC+=$(wildcard $(INCLUDES_DIR)/*.s)

OBJS=$(SRC:.c=.o)
OBJS:=$(OBJS:.s=.o)

all: $(BIN) 

clean:
	rm -f $(BIN) $(shell find ./../ -name '*.o')
	rm -f *.labels *.map *.dump disassembly

%.o: %.c
	$(CC) -c $(LDFLAGS) $< -o $@

%.o: %.s
	$(CC) -c $(LDFLAGS) $< -o $@

$(BIN): $(OBJS)
	$(CC) -o $(BIN) $(LDFLAGS) $(OBJS)

$(OBJS): $(wildcard *.h *.sinc)

disassemble:
	$(extract) $(BIN)  
	$(DA) --cpu 6502 --start-addr '$$8000' PRG.prg >| program.s
	${radare2} -a 6502 -D -B -o 32752 -f $(BIN) >| disassembly 

dump: 
	$(OBJDUMP) --dump-all $(OBJS) > $(NAME).dump

run:
	$(DEBUGGER) ./$(BIN)

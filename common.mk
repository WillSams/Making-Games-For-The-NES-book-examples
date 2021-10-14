#!/bin/sh

BIN	= $(NAME).nes

CC  = cl65
AS	= ca65
LD	= ld65
AR  = ar65 
DA  = da65

extract = ./tools/nesextract
radare2 = ./tools/rasm2

CCFLAGS = -c -t none --add-source -Oi -Cl -g 
LDFLAGS = -C nes.cfg -m $(NAME).map -Ln $(NAME).labels --dbgfile $(APP_NAME).dbg -vm
OBJDUMP = od65
DEBUGGER = fceux

CS=$(wildcard *.c)
SS=$(wildcard *.s)
OBJS=$(CS:.c=.o)
OBJS+=$(SS:.s=.o)

RUNTIME_DIR= ./../runtime
# Use the files downloaded from github
#LIBSRC_DIR = /path_for_cc65_here/libsrc
# Use provided runtime files instead
LIBSRC_DIR = $(RUNTIME_DIR)/libsrc
# RUNTIME_CS=$(wildcard *.c)
# RUNTIME_SS=$(wildcard *.s)

# RUNTIME_OBJ_FILES=$(RS:.s=.o)
RUNTIME_FILES_LIST := $(shell cat ${RUNTIME_DIR}/runtime.lst)
RUNTIME_OBJ_FILES = $(patsubst %.s, $(RUNTIME_DIR)/%.o, $(RUNTIME_FILES_LIST))
RUNTIME_LIB=./../runtime.lib

all: $(RUNTIME_LIB)	$(BIN)

clean:
	rm -f $(BIN) $(shell find ./../ -name '*.o')
	rm -f runtime.* *.map *.dump disassembly

$(BIN): $(OBJS)
	$(LD) -o $(BIN) $(LDFLAGS) $@  $(RUNTIME_LIB)

%.o : %.c
	$(CC) $< -o $@   $(RUNTIME_LIB)

%.o: %.s
	$(AS) $< -o $@

$(RUNTIME_LIB): $(RUNTIME_OBJ_FILES)
	$(AR) a $@ $^

disassemble:
	$(extract) $(BIN)  
	$(DA) --cpu 6502 --start-addr '$$8000' PRG.prg >| program.s
	${radare2} -a 6502 -D -B -o 32752 -f $(BIN) >| disassembly 

dump: 
	$(OBJDUMP) --dump-all $(OBJS) > $(NAME).dump

run:
	$(DEBUGGER) ./$(BIN)

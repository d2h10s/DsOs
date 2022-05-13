ARCHITECTURE = armv7-a
MCPU = cortex-a8
OSNAME = DsOs

ROOT = ./

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = $(ROOT)/DsOs.ld

ASM_SRCS = $(wildcard boot/*.S)
ASM_OBJS = $(patsubst boot/%.S,build%.o,$(ASM_SRCS))

dsos = $(ROOT)/build/$(OSNAME).axf
dsos_bin = $(ROOT)/build/$(OSNMAE).bin

.PHONY: all clean run debug

all: $(dsos)

clean:
	rm ./boot/Entry.bin ./boot/Entry.o

as:
	arm-none-eabi-as -march=$(ARCHITECTURE) -mcpu=$(MCPU) -o ./boot/Entry.o ./boot/Entry.S

run: $(dsos)
	qemu-system-arm -M realview-pb a8 -kernel $(dsos)

debug_o:
	hexdump ./boot/Entry.bin

debug_axf:
	arm-none-eabi-objdump -D $(OSNAME).axf

debug: $(dsos)
	qemu-system-arm -M realview-pb a8 -kernel $(dsos) -S -gdb tcp:1234, ipv4
	$(OC) -O binary ./boot/Entry.o ./boot/Entry.bin

gdb:
	arm-none-eabi-gdb

$(dsos): $(ASM_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(ROOT)/$(OSNAME).ld -nostdlib -o $(OSNAME).axf boot/Entry.o


build/%.o : boot/%.S
	mkdir -p $(shell dirname $@)
	$(AS) -march=$(ARCH) -mcpu=$(MCPU) -g -o $@ $<
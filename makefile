ARCH = armv7-a
MCPU = cortex-a8
OSNAME = DsOs

# tool chanins
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = DsOs.ld

ASM_SRCS = $(wildcard boot/*.S)
ASM_OBJS = $(patsubst boot/%.S,build/%.o,$(ASM_SRCS))

dsos = build/$(OSNAME).axf
dsos_bin = build/$(OSNAME).bin

.PHONY: all clean run debug

all: $(dsos)

clean:
	rm -fr build

run: $(dsos)
	qemu-system-arm -M realview-pb-a8 -kernel $(dsos)

debug: $(dsos)
	qemu-system-arm -M realview-pb-a8 -kernel $(dsos) -S -gdb tcp::1234,ipv4

gdb:
	arm-none-eabi-gdb

$(dsos): $(ASM_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(OSNAME).ld -nostdlib -o $(dsos) $(ASM_OBJS)
	$(OC) -O binary $(dsos) $(dsos_bin)


build/%.o : boot/%.S
	mkdir -p $(shell dirname $@)
	$(AS) -march=$(ARCH) -mcpu=$(MCPU) -g -o $@ $<
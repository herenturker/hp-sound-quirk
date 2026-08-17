# Makefile - HP Sound Quirk (Full HDA Module Build)
# Builds the entire snd-hda-codec-realtek module out-of-tree

obj-m += snd-hda-codec-realtek.o

# Get current kernel version and paths
KERNELRELEASE := $(shell uname -r)
KDIR := /lib/modules/$(KERNELRELEASE)/build
PWD := $(shell pwd)

# Include ALL source files from the hda directory
# This ensures all dependencies are resolved
snd-hda-codec-realtek-y := \
    alc262.o \
    alc268.o \
    alc269.o \
    alc283.o \
    alc290.o \
    alc298.o \
    alc300.o \
    alc320.o \
    alc350.o \
    alc382.o \
    alc383.o \
    alc384.o \
    alc385.o \
    alc386.o \
    alc388.o \
    alc389.o \
    alc390.o \
    alc391.o \
    alc392.o \
    alc393.o \
    alc394.o \
    alc395.o \
    alc396.o \
    alc397.o \
    alc398.o \
    alc399.o \
    alc400.o \
    alc401.o \
    patch_realtek.o

# Copy all required source and header files from kernel source
# This is necessary for out-of-tree builds
$(shell cp /usr/src/linux-headers-$(KERNELRELEASE)/sound/pci/hda/*.c ./ 2>/dev/null || true)
$(shell cp /usr/src/linux-headers-$(KERNELRELEASE)/sound/pci/hda/*.h ./ 2>/dev/null || true)
$(shell cp /usr/src/linux-headers-$(KERNELRELEASE)/sound/hda/*.c ./ 2>/dev/null || true)
$(shell cp /usr/src/linux-headers-$(KERNELRELEASE)/sound/hda/*.h ./ 2>/dev/null || true)

all:
	@echo "Building full HDA module for kernel $(KERNELRELEASE)..."
	@if [ ! -d "$(KDIR)" ]; then \
		echo "ERROR: Kernel headers not found!"; \
		echo "Please install: linux-headers-$(KERNELRELEASE)"; \
		exit 1; \
	fi
	@echo "Copying kernel source files to current directory..."
	@make -C $(KDIR) M=$(PWD) modules

clean:
	@echo "Cleaning build files..."
	@make -C $(KDIR) M=$(PWD) clean 2>/dev/null || true
	@rm -f *.o *.ko *.mod.c *.mod *.order *.symvers *.c *.h
	@echo "Clean complete."

install:
	@echo "Loading module..."
	@sudo modprobe -r snd_hda_codec_realtek 2>/dev/null || true
	@sudo insmod snd-hda-codec-realtek.ko
	@if [ $$? -eq 0 ]; then \
		echo "Module loaded successfully!"; \
		echo "Check: dmesg | tail -20"; \
	else \
		echo "ERROR: Module failed to load!"; \
		echo "Check: dmesg | tail -20"; \
		exit 1; \
	fi

remove:
	@echo "Removing module..."
	@sudo rmmod snd-hda-codec-realtek
	@echo "Module removed."

test: install
	@echo ""
	@echo "=== TEST ==="
	@echo "Recent kernel messages:"
	@dmesg | tail -20
	@echo ""
	@echo "Now press the mute and mic-mute keys on your keyboard."
	@echo "Check if the LEDs are working correctly."
	@echo ""
	@echo "If they work, the quirk is successful!"
	@echo ""
	@echo "To unload: make remove"

.PHONY: all clean install remove test

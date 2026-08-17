# Makefile - HP Laptop 15-fd0039nt Sound Quirk Module

obj-m += snd-hda-codec-realtek.o

# Get current kernel version
KERNELRELEASE := $(shell uname -r)
KDIR := /lib/modules/$(KERNELRELEASE)/build

# Source files (only the one we modified)
snd-hda-codec-realtek-objs := alc269.o

all:
	@echo "Building for kernel $(KERNELRELEASE)..."
	@if [ ! -d "$(KDIR)" ]; then \
		echo "ERROR: Kernel headers not found!"; \
		echo "Please install linux-headers-$(KERNELRELEASE)"; \
		exit 1; \
	fi
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean
	rm -f *.o *.ko *.mod.c *.mod *.order *.symvers

install:
	sudo modprobe -r snd_hda_codec_realtek 2>/dev/null || true
	sudo insmod snd-hda-codec-realtek.ko
	@echo "Module loaded. Check: dmesg | tail -20"

remove:
	sudo rmmod snd-hda-codec-realtek
	@echo "Module removed."

test: install
	@echo ""
	@echo "=== TEST ==="
	@echo "Recent dmesg output:"
	@dmesg | tail -20
	@echo ""
	@echo "Now press the mute and mic-mute keys on your keyboard."
	@echo "If the LEDs work, the test is successful!"
	@echo ""
	@echo "To unload the module: make remove"

.PHONY: all clean install remove test
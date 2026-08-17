# Makefile - HP Sound Quirk (Minimal)
# Builds only the modified alc269.c as the Realtek HDA module

obj-m += snd-hda-codec-realtek.o

KERNELRELEASE := $(shell uname -r)
KDIR := /lib/modules/$(KERNELRELEASE)/build
PWD := $(shell pwd)

# Explicitly set the object file from our source
snd-hda-codec-realtek-objs := alc269.o

all:
	@echo "=========================================="
	@echo "HP Sound Quirk Builder"
	@echo "Kernel: $(KERNELRELEASE)"
	@echo "=========================================="
	@echo ""
	@echo "[1/3] Checking kernel headers..."
	@if [ ! -d "$(KDIR)" ]; then \
		echo "ERROR: Kernel headers not found!"; \
		echo "Run: sudo apt install linux-headers-$(KERNELRELEASE)"; \
		exit 1; \
	fi
	@echo "OK"
	@echo ""
	@echo "[2/3] Copying required headers from kernel..."
	@cp /usr/src/linux-headers-$(KERNELRELEASE)/sound/pci/hda/*.h . 2>/dev/null || true
	@cp /usr/src/linux-headers-$(KERNELRELEASE)/sound/hda/*.h . 2>/dev/null || true
	@echo "OK"
	@echo ""
	@echo "[3/3] Building module..."
	@make -C $(KDIR) M=$(PWD) modules
	@echo ""
	@echo "=========================================="
	@echo "BUILD COMPLETE!"
	@echo "Module: snd-hda-codec-realtek.ko"
	@echo "=========================================="
	@echo ""
	@echo "To test: sudo make test"
	@echo "To remove: sudo make remove"
	@echo "To clean: make clean"

clean:
	@echo "Cleaning..."
	@make -C $(KDIR) M=$(PWD) clean 2>/dev/null || true
	@rm -f *.o *.ko *.mod.c *.mod *.order *.symvers *.h
	@echo "Clean complete."

install:
	@echo "Loading module..."
	@sudo modprobe -r snd_hda_codec_realtek 2>/dev/null || true
	@sudo insmod snd-hda-codec-realtek.ko
	@if [ $$? -eq 0 ]; then \
		echo "Module loaded successfully!"; \
		echo ""; \
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
	@echo "=========================================="
	@echo "TEST"
	@echo "=========================================="
	@echo ""
	@echo "Recent kernel messages:"
	@dmesg | tail -20
	@echo ""
	@echo "Now press the mute and mic-mute keys on your keyboard."
	@echo "Check if the LEDs work correctly."
	@echo ""
	@echo "If they work, the quirk is successful!"
	@echo ""
	@echo "To unload: sudo make remove"

.PHONY: all clean install remove test

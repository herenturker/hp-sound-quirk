
# HP Sound Quirk for HP Laptop 15-fd0039nt

This repository provides an out-of-tree kernel module to fix the mute LED and mic-mute LED functionality on the HP Laptop 15-fd0039nt (and other 15-fd0xxx models) with the Realtek ALC236 audio codec.

## The Problem

The HP Laptop 15-fd0xxx series has an issue where the speaker mute and microphone mute LEDs do not work correctly under Linux. The existing quirk (ALC236_FIXUP_HP_MUTE_LED_COEFBIT2) only enables the speaker mute LED but does not handle the mic-mute LED.

## The Solution

This module applies the ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO fixup, which:
- Enables the speaker mute LED
- Enables the microphone mute LED via GPIO bit 0

The quirk is applied using the device's Subsystem ID (0x103c:0x8bb6).

## Building and Testing

### Prerequisites

You need the kernel headers for your current kernel:

Debian/Ubuntu:
``` bash
sudo apt update
sudo apt install linux-headers-$(uname -r) build-essential
```
Fedora/RHEL:
``` bash
sudo dnf install kernel-devel-$(uname -r) gcc make
```
### Clone and Build
``` bash
git clone https://github.com/herenturker/hp-sound-quirk.git
cd hp-sound-quirk
make
```

## Load and Test

### Remove the existing module
``` bash
sudo modprobe -r snd_hda_codec_realtek
```

### Load your custom module
``` bash
sudo insmod snd-hda-codec-realtek.ko
```

### Check kernel logs
``` bash
dmesg | tail -20
```
You should see a log entry confirming the quirk is applied:
``` bash
hda_codec_realtek: quirk applied for HP Laptop 15-fd0039nt (SSID: 103c:8bb6)
```
Now press the mute and mic-mute keys on your keyboard and verify the LEDs work correctly.

### Unload

``` bash
sudo rmmod snd_hda_codec_realtek
```

### Automated Test Script

Run the included test script to automate the process:
``` bash
chmod +x test.sh
./test.sh
```
## License
GPL v2 (same as the Linux kernel).
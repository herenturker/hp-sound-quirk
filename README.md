
# HP Sound Quirk for HP Laptop 15-fd0039nt

This repository provides an out-of-tree kernel module to fix the mute LED and mic-mute LED functionality on the HP Laptop 15-fd0039nt (and other 15-fd0xxx models) with the Realtek ALC236 audio codec.

## The Problem

The HP Laptop 15-fd0xxx series has an issue where the speaker mute and microphone mute LEDs do not work correctly under Linux. The existing quirk (ALC236_FIXUP_HP_MUTE_LED_COEFBIT2) only enables the speaker mute LED but does not handle the mic-mute LED.

## The Solution

This module applies the ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO fixup, which:
- Enables the speaker mute LED
- Enables the microphone mute LED via GPIO bit 0

The quirk is applied using the device's Subsystem ID (0x103c:0x8bb6).

You need to download the Linux kernel from official resources and replace the ```alc269.c``` file in ```/sound/hda/codecs/realtek```.

The change added is:
``` c
SND_PCI_QUIRK(0x103c, 0x8bb6, "HP Laptop 15-fd0039nt", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO);
```

## License
GPL v2 (same as the Linux kernel).

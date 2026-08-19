# ALC236 Mic-Mute LED Patch for HP Laptop 15-fd0039nt

This repository provides an out-of-tree Linux kernel module patch that fixes the microphone mute LED functionality on the HP Laptop 15-fd0039nt (and potentially other 15-fd0xxx models) using the Realtek ALC236 audio codec.

## Overview

On HP Laptop 15-fd0xxx series laptops running Linux, the microphone mute LED does not toggle correctly by default due to a missing subsystem quirk entry in the kernel's Realtek driver.

This patch adds a dedicated fixup (```ALC236_FIXUP_HP_MICMUTE_LED_ONLY```) targeting Subsystem ID 103c:8bb6. It routes the mic-mute LED control through GPIO 0 with active-low polarity.

## Patch Details

* Target File: sound/pci/hda/patch_realtek.c
* Subsystem ID (SSID): 103c:8bb6
* Fixup Added: ALC236_FIXUP_HP_MICMUTE_LED_ONLY
* Codes added (in random placement):
``` c
static void alc236_fixup_hp_micmute_led_only(struct hda_codec *codec,
					       const struct hda_fixup *fix, int action)
{
	struct alc_spec *spec = codec->spec;

	if (action == HDA_FIXUP_ACT_PRE_PROBE)
		spec->micmute_led_polarity = 1;
	alc_fixup_hp_gpio_led(codec, action, 0x00, 0x01);
}
```
``` c
ALC236_FIXUP_HP_MICMUTE_LED_ONLY,
```
``` c
[ALC236_FIXUP_HP_MICMUTE_LED_ONLY] = {
	.type = HDA_FIXUP_FUNC,
	.v.func = alc236_fixup_hp_micmute_led_only,
},
```
``` c
SND_PCI_QUIRK(0x103c, 0x8bb6, "HP Laptop 15-fd0039nt", ALC236_FIXUP_HP_MICMUTE_LED_ONLY),
```

## Tested On

* Hardware: HP Laptop 15-fd0039nt (SSID: 103c:8bb6)
* OS: Debian Linux
* Kernel Versions (Patch Tested On): 6.12.101 and 7.2.0

## License

GPL-2.0 (same as the Linux kernel).

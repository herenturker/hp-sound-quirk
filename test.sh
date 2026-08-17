#!/bin/bash
# test.sh - Automated test script for HP sound quirk

set -e

echo "=== HP Sound Quirk Test ==="
echo ""

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo: sudo ./test.sh"
    exit 1
fi

# Remove existing module
echo "1. Removing existing module..."
modprobe -r snd_hda_codec_realtek 2>/dev/null || true
echo ""

# Load new module
echo "2. Loading new module..."
insmod snd-hda-codec-realtek.ko

if [ $? -ne 0 ]; then
    echo "ERROR: Module failed to load!"
    echo "Check dmesg for details."
    exit 1
fi
echo "Module loaded successfully."
echo ""

# Show kernel logs
echo "3. Recent kernel logs (last 20 lines):"
dmesg | tail -20
echo ""

# Check if module is loaded
echo "4. Module status:"
lsmod | grep snd_hda_codec_realtek || echo "Module not loaded!"
echo ""

# Instructions
echo "5. Now press the mute and mic-mute keys on your keyboard."
echo "   Check if the LEDs are working correctly."
echo ""
echo "6. To unload the module: sudo rmmod snd_hda_codec_realtek"
echo ""
echo "If everything works, save the dmesg output as proof of testing."
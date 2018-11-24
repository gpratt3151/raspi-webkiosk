# Overclock the Pi Zero W
cat << EOF >> /f/config.txt
# Overclock Raspberry Pi Zero W
arm_freq=1000
gpu_freq=500
core_freq=500
sdram_freq=500
sdram_schmoo=0x02000020
over_voltage=2
sdram_over_voltage=2
EOF

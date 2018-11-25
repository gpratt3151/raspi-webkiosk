# raspi-webkiosk
A web kiosk for the Raspberry Pi Zero W

# Download Image
Download the [RASPBIAN STRETCH LITE](https://www.raspberrypi.org/downloads/raspbian/) image.

# Burn Image
1. Use `Etcher` to burn raspian stretch lite.
0. Execute `pre.sh`
0. Update the `wpa_supplicant.conf` on the root of the SD Card.

# After Initial boot
1. Execute the following command to install git and pull in this repository.
```bash
sudo apt-get install -y git-core && git clone https://github.com/gpratt3151/raspi-webkiosk.git
```
0. Execute `configure.sh`.
0. When complete, reboot the system.

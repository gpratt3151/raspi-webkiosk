# raspi-webkiosk
A web kiosk for the Raspberry Pi Zero W

# Download Image
Download the [RASPBIAN STRETCH LITE](https://www.raspberrypi.org/downloads/raspbian/) image.

# Burn Image & Preconfigure
1. Use `Etcher` to burn raspian stretch lite.
0. Execute `pre.sh`
0. Update the `wpa_supplicant.conf` on the root of the SD Card.

# Post-initial Boot Configuration
1. Login via keyboard connected to the Pi Zero W as `pi` with initial password of `raspberry`.
2. Change the initial password via the `passwd` command.
3. Execute the following command to install git and pull in this repository.
```bash
sudo apt-get install -y git-core && git clone https://github.com/gpratt3151/raspi-webkiosk.git
```
4. Execute `configure.sh`.
5. When complete, reboot the system.

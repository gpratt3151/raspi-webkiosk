# raspi-webkiosk
A web kiosk for the Raspberry Pi Zero W based upon a minimal Raspian Lite (Stretch).

# Purpose
The purpose of this project is to build a functioning web kiosk based upon the $10 USD ($5 on sale) Raspberry Pi Zero W. Power from an integrated USB port on the TV should be fine. The installation process is semi-automated and requires minimal interaction. Once the build is complete, you should have a functioning web browser that can be controlled via the command-line.

## Process Overview
- Download the image
- Perform basic configuration of the initial prior to first boot
- Boot the image
- Perform final configuration of the operating sytem and add all necessary programs for the web browser

# Prerequisites
- Raspberry Pi Zero W
- SD Card >= 4 GB (Supposedly a Class 10 Card will help with performance)
- Windows computer with `Etcher`
- `git bash` command-line
- Micro USB to USB Female connector
- Keyboard

## Considerations
- In order to get good performance from the Pi Zero W it is overclocked. Settings are found in the `config/raspian/overclock.sh` file.
- The web browser is [uzbl](https://www.uzbl.org) because it can be controlled via the command-line and does a fairly good job rendering basic websites. **Note:** This kiosk has been optimized for basic web pages with minimal animation and no video.
- X Windows has been configured to auto-start at boot.
- The [matchbox](https://www.yoctoproject.org/software-item/matchbox/) Window Manager was chosen because it's designed for embedded systems and extremely lightweight.
- The `pre.sh` command is meant to run from a UNIX command-line on Windows. I recommend something like git bash.
- During configuration, bluetooth is disabled and all tools are removed from the operating system.
- There is minimal error checking so you'll need to keep an eye out for any failures during configuration.

# Download The Image
Download the [RASPBIAN STRETCH LITE](https://www.raspberrypi.org/downloads/raspbian/) image.

# Burn The Image & Preconfigure
1. Use `Etcher` to burn raspian stretch lite.
0. Execute `pre.sh`
0. Update the `wpa_supplicant.conf` on the root of the SD Card.

# Post-initial Boot Configuration
1. Login via keyboard connected to the Pi Zero W as `pi` with initial password of `raspberry`.
2. Change the initial password via the `passwd` command.
## Option A - Single Command
3. Execute the following command to install git and pull in this repository.
```bash
sudo apt-get install -y git-core && git clone https://github.com/gpratt3151/raspi-webkiosk.git && (cd raspi-webkiosk; ./configure.sh) && reboot
```
## Option B - Separate Commands
```bash
sudo apt-get install -y git-core
git clone https://github.com/gpratt3151/raspi-webkiosk.git
cd raspi-webkiosk
./configure.sh && reboot
```
4. When complete, the system should reboot reboot the system. If the system does not reboot something failed during the configuration process.

# Customize the default web page
You probably don't want the sample web page that is configured by default. There are two methods to change this:
### Before running `configure.sh`
Edit the `config/X11/xinitrc` file before running configure.sh
### After running `configure.sh`
Edit the $HOME/.xinitrc file
### Modify the URL
In either case you need to change the following line by replacing the URL. Be sure to keep the ampersand (&) at the end!
```
exec /usr/bin/uzbl-core -p http://commondatastorage.googleapis.com/risemedialibrary-395c64e5-2930-460b-881e-009aabb157df/content-templates/teacher-profile/teacher-profile.html &
```

# Controlling ubzl
Here are some example commands for controlling uzbl.
```bash
FIFO=$(ls -1rt /tmp/uzbl* | tail -1)
echo 'set uri = file:///home/pi/raspi-webkiosk/config/calibration/97VkS.png' > ${FIFO}
echo 'set uri = about:blank' > ${FIFO}
echo 'set show_status = 0' > ${FIFO}
```

# Calibrate your monitor or TV
If you need to adjust the image, I have made some improvements to the great utility, `overscan` to make this a turnkey process. Clone the forked project, [gpratt3151/overscan](https://github.com/gpratt3151/set_overscan) and execute `set_overscan.sh` as follows and follow the directions:
```bash
sudo set_overscan.sh
```

# Troubleshooting
The log file is located in `/tmp/xinit.log`

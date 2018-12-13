# Clear manpages and prevent from future installs for space saving
# From: https://askubuntu.com/questions/129566/remove-documentation-to-save-hard-drive-space/401144#401144
sudo cp config/man/01_nodoc  /etc/dpkg/dpkg.cfg.d/01_nodoc
find /usr/share/doc -depth -type f ! -name copyright| sudo xargs rm || true
find /usr/share/doc -empty|xargs sudo rmdir || true
sudo rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/*
sudo rm -rf /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*

# Install additional software

# Remove unused packages or problematic packages
## Bluetooth
sudo apt-get purge -y bluez \
  bluez-firmware \
  pi-bluetooth \
  samba-common \
  nfs-common \
  libnss-mdns

## Compilers
sudo apt-get purge -y gcc \
  gcc-6 \
  gdb

## Compilers
sudo apt-get purge -y gcc \
  gcc-6 \
  gdb

#sudo apt-get autoremove --purge
sudo apt autoremove -y

sudo apt-get update

# For TV status
sudo apt-get -y install \
  cec-utils

# For Web Browser
sudo apt-get -y install \
  git-core \
  matchbox \
  uzbl \
  x11-xserver-utils \
  xserver-xorg \
  x11-utils \
  x11-common \
  xinit

# Configure the hostname
_HOST=$(cat /proc/sys/kernel/random/uuid | awk -F'-' '{ print $5 }')
sudo raspi-config nonint do_hostname $_HOST

# Configure Raspian
## Locale and Keyboard
_LOCALE=en_US.UTF-8
_LAYOUT=us
sudo raspi-config nonint do_change_locale $_LOCALE
sudo raspi-config nonint do_configure_keyboard $_LAYOUT

## Timezone
_TIMEZONE=CST6CDT
sudo raspi-config nonint do_change_timezone $_TIMEZONE

## Fix bug in allowing ssh logins over wireless on Pi Zero W
sudo rm /etc/ssh/ssh_host_* && sudo dpkg-reconfigure openssh-server
# Can't just echo the data to sshd_config as it's protected so we copy
sudo cp config/raspian/sshd_config /etc/ssh/sshd_config
#sudo raspi-config nonint do_ssh

## Wireless Configuration
# If you're not using the wpa_supplicant.conf on /boot update this
# Wireless Configuration
#_COUNTRY=US
#sudo raspi-config nonint do_wifi_country $_COUNTRY
#_SSID=__XYZZY__
#_PASSPHRASE=__xyzzy__
#sudo raspi-config nonint do_wifi_ssid_passphrase $_SSID
#sudo raspi-config nonint do_wifi_ssid_passphrase $_PASSPHRASE

# Boot Behavior - Kiosk mode requires X11 at boot
export SUDO_USER=pi
#export _OPTION=B4  # Multi-user auto-login graphical interface
#sudo raspi-config nonint do_boot_behaviour $_OPTION
sudo systemctl set-default graphical.target
sudo ln -fs /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo sed /etc/systemd/system/autologin@.service -i -e "s#^ExecStart=-/sbin/agetty --autologin [^[:space:]]*#ExecStart=-/sbin/agetty --autologin $SUDO_USER#"
sudo sed /etc/X11/Xwrapper.config -i -e "s#allowed_users=console#allowed_users=anybody#"

# Specific to the kiosk - uzbl web browser and X11 init file
mkdir -p $HOME/.config/uzbl
cp config/uzbl/config $HOME/.config/uzbl/
cp config/X11/xinitrc $HOME/.xinitrc
sudo cp config/X11/Xwrapper.config /etc/X11/Xwrapper.config

cat config/pi/profile >> $HOME/.profile 

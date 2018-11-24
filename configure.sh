# Ensure ssh is enabled at next boot
touch /boot/ssh

# Install additional software

# Remove unused packages
## Bluetooth
sudo apt-get purge -y bluez \
  bluez-firmware \
  pi-bluetooth \
  samba-common \
  nfs-common 

## Compilers
sudo apt-get purge -y gcc \
  gcc-6 \
  gdb

# Remove unused packages
## Bluetooth
sudo apt-get purge -y bluez \
  bluez-firmware \
  pi-bluetooth \
  samba-common \
  nfs-common 

## Compilers
sudo apt-get purge -y gcc \
  gcc-6 \
  gdb

#sudo apt-get autoremove --purge
sudo apt autoremove

sudo apt-get update

sudo apt-get -y install \
  git-core \
  matchbox \
  uzbl \
  x11-xserver-utils \
  xserver-xorg \
  x11-utils \
  x11-common \
  xinit

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
echo "IPQoS 0x00" >> /etc/ssh/sshd_config
sudo rm /etc/ssh/ssh_host_* && sudo dpkg-reconfigure openssh-server
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

cat << EOF >> $HOME/.profile 
# Protect if we are logging in by checking if we are interactive
# If we are not, start X
# If we are interactive allow login without starting X
if [[ $- != *i* ]]
then
  echo "Non-interactive"
  xinit | tee /tmp/xinit.log 2>&1
fi
EOF



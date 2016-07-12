#/bin/sh


apt update -y
apt install -y python
apt install -y libbluetooth-dev bluez

apt install -y dbus
apt install -y python-pip python-dev python-gobject python-dbus

pip install pybluez
pip install evdev

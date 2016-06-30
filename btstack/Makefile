BTSRC=./btstack/src
DAEMONSRC=./btstack/platform/daemon/src
POSIXSRC=./btstack/platform/posix
PORTSRC=./btstack/port/libusb

CFLAGS=-ggdb -O2 -I$(BTSRC) -I$(DAEMONSRC) -I$(POSIXSRC) -I$(PORTSRC) -L/usr/local/lib
LDFLAGS=-lBTstack $(PORTSRC)/btstack_link_key_db_fs.o $(PORTSRC)/hci_dump.o

all: daemon pair

daemon: daemon.c bthid.c uhid.c hiddevs.c
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

pair: pair.c hiddevs.c
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -f daemon

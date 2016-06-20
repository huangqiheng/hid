POSIXH4=./btstack/port/posix-h4
CFLAGS=-ggdb -O2 -I./ -L/usr/local/lib
LDFLAGS=-l BTstack $(POSIXH4)/btstack_link_key_db_fs.o $(POSIXH4)/hci_dump.o

all: daemon pair

daemon: daemon.c bthid.c uhid.c hiddevs.c
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

pair: pair.c hiddevs.c
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -f daemon

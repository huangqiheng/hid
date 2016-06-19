BTSTACK=../btstack
CFLAGS=-ggdb -O2 -I$(BTSTACK)/include -I$(BTSTACK)
LDFLAGS=-l BTstack

all: daemon pair

daemon: daemon.c bthid.c uhid.c hiddevs.c
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

pair: pair.c hiddevs.c
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -f tinyhidd

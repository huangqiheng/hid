#!/bin/sh

proj_path=`dirname $(readlink -f $0)`
init_json=$proj_path/init.json


echo "#-----------------------------------------#"
echo "#             Check VID & PID             #"
echo "#-----------------------------------------#"

if [ "x$1" = "x" ]; then
	vendor_id=''
	product_id=''

	if [ -f $init_json ]; then
		if ! type jq > /dev/null; then
			apt-get install -y jq
		fi

		vendor_id=`cat $init_json | jq -jre '.vendor_id'`
		product_id=`cat $init_json | jq -jre '.product_id'`
	fi
else 
	vendor_id=`echo $1 | cut -d ":" -f 1`
	product_id=`echo $1 | cut -d ":" -f 2`

	echo "{" > $init_json
	echo "\t\"vendor_id\" : \"$vendor_id\"," >> $init_json
	echo "\t\"product_id\" : \"$product_id\"" >> $init_json
	echo "}" >> $init_json
fi

if [ "x$vendor_id" = "x" ] || [ $vendor_id = "null" ]; then
	echo "{" > $init_json
	echo "\t\"vendor_id\" : null," >> $init_json
	echo "\t\"product_id\" : null" >> $init_json
	echo "}" >> $init_json

	echo "WARNNIUNG: The bluetooth device's vendor id and product id MUST be set."
	echo "Check one in the list below:"
	lsusb
	echo "And fill the exactly one in file: $init_json, like this:"
	echo "{"
	echo "\t\"vendor_id\" : \"0a12\","
	echo "\t\"product_id\" : \"0001\""
	echo "}"
	exit
else 
	echo "Please plug in the exactly bluetooth usb dougle. Every runtime."
	echo "  vendor_id : $vendor_id"
	echo "  product_id : $product_id"
fi



if [ ! -f $init_json ]; then
echo "#-----------------------------------------#"
echo "# 	    setup environment           #"
echo "#-----------------------------------------#"

apt-get update -y
apt-get upgrade -y
apt-get install -y git automake build-essential libusb-1.0-0-dev
apt-get install -y pkg-config linux-headers-$(uname -r)

fi # end of block


echo "#-----------------------------------------#"
echo "#             compile btstack             #"
echo "#-----------------------------------------#"

btstack_dir=$proj_path/btstack

if [ ! -f /usr/local/bin/hidd ]; then
	if [ ! -d $btstack_dir ]; then
		cd $proj_path
		git clone https://github.com/bluekitchen/btstack.git
	fi
	
	daemon_dir=$btstack_dir/port/daemon

	if [ ! -d $daemon_dir ]; then
		echo "btstack not ready, try again please."
		exit
	fi

	cd $daemon_dir

	if [ ! -f $daemon_dir/configure ]; then
		./bootstrap.sh
		sed -i "s|-Werror -Wall|-fpic -Wall|g" $daemon_dir/configure
		sed -i "s|cp libBTstack.dylib|cp libBTstack.\$\(BTSTACK_LIB_EXTENSION\)|g" $daemon_dir/src/Makefile.in
		sed -i "s|\/include\/btstack|\/src/*|g" $daemon_dir/src/Makefile.in
		echo "\tcp -r $btstack_dir/platform/posix/* \$(prefix)/include" >> $daemon_dir/src/Makefile.in
	fi

	./configure --with-vendor-id=$vendor_id --with-product-id=$product_id
	make clean
	make
	make install
fi




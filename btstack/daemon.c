#include <btstack.h>
#include <btstack_client.h>
#include <btstack_run_loop_posix.h>
#include <hci_cmd.h>
#include "bthid.h"

int main(int argc, char **argv){
	btstack_run_loop_init(btstack_run_loop_posix_get_instance());

	int err = bt_open();
	if (err)
		return err;

	bt_register_packet_handler(bthid_packet_handler);
	bt_send_cmd(&btstack_set_power_mode, HCI_POWER_ON);
	bt_send_cmd(&l2cap_register_service_cmd, PSM_HID_CONTROL, 250);
	bt_send_cmd(&l2cap_register_service_cmd, PSM_HID_INTERRUPT, 250);
	btstack_run_loop_execute();

	return 0;
}


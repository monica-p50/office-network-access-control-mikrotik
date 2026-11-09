# A second router as an access point

A consumer router (for example a D-Link DIR-615) can extend Wi-Fi without creating a second network. These are the usual steps; check them against the device's own menu.

1. Give it a fixed address in the office range, outside the DHCP pool, for example 192.168.88.5.
2. Turn **DHCP server off** on it. The MikroTik stays the only DHCP server.
3. Connect a **LAN** port of the access point to a bridge port of the MikroTik (not the WAN/Internet port).
4. Set the Wi-Fi name and a strong WPA2/WPA3 password.

Because the access point only bridges, every device still gets its address from the MikroTik and must sign in through the hotspot like any other device.

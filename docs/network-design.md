# Network design

| Item | Value |
| --- | --- |
| Router | MikroTik hEX (RB750Gr3), RouterOS 7.24 |
| LAN | `bridge-lan` 192.168.88.0/24, router 192.168.88.1 |
| DHCP pool | 192.168.88.10 - 192.168.88.254, lease 1 day |
| Uplink 1 | `ether1`, modem 192.168.1.x range, primary (distance 1) |
| Uplink 2 | `ether5`, second modem, backup (distance 2) |
| Home VPN | `wg-home` 10.98.0.1/24, UDP 51820 |
| Monitoring tunnel | `wg-vps` 10.99.0.2/24 |

The router sits behind two ISP modems, so it has a private address on each uplink (double NAT). Anything that must be reached from outside, such as the VPN port, has to be forwarded on both modems.

## Bridge ports
`ether2`, `ether3` and `ether4` are members of `bridge-lan`. `ether1` and `ether5` are the uplinks and are not bridged.

```
/interface bridge port
add bridge=bridge-lan interface=ether2
add bridge=bridge-lan interface=ether3
add bridge=bridge-lan interface=ether4
/ip address
add address=192.168.88.1/24 interface=bridge-lan network=192.168.88.0
/ip dhcp-client
add interface=ether1 add-default-route=no use-peer-dns=no
add interface=ether5 add-default-route=no
```

Default routes are set by hand (see `nat-and-failover.md`), so the DHCP clients do not add routes.

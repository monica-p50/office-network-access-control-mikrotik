# NAT and failover

## NAT

```
/ip firewall nat
add chain=srcnat action=masquerade src-address=192.168.88.0/24 comment="masquerade hotspot network"
add chain=srcnat action=masquerade out-interface=ether1
add chain=srcnat action=masquerade out-interface=ether5
add chain=srcnat action=masquerade out-interface=wg-vps comment="LAN to monitoring server via wg"
```

The router rewrites LAN addresses to the address of whichever uplink carries the traffic. The last rule does the same for the tunnel to the monitoring server.

## Two internet lines

```
/ip route
add dst-address=0.0.0.0/0 gateway=<ISP1 modem> distance=1 check-gateway=ping
add dst-address=0.0.0.0/0 gateway=<ISP2 modem> distance=2 check-gateway=ping
add dst-address=208.67.222.222/32 gateway=<ISP1 modem> comment="monitor ISP1"
add dst-address=9.9.9.9/32 gateway=<ISP2 modem> comment="monitor ISP2"
```

* Both lines have a default route. The line with the lower distance (ISP 1) is used while it works.
* `check-gateway=ping` makes the router test the modem. If the modem stops answering, that route is marked inactive and the second one takes over.
* The two /32 routes pin one test address to each line, so each line can be tested on its own (for example with `ping 208.67.222.222`).

## Test failover

1. `/ip route print` and note the active route (`A`).
2. Unplug ISP 1. Within a short time the ISP 2 route becomes active.
3. Plug ISP 1 back. The distance-1 route returns.

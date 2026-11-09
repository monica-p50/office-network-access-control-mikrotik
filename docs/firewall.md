# Firewall

Two chains matter. **input** is traffic to the router. **forward** is traffic through the router.

## Input chain (protect the router)

```
/ip firewall filter
add chain=input action=accept connection-state=established,related
add chain=input action=drop   connection-state=invalid
add chain=input action=accept protocol=udp dst-port=51820 comment="WireGuard home VPN"
add chain=input action=drop   in-interface=ether5 comment="drop input from uplink 2"
add chain=input action=drop   in-interface=ether1 comment="drop input from uplink 1"
```

Nothing from either internet line may talk to the router, except the VPN port. The VPN accept rule sits above the uplink drops, so the order matters.

A trusted management host gets a full input accept:

```
add chain=input action=accept src-address=192.168.88.<trusted> comment="trusted host input"
```

## Forward chain (traffic between networks)

```
add chain=forward action=accept connection-state=established,related
add chain=forward action=accept connection-state=new protocol=tcp dst-port=443,8443
add chain=forward action=accept connection-state=new protocol=udp dst-port=443,51820
add chain=forward action=accept src-address-list=trusted-full-access comment="trusted users"
add chain=forward action=drop   connection-state=invalid
```

The hotspot adds its own dynamic rules (the ones marked `D`) in front of these. They redirect unsigned devices to the login page and reject their other traffic.

## Data counters
Passthrough rules count how much each company PC sends and receives outside the office networks. They do not block anything:

```
add chain=forward action=passthrough src-address=192.168.88.28 dst-address-list=!office-nets comment=pcdata-up-192.168.88.28
add chain=forward action=passthrough dst-address=192.168.88.28 src-address-list=!office-nets comment=pcdata-down-192.168.88.28
```

## Services on the router

```
/ip service
set ftp disabled=yes
set telnet disabled=yes
set www disabled=yes
set api-ssl disabled=yes
set ssh available-from=192.168.88.0/24,10.98.0.0/24
set api available-from=10.99.0.1/32
```

SSH works only from the office LAN and the home VPN. The API works only from the monitoring server tunnel address, with a read-only account.

## Check

```
/ip firewall filter print
/ip firewall connection print count-only
```

# Hotspot and company PCs

The hotspot runs on `bridge-lan`. Any device that is not bound must sign in with a user name and password before it reaches the internet. Company PCs are bound by MAC address and skip the login.

## Hotspot

```
/ip hotspot profile
add name=hsprof1 hotspot-address=192.168.88.1 dns-name=login.wifi login-by=http-chap http-cookie-lifetime=1d html-directory=flash/hotspot
/ip hotspot
add name=hotspot1 interface=bridge-lan address-pool=dhcp-pool profile=hsprof1 keepalive-timeout=10m idle-timeout=none
/ip hotspot user profile
add name=full-access address-list=trusted-full-access keepalive-timeout=2h mac-cookie-timeout=1d
```

Users are created with `/ip hotspot user add name=<user>`. One profile, `full-access`, puts its users in the address list `trusted-full-access` for the firewall and DNS rules.

## Company PCs skip the login

```
/ip hotspot ip-binding
add mac-address=AA:BB:CC:00:00:01 type=bypassed comment="Company PC - DESKTOP-EXAMPLE1"
add mac-address=AA:BB:CC:00:00:02 type=bypassed comment="Company PC - DESKTOP-EXAMPLE2"
```

`type=bypassed` means: let this device through without a login. The comment follows a naming convention, `Company PC - <hostname>`. Other tools (for example the monitoring dashboard) read this comment to tell company PCs from phones and guests.

## Pair it with a static lease

```
/ip dhcp-server lease
add address=192.168.88.28 mac-address=AA:BB:CC:00:00:01 comment="Company PC - DESKTOP-EXAMPLE1"
```

A fixed address makes firewall rules, remote desktop and logs predictable.

## Walled garden
The monitoring server address is allowed before login so the router can always reach it:

```
/ip hotspot walled-garden ip
add action=accept dst-address=<VPS_IP> comment="monitoring server"
```

## Check

```
/ip hotspot active print
/ip hotspot ip-binding print
```

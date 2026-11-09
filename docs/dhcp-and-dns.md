# DHCP and DNS

```
/ip pool add name=dhcp-pool ranges=192.168.88.10-192.168.88.254
/ip dhcp-server add name=dhcp1 interface=bridge-lan address-pool=dhcp-pool lease-time=1d
/ip dhcp-server network add address=192.168.88.0/24 gateway=192.168.88.1 dns-server=192.168.88.1
```

The router is the DNS server for the LAN. It forwards to a filtering resolver:

```
/ip dns set allow-remote-requests=yes servers=1.1.1.3,1.0.0.3
```

## Local block list
Known advertising and tracking names are answered with 127.0.0.1, so the device cannot reach them:

```
/ip dns static
add name=ads.example.com address=127.0.0.1 match-subdomain=yes type=A
```

## Stopping DNS bypass
Devices can ignore the router and use a public DNS-over-HTTPS server. A list of well-known resolvers is kept so rules can find them:

```
/ip firewall address-list
add list=doh-servers address=1.1.1.1 comment=Cloudflare
add list=doh-servers address=8.8.8.8 comment=Google
add list=doh-servers address=9.9.9.9 comment=Quad9
```

A trusted-host rule sends the DNS of `trusted-full-access` to 1.1.1.1 and skips the hotspot DNS redirect:

```
/ip firewall nat
add chain=dstnat action=dst-nat protocol=udp dst-port=53 src-address-list=trusted-full-access to-addresses=1.1.1.1 to-ports=53
add chain=dstnat action=dst-nat protocol=tcp dst-port=53 src-address-list=trusted-full-access to-addresses=1.1.1.1 to-ports=53
```

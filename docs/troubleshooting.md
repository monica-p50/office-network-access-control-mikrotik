# Troubleshooting

| Symptom | Check |
| --- | --- |
| Company PC is asked to log in | MAC in the binding is wrong, or the PC uses a private/random MAC. Compare with `/ip dhcp-server lease print`. |
| New device gets no login page | The device uses a fixed DNS or DNS-over-HTTPS. Check the doh-servers list and DNS redirect. |
| No internet on one line | `/ip route print`: is the route active? `ping` the monitor address of that line. |
| Failover does not switch | `check-gateway=ping` missing, or the modem still answers. |
| VPN works from one line only | Port forward missing on the other modem. |
| No logs on the server | `/log print`, the tunnel `/interface wireguard peers print`, and the firewall on the server. |

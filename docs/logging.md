# Logging

The router sends log lines to a central server over the monitoring tunnel.

```
/system logging action
add name=remote-syslog target=remote remote=10.99.0.1 src-address=10.99.0.2 syslog-facility=local7 remote-log-format=syslog

/system logging
add action=remote-syslog topics=system
add action=remote-syslog topics=account
add action=remote-syslog topics=firewall
add action=remote-syslog topics=warning
add action=remote-syslog topics=error
add action=remote-syslog topics=critical
add action=remote-syslog topics=hotspot
add action=remote-syslog topics=dns,!packet
add action=remote-syslog topics=script
add action=remote-syslog topics=wireguard
add action=remote-syslog topics=interface,info
```

## Helper scripts
Two small scripts write extra facts into the `script` topic (see `scripts/`).

* `soc-ping` pings the server over the tunnel and logs the round trip, and logs `UP` or `DOWN` only when the state changes.
* `bigtransfer-check` warns when one connection has moved more than 50 MB.

## Read-only account for polling
A separate group can read but not change anything. The API is open only to the monitoring server.

```
/user group add name=soc-read policy=read,api,!local,!telnet,!ssh,!ftp,!reboot,!write,!policy,!test,!winbox,!password,!web,!sniff,!sensitive,!romon,!rest-api
/user add name=<poller> group=soc-read password=<password>
```

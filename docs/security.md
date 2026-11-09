# Security checklist

| Check | Done by |
| --- | --- |
| Router software updated, backup taken first | `/system package update`, `/export` |
| Default admin password changed; a separate read-only user for tools | `/user` |
| FTP, telnet and web (www) disabled | `/ip service` |
| SSH and API limited to named networks | `available-from` |
| Input chain drops everything from the uplinks | firewall rules |
| Hotspot on for everything except bound company PCs | ip-binding |
| Logs leave the router (a deleted local log is not lost) | syslog |
| Exports are never published | `.gitignore` |

Never publish `/export` output: it can contain addresses, MACs, user names and secrets.

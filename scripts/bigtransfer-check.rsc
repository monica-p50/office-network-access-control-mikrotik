# Warn about connections that moved more than 50 MB.
:local threshold 50000000
:foreach i in=[/ip firewall connection find] do={
  :local total ([/ip firewall connection get $i orig-bytes] + [/ip firewall connection get $i repl-bytes])
  :if ($total > $threshold) do={
    :log warning ("BIGTRANSFER src=" . [/ip firewall connection get $i src-address] . " dst=" . [/ip firewall connection get $i dst-address] . " bytes=" . $total)
  }
}

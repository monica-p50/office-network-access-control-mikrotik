# Ping the monitoring server over the tunnel and log the result.
:local r [/ping 10.99.0.1 count=1 as-value]
:local tm ($r->"time")
:global socTun
:if ([:typeof $tm] = "time") do={
  :log info ("PING VPS " . ([:tonsec $tm] / 1000000) . " ms")
  :if ($socTun != "UP") do={ :set socTun "UP"; :log info "TUNNEL UP" }
} else={
  :log info "PING VPS timeout"
  :if ($socTun != "DOWN") do={ :set socTun "DOWN"; :log info "TUNNEL DOWN" }
}

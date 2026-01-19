# Block ICMP Traffic  
netsh advfirewall firewall add rule name="Block ICMP Traffic" dir=in action=block protocol=icmpv4 

# Allow RDP from specific IP addresses
netsh advfirewall firewall add rule name="Allow RDP from HostIPx.x.x.x" dir=in action=allow protocol=TCP localport=3389 remoteip=HostIPx.x.x.x
netsh advfirewall firewall add rule name="Allow RDP from DC1x.x.x.x" dir=in action=allow protocol=TCP localport=3389 remoteip=DC1IPx.x.x.x
netsh advfirewall firewall add rule name="Allow RDP from DC2x.x.x.x" dir=in action=allow protocol=TCP localport=3389 remoteip=DC2IPx.x.x.x

# Block all other RDP connections
netsh advfirewall firewall add rule name="Block RDP - All" dir=in action=block protocol=TCP localport=3389

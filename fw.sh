#!/bin/sh

iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
iptables -F POSTROUTING -t nat
iptables -F PREROUTING -t nat

iptables -A INPUT -p tcp --dport 80 -j ACCEPT    
iptables -A INPUT -p tcp --dport 53 -j ACCEPT    
iptables -A INPUT -p udp --dport 53 -j ACCEPT    
iptables -A INPUT -p tcp --dport 22 -j ACCEPT     
iptables -A INPUT -p tcp --dport 25 -j ACCEPT    
iptables -A INPUT -p icmp -j ACCEPT  
iptables -A INPUT -p tcp -m tcp --tcp-flags ACK ACK -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -m state --state RELATED -j ACCEPT
iptables -A INPUT -j REJECT  



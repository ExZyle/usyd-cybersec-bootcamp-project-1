#!/bin/bash

echo "System Information: $(date)"
echo "uname: $(uname)"
echo "First IP Address: $(ifconfig|grep inet|head -1)"
echo "Hostname: $HOSTNAME"
echo "DNS Info:"
cat /etc/resolv.conf
echo "Memory Info:"
free
echo "CPU Info: $(uptime)"
echo "Disk Usage:"
df -h
echo "Current Users:"
who

#!/bin/bash

echo "===== System Monitoring Report: $(date) =====" >> /var/logs/monitoring/system_monitor.log
echo "----- CPU & Memory Usage -----" >> /var/logs/monitoring/system_monitor.log
top -b -n 1 | head -20 >> /var/logs/monitoring/system_monitor.log

echo "----- Disk Usage -----" >> /var/logs/monitoring/system_monitor.log
df -h >> /var/logs/monitoring/system_monitor.log

echo "----- Top 10 CPU Processes -----" >> /var/logs/monitoring/system_monitor.log
ps aux --sort=-%cpu | head -10 >> /var/logs/monitoring/system_monitor.log

echo "----- Top 10 Memory Processes -----" >> /var/logs/monitoring/system_monitor.log
ps aux --sort=-%mem | head -10 >> /var/logs/monitoring/system_monitor.log

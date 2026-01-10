#!/bin/bash

read cpu user nice system idle iowait irq softirq steal < /proc/stat
total=$((user+nice+system+idle+iowait+irq+softirq+steal))
usage=$((100*(total-idle)/total))

bars="▁▂▃▄▅▆▇█"
index=$((usage * 8 / 100))
bar=${bars:index:1}

echo "{\"text\":\"$bar\",\"tooltip\":\"CPU: $usage%\"}"


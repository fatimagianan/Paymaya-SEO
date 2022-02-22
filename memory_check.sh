#!/bin/bash

usage="usage: ./test -c (critical percentage)/ should not equal or less than to /-w (warning percentage)/ -e (your email address here)"
crit="(current memory usage is on critical stage)"
warn="(current memory usage is on warning stage)"
norm="(current memory usage is on normal state)"

x=$( free | grep Mem: | awk '{printf("%.0f", $3/$2 * 100)}')
y=$(ps -eo pmem,pcpu,vsize,pid,cmd | sort -k 1 -nr | head -10)
d=$(date +%Y%m%d" "%H:%M)

while getopts ":c:w:e:" o;  do
    case "$o" in
        c)
             c=${OPTARG}          ;;
        w)
             w=${OPTARG}          ;;
        e)
             e=${OPTARG}          ;;
    esac
done

        if [ -z "${c}" ]  || [ -z "${w}" ] || [ -z "${e}" ]; then
        echo $usage
        elif [[ "$c" -gt "$x" && "$w" -gt "$x" ]]; then
                echo $norm
        elif [[ "$c" -gt "$w" && "$c" -le "$x" ]]; then
                mail -s "$d memory check-critical" ${e} <<< $y
                echo $crit
        elif [[ "$w" -le "$x" && "$c" -gt "$w" ]]; then
                echo $warn
        elif [ "$w" -eq "$c" ]; then
                echo $usage
        else    echo $usage
        fi
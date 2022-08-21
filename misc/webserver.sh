#!/bin/sh

MYIP=$(/sbin/ifconfig eth0 | grep 'inet ' | awk '{print $2}');
OUTPUT_STR="Welcome to $MYIP ($(hostname))\r"
OUTPUT_LEN=${#OUTPUT_STR}

while true; do
    echo -e "HTTP/1.0 200 OK\r\nContent-Length: ${OUTPUT_LEN}\r\n\r\n${OUTPUT_STR}" | sudo nc -l 8080
done

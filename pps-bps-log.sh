#!/bin/bash

INTERVAL="1"  # update interval in seconds

if [ -z "$1" ]; then
        echo
        echo usage: $0 [network-interface]
        echo
        echo e.g. $0 eth0
        echo
        echo shows packets-per-second
        exit
fi

IF=$1

FN=$(date +%s_%Y%m%d_%H%M)
exec >/root/ppslog/$FN.log

while true
do
        R1=`cat /sys/class/net/$1/statistics/rx_packets`
        RB1=`cat /sys/class/net/$1/statistics/rx_bytes`
        T1=`cat /sys/class/net/$1/statistics/tx_packets`
        TB1=`cat /sys/class/net/$1/statistics/tx_bytes`
        sleep $INTERVAL
        R2=`cat /sys/class/net/$1/statistics/rx_packets`
        RB2=`cat /sys/class/net/$1/statistics/rx_bytes`
        T2=`cat /sys/class/net/$1/statistics/tx_packets`
        TB2=`cat /sys/class/net/$1/statistics/tx_bytes`
        TXPPS=`expr $T2 - $T1`
        TXBPS=`expr $TB2 - $TB1`
        RXPPS=`expr $R2 - $R1`
        RXBPS=`expr $RB2 - $RB1`
	DATE=`date`
	DATEE=`date +%s --utc`
        echo "$DATEE UTC, $DATE: $1: $TXPPS pps $TXBPS Bps RX $1: $RXPPS pps $RXBPS Bps"
done


#!/bin/bash
#Author:jiawei.liu
#Time:2021.1.15
mkdir common_hack_tcp_out
for a in {0..7}
do
        ./clean
        sed -i '6c k=1' sendpkg.sh
        ./sendpkg.sh common_tcp
        sleep 20
        ./sendpkg.sh common_hack $a
        sleep 45
        kill -9 $(ps -ef | grep sendpkg | grep -v grep | awk '{print $2}')

        cp iptable.txt out/iptable.txt
        mv out common_hack_tcp_out/p${a}_common_hack_tcp_out
        mkdir out
done
cp iptable_all.txt common_hack_tcp_out/iptable_all.txt

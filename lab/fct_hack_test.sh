#!/bin/bash
#Author:jiawei.liu
#Time:2021.1.16
mkdir fct_hack_tcp_out
for a in {0..7}
do
	./clean
	sed -i '6c k=1' sendpkg.sh
        ./sleep 1
	./sendpkg.sh fct_hack $a
        while [ 1 ]
	do
        	sleep 1
        	num=$(./sendpkg.sh l | wc -l)
        	if [[ $num == 1 ]];then
                	sleep 4
                	num=$(./sendpkg.sh l | wc -l)
                	if [[ $num == 1 ]];then
                        	kill -9 $(ps -ef | grep sendpkg | grep -v grep | awk '{print $2}')
                        	break
                	fi
        	fi
	done

	kill -9 $(ps -ef | grep sendpkg | grep -v grep | awk '{print $2}')

        cp fcttable.txt out/fcttable.txt
        mv out fct_hack_tcp_out/p${a}_fct_hack_tcp_out
        mkdir out
done
cp fcttable_all.txt fct_hack_tcp_out/fcttable_all.txt


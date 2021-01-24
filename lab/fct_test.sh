#!/bin/bash
#Author:jiawei.liu
#Time:2021.1.15
mkdir fct_tcp_out
sed -i '6c k=1' sendpkg.sh
sleep 1
./sendpkg.sh d
sleep 1

./sendpkg.sh fct_tcp
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
mv out fct_tcp_out/out
mkdir out
cp fcttable_all.txt fct_tcp_out/fcttable_all.txt

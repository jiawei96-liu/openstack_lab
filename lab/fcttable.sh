#!/bin/bash
#Author:jiawei.liu
#Time:2020.12.17
cat config/project_num | while read line
do
    declare -i PROJECT_NUM=$(($line))
	
	if [ $# == 0  ];then
        	./fcttable.sh d
		for((i=0;i<$PROJECT_NUM;i++));do
                	sleep 1
                	./python/project_cmd.py fcttable_create $i
       		done
		cat fcttable_all.txt | grep S0 > fcttable0.txt
		cat fcttable_all.txt | grep S1 > fcttable1.txt
		cat fcttable_all.txt | grep S2 > fcttable2.txt
	elif [ $# == 1 ];then
		if [ $1 == l ];then
			cat fcttable.txt
		elif [ $1 == d ];then
			rm -rf fcttable*.txt
		fi
	fi
	
        break
done

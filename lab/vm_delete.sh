#!/bin/bash
#Author:jiawei.liu
#Time:2020.12.17

cat config/project_num | while read line
do
	declare -i PROJECT_NUM=$(($line))


	for((i=0;i<$PROJECT_NUM;i++));do
		sleep 1
		source /opt/stack/devstack/openrc admin P$i
		./python/placement_cmd.py  delete $i
	done


	source /opt/stack/devstack/openrc admin admin
	./python/project_cmd.py project_delete
	sleep 1

        break
done


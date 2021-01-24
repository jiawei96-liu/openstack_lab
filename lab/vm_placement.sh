#!/bin/bash
#Author:jiawei.liu
#Time:2020.12.17

if [[ $# == 1 ]];then

	cat config/project_num | while read line
	do
		declare -i PROJECT_NUM=$(($line))
	
		source /opt/stack/devstack/openrc admin admin
		./python/project_cmd.py project_create $PROJECT_NUM
		sleep 1

		for((i=0;i<$PROJECT_NUM;i++));do
        		sleep 1
        		source /opt/stack/devstack/openrc admin P$i
        		./python/placement_cmd.py create $i $1;
        		sleep 1
        		./python/project_cmd.py security_group_define $i
		done

		break
	done
else
	echo  usage: ./vm_placement.sh placement_dat_file
fi

#!/bin/bash
#Author:jiawei.liu
#Time:2020.12.17
cat config/project_num | while read line
do
        declare -i PROJECT_NUM=$(($line))
	
	if [ $# == 0  ];then
        	./iptable.sh d
		for((i=0;i<$PROJECT_NUM;i++));do
                	sleep 1
                	source /opt/stack/devstack/openrc admin P$i
                	./python/project_cmd.py iptable_create
       		done
		./iptable.sh l

		sys=$(cat iptable.txt | grep S0 | wc -l)

		if [ $sys != 0 ];then
        		expect -c "
     			spawn ssh -t liujiawei@172.16.62.12 rm -fr ~/lab/iptable.txt ~/lab/iptable_all.txt
        		expect {
        		\"*assword\" {set timeout 300; send \"liujiawei\r\";}
        		\"yes/no\" {send \"yes\r\"; exp_continue;}
       			 }
        		expect eof"

        		sshpass -p "liujiawei" scp -r ~/lab/iptable.txt liujiawei@172.16.62.12:~/lab/iptable.txt

		fi

	
		sys=$(cat iptable.txt | grep S1 | wc -l)

		if [ $sys != 0 ];then
		        expect -c "
		        spawn ssh -t sdn@172.16.62.236 rm -fr ~/lab/iptable.txt ~/lab/iptable_all.txt
		        expect {
		        \"*assword\" {set timeout 300; send \"sdn123456\r\";}
		        \"yes/no\" {send \"yes\r\"; exp_continue;}
		        }
  			expect eof"
		
		        sshpass -p "sdn123456" scp -r ~/lab/iptable.txt sdn@172.16.62.236:~/lab/iptable.txt

		fi

		sys=$(cat iptable.txt | grep S2 | wc -l)

		if [ $sys != 0 ];then
    			expect -c "
		        spawn ssh -t sdn@172.16.62.237 rm -fr ~/lab/iptable.txt ~/lab/iptable_all.txt
		        expect {
		        \"*assword\" {set timeout 300; send \"sdn123456\r\";}
		        \"yes/no\" {send \"yes\r\"; exp_continue;}
		        }
		        expect eof"

		        sshpass -p "sdn123456" scp -r ~/lab/iptable.txt sdn@172.16.62.237:~/lab/iptable.txt

		fi

	elif [ $# == 1 ];then
		if [ $1 == l ];then
			cat iptable.txt
		elif [ $1 == d ];then
			rm -rf iptable.txt
		fi
	fi
	
        break
done

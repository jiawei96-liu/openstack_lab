a=$(uname  -a | grep liujiawei | wc -l)
if [ $a == 0 ]; then 
	echo nonono 
else
	echo sync start
	expect -c "
	spawn ssh -t root@172.16.62.221 rm -fr ~/lab*
	expect {
	\"*assword\" {set timeout 300; send \"sdn123456\r\";}
	\"yes/no\" {send \"yes\r\"; exp_continue;}
	}
	expect eof"

	expect -c "
	spawn ssh -t root@172.16.62.231 rm -fr ~/lab*
	expect {
	\"*assword\" {set timeout 300; send \"sdn123456\r\";}
	\"yes/no\" {send \"yes\r\"; exp_continue;}
	}
	expect eof"

	expect -c "
	spawn ssh -t root@172.16.62.241 rm -fr ~/lab*
	expect {
	\"*assword\" {set timeout 300; send \"sdn123456\r\";}
	\"yes/no\" {send \"yes\r\"; exp_continue;}
	}
	expect eof"

	expect -c "
	spawn ssh -t sdn@172.16.62.236 rm -fr ~/lab*
	expect {
	\"*assword\" {set timeout 300; send \"sdn123456\r\";}
	\"yes/no\" {send \"yes\r\"; exp_continue;}
	}
	expect eof"

	expect -c "
	spawn ssh -t sdn@172.16.62.237 rm -fr ~/lab*
	expect {
	\"*assword\" {set timeout 300; send \"sdn123456\r\";}
	\"yes/no\" {send \"yes\r\"; exp_continue;}
	}
	expect eof"

	sshpass -p "sdn123456" scp -r ~/lab root@172.16.62.221:/root
	sshpass -p "sdn123456" scp -r ~/lab root@172.16.62.231:/root
	sshpass -p "sdn123456" scp -r ~/lab root@172.16.62.241:/root
	sshpass -p "sdn123456" scp -r ~/lab sdn@172.16.62.236:/home/sdn
	sshpass -p "sdn123456" scp -r ~/lab sdn@172.16.62.237:/home/sdn
	echo sync end
fi

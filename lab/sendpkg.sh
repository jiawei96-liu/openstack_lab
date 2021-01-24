#!/bin/bash
# @Author: jiawei.liu
# @Date: 2021-01-07 20:48:02
# @LastEditTime: 2021-01-13 22:25:45

k=1
if [ $# == 0 ];then
        ps -aux | grep iperf3
elif [ $# == 1 ];then
        if [ $1 == l ];then
                ps -aux | grep iperf3
        elif [ $1 == k ];then
                kill -9 $(ps -ef | grep iperf3 | grep -v grep | awk '{print $2}')
        elif [ $1 == d ];then
                rm -rf ./out/dat/$k
                mkdir -p ./out/dat/$k
        elif [ $1 == common_udp ];then
                ./sendpkg.sh k
                sleep 1
                ./sendpkg.sh d
                sleep 1

                while : 
                do
                        cat iptable.txt | while read line
                        do
                                array=(${line//,/ })
                                #bash 不支持浮点运算，如果需要进行浮点运算，需要借助awk处理
                                m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k}')
                                echo -e "\n\n============$(date +%F) $(date +%T)===========\n" >> ./out/dat/$k/${array[0]}_${array[1]}_${m}_common_udp_iperf3.log
                                echo -e "\n\n============$(date +%F) $(date +%T)===========\n" >> ./out/dat/$k/${array[0]}_${array[1]}_${m}_common_udp_ping.log
                        done
                        sleep 10
                done &

                cat iptable.txt | while read line
                do
                        array=(${line//,/ })
                        m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k}')
                        iperf3 -c ${array[1]} -p 25000 -i 1 -t 60 -b ${m}M -u -R --logfile ./out/dat/$k/${array[0]}_${array[1]}_${m}_common_udp_iperf3.log &
                        ping -i 1 -c 60 ${array[1]} >> ./out/dat/$k/${array[0]}_${array[1]}_${m}_common_udp_ping.log &
                done

                sleep 1
                ps -aux | grep iperf3

	elif [ $1 == common_tcp ];then
                ./sendpkg.sh k
                sleep 1
                ./sendpkg.sh d
                sleep 1

                while : 
                do
                        cat iptable.txt | while read line
                        do
                                array=(${line//,/ })
                                #bash 不支持浮点运算，如果需要进行浮点运算，需要借助awk处理
                                m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k}')
                                echo -e "\n\n============$(date +%F) $(date +%T)===========\n" >> ./out/dat/$k/${array[0]}_${array[1]}_${m}_common_tcp_iperf3.log
                                echo -e "\n\n============$(date +%F) $(date +%T)===========\n" >> ./out/dat/$k/${array[0]}_${array[1]}_${m}_common_tcp_ping.log
                        done
                        sleep 10
                done &

                cat iptable.txt | while read line
                do
                        array=(${line//,/ })
                        m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k}')
                        iperf3 -c ${array[1]} -p 25000 -i 1 -t 60 -b ${m}M -R --logfile ./out/dat/$k/${array[0]}_${array[1]}_${m}_common_tcp_iperf3.log &
                        ping -i 1 -c 60 ${array[1]} >> ./out/dat/$k/${array[0]}_${array[1]}_${m}_common_tcp_ping.log &
                done

                sleep 1
                ps -aux | grep iperf3
	 elif [ $1 == fct_udp ];then
               	./sendpkg.sh k
		sleep 1
		./sendpkg.sh d
	       	sleep 1

		while : 
                do
                        cat fcttable.txt | while read line
                        do
                                array=(${line//,/ })
                                #bash 不支持浮点运算，如果需要进行浮点运算，需要借助awk处理
                                m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k}')
                                echo -e "\n\n============$(date +%F) $(date +%T)===========\n" >> ./out/dat/$k/${array[0]}_${array[1]}_${m}_fct_udp_iperf3.log &
                        done
                        sleep 10
                done &

                cat fcttable.txt | while read line
                do
                        array=(${line//,/ })
                        m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k}')
                        for ((j=4; j<${#array[@]}; j++))
                        do
                                port=$(awk -v j=$j 'BEGIN{print 25000+j%5}')
                                index=$(awk -v j=$j 'BEGIN{print j-3}')
                                echo id=${array[0]},ip=${array[1]},bd=${array[2]},$index/${array[3]},port=$port,type=${array[$j]} 
                                if  [ ${array[$j]} == b ];then
                                        iperf3 -c ${array[1]} -p $port -i 1  -F dat/test_big_file -b ${m}M -n 50M -u -R --logfile ./out/dat/$k/${array[0]}_${array[1]}_${m}_fct_udp_iperf3.log
                                else
                                        iperf3 -c ${array[1]} -p $port -i 1  -F dat/test_small_file -b ${m}M -n 2M -u -R --logfile ./out/dat/$k/${array[0]}_${array[1]}_${m}_fct_udp_iperf3.log
                                fi
                        done &
                done
        elif [ $1 == fct_tcp ];then
                ./sendpkg.sh k
		sleep 1
		./sendpkg.sh d
		sleep 1

		while : 
                do
                        cat fcttable.txt | while read line
                        do
                                array=(${line//,/ })
                                #bash 不支持浮点运算，如果需要进行浮点运算，需要借助awk处理
                                m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k}')
                                echo -e "\n\n============$(date +%F) $(date +%T)===========\n" >> ./out/dat/$k/${array[0]}_${array[1]}_${m}_fct_tcp_iperf3.log &
                        done
                        sleep 10
                done &

                cat fcttable.txt | while read line
                do
                        array=(${line//,/ })
                        m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k}')
			for ((j=4; j<${#array[@]}; j++))
                        do
				port=$(awk -v j=$j 'BEGIN{print 25000+j%5}')
				index=$(awk -v j=$j 'BEGIN{print j-3}')
				echo id=${array[0]},ip=${array[1]},bd=${array[2]},$index/${array[3]},port=$port,type=${array[$j]} 
                                if  [ ${array[$j]} == b ];then
                                        iperf3 -c ${array[1]} -p $port -i 1   -b ${m}M -n 50M -R --logfile ./out/dat/$k/${array[0]}_${array[1]}_${m}_fct_tcp_iperf3.log
                                else
                                        iperf3 -c ${array[1]} -p $port -i 1   -b ${m}M -n 2M -R --logfile ./out/dat/$k/${array[0]}_${array[1]}_${m}_fct_tcp_iperf3.log
                                fi
                        done &
                done
        fi


elif [ $# == 2 ];then
        if [ $1 == common_hack ];then
                rm -rf ./out/hack/$k
		mkdir -p ./out/hack/$k

		
		cat iptable.txt | while read line
                do
                        array=(${line//,/ })
                        if [[ ${array[0]:1:1} == $2 ]]; then
			#	m=$(awk -v bd=${array[2]} 'BEGIN{print bd*2}')
                                echo -e "\n\n============$(date +%F) $(date +%T) 20s max hack attack===========\n" > ./out/hack/$k/${array[0]}_${array[1]}_common_hack.log &
                                iperf3 -c ${array[1]} -p 25005 -i 1 -t 20 -b 300M >> ./out/hack/$k/${array[0]}_${array[1]}_common_hack.log &
                        fi
                done

                sleep 1
                ps -aux | grep iperf3
        fi
	if [ $1 == fct_hack ];then
        	./sendpkg.sh k
		sleep 1
		./sendpkg.sh d
		sleep 1
		while :
		do
			cat fcttable.txt | while read line
			do
				array=(${line//,/ })
				#bash 不支持浮点运算，如果需要进行浮点运算，需要借助awk处理
				s=$(cat fcttable.txt | grep P$2 | wc -l)
				if [ $s != 0 ];then
					m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k*0.7}')
				else
					m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k}')
				fi
				echo -e "\n\n============$(date +%F) $(date +%T)===========\n" >> ./out/dat/$k/${array[0]}_${array[1]}_${m}_fct_tcp_iperf3.log &
			done
			sleep 10
		done &
		cat fcttable.txt | while read line
		do
			array=(${line//,/ })
			s=$(cat fcttable.txt | grep P$2 | wc -l)
			if [ $s != 0 ];then
				m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k*0.7}')
			else
				m=$(awk -v k=$k -v bd=${array[2]} 'BEGIN{print bd*k}')
			fi
			for ((j=4; j<${#array[@]}; j++))
			do
				port=$(awk -v j=$j 'BEGIN{print 25000+j%5}')
				index=$(awk -v j=$j 'BEGIN{print j-3}')
				echo id=${array[0]},ip=${array[1]},bd=${array[2]},$index/${array[3]},port=$port,type=${array[$j]} 
				if  [ ${array[$j]} == b ];then
					iperf3 -c ${array[1]} -p $port -i 1   -b ${m}M -n 50M -R --logfile ./out/dat/$k/${array[0]}_${array[1]}_${m}_fct_tcp_iperf3.log
				else
					iperf3 -c ${array[1]} -p $port -i 1   -b ${m}M -n 2M -R --logfile ./out/dat/$k/${array[0]}_${array[1]}_${m}_fct_tcp_iperf3.log
				fi
			done &
		done	
	fi
fi




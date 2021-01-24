if [ $# == 0 ] ; then
	echo usage: ./hack_sys_num.sh ALG
	exit
fi

for a in {0..7}
do
	for s in {0..2}
	do
		n=$(cat $1/sys${s}/fct_hack_tcp_out/p${a}_fct_hack_tcp_out/fcttable.txt |grep P${a} | wc -l)
		echo project $a sys $s num $n
	done
	echo 
done

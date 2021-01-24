./cleanall.sh
#./common_hack_test.sh
#sleep 1
#./clean
./fct_test.sh
sleep 1
mv fct_tcp_out fct_tcp_out_1

./clean
./fct_test.sh
sleep 1


./clean
./fct_hack_test.sh 
sleep 1

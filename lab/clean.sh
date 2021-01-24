./sendpkg.sh d && ./sendpkg.sh k 
kill -9 $(ps -ef | grep sendpkg | grep -v grep | awk '{print $2}')
rm -rf out/*

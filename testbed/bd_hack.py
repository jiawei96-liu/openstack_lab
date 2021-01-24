#!/usr/bin/python3
# -*- coding:utf-8 -*-
import os
import utils
from numpy import *
#utils.execShellCommand("rm -rf *.txt")
algs = ['LLF','SJF','WRR','OUR']
syss = ['sys0','sys1','sys2']
#forms = ['common_hack_tcp_out','common_hack_udp_out']
forms = ['common_hack_tcp_out']
projects = ['p0','p1','p2','p3','p4','p5','p6','p7']
debug = False
utils.execShellCommand("mkdir bd_hack_analysis")
for form in forms:
    for alg in algs:
        outpath="bd_hack_analysis/bd_hack_analysis_"+alg+".txt"
        fout = open(outpath,"w+")
        for sys in syss:
            for project in projects:
                path="./"+alg+"/"+sys+"/"+form+"/"+project+"_"+form+"/dat/1"
                #path = "./LLF/sys0/common_hack_tcp_out/p0_common_hack_tcp_out/dat/1" #文件夹目录
                raw_file_list= os.listdir(path) #得到文件夹下的所有文件名称
                iperf3_file_list = []
                for raw_file in raw_file_list: #遍历文件夹
                    if not os.path.isdir(raw_file): #判断是否是文件夹，不是文件夹才打开
                        if "iperf3" in raw_file:
                            iperf3_file_list.append(path+"/"+raw_file)

                raw_dat = []
                for iperf3_file in iperf3_file_list:
                    raw_dat.append(utils.execShellCommand("cat "+iperf3_file+"  | grep Mbits/sec").split('\n'))
                #print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n")
                #print(raw_dat)
                #print(len(raw_dat))
                #print(len(raw_dat[0]))

                dat = []
                for i in range(0,len(raw_dat)):
                    temp = []
                    for j in range(0,len(raw_dat[0])-3):
                        temp.append(raw_dat[i][j])
                    dat.append(temp)
                #print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n")
                #print(dat)
                #print(len(dat))
                #print(len(dat[0]))
                
                bd_dat = []
                for item_list in dat:
                    temp = []
                    for item in item_list:
                        item=item.split('  ')[5].strip()
                        item=item.split(" ")[0].strip()
                        temp.append(float(item))
                    bd_dat.append(temp)
                
                #print("************************************\n")
                #print(bd_dat)
                #print(len(bd_dat))
                #print(len(bd_dat[0]))
                
                bd_sum = []
                for i in range(0,len(bd_dat[0])):
                    temp = 0
                    for j in range(0,len(bd_dat)):
                        temp += bd_dat[j][i]
                    bd_sum.append(temp)
                #print(str(len(bd_sum)))
                bd_sum = bd_sum[11:-9]
                #print(str(len(bd_sum)))
                #print(bd_sum)

                init = bd_sum[1:6]
                init.extend(bd_sum[-6:-1])
                initbd = mean(init)
                #print(initbd)

                hack = bd_sum[15:25]
                if init[0] > 800:
                    hackbd = mean(hack)
                else :
                    hackbd = min(bd_sum)
                #print(hackbd)
                
                fout.write("=========================================================\n")
                fout.write(path+"\n"+ str(bd_sum)+"\n")
                fout.write("-- analysis || "+" alg: "+alg+" sys: "+sys+" hacker: "+project+" initbd,hackbd: "+str(format(initbd,'.2f'))+","+str(format(hackbd, '.2f'))+"\n")
                if debug:
                    exit(0)
        fout.close()

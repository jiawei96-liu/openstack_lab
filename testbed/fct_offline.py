#!/usr/bin/python3
# -*- coding:utf-8 -*-
import os
import utils
#utils.execShellCommand("rm -rf *.txt")
algs = ['LLF','SJF','WRR','OUR']
syss = ['sys0','sys1','sys2']
forms = ['fct_tcp_out_1']
projects = ['P0', 'P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7']
debug = False
offline_syss = ['S0','S1','S2']
offline_time = 60
offline_when = 30
utils.execShellCommand("mkdir fct_offline_analysis")
for form in forms:
    for alg in algs:
        outpath="fct_offline_analysis/fct_offline_analysis_"+alg+".txt"
        fout = open(outpath,"w+")
        for offline_sys in offline_syss:
            for project in projects:
                fct_collect = []
                # 拿到三个系统的同一个用户的所有数据
                project_iperf3_file_list = []
                for sys in syss:
                    path = "./"+alg+"/"+sys+"/"+form+"/out/dat/1"
                    # print(path)

                    raw_file_list = os.listdir(path)  # 得到文件夹下的所有文件名称
                    # print(raw_file_list)

                    for raw_file in raw_file_list:  # 遍历文件夹
                        if not os.path.isdir(raw_file):  # 判断是否是文件夹
                            if project in raw_file:
                                project_iperf3_file_list.append(
                                    path+"/"+raw_file)
                                #print(project)
                                #print(raw_file)

                #print(project_iperf3_file_list)
                for project_iperf3_file in project_iperf3_file_list :
                    raw_dat_list =utils.execShellCommand("cat "+project_iperf3_file+" | grep receiver").split("\n")[:-1]
                    #print(raw_dat_list)
                    dat_list = []
                    for raw_dat in raw_dat_list:
                        dat_list.append(raw_dat.split("  ")[2].strip())

                    #print(dat_list)

                    time_list = []
                    for dat in dat_list:
                        time_list.append(float(dat.split("-")[1].strip()))
                    #print(time_list)
                    
                    fct = []
                    fct_temp = 0
                    offline_flag = False
                    for time in time_list:
                        if offline_sys in project_iperf3_file and fct_temp > offline_when and offline_flag == False :
                            fct_temp += offline_time
                            offline_flag = True
                        fct_temp += time
                        fct.append(fct_temp)
                        fct_collect.append(fct_temp)

                    fout.write("=========================================================\n")
                    fout.write(project_iperf3_file+"\n"+ str(str(fct))+"\n")
            
                fct_collect.sort()
                if len(fct_collect)<50 :
                    print("ERROR")
                    exit()
                fout.write("=========================================================\n")
                fout.write(str(fct_collect))
                fout.write("\n-- analysis || "+" alg: "+alg+" offline_sys: "+str(offline_sys)+" offline_when: "+str(offline_when)+" project "+project+" fct : "+str(format(fct_collect[-10],'.2f'))+" , " +str(format(fct_collect[-9],'.2f'))+" , "+str(format(fct_collect[-8],'.2f'))+" , "+str(format(fct_collect[-7],'.2f'))+" , "+str(format(fct_collect[-6],'.2f'))+" , "+str(format(fct_collect[-5],'.2f'))+" , "+str(format(fct_collect[-4],'.2f'))+" , "+str(format(fct_collect[-3],'.2f'))+" , "+str(format(fct_collect[-2],'.2f'))+" , "+str(format(fct_collect[-1],'.2f'))+"\n\n")
            
                if debug:
                    exit()

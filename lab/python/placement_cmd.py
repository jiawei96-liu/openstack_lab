#!/usr/bin/python3
# -*- coding:utf-8 -*-

import sys
import os
import subprocess
import utils

sysId = {"computer11": 0, "computer12": 0, "computer13": 0, "computer14": 0,
         "computer15": 1, "computer16": 1, "computer21": 1, "computer22": 1,
         "computer23": 2, "computer24": 2, "computer25": 2, "computer26": 2}

zone = ["nova:computer12:computer12", "nova:computer13:computer13", "nova:computer14:computer14",
        "nova:computer16:computer16", "nova:computer21:computer21", "nova:computer22:computer22",
        "nova:computer24:computer24", "nova:computer25:computer25", "nova:computer26:computer26"]


def raw_str_parse(raw_str):
    lt = raw_str.split("], [")
    lt[0] = lt[0].split("[[")[-1].strip()
    lt[-1] = lt[-1].split("]]")[0].strip()
    # print(lt)
    ret = []
    for i in range(len(lt)):
        temp = lt[i].split("),")
        temp[0] = temp[0].split('(')[-1]
        temp[0] = temp[0].split(',')
        temp[1] = temp[1].split(',')
        for j in range(len(temp[0])):
            temp[0][j] = temp[0][j].strip()
        for j in range(len(temp[1])):
            temp[1][j] = temp[1][j].strip()

        ret.append(temp)
    # print(ret)
    return ret


def openstack_flavor_create(cpu, ram, bandwidth):
    flavor = "cpu_"+cpu+"_ram_"+ram+"_bandwidth_"+bandwidth
    temp = utils.execShellCommand("openstack flavor list | grep "+flavor)
    if len(temp) == 0:
        utils.execShellCommand(
            "openstack flavor create --vcpus "+cpu+" --ram "+ram+" --disk 10 "+flavor)
    return flavor


def openstack_create_instance(info, my_id):
    flavor = openstack_flavor_create(info[0][0], info[0][1], info[0][2])
    cmd = "openstack server create --flavor "+flavor+" --image ubuntu_sdnlab "
    cmd += "--nic net-id=private --user-data config/ubuntu.config --availability-zone " + \
        zone[int(info[1][0])] + " "+my_id
    utils.execShellCommand(cmd)


def openstack_delete_instance():
    ret = utils.execShellCommand(
        "openstack server list |grep ubuntu").split("\n")[0:-1]
    for i in range(len(ret)):
        id = ret[i].split("|")[1].strip()
        utils.execShellCommand("openstack server delete "+id)


if __name__ == "__main__":

    print("******************************************************************")
    print("***                 project: P"+sys.argv[2])
    print("******************************************************************")
    computer_name = utils.execShellCommand("uname -n").strip()
    if sys.argv[1] == "create":
        raw_str = utils.read_file_as_str(sys.argv[3])
        pd_list = raw_str_parse(raw_str)
        instance_id = 0
        for i in range(len(pd_list)):
            info = pd_list[i]
            if int(info[1][1]) == sysId[computer_name] and sys.argv[2] == info[1][2]:
                #租户ID,实例ID,sysID,zoneID,vCPU,RAM,带宽
                my_id = "P"+str(sys.argv[2])+"I"+str(instance_id)+"_S"+str(info[1][1])+"Z"+str(info[1][0])+"_C"+str(info[0][0])+"R"+str(info[0][1])+"_B"+str(info[0][2])
                openstack_create_instance(info, my_id)
                instance_id += 1
    elif sys.argv[1] == "delete":
        openstack_delete_instance()
                                             

#!/usr/bin/python3
# -*- coding:utf-8 -*-

import sys
import os
import subprocess
import utils


def project_create(project_num):
    for i in range(int(project_num)):
        project = "P"+str(i)
        cmd = "openstack project create --domain default   --description  Project" + \
            str(i)+" "+project
        utils.execShellCommand(cmd)
        cmd = "openstack role add --project "+project+" --user admin admin"
        utils.execShellCommand(cmd)


def project_delete():
    utils.execShellCommand("rm -rf iptable.txt")
    ret = utils.execShellCommand(
        "openstack project list |grep P").split("\n")[0:-1]
    for i in range(len(ret)):
        ret[i] = ret[i].split("|")[1].strip()
        utils.execShellCommand("openstack project delete "+ret[i])
        sg = utils.execShellCommand(
            "openstack security group list | grep "+ret[i])
        if(len(sg)):
            sg = sg.split("|")[1].strip()
            utils.execShellCommand("openstack security group delete "+sg)

    ret = utils.execShellCommand(
        "openstack flavor list | grep cpu").split("\n")[0:-1]
    for i in range(len(ret)):
        ret[i] = ret[i].split("|")[1].strip()
        utils.execShellCommand("openstack flavor delete "+ret[i])


def project_sg(project_name):
    ret = utils.execShellCommand("openstack project list |grep P"+project_name)
    if len(ret):
        project_id = ret.split("|")[1].strip()
        sg = utils.execShellCommand(
            "openstack security group list | grep "+project_id)
        if(len(sg)):
            sg_id = sg.split("|")[1].strip()
            utils.execShellCommand(
                "openstack security group rule create --proto icmp "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto tcp --dst-port 22 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto tcp --dst-port 25000 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto tcp --dst-port 25001 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto tcp --dst-port 25002 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto tcp --dst-port 25003 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto tcp --dst-port 25004 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto tcp --dst-port 25005 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto udp --dst-port 25000 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto udp --dst-port 25001 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto udp --dst-port 25002 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto udp --dst-port 25003 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto udp --dst-port 25004 "+sg_id)
            utils.execShellCommand(
                "openstack security group rule create --proto udp --dst-port 25005 "+sg_id)


def project_iptable_create():
    ret = utils.execShellCommand(
        "openstack server list |grep ubuntu").split("\n")[0:-1]
    fout = open("iptable.txt", "a+")
    for i in range(len(ret)):
        name = ret[i].split("|")[2].strip()
        ip = ret[i].split("|")[4].strip()
        bandwidth = ret[i].split("|")[-2].strip()
        ip = ip.split("=")[1].strip()
        bandwidth = bandwidth.split("_")[-1].strip()
        fout.write(name+","+ip+","+bandwidth+"\n")

    fout.close()

def project_fcttable_create(project_name):
    iptable_project = utils.execShellCommand(
        "cat iptable_all.txt | grep P"+project_name).split("\n")[0:-1]
    #print(iptable_project)
    #print(len(iptable_project))
    fout = open("fcttable_all.txt", "a+")
    task = []
    for i in range(len(iptable_project)):
        task.append([])
    #fct大包列表,随机数生成
    bigpkglist = [13,43,39,3,30,14,29,36,42,32]
    for i in range(50):
        if i in bigpkglist:
            task[i%len(task)].append('b')
        else:
            task[i%len(task)].append('s')

    for i in range(len(iptable_project)):
        item = iptable_project[i] + "," + str(len(task[i]))
        for t in task[i]:
            item += "," + t 
        fout.write(item+"\n")
    
    fout.close()
    

if __name__ == "__main__":
    if sys.argv[1] == "project_create":
        project_create(sys.argv[2])
    elif sys.argv[1] == "project_delete":
        project_delete()
    elif sys.argv[1] == "security_group_define":
        project_sg(sys.argv[2])
    elif sys.argv[1] == "iptable_create":
        project_iptable_create()
    elif sys.argv[1] == "fcttable_create":
        project_fcttable_create(sys.argv[2])


#!/usr/bin/env python
#encoding:utf-8
import os
import sys
import string
import random
import os.path
import re


def Get_Random_IP(file):
 IPlist=[]
 f=open(file,'r')
 for line in f.readlines():
   if line:
     IPlist.append(line)
 ip1=random.choice(IPlist).strip()
#   ip2=random.choice(IPlist).strip()
 return ip1;

#IP1,IP2=Get_Random_IP(IP_world.txt)

def walk_dir(dir):
   list1=[]
   for root, dirs, files in os.walk(dir):
        for name in files:
            file=os.path.join(root,name)
            list1.append(file)
        for name in dirs:
            file=(os.path.join(root,name))
            list1.append(file)
   return list1

#sendfile machines Network adapter
Sendfile_network='p4p1'
# test machine MAC address
Xingyun_Mac='C8:1F:66:B8:11:C1'
# sample directory
Sample_list='/test/'
#tmp folder
Send_tmp_list='/home'
# protocols by sendfile
Protocol=['http','smtp','pop3','ftp_pas','ftp_port']
# send rate by Mbps
Send_rate='10'
# IP lists,include IP_china.txt OR IP_world.txt
IP_list='/sendfile/IP_china.txt'


if __name__=='__main__':
 files=walk_dir(Sample_list)
 for file in files:
     IP1=Get_Random_IP(IP_list)
     IP2=Get_Random_IP(IP_list)
     Cmd1='echo y | ./sendfile -i {0}  -m {1} -s {2} -d {3} -f {4} -t {5} -p {6} -x -r {7} $*'.format(Sendfile_network,Xingyun_Mac,IP1,IP2,file,Send_tmp_list,Protocol[0],Send_rate)
     os.system(Cmd1)
 print "send files done!"




#!/usr/bin/env python
import sys
import os
os.system('mkdir logs')

os.system('find ./ -name "*.log">>logs.txt')
filelog=open('logs.txt','r')
for line in filelog.readlines():
  line=line.strip()
  print line
  print '=============================='
  os.system('mv {0} logs'.format(line))
os.system('rm  logs.txt')

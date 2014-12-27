#-*- coding:utf-8 -*-

################################################################################
import os
if os.path.exists("list.txt"):
    fp = open("list.txt")
    line = fp.readline()
    while line:
        os.system("wget -T 2 {0}".format(line))
        line = fp.readline()

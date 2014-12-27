#-*- coding:utf-8 -*-
#如果check.txt中的url含中文，需要将check.txt格式编码通过node++转换为utf-8 无BOM格式
import os
import urllib2
namelist=open('check.txt','r')
name=namelist.readlines()
mask=0
for file_name in name:
    name1=file_name.strip()
    print repr(name1)
    re = urllib2.Request(name1)
    rs = urllib2.urlopen(re).read()  
    split_name=name1.split("/")
    #dfile=split_name[-1]
    dfile = os.path.basename(name1)
    dfile = dfile.decode('utf-8')
    #print dfile
    open(dfile, 'wb').write(rs)  
namelist.close()




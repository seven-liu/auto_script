#!/usr/bin/python2



import re
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import smtplib
import time

#flag = 0

count=0
#while (flag==0):

filelist = open("filelist.txt",'r')
for line in filelist:
   fin = open(line.strip())
   for line in fin:
     nullstring='                        '
     msgcontent=line
     msg = MIMEMultipart()
#    text_msg = MIMEText('Hello,Tester ,\n{0}This is a auto email.\n{1} '.format(nullstring,nullstring),'plain','gb2312')
     text_msg = MIMEText(msgcontent)
     msg['to'] = 'xxx@xxx.com'
     msg['from'] = 'xxx2@xxx.com'
     msg['subject'] = 'send email with 1000 urls'

     msg.attach(text_msg)

   try:
      server = smtplib.SMTP()
      server.connect('smtp.xx.com')
      server.login('xxx@xxx.com','password')
      server.sendmail(msg['from'], msg['to'],msg.as_string())
      server.quit()
      print 'send email successful'
      count=count+1
      print count
   except Exception, e:
      print str(e)
      time.sleep(1)


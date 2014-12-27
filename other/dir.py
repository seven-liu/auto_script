
import os
import os.path
import re

path = os.getcwd()

f = file("filelist.txt", "w")
rmlist=["dir.py","readheader.py","filelist.txt"]
fnamelst = open("filelist.txt", "r+")
for root, dirs, files in os.walk(path):
   for file in files:
      print os.path.join(root, file)
      if not(file in rmlist):
         fnamelst.write(os.path.join(root, file)+'\n')
fnamelst.close()


import os
import os.path
import re

path = os.getcwd()
f = file("listpath.txt", "w")
pathlist = open("listpath.txt", "r+")
for root, dirs, files in os.walk(path):
  for dir in dirs:
      print os.path.join(root, dir)
      pathlist.write(os.path.join(root,dir)+'\n')

pathlist.close()
 


import re
import os
import time
log=file('renamelog.txt','w')
count=100000000
filetpye=''
logfile=open('renamelog.txt','r+')
path = os.getcwd()
rmlist=["rename.py","renamelog.txt"]
for root, dirs, files in os.walk(path):
   for filename in files:
       if not(filename in rmlist):
           print os.path.join(root, filename)
           logfile.write('the original file is:'+os.path.join(root, filename)+'\n')
           if os.path.isfile(os.path.join(root,filename))==True:
                if filename[-4:]=='.doc':
                   filetpye='.doc'
                if filename[-4:]=='.xls':
                   filetpye='.xls'
                if filename[-4:]=='.pdf':
                   filetpye='.pdf'  
                if filename[-4:]=='.PDF':
                   filetpye='.PDF'
                if filename[-4:]=='.ppt':
                   filetpye='.ppt'
                if filename[-4:]=='.txt':
                   filetpye='.txt'
                if filename[-4:]=='.XLS':
                   filetpye='.XLS'
                if filename[-4:]=='.DOC':
                   filetpye='.DOC'
                if filename[-4:]=='.PPT':
                   filetpye='.PPT'
                if filename[-5:]=='.docx':
                   filetpye='.docx'
                if filename[-5:]=='.pptx':
                   filetpye='.pptx'
                if filename[-5:]=='.xlsx':
                   filetpye='.xlsx'
                if filename[-5:]=='.pptx':
                   filetpye='.pptx'
                if filename[-5:]=='.xlsm':
                   filetpye='.xlsm'
                if filename[-4:]=='.tif':
                   filetpye='.tif'
                if filename[-4:]=='.zip':
                   filetpye='.zip'
                if filename[-4:]=='.rar':
                   filetpye='.rar'
                if filename[-4:]=='.swf':
                   filetpye='.swf'
                if filename[-4:]=='.rtf':
                   filetpye='.rtf'
                if filename[-4:]=='.pps':
                   filetpye='.pps'
                
                newname=str(count)+filetpye
                if filetpye!='':
                    print newname
                    logfile.write('the new name of file:'+newname+'\n')
                    os.rename(os.path.join(root,filename),os.path.join(root,newname))
                    print filename,'ok'
                    count=count+1
                    filetpye=''
logfile.close()


import os
catchfile=open('md51.txt','r')
checkfile=open('md52.txt','r')
checklog=file('checklog.txt','w')
log=open('checklog.txt','r+')
catchfile_lst=catchfile.readlines()
checkfile_lst=checkfile.readlines()
right_num=0
error_num=0

for catched_file in catchfile_lst:
    catchedfile_md5=catched_file.strip().split()
    for checked_file in checkfile_lst:
        checkedfile_md5=checked_file.strip().split()
        if catchedfile_md5[0]==checkedfile_md5[0]:
            print "tcpxtract catched file :"
            print catched_file.strip()
            print "checked OK"
            right_num=right_num+1
            print '========================='
            break
        if checked_file==checkfile_lst[-1]:
            print "tcpxtract catched file :"
            print catched_file.strip()
            print "checked Error"
            error_num=error_num+1
            log.write("tcpxtract catched file :"+'\n')
            log.write(catched_file.strip()+'\n')
            log.write("checked Error"+'\n')
            log.write('======================================'+'\n')
print right_num
print error_num
log.write('rigth_num='+str(right_num)+'\n')
log.write('wrong_num='+str(error_num)+'\n')
catchfile.close()
checkfile.close()
log.close()

             

    
     

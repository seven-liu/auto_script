# -*- coding: utf-8 -*- 
import os.path as osp
import logging
import struct
import ctypes
import os
import time
from  ftplib import FTP
import ftplib
import sys
import md5
import subprocess
import socket 
logging.basicConfig(level=logging.DEBUG)
LOGGER = logging.getLogger()
global server_ftp_ip
global server_ftp_port
global server_ftp_username
global server_ftp_passwd
    
def is_pe_file(filename):
    
    """检查文件是否是PE格式.

    判断条件： 以二进制形式读取文件，如果文件开头两个字节为MZ，
    且读取0x3C的偏移量，然后该偏移量位置的2个字节为PE，则判断为PE文件

    @param filename: 文件名
    @type filename: str

    @return: 判断结果
    @rtype: bool

    """
    if not osp.isfile(filename):
        log = 'filename: %s: not found' % filename
        LOGGER.error(log)
        return False

    try:
        with open(filename, 'rb') as fp:
            fhead = fp.read(2)
            if fhead != 'MZ':
                return False

            fp.seek(0x3C)
            src_offset = fp.read(4)
            if len(src_offset) < 4:
                return False

            try:
                offset = struct.unpack('I', src_offset)[0]
            except Exception as e:
                log = 'get offset error: %s' % e
                LOGGER.error(log)
                return False

            fp.seek(offset)
            offset_value = fp.read(2)
            if offset_value == 'PE':
                
                return True
            else:
                return False
    except Exception as e:
        log = 'read %s error: %s' % (filename, e)
        LOGGER.error(log)
        return False
def panfu_iterate_file(ftp):
    ftp_up_num=0
    md5_list_all=md5_list()
    lpBuffer = ctypes.create_string_buffer(78)
    ctypes.windll.kernel32.GetLogicalDriveStringsA(ctypes.sizeof(lpBuffer), lpBuffer)
    vol = lpBuffer.raw.split('\x00')
    vol=['D:\\','E:\\','F:\\','G\\']
    for i in vol:
       if i:
            print i
            for root,dirs,files in os.walk(i):
                for fn in files:
                    file_path_name=root+'\\'+fn
                    try:
                        size = os.path.getsize(file_path_name.strip())
                    except:
                        print 'get file size fail '
                        break
                    if size < 5242880:
                        if is_pe_file(file_path_name.strip()):
                            file_md5=md5sum(file_path_name.strip())
                            for md5_list_one in md5_list_all:
                                if file_md5==md5_list_one.strip():
                                    break
                                if md5_list_one==md5_list_all[-1]:
                                    print file_path_name.strip()
                                    print file_md5
                                    try:
                                        ftp_upload(ftp,file_path_name.strip(),file_md5)
                                        ftp_up_num=ftp_up_num+1
                                        print 'upload pe file num:{0} successful'.format(str(ftp_up_num))
                                        print '________________________'
                                        break
                                    except:
                                        print'upload pe file fail'
def ftp_upload(ftp,filename,file_md5=''):
    bufsize = 1024
    file_handler = open(filename,'rb')#以读模式在本地打开文件 s
    obj_file_name=file_md5+'_'+os.path.basename(filename)
    ftp.storbinary('STOR %s' % obj_file_name,file_handler,bufsize)#上传文件 
    ftp.set_debuglevel(0) 
    file_handler.close()
       
def ftp_connet():
    try:
        ftp=FTP() 
        ftp.connect(server_ftp_ip,server_ftp_port)#
        ftp.login(server_ftp_username,server_ftp_passwd)
        ftp.cwd(server_path) #选择操作目录
        return ftp
    except:
        print 'login ftp server  error'
def ftp_close(ftp):
        ftp.quit()
                                
def ftp_creat_dir():
    ftp=FTP() 
    ftp.set_debuglevel(2)#打开调试级别2，显示详细信息;0为关闭调试信息 
    ftp.connect(server_ftp_ip,server_ftp_port)#连接
    ftp.login(server_ftp_username,server_ftp_passwd)
    try:
        ftp.cwd(server_path)
        return True
    except ftplib.error_perm:
        try:
            ftp.mkd(server_path)
            return True
            
        except ftplib.error_perm:
            return False
    ftp.quit()

def sumfile(fobj):    
    m = md5.new()
    while True:
        d = fobj.read(8096)
        if not d:
            break
        m.update(d)
    return m.hexdigest()

def md5sum(fname):    
    if fname == '-':
        ret = sumfile(sys.stdin)
    else:
        try:
            f = file(fname, 'rb')
        except:
            return 'Failed to open file'
        ret = sumfile(f)
        f.close()
    return ret
def md5_list():
    md5_list_fh=open('md5_all.txt','r')
    md5_list=md5_list_fh.readlines()
    md5_list_fh.close()
    return md5_list
def get_ftp_info():
    global server_ftp_ip
    global server_ftp_port
    global server_ftp_username
    global server_ftp_passwd
    if os.path.exists('config.txt'):
        config_fh=open('config.txt','r')
        ftp_info=config_fh.readlines()
        server_ftp_ip=ftp_info[0].split('=')[-1].strip()
        server_ftp_port=ftp_info[1].split('=')[-1].strip()
        server_ftp_username=ftp_info[2].split('=')[-1].strip()
        server_ftp_passwd=ftp_info[3].split('=')[-1].strip()
    else:
        print 'config file does not exist--------------'


if __name__=='__main__':
    global server_path
    global server_ftp_ip
    global server_ftp_port
    global server_ftp_username
    global server_ftp_passwd
    get_ftp_info()
    whoami_info=os.system('whoami >systeminfo.txt')
    systeminfo=os.system('systeminfo >>systeminfo.txt')
    hostname=socket.gethostname()
    ip_addr=socket.gethostbyname(hostname)
    server_path=ip_addr+'_'+hostname
    print server_path
    if ftp_creat_dir():
        ftp=ftp_connet()
        panfu_iterate_file(ftp)
        ftp_upload(ftp,'systeminfo.txt')
        ftp_close(ftp)
        print 'upload file end'
    else:
        print '{0} does not exist'.format(server_path)
    
    
         
   

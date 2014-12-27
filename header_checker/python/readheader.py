#!/usr/bin/python
# -*- coding=utf-8 -*-

import sys
import os
import os.path
import shutil

source={
'4D5A':'.EXE/.DLL/.SYS/.OCX/.OLB/.IMM/.IME/.FON字库',

'4C00':'4C00000001140200.LNK Windows 快捷方式',
'5B49':'5B496E7465726E657453686F72746375745D.URL 网址快捷方式',
'5B44':'5B44454641554C545D0D0A4241534555524C3D.URL 网址快捷方式',

'3C3F':'3C3F786D6C20.XML',
'EFBB':'EFBBBF3C3F786D6C.XML UTF-8 编码/UTF-8 编码文本',
'FFFE':'FFFE3C003F0078006D006C00.XML Unicode Little Endian 编码/Unicode Little Endian 编码文本',
'FEFF':'FEFF003C003F0078006D006C.XML Unicode Big Endian 编码/Unicode Big Endian 编码文本',

'377A':'.7Z 7-ZIP压缩包',
'425A':'.BZ2 BZIP2压缩包',
'EB3C':'EB3C90.IMG /.IMA 磁盘映像',
'5261':'52617221.RAR 压缩包',
'1F8B':'1F8B0808.GZ GZIP压缩包',
'504B':'504B0304.ZIP 压缩包 /.IMZ 磁盘压缩映像/.APK 安卓系统软件包',
'FEEF':'FEEF0103.GHO GHOST 磁盘备份文件',
'4D53':'4D5357494D.WIM 压缩包/4D53434600.CAB 压缩包',
'FD37':'FD377A585A.XZ 压缩包',

'434E':'.E 易语言源码文件',
'D0CF':'D0CF11E0.DOC Word /.XLS Excel /.PPT PowerPoint',
'504B':'504B0304.DOCX Word /.XLSX Excel /.PPTX PowerPoint',
'2142':'2142444E.PST Outlook',
'E382':'E3828596.PWL Windows Password',
'7474':'74746366.TTC 字库',
'4244':'424454.TTF 中文字库',
'5349':'534947.TTF 非中文字库',
'3F5F':'3F5F0300.HLP Windows 帮助文件',
'4954':'4954534603.CHM 帮助文件或电子书',
'7B5C':'7B5C727466.RTF 文档',
'4444':'44446F634642.WDL 文档',
'2550':'255044462D312E.PDF 文档',
'CFAD':'CFAD12FEC5FD746F.DBX Outlook Express',
'5374':'5374616E64617264204A.MDB Access',
'6438':'64383A616E6E6F756E6365.TORRENT BT 种子',
'5245':'52454745444954340D0A.REG 注册表数据文件',
'0609':'06092A864886F70D010702A082.CAT 安全编录文件',


'424D':'.BMP 图片',
'4749':'474946.GIF 图片',
'4949':'49492A.TIF /.TIFF 图片',
'FFD8':'FFD8FFE0.JPG /.JPEG 图片',
'8950':'89504E47.PNG 图片',
'3842':'38425053.PSD Photoshop 图片',
'4143':'41433130.DWG CAD 图片',

'4944':'494433.MP3 带标签',
'FFFB':'FFFB90.MP3 无标签',
'4D54':'4D546864.MID MIDI音乐',
'4F67':'4F676753.OGG 音频格式',
'2E72':'2E7261FD.RAM Real 音频格式',
'6B72':'6B7263313846.KRC 酷狗音乐歌词文件',
'5741':'57415645666D7420.WAV Windows 波形声音文件',

'4156':'415649.AVI 视频',
'4357':'435753.SWF Flash',
'464C':'464C56.FLV 视频',
'2E52':'2E524D46.RMVB 视频/.RM 音频',
'6D6F':'6D6F6F76.MOV QuickTime 视频',
'1A45':'1A45DFA3.MKV 视频',
'0000':'000001BA44.VOB 视频/000001BA.MPG 视频/000001B3.MPG 视频',
'6674':'667479706D7034.MP4 (视频)/66747970336770.3GP (视频)/6674797069736F.MP4 (视频)',
'4344':'43445841666D7420/.MPG 视频',
'3026':'3026B2758E66CF11A6D900/.ASF 视频/.WMV 视频/.WMA 音频'
}


len_source=len(source)
print len_source
count=0

os.mkdir("tmp")
f = open("result.txt",'w')
f.close()





# path = os.getcwd()
filelist=open("filelist.txt",'r+') #写入文件#
# for root, dirs, files in os.walk(path):
#     for filelst in files:
#         print os.path.join(root, filelst)
#         filelist.write(os.path.join(root, filelst)+'\n')


namelist=filelist.read().split('\n')   #读文件列表#
f2=open("result.txt",'r+')

for i in range(0,len(namelist)-1):
     print namelist[i]
     f2.write(namelist[i]+'\n')
     print open(namelist[i],'rb').read(2).encode('hex')
     f2.write(open(namelist[i],'rb').read(2).encode('hex')+'\n')
     head= (open(namelist[i], 'rb').read(2).encode('hex'))
     HEAD=head.upper()
     print "HEAD :"+HEAD
     f2.write("HEAD :"+HEAD+'\n')
     for key in source.keys():
      
         if HEAD==key:
             print "matched" +"   "+source[key]
             f2.write("matched" +"   "+source[key]+'\n')
             count=0
             break
         else:
             count=count+1
             if count==len_source-1:
                  print "Not match!" +"    " +"head is" +"   "+HEAD
                  f2.write("Not match!" +"    " +"head is" +"   "+HEAD+'\n')
                  shutil.copy(namelist[i],"tmp")
                 #os.remove(namelist[i])
                  count=1
                 
           



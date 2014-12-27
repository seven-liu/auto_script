:: 文件类型检测批处理 By SunTB

@echo off & setlocal enabledelayedexpansion


::特殊情况检测
if not exist "%~dpnx1" (echo.&set /p tmpstr=请将要检测的文件发送到此批处理上执行，<nul&goto :quit)
set file_size=%~z1
if not defined file_size (echo.&set /p tmpstr=该文件无法检测，<nul&goto :quit)
if exist "%~dpnx1\" (echo.&set /p tmpstr=不支持检测文件夹，<nul&goto :quit)
if %~z1 equ 0 (echo.&set /p tmpstr=该文件大小为 0 字节，<nul&goto :quit)

::生成VBS备用
set vbs=%temp%\CodeQuery.vbs
 if not exist "%vbs%" (
echo N = Wscript.Arguments(0^)
echo file = Wscript.Arguments(1^)
echo Dim slz
echo set slz = CreateObject("Adodb.Stream"^)
echo slz.Type = 1
 echo slz.Mode = 3
echo slz.Open
echo  slz.Position = 0
echo slz.Loadfromfile file
echo Bin=slz.read(N^)
echo For I = 1 To N
echo WScript.echo Hex(AscB(MidB(Bin,I,1^)^)^)
echo Next
)>"%vbs%"

::检测文本编码

echo.&echo 当前检测文件 ：%~dpnx1

::设置文件头默认取值字节数，可自行更改为非零的10进制数
set n=20

::当文件字节数小于默认取值字节数时以实际文件大小值为准
if %~z1 lss !n! set n=%~z1

::显示提取到的文件头数据
set bit16=0 1 2 3 4 5 6 7 8 9 a b c d e f

for %%a in (!bit16!) do (
  for %%b in (!bit16!) do if 0x%%a%%b lss !n! set /p tmpstr=%%a%%b <nul
)

for /f %%a in ('cscript //nologo "%vbs%" !n! "%~dpnx1"') do (
  set code_tmp=%%a
  if "!code_tmp:~1,1!"=="" set code_tmp=0%%a
  set code_all=!code_all!!code_tmp!
  if not defined code_all_2 (set code_all_2=!code_tmp!) else (set code_all_2=!code_all_2! !code_tmp!)
)


::查找批处理后附数据，若有对应文件头标识数据则显示预设的文件类型等信息
for /f "delims=:" %%i in ('findstr /n /i /b "::code" %0') do (
  for /f "tokens=1,2* delims={}" %%a in ('more +%%i %0^|findstr /v /b "'"') do (
	set code=%%b
	set code=!code: =!
    set code_b=%%a
	set /a b=%%a*2
	set type=%%c
	call :code_len
    call :code_if
  )
)

::显示最终识别结果
if not defined code_find (
echo.&set /p tmpstr=识别的结果为 ：批处理内无相关数据，<nul
  set type_last=无法确定文件类型
echo.!type_last!
move  %~dpnx1 ./temp/
  echo.&goto :quit

)

if !b_last! neq 0 (set x=&call :out_space)
set x=0&call :out_code


::退出批处理

:quit
if exist "%vbs%" del "%vbs%"




:code_len
for /l %%n in (1,1,99) do (
  if /i "!code:~%%n,1!"=="" (set code_len=%%n&goto :eof)
)
goto :eof

:code_if
if /i "!code_all:~%b%,%code_len%!"=="!code!" (
  set code_find=1
  set b_last=!b!
  set code_last=!code!
  set type_last=!type!
)
goto :eof
	  
:out_space
set /a x+=2
set /p tmpstr=   <nul
if !x! equ !b_last! goto :eof
goto :out_space

:out_code
if "!code_last:~%x%,2!"=="" (echo.&goto :eof)
set /p tmpstr=!code_last:~%x%,2! <nul
set /a x+=2
goto :out_code


::可自行按如下添加文件头标识数据

{开始取值字节位}{文件头标识}{文件类型}

说明:
    {开始取值字节位}      数据为对应的10进制值，一般为{0}
    {文件头标识}          文件头标识码，数据为16进制值，支持字节之间加空格

注意：
    1、若文件头标识前面字节数据相同，则文件头标识数据短的在上，长的在下！
    2、下一行的“::code”作为批处理提取数据时的起始行标志，请勿删除！
    3、处理时自动忽略以字符“‘”为行首的注释行！

::code

’以{4D5A}为文件头的文件类型太多，全集中此处检测
{0}{4D5A}{.EXE/.DLL/.SYS/.OCX/.OLB/.IMM/.IME/.FON{字库}

{0}{4C00000001140200}{.LNK {Windows 快捷方式}
{0}{5B496E7465726E657453686F72746375745D}{.URL {网址快捷方式}
{0}{5B44454641554C545D0D0A4241534555524C3D}{.URL {网址快捷方式}

{0}{EFBB}{UTF-8 编码文本
{0}{FFFE}{Unicode Little Endian 编码文本
{0}{FEFF}{Unicode Big Endian 编码文本
{0}{3C3F786D6C20}{.XML
{0}{EFBBBF3C3F786D6C}{.XML {UTF-8 编码}
{0}{FFFE3C003F0078006D006C00}{.XML {Unicode Little Endian 编码}
{0}{FEFF003C003F0078006D006C}{.XML {Unicode Big Endian 编码}

{0}{377A}{.7Z {7-ZIP压缩包}
{0}{425A}{.BZ2 {BZIP2压缩包}
{0}{EB3C90}{.IMG /.IMA {磁盘映像}
{0}{52617221}{.RAR {压缩包}
{0}{1F8B0808}{.GZ {GZIP压缩包}
{0}{504B0304}{.ZIP {压缩包} /.IMZ {磁盘压缩映像} /.APK {安卓系统软件包}
{0}{FEEF0103}{.GHO {GHOST 磁盘备份文件}
{0}{4D53434600}{.CAB {压缩包}
{0}{4D5357494D}{.WIM {压缩包}
{0}{FD377A585A}{.XZ {压缩包}

{0}{434E}{.E {易语言源码文件}
{0}{D0CF11E0}{.DOC {Word} /.XLS {Excel} /.PPT {PowerPoint}
{0}{504B0304}{.DOCX {Word} /.XLSX {Excel} /.PPTX {PowerPoint}
{0}{2142444E}{.PST {Outlook}
{0}{E3828596}{.PWL {Windows Password}
{0}{74746366}{.TTC {字库}
{13}{424454}{.TTF {中文字库}
{13}{534947}{.TTF {非中文字库}
{0}{3F5F0300}{.HLP {Windows 帮助文件}
{0}{4954534603}{.CHM {帮助文件或电子书}
{0}{7B5C727466}{.RTF 文档
{0}{44446F634642}{.WDL 文档
{0}{255044462D312E}{.PDF 文档
{0}{CFAD12FEC5FD746F}{.DBX {Outlook Express}
{4}{5374616E64617264204A}{.MDB {Access}
{0}{64383A616E6E6F756E6365}{.TORRENT {BT 种子}
{0}{52454745444954340D0A}{.REG {注册表数据文件}
{4}{06092A864886F70D010702A082}{.CAT {安全编录文件}


{0}{424D}{.BMP {图片}
{0}{474946}{.GIF {图片}
{0}{49492A}{.TIF /.TIFF {图片}
{0}{FFD8FFE0}{.JPG /.JPEG {图片}
{0}{89504E47}{.PNG {图片}
{0}{38425053}{.PSD {Photoshop 图片}
{0}{41433130}{.DWG {CAD 图片}

{0}{494433}{.MP3 {带标签}
{0}{FFFB90}{.MP3 {无标签}
{0}{4D546864}{.MID {MIDI音乐}
{0}{4F676753}{.OGG {音频格式}
{0}{2E7261FD}{.RAM {Real 音频格式}
{0}{6B7263313846}{.KRC {酷狗音乐歌词文件}
{8}{57415645666D7420}{.WAV {Windows 波形声音文件}

{8}{415649}{.AVI {视频}
{0}{435753}{.SWF {Flash}
{0}{464C56}{.FLV {视频}
{0}{2E524D46}{.RMVB {视频}/.RM {音频}
{0}{6D6F6F76}{.MOV {QuickTime 视频}
{0}{000001B3}{.MPG {视频}
{0}{000001BA}{.MPG {视频}
{0}{1A45DFA3}{.MKV {视频}
{0}{000001BA44}{.VOB {视频}
{4}{66747970336770}{.3GP (视频)
{4}{667479706D7034}{.MP4 (视频)
{4}{6674797069736F}{.MP4 (视频)
{8}{43445841666D7420}{.MPG {视频}
{0}{3026B2758E66CF11A6D900}{.ASF {视频}/.WMV {视频}/.WMA {音频}

:: �ļ����ͼ�������� By SunTB

@echo off & setlocal enabledelayedexpansion


::����������
if not exist "%~dpnx1" (echo.&set /p tmpstr=�뽫Ҫ�����ļ����͵�����������ִ�У�<nul&goto :quit)
set file_size=%~z1
if not defined file_size (echo.&set /p tmpstr=���ļ��޷���⣬<nul&goto :quit)
if exist "%~dpnx1\" (echo.&set /p tmpstr=��֧�ּ���ļ��У�<nul&goto :quit)
if %~z1 equ 0 (echo.&set /p tmpstr=���ļ���СΪ 0 �ֽڣ�<nul&goto :quit)

::����VBS����
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

::����ı�����

echo.&echo ��ǰ����ļ� ��%~dpnx1

::�����ļ�ͷĬ��ȡֵ�ֽ����������и���Ϊ�����10������
set n=20

::���ļ��ֽ���С��Ĭ��ȡֵ�ֽ���ʱ��ʵ���ļ���СֵΪ׼
if %~z1 lss !n! set n=%~z1

::��ʾ��ȡ�����ļ�ͷ����
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


::��������������ݣ����ж�Ӧ�ļ�ͷ��ʶ��������ʾԤ����ļ����͵���Ϣ
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

::��ʾ����ʶ����
if not defined code_find (
echo.&set /p tmpstr=ʶ��Ľ��Ϊ ������������������ݣ�<nul
  set type_last=�޷�ȷ���ļ�����
echo.!type_last!
mkdir temp
move  %~dpnx1 ./temp/
  echo.&goto :quit

)

if !b_last! neq 0 (set x=&call :out_space)
set x=0&call :out_code


::�˳�������

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


::�����а���������ļ�ͷ��ʶ����

{��ʼȡֵ�ֽ�λ}{�ļ�ͷ��ʶ}{�ļ�����}

˵��:
    {��ʼȡֵ�ֽ�λ}      ����Ϊ��Ӧ��10����ֵ��һ��Ϊ{0}
    {�ļ�ͷ��ʶ}          �ļ�ͷ��ʶ�룬����Ϊ16����ֵ��֧���ֽ�֮��ӿո�

ע�⣺
    1�����ļ�ͷ��ʶǰ���ֽ�������ͬ�����ļ�ͷ��ʶ���ݶ̵����ϣ��������£�
    2����һ�еġ�::code����Ϊ��������ȡ����ʱ����ʼ�б�־������ɾ����
    3������ʱ�Զ��������ַ�������Ϊ���׵�ע���У�

::code

����{4D5A}Ϊ�ļ�ͷ���ļ�����̫�࣬ȫ���д˴����
{0}{4D5A}{.EXE/.DLL/.SYS/.OCX/.OLB/.IMM/.IME/.FON{�ֿ�}

{0}{4C00000001140200}{.LNK {Windows ��ݷ�ʽ}
{0}{5B496E7465726E657453686F72746375745D}{.URL {��ַ��ݷ�ʽ}
{0}{5B44454641554C545D0D0A4241534555524C3D}{.URL {��ַ��ݷ�ʽ}

{0}{EFBB}{UTF-8 �����ı�
{0}{FFFE}{Unicode Little Endian �����ı�
{0}{FEFF}{Unicode Big Endian �����ı�
{0}{3C3F786D6C20}{.XML
{0}{EFBBBF3C3F786D6C}{.XML {UTF-8 ����}
{0}{FFFE3C003F0078006D006C00}{.XML {Unicode Little Endian ����}
{0}{FEFF003C003F0078006D006C}{.XML {Unicode Big Endian ����}

{0}{377A}{.7Z {7-ZIPѹ����}
{0}{425A}{.BZ2 {BZIP2ѹ����}
{0}{EB3C90}{.IMG /.IMA {����ӳ��}
{0}{52617221}{.RAR {ѹ����}
{0}{1F8B0808}{.GZ {GZIPѹ����}
{0}{504B0304}{.ZIP {ѹ����} /.IMZ {����ѹ��ӳ��} /.APK {��׿ϵͳ�����}
{0}{FEEF0103}{.GHO {GHOST ���̱����ļ�}
{0}{4D53434600}{.CAB {ѹ����}
{0}{4D5357494D}{.WIM {ѹ����}
{0}{FD377A585A}{.XZ {ѹ����}

{0}{434E}{.E {������Դ���ļ�}
{0}{D0CF11E0}{.DOC {Word} /.XLS {Excel} /.PPT {PowerPoint}
{0}{504B0304}{.DOCX {Word} /.XLSX {Excel} /.PPTX {PowerPoint}
{0}{2142444E}{.PST {Outlook}
{0}{E3828596}{.PWL {Windows Password}
{0}{74746366}{.TTC {�ֿ�}
{13}{424454}{.TTF {�����ֿ�}
{13}{534947}{.TTF {�������ֿ�}
{0}{3F5F0300}{.HLP {Windows �����ļ�}
{0}{4954534603}{.CHM {�����ļ��������}
{0}{7B5C727466}{.RTF �ĵ�
{0}{44446F634642}{.WDL �ĵ�
{0}{255044462D312E}{.PDF �ĵ�
{0}{CFAD12FEC5FD746F}{.DBX {Outlook Express}
{4}{5374616E64617264204A}{.MDB {Access}
{0}{64383A616E6E6F756E6365}{.TORRENT {BT ����}
{0}{52454745444954340D0A}{.REG {ע��������ļ�}
{4}{06092A864886F70D010702A082}{.CAT {��ȫ��¼�ļ�}


{0}{424D}{.BMP {ͼƬ}
{0}{474946}{.GIF {ͼƬ}
{0}{49492A}{.TIF /.TIFF {ͼƬ}
{0}{FFD8FFE0}{.JPG /.JPEG {ͼƬ}
{0}{89504E47}{.PNG {ͼƬ}
{0}{38425053}{.PSD {Photoshop ͼƬ}
{0}{41433130}{.DWG {CAD ͼƬ}

{0}{494433}{.MP3 {����ǩ}
{0}{FFFB90}{.MP3 {�ޱ�ǩ}
{0}{4D546864}{.MID {MIDI����}
{0}{4F676753}{.OGG {��Ƶ��ʽ}
{0}{2E7261FD}{.RAM {Real ��Ƶ��ʽ}
{0}{6B7263313846}{.KRC {�ṷ���ָ���ļ�}
{8}{57415645666D7420}{.WAV {Windows ���������ļ�}

{8}{415649}{.AVI {��Ƶ}
{0}{435753}{.SWF {Flash}
{0}{464C56}{.FLV {��Ƶ}
{0}{2E524D46}{.RMVB {��Ƶ}/.RM {��Ƶ}
{0}{6D6F6F76}{.MOV {QuickTime ��Ƶ}
{0}{000001B3}{.MPG {��Ƶ}
{0}{000001BA}{.MPG {��Ƶ}
{0}{1A45DFA3}{.MKV {��Ƶ}
{0}{000001BA44}{.VOB {��Ƶ}
{4}{66747970336770}{.3GP (��Ƶ)
{4}{667479706D7034}{.MP4 (��Ƶ)
{4}{6674797069736F}{.MP4 (��Ƶ)
{8}{43445841666D7420}{.MPG {��Ƶ}
{0}{3026B2758E66CF11A6D900}{.ASF {��Ƶ}/.WMV {��Ƶ}/.WMA {��Ƶ}


 @echo on
for  /r %%i in (*.*)  do echo "%%i"  >> tmp.txt



for /f "tokens=*" %%a in (tmp.txt) do @echo %%a|find /v "listfile" >>tmp1.txt
for /f "tokens=*" %%a in (tmp1.txt) do @echo %%a|find /v "runCheck" >>tmp2.txt
for /f "tokens=*" %%a in (tmp2.txt) do @echo %%a|find /v "ZzzFiletypecheck" >>tmp3.txt   
for /f "tokens=*" %%a in (tmp3.txt) do @echo %%a|find /v "FiletypeCheck"   >>filelist.txt

del /f  tmp.txt tmp1.txt tmp2.txt tmp3.txt 
@echo off
rem ָ�����������ļ�
RD /S/Q cache

setlocal enabledelayedexpansion
md exefile 
set type=.dll .sys .ocx .exe .com

  
  
echo �������������Ժ�...
for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
  if exist %%a:\nul (
    for %%i in (%type%) do (
      for /f "delims=" %%b in ('dir /s /a-d /b *"%%i" ') do (
	    echo %%b  >>e:\log.txt
        copy %%b   e:\exefile   >>e:\log.txt
     ) 
   )
  )
)
pause
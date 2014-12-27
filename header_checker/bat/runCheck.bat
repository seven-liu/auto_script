@echo off
call  listfile.bat
echo.
 for /f "delims='" %%i in (filelist.txt)  do Zzzfiletypecheck.bat %%i >>result.txt
            


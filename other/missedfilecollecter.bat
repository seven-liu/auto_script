
 @echo off
:set counter
RD /S/Q cache

setlocal enabledelayedexpansion

md missedfiles




for /f "delims='" %%i in (bad.txt) do (
echo ***********************************
echo %%i 
copy %%i missedfiles
echo ***********************************     >>copylog.txt    
                                                 
 )

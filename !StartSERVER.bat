@echo off
:start
C:\Windows\System32\tasklist /FI "IMAGENAME eq arma3server.exe" 2>NUL | C:\Windows\System32\find /I /N "arma3server.exe">NUL
if "%ERRORLEVEL%"=="0" goto loop
echo Server monitored is not running, will be started now
start "" /wait "C:\Games\Arma3\A3Master\arma3server.exe" -bepath="battleye" -port=2302 -autoInit -world=empty -cfg=basic.cfg -name=ghostoserver -config="server.cfg" -profiles="Users" -serverMod="@inidbi2" -mod="mods\@CBA_A3;mods\@IMS;mods\@WebKnightZaC;mods\@RHSGREF;mods\@RHSSAF;mods\@RHSUSAF;mods\@RHSAFRF;mods\@Enhanced_Movement;mods\@EMRework;mods\@discord"
echo Server started succesfully
goto started
:loop
cls
echo Server is already running, running monitoring loop
:started
C:\Windows\System32\timeout /t 10
C:\Windows\System32\tasklist /FI "IMAGENAME eq arma3server.exe" 2>NUL | C:\Windows\System32\find /I /N "arma3server.exe">NUL
if "%ERRORLEVEL%"=="0" goto loop
C:\Windows\System32\taskkill /im arma3server.exe
goto start
@echo off
SET DOSDIR=A:\DOS
SET LANG=GR
SET PATH=%dosdir%\BIN

SET DIRCMD=/P /OGN /Y

rem SET TEMP=%dosdir%\TEMP
rem SET TMP=%TEMP%

rem SET NLSPATH=%dosdir%\NLS
rem SET HELPPATH=%dosdir%\HELP
rem SET BLASTER=A220 I5 D1 H5 P330
rem SET COPYCMD=/-Y

DEVLOAD /H /Q %dosdir%\BIN\UDVD2.SYS /D:FDCD0001
SHSUCDX /QQ /D3

FDAPM APMDOS
NLSFUNC %dosdir%\BIN\COUNTRY.SYS
KEYB GR,858,%dosdir%\bin\keyboard.sys
rem CHCP 858
rem PCNTPK INT=0x60
rem DHCP
rem MOUSE

rem DEVLOAD /H /Q %dosdir%\BIN\UIDE.SYS /H /D:FDCD0001 /S5

SHSUCDX /QQ /~ /D:?SHSU-CDR,D /D:?SHSU-CDH,D /D:?FDCD0001,D /D:?FDCD0002,D /D:?FDCD0003,D

rem MEM /C /N

SHSUCDX /D

rem DOSLFN

SET AUTOFILE=%0
SET CFGFILE=\FDCONFIG.SYS
alias reboot=fdapm warmboot
alias reset=fdisk /reboot
alias halt=fdapm poweroff
alias shutdown=fdapm poweroff

rem alias cfg=edit %cfgfile%

d:
cd pconline
btx1

@echo off
SET DOSDIR=A:\DOS
SET LANG=GR
SET PATH=%dosdir%\BIN

SET DIRCMD=/P /OGN /Y

NLSFUNC %dosdir%\BIN\COUNTRY.SYS
KEYB GR,858,%dosdir%\bin\keyboard.sys

SET AUTOFILE=%0
SET CFGFILE=\FDCONFIG.SYS

cd pconline
btx1

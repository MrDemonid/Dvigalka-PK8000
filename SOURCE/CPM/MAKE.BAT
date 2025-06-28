@ECHO OFF
BREAK ON
:: set PL/M tools and sources paths
set SOURCES=.
set BINARY=..\..\bin

if "%PLM80%" == "" goto nodef
set PLMBIN=%PLM80%\BIN
set PLMLIB=%PLM80%\LIB
goto clearprev

:nodef
:: !!! predefined path not found, use default !!!
echo WARNING!!! Path for PL/M not found!
echo Use default path
pause
set PLMBIN=C:\PLMTOOL\BIN
set PLMLIB=C:\PLMTOOL\LIB

:clearprev
:: clear previous files
%SOURCES%\del *.obj
%SOURCES%\del *.lst
del %BINARY%\dvig.com
del dvig.com


:: set sources and plm80 paths with ISIS-II style
set :F0:=%SOURCES%
set :F1:=%PLMBIN%
set :F2:=%PLMLIB%

cls
%PLMBIN%\ASM80 about.m80
if errorlevel == 1 goto error
%PLMBIN%\ASM80 stplay.m80
if errorlevel == 1 goto error


%PLMBIN%\PLM80 pole.plm DEBUG PAGEWIDTH(120)
if errorlevel == 1 goto error

%PLMBIN%\PLM80 data.plm DEBUG PAGEWIDTH(120)
if errorlevel == 1 goto error

%PLMBIN%\PLM80 stone.plm DEBUG PAGEWIDTH(120)
if errorlevel == 1 goto error

%PLMBIN%\PLM80 gproc.plm DEBUG PAGEWIDTH(120)
if errorlevel == 1 goto error

%PLMBIN%\PLM80 main.plm DEBUG PAGEWIDTH(120)
if errorlevel == 1 goto error

echo ===========================================
echo = Yeehaw! All compiled! No Errors! Ready! =
echo ===========================================
pause

cls
@ECHO ON
%PLMBIN%\LINK main.obj,gproc.obj,pole.obj,stone.obj,stplay.obj,about.obj,game.lib,:f2:plm80.lib,data.obj TO dvig.lnk
%PLMBIN%\LOCATE dvig.lnk TO dvig.kz CODE(100H) STACKSIZE(100) MAP PRINT(dvig.tra)
%PLMBIN%\OBJCPM dvig.kz
@ECHO OFF
copy /b %SOURCES%\dvig.com %BINARY%\dvig.com
if errorlevel == 1 goto error

:: copy to HDD image file, for emulator EMU80
:: if exist "D:\EMU80\PK8000\cf.cpm" %PLMBIN%\c8000w.exe -r "D:\EMU80\PK8000\cf.cpm" A: dvig.com

goto end

:error
echo ######################################
echo ######################################
echo ######### AN ERROR OCCURED! ##########
echo ######################################
echo ######################################

:end
pause
del %SOURCES%\*.lst
del %SOURCES%\*.obj
del %SOURCES%\dvig.kz
del %SOURCES%\dvig.lin
del %SOURCES%\dvig.lnk
del %SOURCES%\dvig.sym
del %SOURCES%\dvig.tra
del %SOURCES%\dvig.com

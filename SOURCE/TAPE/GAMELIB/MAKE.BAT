@ECHO OFF
BREAK ON

:: set PL/M tools and sources paths
if "%PLM80%" == "" goto nodef
set PLMBIN=%PLM80%\BIN
goto clearprev

:nodef
:: !!! predefined path not found, use default !!!
set PLMBIN=C:\PLMTOOL\BIN

:clearprev

del game.lib
cls
@echo Make game library

SET :F0:=%PLMBIN%
SET :F1:=.
@ECHO ON

%PLMBIN%\lib.exe < mklib.txt

if exist game.lib copy /b game.lib ..\game.lib
del game.lib

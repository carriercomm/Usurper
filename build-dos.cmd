@ECHO OFF

Z:
CD Z:\PROGRA~1\USURPER

ECHO CLEANING OUTPUT DIRECTORY
DEL /Q Z:\PROGRA~1\USURPER\BIN\I386-M~1\*.*

ECHO COPYING BPC.CFG
COPY BPC.CFG Z:\BP\BIN

ECHO COMPILING EDITOR
CD SOURCE\EDITOR
Z:\BP\BIN\BPC EDITOR
IF NOT %ERRORLEVEL% == 0 GOTO END

ECHO COMPILING USURPER
CD ..\USURPER
Z:\BP\BIN\BPC USURPER
IF NOT %ERRORLEVEL% == 0 GOTO END

ECHO.
ECHO DONE!

:END
CD Z:\PROGRA~1\USURPER
PAUSE
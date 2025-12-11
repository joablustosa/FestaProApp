@echo off
REM Wrapper para flutter.bat que garante que Git esteja no PATH
setlocal

REM Adicionar Git ao PATH antes de tudo
set "PATH=C:\Program Files\Git\cmd;C:\Program Files\Git\bin;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\usr\bin;%PATH%"

REM Chamar o Flutter original com todos os argumentos
C:\flutter\bin\flutter.bat %*

endlocal


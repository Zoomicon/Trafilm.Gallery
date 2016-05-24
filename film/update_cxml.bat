:: Version: 20160524
:: Author: George Birbilis <birbilis@kagi.com>

@echo off

call :process > C:\inetpub\wwwroot\Trafilm_Gallery\film\update_cxml.log
goto :EOF


:process

ECHO ---- Updating collection and DeepZoom assets

cd C:\inetpub\wwwroot\Trafilm_Gallery\film
c:\programs\pauthor\pauthor.exe /source cxml films.cxml /html-template template.html /target deepzoom ..\collection\films.cxml && (goto OK) || (goto Fail)
goto :EOF


:OK
echo OK
::start http://gallery.clipflair.net/films
goto :EOF


:Fail
echo FAILED
goto :EOF

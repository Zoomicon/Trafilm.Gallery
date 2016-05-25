:: Version: 20160525
:: Author: George Birbilis <birbilis@kagi.com>

@echo off
call :process > update_cxml.log
goto :EOF

:process
ECHO ---- Updating collection and DeepZoom assets
c:\programs\pauthor\pauthor.exe /source cxml films.cxml /html-template template.html /target deepzoom ..\collection\films.cxml && (goto OK) || (goto Fail)
goto :EOF

:OK
echo OK
::start http://gallery.clipflair.net/films
goto :EOF

:Fail
echo FAILED
goto :EOF

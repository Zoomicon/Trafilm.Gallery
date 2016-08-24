:: Version: 20160529
:: Author: George Birbilis (http://zoomicon.com)

@echo off
call :process > update_cxml.log
goto :EOF

:process
ECHO ---- Deleting old DeepZoom assets
rd /s/q ..\collection\films_deepzoom

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

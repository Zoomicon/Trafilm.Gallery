:: Version: 20160525
:: Author: George Birbilis <birbilis@kagi.com>

@echo off
call :process > update_cxml.log
goto :EOF

:process
ECHO ---- Updating collection and DeepZoom assets
c:\programs\pauthor\pauthor.exe /source cxml L3occurrences.cxml /html-template template.html /target deepzoom ..\collection\L3occurrences.cxml && (goto OK) || (goto Fail)
goto :EOF

:OK
echo OK
::start http://gallery.clipflair.net/L3occurrences
goto :EOF

:Fail
echo FAILED
goto :EOF

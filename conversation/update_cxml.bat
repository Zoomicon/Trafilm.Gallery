:: Version: 20160529
:: Author: George Birbilis (http://zoomicon.com)

@echo off
call :process > update_cxml.log
goto :EOF

:process
ECHO ---- Deleting old DeepZoom assets
rd /s/q ..\collection\conversations_deepzoom

ECHO ---- Updating collection and DeepZoom assets
c:\programs\pauthor\pauthor.exe /source cxml conversations.cxml /html-template template.html /target deepzoom ..\collection\conversations.cxml && (goto OK) || (goto Fail)
goto :EOF

:OK
echo OK
::start http://gallery.clipflair.net/conversations
goto :EOF

:Fail
echo FAILED
goto :EOF

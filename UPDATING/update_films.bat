:: Version: 20161213
:: Author: George Birbilis (http://zoomicon.com)

@echo off
call :process 2>&1 > update_films.log
goto :EOF

:process
setlocal
set PAUTHOR=c:\programs\pauthor\pauthor.exe
set SOURCE=film
set COLLECTION=films

ECHO ---- Deleting old temp folder (in case it exists from previous failed attempt)
rd /s/q ..\collection\%COLLECTION%_TMP 2>&1

ECHO ---- Generating collection and DeepZoom assets at temp folder
cd ..\%SOURCE%
%PAUTHOR% /source cxml %COLLECTION%.cxml /html-template template.html /target deepzoom ..\collection\%COLLECTION%_TMP\%COLLECTION%.cxml && (goto OK) || (goto Fail)

:: control flow should never reach this, but manually terminating (jumping to implicit end-of-file marker) just in case
goto :EOF

:OK
ECHO ---- Deleting old DeepZoom assets (to release from IIS)
rd /s/q ..\collection\%COLLECTION%_deepzoom 2>&1

ECHO --- Copying DeepZoom assets from temp folder, merging (overwriting already existing old ones)
move /Y ..\collection\%COLLECTION%_TMP\%COLLECTION%_deepzoom ..\collection 2>&1

ECHO --- Copying CXML file from temp folder, overwriting old one
move /Y ..\collection\%COLLECTION%_TMP\%COLLECTION%.cxml ..\collection 2>&1

ECHO --- Removing empty temp folder
:: not using /s/q parameters to see if indeed all contents were moved from the temp folder succesfully
rd ..\collection\%COLLECTION%_tmp 2>&1

echo OK
::start http://gallery.trafilm.net/
goto :EOF

:Fail
:: not deleting temp folder (will delete at next run) that remained for easier troubleshooting of failed attempt
echo FAILED
goto :EOF

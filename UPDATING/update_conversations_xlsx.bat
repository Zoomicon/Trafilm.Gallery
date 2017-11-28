:: Version: 20171128
:: Author: George Birbilis (http://zoomicon.com)

@echo off
call :process 2>&1 > logs\update_conversations_xlsx.log
goto :EOF


:process
setlocal
set PAUTHOR=c:\programs\pauthor\pauthor.exe
set SOURCE=conversation
set COLLECTION=%SOURCE%s

ECHO ---- Deleting old temp folder (in case it exists from previous failed attempt)
rd /s/q ..\TMP\%COLLECTION%_XLSX 2>&1
ECHO.

ECHO ---- Generating .xlsx file for collection at temp folder
cd ..\%SOURCE%
%PAUTHOR% /source cxml %COLLECTION%.cxml /target excel ..\TMP\%COLLECTION%_XLSX\%COLLECTION%.xlsx && (goto OK) || (goto Fail)

:: control flow should never reach this, but manually terminating (jumping to implicit end-of-file marker) just in case
goto :EOF

:OK
ECHO.
ECHO ---- Deleting old images (to release from IIS)
rd /s/q ..\collection\%COLLECTION%_images 2>&1
ECHO.

ECHO --- Copying images from temp folder
move /Y ..\TMP\%COLLECTION%_XLSX\%COLLECTION%_images ..\collection 2>&1
ECHO.

ECHO --- Copying XLSX file from temp folder, overwriting old one
move /Y ..\TMP\%COLLECTION%_XLSX\%COLLECTION%.xlsx ..\collection 2>&1
ECHO.

ECHO --- Removing temp folder if empty
:: not using /s/q parameters to see if indeed all contents were moved from the temp folder succesfully
rd ..\TMP\%COLLECTION%_XLSX 2>&1
ECHO.

echo OK
::start ..\collection\%COLLECTION%.xlsx
goto :EOF

:Fail
:: not deleting temp folder (will delete at next run) that remained for easier troubleshooting of failed attempt
echo FAILED
goto :EOF

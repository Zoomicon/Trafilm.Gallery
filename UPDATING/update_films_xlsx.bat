:: Version: 20171127
:: Author: George Birbilis (http://zoomicon.com)

@echo off
call :process 2>&1 > update_films_xlsx.log
goto :EOF


:process
setlocal
set PAUTHOR=c:\programs\pauthor\pauthor.exe
set SOURCE=film
set COLLECTION=films

ECHO ---- Deleting old temp .xlsx file and images (in case we had failed to remove those)
del ..\collection\%COLLECTION%_TMP.xlsx
rd /s/q ..\collection\%COLLECTION%_TMP_images
ECHO.

ECHO ---- Generating .xlsx file for collection
cd ..\%SOURCE%
%PAUTHOR% /source cxml %COLLECTION%.cxml /target excel ..\collection\%COLLECTION%_TMP.xlsx && (goto OK) || (goto Fail)
goto :EOF

:OK
echo OK
move /Y ..\collection\%COLLECTION%_TMP.xlsx ..\collection\%COLLECTION%.xlsx
move /Y ..\collection\%COLLECTION%_TMP_images ..\collection\%COLLECTION%_images
::start ..\collection\%COLLECTION%.xlsx
goto :EOF

:Fail
:: not deleting temp files/folder (will delete at next run) that remained for easier troubleshooting of failed attempt
echo FAILED
goto :EOF

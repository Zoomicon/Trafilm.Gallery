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

ECHO ---- Deleting old temp .xlsx file (in case we had failed to remove it)
del ..\collection\%COLLECTION%_TMP.xlsx
ECHO.

ECHO ---- Generating .xlsx file for collection
cd ..\%SOURCE%
%PAUTHOR% /source cxml %COLLECTION%.cxml /target excel ..\collection\%COLLECTION%_TMP.xlsx && (goto OK) || (goto Fail)
goto :EOF

:OK
echo OK
move /Y ..\collection\%COLLECTION%_TMP.xlsx ..\collection\%COLLECTION%.xlsx
::start ..\collection\%COLLECTION%.xlsx
goto :EOF

:Fail
del ..\collection\%COLLECTION%_TMP.xlsx
echo FAILED
goto :EOF

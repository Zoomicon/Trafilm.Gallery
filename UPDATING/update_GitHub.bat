:: Version: 20161215
:: Author: George Birbilis (http://zoomicon.com)

@echo off
call :process 2>&1 > update_GitHub.log
goto :EOF

:process

ECHO ---- Staging changes for addition to local repository
git add . 2>&1 || (goto Fail)
ECHO:

ECHO ---- Commiting staged changes to local repository
git commit -m "Metadata updates (auto commit)" 2>&1 || (goto Fail)
ECHO:

ECHO ---- Pushing commited changes to remote repository
git push origin master 2>&1 || (goto Fail)
ECHO:

:OK
ECHO OK
goto :EOF

:Fail
ECHO FAILED
goto :EOF

@echo off
setlocal
cd /d "%~dp0.."

echo Gate 1 — modernization verification
echo ===================================

if "%LAKE_UPDATE%"=="1" call lake update || exit /b 1
call lake build Uprove || exit /b 1
call lake build UproveExamples || exit /b 1
call lake test || exit /b 1
call lake exe uprove-test-simple || exit /b 1
call lake exe uprove-test-real || exit /b 1

echo.
echo Gate 1 passed.
exit /b 0

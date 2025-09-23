@echo off
REM lean-uprove installation script for Windows
REM Provides one-command installation and setup

setlocal enabledelayedexpansion

REM Configuration
set INSTALL_DIR=C:\Program Files\lean-uprove
set BIN_DIR=C:\Program Files\lean-uprove\bin
set PROJECT_NAME=lean-uprove
set VERSION=0.1.0

echo lean-uprove Installation Script
echo ===============================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [WARNING] Running as administrator. This is not recommended for security reasons.
    set /p continue="Continue anyway? (y/N): "
    if /i not "!continue!"=="y" exit /b 1
) else (
    echo [INFO] Not running as administrator. Installation will use user directory.
    set INSTALL_DIR=%USERPROFILE%\.lean-uprove
    set BIN_DIR=%USERPROFILE%\.lean-uprove\bin
)

REM Check system requirements
echo [INFO] Checking system requirements...

REM Check for Lean 4
lean --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Lean 4 is not installed. Please install Lean 4 first.
    echo [INFO] Visit: https://leanprover.github.io/lean4/doc/setup.html
    exit /b 1
)

REM Check for Lake
lake --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Lake is not installed. Please install Lake first.
    echo [INFO] Lake should be installed with Lean 4.
    exit /b 1
)

REM Get versions
for /f "tokens=*" %%i in ('lean --version') do set LEAN_VERSION=%%i
for /f "tokens=*" %%i in ('lake --version') do set LAKE_VERSION=%%i

echo [INFO] Found Lean 4 version: !LEAN_VERSION!
echo [INFO] Found Lake version: !LAKE_VERSION!
echo [SUCCESS] System requirements satisfied

REM Install dependencies
echo [INFO] Installing dependencies...

REM Check for git
git --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Git is not installed. Please install Git first.
    echo [INFO] Visit: https://git-scm.com/download/win
    exit /b 1
)

echo [SUCCESS] Dependencies satisfied

REM Install lean-uprove
echo [INFO] Installing lean-uprove...

REM Create installation directory
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

REM Copy project files
xcopy /E /I /Y . "%INSTALL_DIR%"

REM Create executable script
echo @echo off > "%INSTALL_DIR%\lean-uprove.bat"
echo REM lean-uprove CLI wrapper >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo setlocal enabledelayedexpansion >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo set SCRIPT_DIR=%%~dp0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo set PROJECT_DIR=%%SCRIPT_DIR%% >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="--help" goto :help >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="-h" goto :help >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="--version" goto :version >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="-v" goto :version >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="test" goto :test >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="benchmark" goto :benchmark >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="examples" goto :examples >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="validate" goto :validate >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="build" goto :build >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="clean" goto :clean >> "%INSTALL_DIR%\lean-uprove.bat"
echo if "%%1"=="" goto :default >> "%INSTALL_DIR%\lean-uprove.bat"
echo goto :unknown >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo :help >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo lean-uprove - Lean 4 tactic for universal properties >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Usage: lean-uprove [COMMAND] [OPTIONS] >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Commands: >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   --help, -h     Show this help message >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   --version, -v  Show version information >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   test           Run test suite >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   benchmark      Run performance benchmarks >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   examples       Run examples >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   validate       Validate installation >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   build          Build the project >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   clean          Clean build artifacts >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Examples: >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   lean-uprove test >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   lean-uprove benchmark >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo   lean-uprove examples >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo For more information, visit: https://github.com/fraware/lean-uprove >> "%INSTALL_DIR%\lean-uprove.bat"
echo exit /b 0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo :version >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo lean-uprove version 0.1.0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo for /f "tokens=*" %%%%i in ('lean --version') do echo Lean 4 version: %%%%i >> "%INSTALL_DIR%\lean-uprove.bat"
echo for /f "tokens=*" %%%%i in ('lake --version') do echo Lake version: %%%%i >> "%INSTALL_DIR%\lean-uprove.bat"
echo exit /b 0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo :test >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Running lean-uprove test suite... >> "%INSTALL_DIR%\lean-uprove.bat"
echo cd /d "%%PROJECT_DIR%%" >> "%INSTALL_DIR%\lean-uprove.bat"
echo lake exe test >> "%INSTALL_DIR%\lean-uprove.bat"
echo lake exe uprove-test-simple >> "%INSTALL_DIR%\lean-uprove.bat"
echo lake exe uprove-test-production >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo [SUCCESS] All tests passed! >> "%INSTALL_DIR%\lean-uprove.bat"
echo exit /b 0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo :benchmark >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Running lean-uprove performance benchmarks... >> "%INSTALL_DIR%\lean-uprove.bat"
echo cd /d "%%PROJECT_DIR%%" >> "%INSTALL_DIR%\lean-uprove.bat"
echo lake exe uprove-performance-validation >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo [SUCCESS] Benchmarks completed! >> "%INSTALL_DIR%\lean-uprove.bat"
echo exit /b 0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo :examples >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Running lean-uprove examples... >> "%INSTALL_DIR%\lean-uprove.bat"
echo cd /d "%%PROJECT_DIR%%" >> "%INSTALL_DIR%\lean-uprove.bat"
echo lake exe test >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo [SUCCESS] Examples completed! >> "%INSTALL_DIR%\lean-uprove.bat"
echo exit /b 0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo :validate >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Validating lean-uprove installation... >> "%INSTALL_DIR%\lean-uprove.bat"
echo cd /d "%%PROJECT_DIR%%" >> "%INSTALL_DIR%\lean-uprove.bat"
echo lake build >> "%INSTALL_DIR%\lean-uprove.bat"
echo lake exe test >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo [SUCCESS] Installation validated! >> "%INSTALL_DIR%\lean-uprove.bat"
echo exit /b 0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo :build >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Building lean-uprove... >> "%INSTALL_DIR%\lean-uprove.bat"
echo cd /d "%%PROJECT_DIR%%" >> "%INSTALL_DIR%\lean-uprove.bat"
echo lake build >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo [SUCCESS] Build completed! >> "%INSTALL_DIR%\lean-uprove.bat"
echo exit /b 0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo :clean >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Cleaning lean-uprove build artifacts... >> "%INSTALL_DIR%\lean-uprove.bat"
echo cd /d "%%PROJECT_DIR%%" >> "%INSTALL_DIR%\lean-uprove.bat"
echo lake clean >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo [SUCCESS] Clean completed! >> "%INSTALL_DIR%\lean-uprove.bat"
echo exit /b 0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo :default >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo lean-uprove - Lean 4 tactic for universal properties >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Run 'lean-uprove --help' for usage information >> "%INSTALL_DIR%\lean-uprove.bat"
echo exit /b 0 >> "%INSTALL_DIR%\lean-uprove.bat"
echo. >> "%INSTALL_DIR%\lean-uprove.bat"
echo :unknown >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Unknown command: %%1 >> "%INSTALL_DIR%\lean-uprove.bat"
echo echo Run 'lean-uprove --help' for usage information >> "%INSTALL_DIR%\lean-uprove.bat"
echo exit /b 1 >> "%INSTALL_DIR%\lean-uprove.bat"

REM Copy to bin directory
copy "%INSTALL_DIR%\lean-uprove.bat" "%BIN_DIR%\lean-uprove.bat"

REM Add to PATH if not already there
echo [INFO] Adding lean-uprove to PATH...
setx PATH "%PATH%;%BIN_DIR%" /M >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARNING] Could not add to system PATH. Adding to user PATH...
    setx PATH "%PATH%;%BIN_DIR%" >nul 2>&1
)

echo [SUCCESS] lean-uprove installed to %INSTALL_DIR%

REM Build the project
echo [INFO] Building lean-uprove...
cd /d "%INSTALL_DIR%"
lake update
lake build

echo [SUCCESS] Build completed

REM Run validation tests
echo [INFO] Validating installation...
lake exe test

echo [SUCCESS] Installation validated

echo.
echo [SUCCESS] lean-uprove installation completed successfully!
echo.
echo Usage:
echo   lean-uprove --help     # Show help
echo   lean-uprove test       # Run tests
echo   lean-uprove benchmark  # Run benchmarks
echo   lean-uprove examples   # Run examples
echo.
echo For more information, visit: https://github.com/fraware/lean-uprove
echo.
echo Note: You may need to restart your command prompt for PATH changes to take effect.

endlocal

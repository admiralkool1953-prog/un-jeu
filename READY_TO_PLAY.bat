@echo off
REM ============================================
REM   READY TO PLAY CHECK
REM ============================================

setlocal enabledelayedexpansion

cls
echo.
echo ╔════════════════════════════════════════════╗
echo ║     REACTION TIME - READY TO PLAY CHECK    ║
echo ╚════════════════════════════════════════════╝
echo.

REM Quick check 1: simulation.py exists
if not exist "simulation.py" (
    echo [ERROR] simulation.py not found
    echo Please make sure you're in the correct directory
    echo.
    pause
    exit /b 1
)

REM Quick check 2: Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found
    echo Install from: https://python.org
    echo.
    pause
    exit /b 1
)

REM Quick check 3: Python syntax is valid
echo Checking Python syntax...
python -m py_compile simulation.py 2>nul
if errorlevel 1 (
    echo [ERROR] Python syntax error
    echo.
    pause
    exit /b 1
)

REM All checks passed
cls
echo.
echo ╔════════════════════════════════════════════╗
echo ║  ✅ ALL SYSTEMS GO - READY TO PLAY! ✅    ║
echo ╚════════════════════════════════════════════╝
echo.
echo Everything is set up correctly.
echo.
echo Next step: Run PLAY.bat to start the game
echo.
pause

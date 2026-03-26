@echo off
REM ============================================
REM   REACTION TIME - LAUNCHER ULTRA-SIMPLE
REM ============================================
REM   UN CLIC = UN JEU
REM ============================================

title REACTION TIME - GAME

REM Vérifiez que le fichier Python existe
if not exist "simulation.py" (
    echo.
    echo ERROR: simulation.py not found
    echo Please check you have the file in the same directory
    echo.
    pause
    exit /b 1
)

REM Vérifiez que Python est installé
python --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Python not installed or not in PATH
    echo.
    echo Install Python from: https://python.org
    echo Make sure to check "Add Python to PATH"
    echo.
    pause
    exit /b 1
)

REM Lancez le jeu
echo.
echo ========================================
echo     REACTION TIME - Ready to play!
echo ========================================
echo.
echo Starting game...
echo.

python simulation.py

REM Si on arrive ici, le jeu s'est fermé
echo.
echo Game closed. Have fun next time!
echo.
pause

@echo off
REM ============================================
REM   VERIFICATION FINALE - TOUS LES FICHIERS
REM ============================================

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   VERIFICATION FINALE DU PROJET
echo ========================================
echo.

set count=0
set missing=0

REM Liste des fichiers requis
set files[0]=PLAY.bat
set files[1]=START.bat
set files[2]=simulation.py
set files[3]=reaction_time.c
set files[4]=Makefile
set files[5]=compile.bat
set files[6]=test.py
set files[7]=README_SIMPLE.md
set files[8]=GUIDE_FINAL.md
set files[9]=PARTAGE.md
set files[10]=START_HERE.md
set files[11]=00_CHECKLIST.md
set files[12]=README.txt
set files[13]=README.md
set files[14]=INDEX.md
set files[15]=STRUCTURE_PROJET.md
set files[16]=DOCUMENTATION_TECHNIQUE.md
set files[17]=RAYLIB_INSTALLATION.md
set files[18]=DEMARRAGE_RAPIDE.md
set files[19]=DEMO_VISUELLE.md
set files[20]=RESUME_PROJET.md
set files[21]=SOMMAIRE.md
set files[22]=AFFICHAGE_EN_ACTION.md

REM Vérifier chaque fichier
for /L %%i in (0,1,22) do (
    set file=!files[%%i]!
    if exist "!file!" (
        echo [OK] !file!
        set /a count+=1
    ) else (
        echo [MISSING] !file!
        set /a missing+=1
    )
)

echo.
echo ========================================
echo   RÉSUMÉ
echo ========================================
echo.
echo Fichiers trouvés : %count%/23
echo Fichiers manquants : %missing%

if %missing% gtr 0 (
    echo.
    echo STATUS : ⚠️  INCOMPLET
) else (
    echo.
    echo STATUS : ✅ COMPLET!
)

echo.
echo ========================================
echo   VÉRIFICATIONS SUPPLÉMENTAIRES
echo ========================================
echo.

REM Vérifier Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Python not found in PATH
    echo → Install from https://python.org
) else (
    for /f "tokens=*" %%A in ('python --version') do (
        echo [OK] Python: %%A
    )
)

echo.

REM Tester le fichier Python
if exist "simulation.py" (
    REM Vérifier si le fichier est valide Python
    python -m py_compile simulation.py 2>nul
    if errorlevel 1 (
        echo [ERROR] simulation.py has syntax errors
    ) else (
        echo [OK] simulation.py: Valid Python syntax
    )
) else (
    echo [ERROR] simulation.py not found
)

echo.
echo ========================================
echo   PRÊT À JOUER?
echo ========================================
echo.

if %missing% equ 0 (
    echo YES! Everything is ready!
    echo.
    echo Next step: Double-click PLAY.bat
    echo.
) else (
    echo NO. Some files are missing.
    echo.
    echo Please check:
    echo - All files have been created
    echo - Files are not in subdirectories
    echo.
)

echo.
pause

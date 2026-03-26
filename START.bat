@echo off
REM =====================================================
REM REACTION TIME - LAUNCHER SIMPLE
REM =====================================================

echo.
echo ========================================
echo  REACTION TIME - JEU DE TEMPS DE REACTION
echo ========================================
echo.
echo Choisissez une option :
echo.
echo 1 - Jouer EN PYTHON (Rapide, aucun setup)
echo 2 - Compiler en C/Raylib (Graphique beau)
echo 3 - Instructions
echo 4 - Quitter
echo.

set /p choice="Votre choix (1-4) : "

if "%choice%"=="1" goto python
if "%choice%"=="2" goto compile
if "%choice%"=="3" goto help
if "%choice%"=="4" goto end

:python
echo.
echo Demarrage du jeu Python...
echo.
python simulation.py
goto end

:compile
echo.
echo Compilation du code C...
echo.
echo NOTE: Vous avez besoin de Raylib installe
echo Pour installer Raylib, voir RAYLIB_INSTALLATION.md
echo.
gcc -Wall -Wextra -std=c99 -O2 -I./raylib/include -c reaction_time.c
if errorlevel 1 (
    echo.
    echo [ERREUR] La compilation du fichier objet a echoue
    echo.
    echo Solutions :
    echo - Verifiez que raylib.h est dans raylib/include/
    echo - Verifiez que GCC/MinGW est installe
    echo - Consultez RAYLIB_INSTALLATION.md
    echo.
    pause
    goto end
)

gcc reaction_time.o -o reaction_time.exe -L./raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm
if errorlevel 1 (
    echo.
    echo [ERREUR] La liaison a echoue
    echo.
    echo Solutions :
    echo - Verifiez que raylib.a est dans raylib/lib/
    echo - Verifiez les permissions sur les fichiers
    echo.
    pause
    goto end
)

echo.
echo [+] Compilation reussie !
echo [+] Executable cree : reaction_time.exe
echo.

set /p launch="Voulez-vous lancer le jeu maintenant ? (o/n) : "
if /i "%launch%"=="o" (
    reaction_time.exe
)
goto end

:help
echo.
echo ========================================
echo INSTRUCTIONS
echo ========================================
echo.
echo OPTION 1 - PYTHON (Recommande)
echo ────────────────────
echo  * Aucune installation requise
echo  * Lancez simplement : python simulation.py
echo  * Le jeu s'affiche en terminal
echo  * Parfait pour jouer maintenant !
echo.
echo OPTION 2 - C/RAYLIB (Graphique)
echo ─────────────────────
echo  * Necessite Raylib installe
echo  * Crée un exe graphique (.exe)
echo  * Plus beau mais plus complexe
echo  * Voir RAYLIB_INSTALLATION.md
echo.
echo PARTAGE
echo ───────
echo  * Envoyez simulation.py pour version Python
echo  * Compilez et envoyez reaction_time.exe pour version graphique
echo  * Consultez GUIDE_FINAL.md pour plus de details
echo.
echo ========================================
echo.
pause
goto Start

:end

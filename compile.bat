@echo off
REM =====================================================
REM SCRIPT DE COMPILATION - REACTION TIME EN C
REM =====================================================
REM
REM Ce script compile et exécute le jeu sur Windows
REM Assurez-vous que MinGW et Raylib sont installés
REM
REM Utilisation : compile.bat [option]
REM  compile.bat          -> Compile et exécute
REM  compile.bat rebuild  -> Nettoie et recompile
REM  compile.bat clean    -> Supprime les fichiers objets

setlocal enabledelayedexpansion

REM Couleurs et texte
color 0A
title Compilation - Reaction Time

echo.
echo =====================================================
echo   JEU "REACTION TIME" - COMPILATION WINDOWS
echo =====================================================
echo.

REM Vérifier les arguments
if "%1"=="clean" goto clean
if "%1"=="rebuild" goto rebuild
goto compile

:clean
echo [*] Suppression des fichiers compiles...
if exist reaction_time.o del reaction_time.o
if exist reaction_time.exe del reaction_time.exe
echo [+] Nettoyage termine !
echo.
exit /b 0

:rebuild
echo [*] Recompilation complete...
call :clean
goto compile

:compile
echo [*] Verification des fichiers Raylib...

if not exist "raylib\include\raylib.h" (
    echo [!] ERREUR : raylib.h non trouve !
    echo.
    echo Les fichiers Raylib doivent etre places ici :
    echo - raylib\include\raylib.h
    echo - raylib\lib\raylib.a
    echo.
    echo Telechargez Raylib : https://github.com/raysan5/raylib/releases
    echo.
    pause
    exit /b 1
)

if not exist "raylib\lib\raylib.a" (
    echo [!] ERREUR : raylib.a non trouve !
    echo.
    echo Les fichiers Raylib doivent etre places ici :
    echo - raylib\include\raylib.h
    echo - raylib\lib\raylib.a
    echo.
    pause
    exit /b 1
)

echo [+] Fichiers Raylib trouves !
echo.

REM Compilation
echo [*] Compilation en cours...
gcc -Wall -Wextra -std=c99 -O2 -I./raylib/include -c reaction_time.c

if errorlevel 1 (
    echo [!] ERREUR DE COMPILATION !
    echo.
    echo Verifiez que :
    echo - GCC (MinGW) est installe
    echo - Le fichier reaction_time.c existe
    echo - Les chemins vers Raylib sont corrects
    echo.
    pause
    exit /b 1
)

echo [+] Fichier objet cree : reaction_time.o
echo.

REM Liaison
echo [*] Liaison en cours...
gcc reaction_time.o -o reaction_time.exe -L./raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm

if errorlevel 1 (
    echo [!] ERREUR DE LIAISON !
    echo.
    echo Verifiez que :
    echo - raylib.a est dans raylib\lib\
    echo - Les bibliotheques OpenGL et GDI32 sont disponibles
    echo.
    pause
    exit /b 1
)

echo [+] Exe cree : reaction_time.exe
echo.
echo =====================================================
echo   COMPILATION REUSSIE !
echo =====================================================
echo.

REM Demander si on exécute le jeu
set /p run="Voulez-vous lancer le jeu maintenant ? (o/n) : "
if /i "%run%"=="o" (
    echo.
    echo [*] Demarrage du jeu...
    echo.
    reaction_time.exe
    if errorlevel 1 (
        echo.
        echo [!] Erreur lors de l'execution du jeu
        pause
        exit /b 1
    )
    echo.
    echo [+] Jeu ferme avec succes
) else (
    echo.
    echo [+] Vous pouvez lancer le jeu en double-cliquant : reaction_time.exe
)

echo.
pause
exit /b 0

# =====================================================
# MAKEFILE - COMPILATION DU JEU REACTION TIME EN C
# =====================================================
#
# À utiliser avec MinGW sur Windows
#
# Commandes :
#   make          -> Compile le projet
#   make run      -> Compile et exécute le jeu
#   make clean    -> Supprime les fichiers objets et exécutables
#   make rebuild  -> Nettoie et recompile

# Variables de compilation
CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -O2
LFLAGS = -lraylib -lopengl32 -lgdi32 -lwinmm

# Noms des fichiers
TARGET = reaction_time.exe
SOURCE = reaction_time.c
OBJECT = reaction_time.o

# Dossiers Raylib (à adapter selon votre installation)
# Pour Windows avec MinGW, Raylib est généralement dans :
# - C:\raylib\raylib\src (headers)
# - C:\raylib\raylib\build\lib (libraries)
RAYLIB_INC = -I./raylib/include
RAYLIB_LIB = -L./raylib/lib

# Cibles
all: $(TARGET)

$(TARGET): $(OBJECT)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJECT) $(RAYLIB_LIB) $(LFLAGS)
	@echo "✓ Compilation terminée ! Exécutable : $(TARGET)"

$(OBJECT): $(SOURCE)
	$(CC) $(CFLAGS) $(RAYLIB_INC) -c $(SOURCE) -o $(OBJECT)
	@echo "✓ Fichier objet créé : $(OBJECT)"

run: $(TARGET)
	./$(TARGET)
	@echo "✓ Jeu fermé"

clean:
	@if exist $(OBJECT) del $(OBJECT)
	@if exist $(TARGET) del $(TARGET)
	@echo "✓ Nettoyage terminé"

rebuild: clean all
	@echo "✓ Recompilation terminée"

.PHONY: all run clean rebuild

# =====================================================
# NOTES D'INSTALLATION DE RAYLIB
# =====================================================
#
# 1. Télécharger Raylib : https://github.com/raysan5/raylib/releases
#
# 2. Extraire l'archive dans C:\raylib\
#
# 3. Copier les fichiers :
#    - De : C:\raylib\raylib\src\raylib.h
#      Vers: ./raylib/include/raylib.h
#    
#    - De : C:\raylib\raylib\build\lib\raylib.a
#      Vers: ./raylib/lib/raylib.a
#
# 4. Utiliser 'make' ou 'make rebuild' pour compiler
#
# Alternative : Compilation manuelle
# gcc -Wall -Wextra -std=c99 -O2 -I./raylib/include -c reaction_time.c
# gcc reaction_time.o -o reaction_time.exe -L./raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm

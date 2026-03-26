# 📦 GUIDE D'INSTALLATION DE RAYLIB POUR WINDOWS

Ce fichier fournit des instructions détaillées pour installer Raylib et compiler le jeu.

## ⚡ Installation Rapide (5 minutes)

### Option 1 : Utiliser une librairie précompilée (RECOMMANDÉ)

#### Étape 1 : Télécharger Raylib

1. Aller sur : https://github.com/raysan5/raylib/releases
2. Télécharger `raylib-4.5.0_win64_mingw-w64.zip` (ou version plus récente)
3. Extraire l'archive quelque part

#### Étape 2 : Préparer les fichiers

1. Créer un dossier `raylib` dans le même répertoire que `reaction_time.c`
2. À l'intérieur, créer deux sous-dossiers : `include` et `lib`

```
mini projet c/
├── reaction_time.c
├── Makefile
└── raylib/
    ├── include/
    └── lib/
```

#### Étape 3 : Copier les fichiers

Depuis l'archive Raylib téléchargée :

1. **Fichier header** :
   - De : `raylib-4.5.0/include/raylib.h`
   - Vers : `raylib/include/raylib.h`

2. **Fichier library** :
   - De : `raylib-4.5.0/lib/gcc/libraylib.a`
   - Vers : `raylib/lib/raylib.a`

> **Important** : S'assurer qu'il existe des fichiers dans le dossier raylib/include/ et raylib/lib/

### Option 2 : Compiler Raylib depuis les sources

#### Prérequis

- CMake (https://cmake.org/)
- MinGW (gcc compiler)

#### Étapes

```bash
# 1. Cloner le repository
git clone https://github.com/raysan5/raylib.git
cd raylib/src

# 2. Compiler
gcc -O1 -Wall -std=c99 -Wno-missing-braces -D_DEFAULT_SOURCE ...
[longue commande de compilation - voir le site Raylib]

# 3. Copier les fichiers résultants
```

> Pour plus de détails : https://github.com/raysan5/raylib/wiki/

## 🔧 Compilation du Jeu

### Avec le script batch (PLUS FACILE)

```bash
compile.bat
```

Le script :
- Vérifie la présence des fichiers Raylib
- Compile automatiquement
- Lance le jeu si demandé

### Avec Make

```bash
mingw32-make rebuild
mingw32-make run
```

### Compilation manuelle

```bash
# Compilation
gcc -Wall -Wextra -std=c99 -O2 -I./raylib/include -c reaction_time.c

# Liaison (linking)
gcc reaction_time.o -o reaction_time.exe ^
    -L./raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm

# Exécution
reaction_time.exe
```

## ✅ Vérification de l'Installation

### Tester Raylib

Créer un fichier `test.c` :

```c
#include <raylib.h>

int main() {
    InitWindow(800, 450, "Test Raylib");
    
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(DARKBLUE);
        DrawText("Raylib fonctionne !", 190, 200, 20, LIGHTGRAY);
        EndDrawing();
    }
    
    CloseWindow();
    return 0;
}
```

Compiler :

```bash
gcc -I./raylib/include -c test.c
gcc test.o -o test.exe -L./raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm
test.exe
```

Si une fenêtre bleue apparaît avec le texte, Raylib fonctionne ! ✓

## 🆘 Résolution des Problèmes

### Erreur : "raylib.h: No such file or directory"

**Cause** : Le fichier raylib.h n'est pas trouvé

**Solutions** :
1. Vérifier que `raylib/include/raylib.h` existe
2. Vérifier le chemin dans le Makefile
3. Vérifier les droits d'accès aux fichiers

### Erreur : "raylib.a: No such file or directory"

**Cause** : La librairie compilée n'est pas trouvée

**Solutions** :
1. Vérifier que `raylib/lib/raylib.a` existe
2. S'assurer que le fichier n'est pas vide (> 100 KB)
3. Recompiler Raylib depuis les sources

### Erreur : "lraylib: cannot find -lraylib"

**Cause** : Le fichier raylib.a n'est pas reconnu

**Solutions** :
1. Vérifier que le fichier existe et est valide
2. Utiliser le chemin complet dans la commande de linking
3. Essayer une version précompilée différente

### Le jeu se lance mais l'affichage est noir

**Cause** : Raylib ne trouve pas les librairies OpenGL

**Solutions** :
1. Vérifier que OpenGL 3.3+ est supporté par la carte graphique
2. Mettre à jour les drivers de la carte graphique
3. Essayer sur un autre ordinateur

### Le jeu lagge ou a des performances faibles

**Solutions** :
1. Réduire la résolution (SCREEN_WIDTH/SCREEN_HEIGHT)
2. Réduire les effets visuels
3. Utiliser `-O3` au lieu de `-O2` pour une compilation optimisée

## 📊 Structure des Fichiers Raylib

```
rasplib/
├── include/
│   ├── raylib.h          👈 À copier
│   ├── raylibs.h
│   ├── rlgl.h
│   ├── rmath.h
│   ├── physac.h
│   └── raudio.h
└── lib/
    └── gcc/
        └── libraylib.a   👈 À renommer en raylib.a
```

## 🎯 Vérifier la Configuration

Exécuter cette commande pour voir les informations de compilation :

```bash
gcc --version
```

Résultat attendu :
```
gcc (MinGW.org GCC-6.3.0-1) 6.3.0
```

## 💡 Conseils

- ✅ Utiliser une version récente de MinGW (8.0+)
- ✅ S'assurer que les fichiers Raylib sont accessibles
- ✅ Compiler avec `-O2` pour une bonne optimisation
- ✅ Tester l'installation avec un exemple simple

## 📚 Ressources

- **Site officiel Raylib** : https://www.raylib.com/
- **Télécharger Raylib** : https://github.com/raysan5/raylib/releases
- **Documentation** : https://raylib.com/cheatsheet/cheatsheet.html
- **Exemples** : https://github.com/raysan5/raylib/tree/master/examples
- **Wiki** : https://github.com/raysan5/raylib/wiki

## 🔗 Liens Utiles

- MinGW : https://www.mingw-w64.org/
- CMake : https://cmake.org/
- GCC Documentation : https://gcc.gnu.org/
- OpenGL : https://www.opengl.org/

---

**Une fois Raylib installé, vous pouvez compiler et jouer à Reaction Time !** 🎮

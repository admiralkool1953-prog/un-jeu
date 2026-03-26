# ⚡ DÉMARRAGE RAPIDE - 5 MINUTES

Vous venez juste de recevoir le projet ? Voici comment le démarrer en 5 minutes !

## 1️⃣ Option la Plus Rapide : Tester d'Abord (2 min)

Pas envie de compiler ? Testez la simulation Python d'abord !

```bash
cd "mini projet c"
python simulation.py
```

**Résultat** : Vous verrez le jeu en ligne de commande ! No compilation needed. ✨

---

## 2️⃣ Compilation Complète avec Raylib (5 min)

### Étape 1 : Installer Raylib (3 min)

1. Télécharger : https://github.com/raysan5/raylib/releases
2. Extraire l'archive
3. Copier les fichiers :
   ```
   raylib-{version}/include/raylib.h  →  raylib/include/raylib.h
   raylib-{version}/lib/gcc/libraylib.a → raylib/lib/raylib.a
   ```

### Étape 2 : Compiler le Jeu (1 min)

**Sur Windows** :
```bash
cd "c:\Users\HP\Desktop\mini projet c"
compile.bat
```

**Sur Linux/Mac** :
```bash
cd "mini projet c"
make rebuild
make run
```

**Manuel** :
```bash
gcc -Wall -Wextra -std=c99 -O2 -I./raylib/include -c reaction_time.c
gcc reaction_time.o -o reaction_time.exe -L./raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm
reaction_time.exe
```

### Étape 3 : Jouer !

Double-cliquez sur `reaction_time.exe` et amusez-vous ! 🎮

---

## 📂 Fichiers du Projet

| Fichier | Utilité | Priorité |
|---------|---------|----------|
| **reaction_time.c** | Code source C | 🔴 ESSENTIEL |
| **Makefile** | Compilation | 🔴 ESSENTIEL |
| **compile.bat** | Script Windows | 🟡 RECOMMANDÉ |
| **simulation.py** | Version Python | 🟡 RECOMMANDÉ |
| **README.md** | Documentation générale | 🟢 INFO |
| **RAYLIB_INSTALLATION.md** | Guide Raylib | 🟢 INFO |
| **DOCUMENTATION_TECHNIQUE.md** | Détails internes | 🟢 INFO |

---

## 🎮 Guide de Gameplay Express

```
1. Écran ROUGE : Attendez ⏳
2. Écran VERT : Appuyez VITE ⚡
3. Battez votre record ! 🏆
```

**Touches** :
- ESPACE : Réagir
- R : Restart
- Flèches : Changer niveau
- ESC : Quitter

---

## 🆘 Problèmes Courants

### ❌ "raylib.h: No such file"

**Solution** : Crér le dossier raylib avec les fichiers :
```
raylib/
├── include/
│   └── raylib.h
└── lib/
    └── raylib.a
```

### ❌ "gcc: command not found"

**Solution** : Installer MinGW :
https://www.mingw-w64.org/

### ❌ Rien ne s'affiche

**Solution** : Mettre à jour les drivers graphiques

---

## 📊 Résumé des Fichiers Créés

✅ **reaction_time.c** (650 lignes)
   - Logique complète du jeu
   - Affichage graphique Raylib
   - Gestion des états
   - Timing précis
   - Scoring et meilleur record

✅ **Makefile**
   - Compilation optimisée
   - Cibles : make, make run, make clean

✅ **compile.bat**
   - Script automatique pour Windows
   - Vérifications avant compilation
   - Lancement du jeu

✅ **simulation.py** (280 lignes)
   - Version Python du jeu
   - Fonctionne sans Raylib
   - Démontre la logique

✅ **Documentation** (4 fichiers)
   - README.md : Guide général
   - RAYLIB_INSTALLATION.md : Installation
   - DOCUMENTATION_TECHNIQUE.md : Architecture
   - STRUCTURE_PROJET.md : Vue d'ensemble
   - DEMO_VISUELLE.md : Affichages

---

## 🚀 Résumé du Projet

**Nom** : Reaction Time - Mini-Projet en C
**Type** : Jeu desktop interactif
**Langage** : C99
**Bibliothèque** : Raylib 4.0+
**Plateforme** : Windows / Linux / macOS
**Taille Code** : ~930 lignes au total
**Temps de développement** : Étudiant (2-4h)

---

## 🎯 Prochaines Étapes

1. Tester avec `simulation.py` ✅ (Rapide)
2. Installer Raylib ⬜ (Facile)
3. Compiler avec `compile.bat` ⬜ (Automatique)
4. Jouer et battre les records ! ⬜ (Amusant)
5. Lire la documentation technique ⬜ (Optionnel)
6. Ajouter des améliorations ⬜ (Avancé)

---

## 📚 Où Trouver Quoi

| Question | Réponse |
|----------|---------|
| Comment jouer ? | → DEMO_VISUELLE.md |
| Comment installer ? | → RAYLIB_INSTALLATION.md |
| Comment fonctionne le code ? | → DOCUMENTATION_TECHNIQUE.md |
| Quels fichiers utiliser ? | → STRUCTURE_PROJET.md |
| Comment compiler ? | → README.md |
| Besoin d'aide ? | → Ce fichier ! |

---

## ✨ Fonctionnalités Complètes

✅ Affichage graphique Raylib
✅ États du jeu (WAITING, READY, RESULT, TOO_EARLY)
✅ Timing précis et délai aléatoire
✅ Meilleur score (pendant l'exécution)
✅ Nombre de tentatives
✅ Niveaux progressifs (Facile → Moyen → Difficile)
✅ Évaluation de performance
✅ Animation pulsante pour le chrono
✅ Interface propre et centrée
✅ Code commenté et modulaire

---

## 🎁 Bonus

- Version simulation Python (pour debug)
- Script batch automatique (Windows)
- Makefile pour compilation (Unix/Linux)
- Documentation technique complète
- Démonstration visuelle
- Guide d'installation Raylib

---

## 🏁 C'EST TOUT !

Vous êtes prêt à :
1. Compiler ✅
2. Jouer ✅
3. Modifier ✅
4. Améliorer ✅

**Bonne chance et amusez-vous ! 🎮🏆**

---

### 📞 Support Rapide

**Si vous êtes bloqué** :
1. Relisez ce fichier
2. Vérifiez RAYLIB_INSTALLATION.md
3. Testez simulation.py d'abord
4. Consultez README.md

**Vous êtes un expert ?**
1. Lisez DOCUMENTATION_TECHNIQUE.md
2. Explorez le code source
3. Ajoutez vos améliorations
4. Amusez-vous ! 🚀

---

*Version : 1.0 - Créé le 22 Mars 2026 - Projet Étudiant en C*

# 🎮 JEU "REACTION TIME" - MINI-PROJET EN C AVEC RAYLIB

## 📌 Description

**Reaction Time** est un jeu interactif qui teste votre temps de réaction. Le concept est simple mais addictif :

1. L'écran devient **ROUGE** (état d'attente)
2. Après un délai aléatoire, l'écran devient **VERT** (signal)
3. Vous devez appuyer sur **ESPACE** le plus rapidement possible
4. Le jeu mesure votre temps de réaction en **millisecondes**

## 🎯 Objectifs Complétés

✅ Affichage graphique en temps réel avec Raylib
✅ Délai aléatoire avant le passage du rouge au vert
✅ Mesure précise du temps en millisecondes
✅ Affichage du temps de réaction et meilleur score
✅ Gestion complète des états du jeu
✅ Détection si le joueur appuie trop tôt
✅ Système de niveaux progressifs (Facile → Moyen → Difficile)
✅ Code structuré et modulaire
✅ Code complet avec commentaires explicatifs

## 🎮 Fonctionnalités

### Fonctionnalités Principales

- **États de jeu** :
  - 🔴 **ATTENTE** : Écran rouge, attendez le signal
  - 🟢 **PRÊT** : Écran vert, appuyez sur ESPACE !
  - 📊 **RÉSULTAT** : Affichage du temps et des statistiques
  - ❌ **TROP TÔT** : Vous avez appuyé avant le vert

- **Système de scoring** :
  - Temps de réaction actuel en ms
  - Meilleur temps (persistant pendant l'exécution)
  - Nombre de tentatives
  - Indicateur de nouveau meilleur record

### Niveaux de Difficulté

| Niveau | Délai | Description |
|--------|-------|------------|
| 🟢 FACILE | 2-4 secondes | Idéal pour débuter |
| 🟡 MOYEN | 1-3 secondes | Difficulté standard |
| 🔴 DIFFICILE | 0.5-2 secondes | Maîtres uniquement ! |

### Commandes du Jeu

| Touche | Action |
|--------|--------|
| **ESPACE** | Réagir au signal vert / Valider |
| **FLÈCHE UP** | Réduire la difficulté |
| **FLÈCHE DOWN** | Augmenter la difficulté |
| **R** | Réinitialiser complètement |
| **ESC** | Quitter le jeu |

## 🛠️ Installation et Compilation

### Prérequis

- **Compilateur** : GCC ou MinGW (pour Windows)
- **Raylib** : Bibliothèque graphique (téléchargement gratuit)
- **Make** : Outil de compilation (optionnel pour Windows)

### Étape 1 : Installer Raylib

#### Sur Windows :

1. Télécharger Raylib : https://github.com/raysan5/raylib/releases
2. Extraire l'archive
3. Créer un dossier `raylib` à côté du fichier source
4. Copier les fichiers :
   ```
   raylib-master/src/raylib.h → raylib/include/raylib.h
   raylib-master/src/raylibs.h → raylib/include/raylibs.h
   raylib-master/build/lib/raylib.a → raylib/lib/raylib.a
   ```

### Étape 2 : Compiler le Projet

#### Option 1 : Avec Make (recommandé)

```bash
cd "chemin\vers\mini projet c"
mingw32-make rebuild
mingw32-make run
```

#### Option 2 : Compilation manuelle

```bash
gcc -Wall -Wextra -std=c99 -O2 -I./raylib/include -c reaction_time.c
gcc reaction_time.o -o reaction_time.exe -L./raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm
./reaction_time.exe
```

#### Option 3 : Script batch (Windows)

Utiliser le fichier `compile.bat` fourni avec le projet.

## 📁 Structure du Projet

```
mini projet c/
├── reaction_time.c      # Code source principal
├── Makefile             # Fichier de compilation
├── compile.bat          # Script de compilation (Windows)
├── README.md            # Ce fichier
└── raylib/              # Dossier Raylib (dépendances)
    ├── include/
    │   ├── raylib.h
    │   └── raylibs.h
    └── lib/
        └── raylib.a
```

## 🎮 Guide d'Utilisation

### Au Démarrage

- Le jeu commence instantanément
- L'écran est **ROUGE**
- Patientez... le signal vert arrive bientôt !

### Pendant le Jeu

1. **Attendez le GREEN** : Don't press SPACE yet!
2. **Dès que le vert apparaît** : Appuyez rapidement sur ESPACE
3. **Consultez votre score** : Temps de réaction affiché

### Stratégie

- Restez concentré et détenu
- Ne paniquez pas si vous êtes trop tôt
- Essayez de battre votre meilleur record
- Augmentez la difficulté progressivement

## 💻 Architecture du Code

### Énumérations

```c
typedef enum {
    STATE_WAITING,   // Écran rouge
    STATE_READY,     // Écran vert
    STATE_RESULT,    // Résultat affiché
    STATE_TOO_EARLY  // Trop tôt !
} GameState;

typedef enum {
    LEVEL_EASY,      // Délai long
    LEVEL_MEDIUM,    // Délai moyen
    LEVEL_HARD       // Délai court
} Level;
```

### Structure Principale

```c
typedef struct {
    GameState state;         // État actuel
    Level level;             // Niveau de difficulté
    float delay;             // Délai aléatoire
    float elapsedTime;       // Temps écoulé
    double reactionTime;     // Temps mesuré (ms)
    int bestScore;           // Meilleur temps
    long int attempts;       // Nombre de tentatives
    bool isNewBest;          // Nouveau record ?
} GameData;
```

### Fonctions Principales

| Fonction | Rôle |
|----------|------|
| `InitializeGame()` | Initialise les données du jeu |
| `StartNewAttempt()` | Commence une nouvelle tentative |
| `GenerateRandomDelay()` | Génère un délai aléatoire |
| `UpdateGame()` | Mise à jour de la logique |
| `Render()` | Affichage graphique |

## 🎨 Palette de Couleurs

- 🔴 **ROUGE** (#DC143C) : État d'attente - Soyez patient
- 🟢 **VERT** (#32CD32) : État prêt - Réagissez maintenant !
- ⚫ **GRIS FONCÉ** (#282828) : Fond neutre pour les résultats
- ⭐ **OR** (#FFD700) : Couleur du nouveau record

## 🚀 Améliorations Possibles

- [ ] Stockage du meilleur score en base de données
- [ ] Sons et effets audio
- [ ] Classement de joueurs multiples
- [ ] Thème personnalisable
- [ ] Mode multijoueur
- [ ] Statistiques détaillées (moyenne, écart-type, etc.)
- [ ] Interface graphique améliorée

## 🐛 Troubleshooting

### Le programme ne compile pas

**Erreur** : `raylib.h: No such file or directory`
- Vérifiez que le dossier `raylib/include/` existe
- Vérifiez que `raylib.h` est bien présent

### Le programme compile mais ne s'exécute pas

**Erreur** : `raylib.a: No such file or directory`
- Vérifiez que `raylib.a` est dans `raylib/lib/`
- Vérifiez les permissions d'accès aux fichiers

### Problèmes d'affichage graphique

- Vérifiez que Raylib est correctement compilé pour MinGW
- Essayez de recompiler Raylib depuis les sources

## 📝 Commentaires du Code

Le code source est entièrement commenté dans :
- En-tête du projet
- Chaque section logique
- Chaque fonction
- Points clés du code

## 👨‍💻 Informations Supplémentaires

| Information | Détail |
|-------------|--------|
| **Langage** | C (standard C99) |
| **Bibliothèque graphique** | Raylib 4.0+ |
| **Système d'exploitation** | Windows (MinGW) / Linux / macOS |
| **Compilateur** | GCC / MinGW / Clang |
| **Licence** | Libre d'utilisation pour le projet éducatif |

## 📚 Ressources et Liens

- 🌐 **Raylib** : https://www.raylib.com/
- 📖 **Documentation Raylib** : https://raylib.com/cheatsheet/cheatsheet.html
- 💾 **GitHub Raylib** : https://github.com/raysan5/raylib
- 🎮 **Exemples Raylib** : https://github.com/raysan5/raylib/tree/master/examples

## 🎯 Conseils pour les Améliorations

### Pour débuter

- Testez le jeu dans sa forme basique
- Comprenez la structure du code
- Modifiez les couleurs et les textes

### Pour progresser

- Ajoutez des effets sonores avec Raylib
- Créez un système de sauvegarde du score
- Ajoutez une interface de menu

### Pour experts

- Implémentez la multithreading pour le timing
- Créez un mode statistiques avancées
- Ajoutez une IA pour défier l'utilisateur

## 📞 Support

Pour des questions ou des problèmes :
1. Consultez la documentation de Raylib
2. Vérifiez que tous les fichiers sont en place
3. Testez avec un exemple simple de Raylib

---

**Bon jeu et amusez-vous à battre votre meilleur record !** 🎮⚡

Version : 1.0 | Date : Mars 2026

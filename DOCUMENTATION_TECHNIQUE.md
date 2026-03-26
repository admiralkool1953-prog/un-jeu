# 🔧 DOCUMENTATION TECHNIQUE - REACTION TIME

## 📋 Table des Matières

1. [Architecture Globale](#architecture-globale)
2. [Énumérations et Constantes](#énumérations-et-constantes)
3. [Structures de Données](#structures-de-données)
4. [Flux d'Exécution](#flux-dexécution)
5. [Gestion des États](#gestion-des-états)
6. [Système de Timing](#système-de-timing)
7. [Interface Utilisateur](#interface-utilisateur)
8. [Optimisations et Améliorations](#optimisations-et-améliorations)

## 🏗️ Architecture Globale

### Vue d'Ensemble

```
┌─────────────────────────────────────┐
│     REACTION TIME GAME (C99)        │
├─────────────────────────────────────┤
│  Input (Keyboard)                   │
│     ↓                               │
│  Logic (UpdateGame)                 │
│     ↓                               │
│  State Management (GameData)        │
│     ↓                               │
│  Rendering (Raylib)                 │
│     ↓                               │
│  Display (Screen)                   │
└─────────────────────────────────────┘
```

### Modules Principaux

| Module | Rôle |
|--------|------|
| **Initialization** | Préparation du jeu et Raylib |
| **Input Handling** | Capture des entrées clavier |
| **Game Logic** | Mise à jour de l'état du jeu |
| **Rendering** | Affichage graphique |
| **Utilities** | Fonctions utilitaires (timers, RNG) |

## 📌 Énumérations et Constantes

### État du Jeu (GameState)

```c
typedef enum {
    STATE_WAITING,    // 🔴 Écran rouge - en attente
    STATE_READY,      // 🟢 Écran vert - signal
    STATE_RESULT,     // 📊 Affichage du résultat
    STATE_TOO_EARLY   // ❌ Joueur trop rapide
} GameState;
```

**Transitions d'État** :
```
WAITING → READY (après le délai)
       → TOO_EARLY (si appui avant délai)
       
READY → RESULT (après appui)

TOO_EARLY → WAITING
RESULT → WAITING (appui sur ESPACE)
```

### Niveaux de Difficulté (Level)

```c
typedef enum {
    LEVEL_EASY,      // Délai 2-4 sec : pour débuter
    LEVEL_MEDIUM,    // Délai 1-3 sec : standard
    LEVEL_HARD       // Délai 0.5-2 sec : expert
} Level;
```

**Progression Automatique** :
- Après 5 tentatives → Passe à MOYEN
- Après 15 tentatives → Passe à DIFFICILE

### Constantes Importantes

```c
#define SCREEN_WIDTH 800      // Largeur de la fenêtre (pixels)
#define SCREEN_HEIGHT 600     // Hauteur de la fenêtre (pixels)
#define MAX_DELAY 4.0f        // Délai maximum (secondes)
#define MIN_DELAY 1.0f        // Délai minimum (secondes)
#define FPS 60                // Images par seconde
```

## 🗂️ Structures de Données

### GameData - Structure Principale

```c
typedef struct {
    GameState state;           // État actuel (WAITING/READY/RESULT/TOO_EARLY)
    Level level;               // Niveau de difficulté (EASY/MEDIUM/HARD)
    
    float delay;               // Délai avant transition (en secondes)
    float elapsedTime;         // Temps écoulé depuis le début de la phase actuelle
    
    double reactionTime;       // Temps de réaction mesuré (en millisecondes)
    int currentScore;          // Score actuel de cette tentative
    int bestScore;             // Meilleur score enregistré
    
    long int attempts;         // Nombre total de tentatives complétées
    double lastReactionTime;   // Dernière mesure du temps
    bool isNewBest;            // Indicateur : nouveau record ? (bool)
} GameData;
```

**Tailles mémoire** :
```
GameState        : 4 bytes   (enum)
Level            : 4 bytes   (enum)
float delay      : 4 bytes
float elapsedTime: 4 bytes
double reaction  : 8 bytes
int bestScore    : 4 bytes
attempts         : 8 bytes
bool isNewBest   : 1 byte
─────────────────────────
Total            : ~37 bytes
```

## 🔄 Flux d'Exécution

### Fonction Principale (main)

```
1. InitWindow()           ← Inicialise Raylib
2. SetTargetFPS(60)       ← Configure 60 FPS
3. InitializeGame()       ← Initialise GameData
4. StartNewAttempt()      ← Génère le délai aléatoire

5. BOUCLE PRINCIPALE :
   while (!WindowShouldClose()) {
       UpdateGame()        ← Traite les entrées et la logique
       Render()            ← Affiche à l'écran
   }

6. CloseWindow()          ← Ferme Raylib
```

### Boucle de Jeu (50ms par frame @ 60 FPS)

```
Frame (16.67ms) :
    ├─ Entrée Clavier
    │  └─ IsKeyPressed(KEY_SPACE)
    ├─ Mise à Jour Logique
    │  ├─ Détection état
    │  ├─ Timing
    │  └─ Calculs
    ├─ Rendu
    │  ├─ ClearBackground()
    │  ├─ DrawText()
    │  └─ EndDrawing()
    └─ Attendre prochaine frame
```

## 📊 Gestion des États

### État WAITING (Attente)

**Condition d'Activation** : Au démarrage ou après un résultat

**Durée** : `delay` secondes (aléatoire)

**Affichage** :
- Fond : 🔴 ROUGE (#DC143C)
- Texte : "ATTENDEZ..."
- Temps restant approximatif

**Transition** :
```c
if (elapsedTime >= delay) {
    state = STATE_READY;
    elapsedTime -= delay;  // Réinitialise le compteur
}
```

### État READY (Prêt)

**Condition d'Activation** : Après expiration du délai

**Durée** : Jusqu'à l'appui sur ESPACE

**Affichage** :
- Fond : 🟢 VERT (#32CD32)
- Texte animé : "C'EST PARTI !"
- Chronomètre pulsant

**Mesure du Temps** :
```c
// Enregistré lors de l'appui
reaction_time = elapsedTime * 1000;  // Conversion en ms
```

**Animation Pulsante** :
```c
float pulse = 30.0f * sin(elapsedTime * 4.0f) + 50.0f;
// Fait pulseur l'affichage du temps
```

### État RESULT (Résultat)

**Condition d'Activation** : Après appui en mode READY

**Durée** : Jusqu'à l'appui sur ESPACE

**Affichage** :
- Fond : Gris neutre
- Temps de réaction : `{x} ms`
- Meilleur score : `{y} ms`
- Nombre de tentatives

**Indicateur Nouveau Record** :
```c
if (attempts == 0 || reaction_time < best_score) {
    best_score = reaction_time;
    is_new_best = true;  // Affiche 🎉
}
```

### État TOO_EARLY (Trop Tôt)

**Condition d'Activation** : Appui avant la transition vers READY

**Durée** : Jusqu'à l'appui sur ESPACE

**Affichage** :
- Fond : 🔴 ROUGE FONCÉ
- Message d'erreur : "❌ TROP TÔT !"

## ⏱️ Système de Timing

### Délai Aléatoire

```c
float GenerateRandomDelay(Level level) {
    float min_delay, max_delay;
    
    switch (level) {
        case LEVEL_EASY:    min=2.0, max=4.0;
        case LEVEL_MEDIUM:  min=1.0, max=3.0;
        case LEVEL_HARD:    min=0.5, max=2.0;
    }
    
    float random = (float)rand() / RAND_MAX;  // [0.0, 1.0]
    return min + random * (max - min);
}
```

**Distribution** :
- Uniforme entre min et max
- Réinitialisé à chaque tentative
- Seed aléatoire au démarrage

### Mesure du Temps de Réaction

```
État WAITING             État READY          État RESULT
     ─┬─────────────────────┬─────────────┬
      │                     │             │
 elapsedTime=0         delay secondes  [USER PRESSES]
                       elapsedTime=0    measure!
                       
réactionTime = elapsedTime * 1000  (millisecondes)
```

**Précision** :
- Raylib : GetFrameTime() retourne Δt en secondes
- Accumulation : Σ(ΔtĀ entre frames
- Précision : ±1/60 secondes (~16ms@60FPS)

## 🎨 Interface Utilisateur

### Layout de L'Écran

```
┌─────────────────────────────────────────────────┐
│ Meilleur: 123 ms        Tentatives: 5          │ (20px)
│─────────────────────────────────────────────────│
│                                                 │
│                   ATTENDEZ...                   │
│            L'écran deviendra vert               │
│                                                 │
│                                                 │
│                                                 │
│─────────────────────────────────────────────────│
│ R: Reinit | FLECHES: Niveau | ESC: Quitter    │ (30px)
└─────────────────────────────────────────────────┘
```

### Palette de Couleurs

```c
COLOR_RED       = (220, 20, 60)     // 🔴 Attente
COLOR_GREEN     = (50, 205, 50)     // 🟢 Prêt
COLOR_BG        = (40, 40, 40)      // ⚫ Fond neutre
COLOR_TEXT      = (255, 255, 255)   // ⚪ Texte blanc
COLOR_EXCELLENT = (255, 215, 0)     // ⭐ Or - Nouveau record
```

### Tailles de Police

| Texte | Taille |
|-------|--------|
| Titre principal | 60-80px |
| Texte secondaire | 30-50px |
| Instructions | 20-25px |
| UI en bas | 16px |

## 🚀 Optimisations et Améliorations

### Optimisations Actuelles

✅ **Enum au lieu de constantes** :
```c
// ✅ BON - Type safe
typedef enum { STATE_WAITING } GameState;
game.state = STATE_WAITING;

// ❌ MAUVAIS - Pas de vérification de type
#define STATE_WAITING 0
game.state = STATE_WAITING;
```

✅ **Structure cohérente** :
- Toutes les données centralisées dans `GameData`
- Facile à passer en paramètre

✅ **Séparation logique/affichage** :
- `UpdateGame()` : logique pure
- `Render()` : affichage uniquement
- Facile à déboguer

### Améliorations Futures

#### 1. Persistence du Meilleur Score

```c
// Sauvegarder dans un fichier
void SaveBestScore(int score) {
    FILE *file = fopen("best_score.txt", "w");
    fprintf(file, "%d", score);
    fclose(file);
}

// Charger au démarrage
int LoadBestScore() {
    FILE *file = fopen("best_score.txt", "r");
    int score;
    fscanf(file, "%d", &score);
    fclose(file);
    return score;
}
```

#### 2. Système de Classement

```c
#define MAX_SCORES 10

typedef struct {
    char playerName[50];
    int score;
    time_t timestamp;
} ScoreEntry;

ScoreEntry leaderboard[MAX_SCORES];
```

#### 3. Effets Sonores

```c
#include "raudio.h"

InitAudioDevice();
Sound soundReady = LoadSound("ready.wav");
PlaySound(soundReady);
```

#### 4. Mode Multijoueur

```c
typedef enum {
    MODE_SINGLE,
    MODE_MULTIPLAYER
} GameMode;

// Chacun son tour, afficher le meilleur
```

#### 5. Statistiques Avancées

```c
typedef struct {
    double average;      // Moyenne
    double deviation;    // Écart-type
    double best;         // Meilleur
    double worst;        // Pire
    int totalAttempts;
} Statistics;
```

## 🔐 Gestion des Erreurs

### Validations Actuelles

✅ Vérification de `WindowShouldClose()`
✅ Bornes de délai (min/max)
✅ Vérification des états avant action

### Validations Recommandées

```c
// Valider les delais
if (delay < 0 || delay > MAX_DELAY) {
    delay = GenerateRandomDelay(level);
}

// Valider les scores
if (reaction_time < 0) {
    reaction_time = 0;
}

// Valider les énumérations
if (state < STATE_WAITING || state > STATE_TOO_EARLY) {
    state = STATE_WAITING;
}
```

## 📝 Conventions de Code

### Nommage

```c
// Constantes : UPPERCASE
#define SCREEN_WIDTH 800

// Énumérations : TypeName
typedef enum { VALUE_NAME } EnumName;

// Structures : TypeName
typedef struct { /*...*/ } StructName;

// Fonction : snake_case
void draw_text_centered(const char *text);

// Variables : snake_case
int best_score;
float elapsed_time;
```

### Commentaires

```c
/*
 * Description courte de la fonction
 * Paramètres : description
 * Retour : description
 */
void MyFunction(int param);
```

## 🧪 Tests Recommandés

### Tests Unitaires

```c
// Tester GenerateRandomDelay()
assert(delay >= MIN_DELAY);
assert(delay <= MAX_DELAY);

// Tester le calcul du temps
double elapsed = 1.5;  // 1.5 secondes
double reaction = elapsed * 1000;
assert(reaction == 1500.0);
```

### Tests d'Intégration

- Vérifier la transition entre états
- Vérifier le scoring
- Vérifier la progression des niveaux

### Tests d'Interface

- Vérifier l'affichage @ différentes résolutions
- Vérifier l'input au mauvais moment
- Vérifier la performance (FPS constant)

## 📚 Références

- **C99 Standard** : ISO/IEC 9899:1999
- **Raylib Documentation** : https://raylib.com/
- **Game Loop** : https://gafferongames.com/post/fix_your_timestep/
- **Timing Precision** : https://en.wikipedia.org/wiki/Comparison_of_processor_schedulers

---

**Pour plus d'informations, consultez le code source commenté dans `reaction_time.c`**

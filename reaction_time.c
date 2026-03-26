/*
 * =====================================================
 * MINI-PROJET : JEU "REACTION TIME" EN C AVEC RAYLIB
 * =====================================================
 * 
 * Description : Un jeu qui teste le temps de réaction du joueur
 * L'écran affiche d'abord du rouge, puis après un délai aléatoire,
 * devient vert. Le joueur doit appuyer sur une touche dès qu'il le voit.
 * 
 * Compilateur : GCC / MinGW
 * Dépendances : Raylib (https://www.raylib.com/)
 * 
 * Date : 2026
 */

#include <raylib.h>
#include <time.h>
#include <stdio.h>
#include <math.h>

// =====================================================
// CONSTANTES ET ÉNUMÉRATIONS
// =====================================================

// États du jeu
typedef enum {
    STATE_WAITING,    // État d'attente (écran rouge)
    STATE_READY,      // État prêt (écran vert)
    STATE_RESULT,     // État d'affichage du résultat
    STATE_TOO_EARLY   // État : joueur a appuyé trop tôt
} GameState;

// Niveaux de difficulté
typedef enum {
    LEVEL_EASY,       // 2-4 secondes
    LEVEL_MEDIUM,     // 1-3 secondes
    LEVEL_HARD        // 0.5-2 secondes
} Level;

// Constantes du jeu
#define SCREEN_WIDTH 800
#define SCREEN_HEIGHT 600
#define MAX_DELAY 4.0f      // Délai maximum en secondes
#define MIN_DELAY 1.0f      // Délai minimum en secondes
#define FPS 60

// Constantes pour les couleurs
#define COLOR_BG (Color){40, 40, 40, 255}
#define COLOR_RED (Color){220, 20, 60, 255}
#define COLOR_GREEN (Color){50, 205, 50, 255}
#define COLOR_TEXT (Color){255, 255, 255, 255}
#define COLOR_EXCELLENT (Color){255, 215, 0, 255}

// =====================================================
// STRUCTURES DE DONNÉES
// =====================================================

typedef struct {
    GameState state;           // État actuel du jeu
    Level level;               // Niveau de difficulté actuel
    float delay;               // Délai avant le passage au vert (en secondes)
    float elapsedTime;         // Temps écoulé depuis le début de la transition
    double reactionTime;       // Temps de réaction mesuré (en ms)
    int currentScore;          // Score actuel
    int bestScore;             // Meilleur score (meilleur temps)
    long int attempts;         // Nombre de tentatives
    double lastReactionTime;   // Dernière mesure du temps
    bool isNewBest;            // Indicateur de nouveau meilleur score
} GameData;

// =====================================================
// FONCTIONS UTILITAIRES
// =====================================================

/*
 * Initialise les données du jeu
 */
void InitializeGame(GameData *game) {
    game->state = STATE_WAITING;
    game->level = LEVEL_MEDIUM;
    game->delay = 0;
    game->elapsedTime = 0;
    game->reactionTime = 0;
    game->currentScore = 0;
    game->bestScore = 0;
    game->attempts = 0;
    game->lastReactionTime = 0;
    game->isNewBest = false;
    
    // Initialisation du générateur aléatoire
    srand((unsigned int)time(NULL));
}

/*
 * Génère un nouveau délai aléatoire selon le niveau
 */
float GenerateRandomDelay(Level level) {
    float min_delay, max_delay;
    
    switch (level) {
        case LEVEL_EASY:
            min_delay = 2.0f;
            max_delay = 4.0f;
            break;
        case LEVEL_MEDIUM:
            min_delay = 1.0f;
            max_delay = 3.0f;
            break;
        case LEVEL_HARD:
            min_delay = 0.5f;
            max_delay = 2.0f;
            break;
        default:
            min_delay = MIN_DELAY;
            max_delay = MAX_DELAY;
    }
    
    // Génère un nombre aléatoire entre min_delay et max_delay
    float randomValue = (float)rand() / RAND_MAX;
    return min_delay + randomValue * (max_delay - min_delay);
}

/*
 * Commence une nouvelle tentative
 */
void StartNewAttempt(GameData *game) {
    game->state = STATE_WAITING;
    game->delay = GenerateRandomDelay(game->level);
    game->elapsedTime = 0;
    game->reactionTime = 0;
    game->isNewBest = false;
}

/*
 * Augmente le niveau de difficulté progressivement
 */
void IncreaseLevel(GameData *game) {
    if (game->attempts > 5 && game->level < LEVEL_HARD) {
        game->level = LEVEL_MEDIUM;
    }
    if (game->attempts > 15 && game->level < LEVEL_HARD) {
        game->level = LEVEL_HARD;
    }
}

// =====================================================
// FONCTIONS DE LOGIQUE DU JEU
// =====================================================

/*
 * Met à jour la logique du jeu à chaque frame
 */
void UpdateGame(GameData *game) {
    // Gestion de l'entrée utilisateur
    if (IsKeyPressed(KEY_SPACE)) {
        switch (game->state) {
            case STATE_WAITING:
                // Le joueur a appuyé trop tôt
                game->state = STATE_TOO_EARLY;
                game->lastReactionTime = -1;
                break;
                
            case STATE_READY:
                // Enregistre le temps de réaction
                game->reactionTime = game->elapsedTime * 1000; // Convertir en ms
                game->lastReactionTime = game->reactionTime;
                
                // Met à jour le meilleur score
                if (game->attempts == 0 || game->reactionTime < game->bestScore) {
                    game->bestScore = (int)game->reactionTime;
                    game->isNewBest = true;
                }
                
                game->state = STATE_RESULT;
                game->attempts++;
                IncreaseLevel(game);
                break;
                
            case STATE_RESULT:
            case STATE_TOO_EARLY:
                // Redémarre le jeu avec la barre d'espace
                StartNewAttempt(game);
                break;
                
            default:
                break;
        }
    }
    
    // Redémarrage avec R
    if (IsKeyPressed(KEY_R)) {
        InitializeGame(game);
        StartNewAttempt(game);
    }
    
    // Changement de niveau avec UP/DOWN
    if (IsKeyPressed(KEY_UP) && game->level > LEVEL_EASY) {
        game->level--;
    }
    if (IsKeyPressed(KEY_DOWN) && game->level < LEVEL_HARD) {
        game->level++;
    }
    
    // Fermeture de la fenêtre avec ESC
    if (IsKeyPressed(KEY_ESCAPE)) {
        exit(0);
    }
    
    // Mise à jour du temps écoulé
    if (game->state == STATE_WAITING || game->state == STATE_READY) {
        game->elapsedTime += GetFrameTime();
        
        // Transition vers l'état READY
        if (game->state == STATE_WAITING && game->elapsedTime >= game->delay) {
            game->state = STATE_READY;
            game->elapsedTime = game->elapsedTime - game->delay;
        }
    }
}

// =====================================================
// FONCTIONS DE RENDU / AFFICHAGE
// =====================================================

/*
 * Affiche le texte au centre de l'écran
 */
void DrawCenteredText(const char *text, int fontSize, Color color) {
    int textWidth = MeasureText(text, fontSize);
    DrawText(text, (SCREEN_WIDTH - textWidth) / 2, SCREEN_HEIGHT / 2 - fontSize / 2, 
             fontSize, color);
}

/*
 * Affiche le texte à une position horizontale centrée
 */
void DrawCenteredTextAt(const char *text, int fontSize, int y, Color color) {
    int textWidth = MeasureText(text, fontSize);
    DrawText(text, (SCREEN_WIDTH - textWidth) / 2, y, fontSize, color);
}

/*
 * Affiche l'état d'attente (écran rouge)
 */
void DrawWaitingState(GameData *game) {
    ClearBackground(COLOR_RED);
    
    DrawCenteredTextAt("ATTENDEZ...", 60, 150, COLOR_TEXT);
    DrawCenteredTextAt("L'ecran deviendra vert bientot...", 30, 250, 
                       (Color){200, 200, 200, 255});
    
    // Affiche le compte à rebours approximatif
    float remainingTime = game->delay - game->elapsedTime;
    if (remainingTime > 0) {
        char buffer[50];
        snprintf(buffer, sizeof(buffer), "Temps restant: %.2f s", remainingTime);
        DrawCenteredTextAt(buffer, 25, 350, (Color){200, 200, 200, 255});
    }
}

/*
 * Affiche l'état prêt (écran vert)
 */
void DrawReadyState(GameData *game) {
    ClearBackground(COLOR_GREEN);
    
    DrawCenteredTextAt("C'EST PARTI !", 80, 200, COLOR_TEXT);
    DrawCenteredTextAt("Appuyez sur ESPACE MAINTENANT !", 35, 320, 
                       (Color){0, 0, 0, 200});
    
    // Animation de pulse (grossissement/rétrécissement du texte)
    float pulse = 30.0f * (float)sin(game->elapsedTime * 4.0f) + 50.0f;
    char buffer[50];
    snprintf(buffer, sizeof(buffer), "%.0f ms", game->elapsedTime * 1000);
    
    int textWidth = MeasureText(buffer, (int)pulse);
    DrawText(buffer, (SCREEN_WIDTH - textWidth) / 2, 450, (int)pulse, 
             (Color){255, 255, 255, 100});
}

/*
 * Affiche l'état résultat
 */
void DrawResultState(GameData *game) {
    ClearBackground(COLOR_BG);
    
    // Titre
    if (game->isNewBest) {
        DrawCenteredTextAt("🎉 NOUVEAU MEILLEUR TEMPS ! 🎉", 50, 50, COLOR_EXCELLENT);
    } else {
        DrawCenteredTextAt("TEMPS DE REACTION", 40, 50, COLOR_TEXT);
    }
    
    // Affiche le temps de réaction
    char reactionBuffer[100];
    snprintf(reactionBuffer, sizeof(reactionBuffer), "Votre temps : %.0f ms", 
             game->reactionTime);
    DrawCenteredTextAt(reactionBuffer, 50, 150, COLOR_GREEN);
    
    // Affiche les statistiques
    int statsY = 280;
    
    // Meilleur score
    char bestBuffer[100];
    snprintf(bestBuffer, sizeof(bestBuffer), "Meilleur temps : %d ms", 
             game->bestScore);
    DrawCenteredTextAt(bestBuffer, 30, statsY, COLOR_EXCELLENT);
    
    // Nombre de tentatives
    char attemptsBuffer[100];
    snprintf(attemptsBuffer, sizeof(attemptsBuffer), "Tentatives : %ld", 
             game->attempts);
    DrawCenteredTextAt(attemptsBuffer, 30, statsY + 60, COLOR_TEXT);
    
    // Niveau actuel
    const char *levelText;
    switch (game->level) {
        case LEVEL_EASY:
            levelText = "Niveau : FACILE";
            break;
        case LEVEL_MEDIUM:
            levelText = "Niveau : MOYEN";
            break;
        case LEVEL_HARD:
            levelText = "Niveau : DIFFICILE";
            break;
        default:
            levelText = "Niveau : INCONNU";
    }
    DrawCenteredTextAt(levelText, 30, statsY + 120, COLOR_TEXT);
    
    // Instructions
    DrawCenteredTextAt("Appuyez sur ESPACE pour continuer", 25, 500, 
                       (Color){150, 150, 150, 255});
}

/*
 * Affiche l'état "Trop tôt !"
 */
void DrawTooEarlyState(GameData *game) {
    ClearBackground((Color){200, 50, 50, 255});
    
    DrawCenteredTextAt("❌ TROP TOT ! ❌", 60, 150, COLOR_TEXT);
    DrawCenteredTextAt("Vous avez appuye avant que l'ecran ne devienne vert.", 30, 270, 
                       (Color){255, 255, 200, 255});
    DrawCenteredTextAt("Attendez le signal vert !", 30, 320, 
                       (Color){255, 255, 200, 255});
    DrawCenteredTextAt("Appuyez sur ESPACE pour rejouer", 25, 450, 
                       (Color){150, 150, 150, 255});
}

/*
 * Affiche l'interface générale (texte en bas de l'écran)
 */
void DrawUI(GameData *game) {
    // Affiche le meilleur score en haut à gauche
    if (game->bestScore > 0) {
        char bestScoreText[50];
        snprintf(bestScoreText, sizeof(bestScoreText), "Meilleur : %d ms", 
                 game->bestScore);
        DrawText(bestScoreText, 20, 20, 20, COLOR_TEXT);
    }
    
    // Affiche le nombre de tentatives en haut à droite
    char attemptsText[50];
    snprintf(attemptsText, sizeof(attemptsText), "Tentatives : %ld", game->attempts);
    int attemptsWidth = MeasureText(attemptsText, 20);
    DrawText(attemptsText, SCREEN_WIDTH - attemptsWidth - 20, 20, 20, COLOR_TEXT);
    
    // Instructions en bas
    DrawText("R: Reinitialiser | FLECHES: Niveau | ESC: Quitter", 10, 
             SCREEN_HEIGHT - 30, 16, (Color){100, 100, 100, 255});
}

/*
 * Affiche l'écran complet
 */
void Render(GameData *game) {
    BeginDrawing();
    
    // Affiche l'état approprié
    switch (game->state) {
        case STATE_WAITING:
            DrawWaitingState(game);
            break;
            
        case STATE_READY:
            DrawReadyState(game);
            break;
            
        case STATE_RESULT:
            DrawResultState(game);
            break;
            
        case STATE_TOO_EARLY:
            DrawTooEarlyState(game);
            break;
            
        default:
            ClearBackground(COLOR_BG);
    }
    
    // Affiche l'interface générale
    DrawUI(game);
    
    EndDrawing();
}

// =====================================================
// FONCTION PRINCIPALE
// =====================================================

int main(void) {
    // Initialisation de la fenêtre Raylib
    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Reaction Time - Mini Projet C");
    SetTargetFPS(FPS);
    
    // Initialisation du jeu
    GameData game;
    InitializeGame(&game);
    StartNewAttempt(&game);
    
    // Boucle principale du jeu
    while (!WindowShouldClose()) {
        // Mise à jour
        UpdateGame(&game);
        
        // Rendu
        Render(&game);
    }
    
    // Fermeture
    CloseWindow();
    
    return 0;
}

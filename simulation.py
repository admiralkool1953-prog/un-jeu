
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
JEU "REACTION TIME" - VERSION SIMULATION PYTHON
===============================================
Appuyez sur ENTRÉE dès que vous voyez "🟢 C'EST PARTI !"
"""

import time
import random
import os

def clear_screen():
    """Efface l'écran"""
    os.system('cls' if os.name == 'nt' else 'clear')



def demo_game():
    """Partie complète du jeu"""
    
    print("\n" + "="*60)
    print(" "*15 + "🎮 REACTION TIME 🎮")
    print("="*60)
    print()
    print("COMMENT JOUER:")
    print("1. Lisez les instructions")
    print("2. Attendez l'écran ROUGE")
    print("3. L'écran devient VERT après un délai aléatoire")
    print("4. Appuyez sur ENTRÉE IMMÉDIATEMENT")
    print()
    print("="*60)
    print()
    
    best_score = None
    attempts = 0
    
    while True:
        attempts += 1
        
        print(f"\n--- TENTATIVE {attempts} ---")
        print("Meilleur temps :", f"{best_score:.0f} ms" if best_score else "N/A")
        print()
        
        # Phase 1 : Attente (Rouge)
        delay = random.uniform(1.5, 3.0)
        print("🔴 ATTENDEZ... (écran ROUGE)")
        print(f"   Signal dans ~{delay:.1f} secondes...")
        
        input("Appuyez sur ENTRÉE pour CONFIRMER ET DÉMARRER : ")
        
        # Compte à rebours visible
        print()
        start = time.time()
        
        while True:
            elapsed = time.time() - start
            remaining = delay - elapsed
            
            if remaining <= 0:
                break
            
            print(f"\r   Attente... {remaining:.2f}s restant", end="", flush=True)
            time.sleep(0.05)
        
        print("\r" + " "*40)  # Efface la ligne
        
        # Phase 2 : Signal (Vert)
        print("")
        print("🟢🟢🟢 C'EST PARTI !!! 🟢🟢🟢")
        print()
        
        ready_time = time.time()
        
        # Attendre que l'utilisateur appuie
        input("⚡ APPUYEZ SUR ENTRÉE MAINTENANT !!! ⚡")
        
        # Mesurer le temps
        reaction = (time.time() - ready_time) * 1000
        
        # Phase 3 : Afficher résultat
        print()
        print("="*60)
        print("📊 RÉSULTAT")
        print("="*60)
        print(f"Votre temps de réaction : {reaction:.1f} ms")
        print()
        
        # Évaluation
        if reaction < 200:
            evaluation = "EXCELLENT ! 🚀 EXPERT !"
        elif reaction < 300:
            evaluation = "TRÈS BON ! 😊 BRAVO !"
        elif reaction < 400:
            evaluation = "BON ! 👍"
        elif reaction < 500:
            evaluation = "CORRECT 🤔"
        else:
            evaluation = "À AMÉLIORER 💪 ENCORE !"
        
        print(f"Évaluation : {evaluation}")
        print()
        
        # Mise à jour best score
        if best_score is None or reaction < best_score:
            best_score = reaction
            print("⭐ NOUVEAU MEILLEUR TEMPS ! 🎉🎉🎉")
        else:
            print(f"Meilleur temps : {best_score:.0f} ms")
        
        print()
        print(f"Tentatives : {attempts}")
        print()
        
        # Menu
        print("-"*60)
        print("(ENTRÉE) Rejouer | (Q) Quitter | (R) Restart complet")
        cmd = input("Votre choix : ").strip().lower()
        
        if cmd == 'q':
            break
        elif cmd == 'r':
            attempts = 0
            best_score = None
            clear_screen()
    
    # Fin
    print()
    print("="*60)
    print(" "*10 + "MERCI D'AVOIR JOUÉ À REACTION TIME !")
    print("="*60)
    print(f"Tentatives totales : {attempts}")
    print(f"Meilleur temps : {best_score:.0f} ms" if best_score else "Meilleur temps : N/A")
    print()
    print("👋 À bientôt !")
    print()

if __name__ == "__main__":
    try:
        clear_screen()
        demo_game()
    except KeyboardInterrupt:
        print("\n\nJeu interrompu. Au revoir ! 👋")


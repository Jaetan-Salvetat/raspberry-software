import tkinter as tk
import subprocess
import sys
import os

# Fonction pour fermer la fenêtre
def fermer_fenetre():
    fenetre.quit()

# Fonction pour l'action du bouton "Jouer"
def jouer():
    print("Lancement de choix_age.py...")
    
    # Utiliser `after` pour lancer le script de manière asynchrone
    fenetre.after(0, lancer_script)  # Lancer la fonction `lancer_script` immédiatement

def lancer_script():
    # Obtenir le chemin du répertoire courant
    current_dir = os.path.dirname(os.path.abspath(__file__))
    script_path = os.path.join(current_dir, "choix_age.py")

    # Vérifier si le fichier existe
    if os.path.exists(script_path):
        # Lancer le script choix_age.py
        if sys.platform.startswith('win'):
            # Windows
            subprocess.Popen([sys.executable, script_path])
        else:
            # Unix/Linux/Mac
            subprocess.Popen([sys.executable, script_path])
        # Fermer la fenêtre après avoir lancé le script
        fenetre.quit()
    else:
        print(f"Erreur: Le fichier {script_path} n'a pas été trouvé.")
        # Alternative: créer un message d'erreur dans une fenêtre
        error_window = tk.Tk()
        error_window.title("Erreur")
        tk.Label(error_window, text=f"Le fichier {script_path} n'a pas été trouvé.", font=("Arial", 12), fg="red").pack(padx=20, pady=20)
        tk.Button(error_window, text="OK", command=error_window.destroy).pack(pady=10)
        error_window.mainloop()

# Fonction pour l'action du bouton "Wi-Fi"
def wifi():
    print("Wi-Fi action!")

# Créer la fenêtre principale
fenetre = tk.Tk()

# Masquer la barre de menu et les boutons de la fenêtre
fenetre.overrideredirect(True)  # Supprimer la barre de titre
fenetre.geometry("1920x1080")  # Taille de la fenêtre

# Récupérer la taille de l'écran
largeur_ecran = fenetre.winfo_screenwidth()
hauteur_ecran = fenetre.winfo_screenheight()

# Adapter la fenêtre à la taille de l'écran
fenetre.geometry(f"{largeur_ecran}x{hauteur_ecran}+0+0")

# Charger l'image à afficher (utilisation de PhotoImage de Tkinter pour les formats supportés)
image_path = "C:/Users/valen/Downloads/th.png"  # Chemin de l'image
try:
    photo = tk.PhotoImage(file=image_path)
    # Créer un label avec l'image
    label_image = tk.Label(fenetre, image=photo)
    label_image.place(relwidth=1, relheight=1)  # Prendre toute la fenêtre
except Exception as e:
    print(f"Erreur lors du chargement de l'image: {e}")
    # Créer un fond de couleur si l'image ne peut pas être chargée
    label_image = tk.Label(fenetre, bg="light blue")
    label_image.place(relwidth=1, relheight=1)

# Ajouter un bouton simple "Jouer" au centre
bouton_jouer = tk.Button(fenetre, text="Jouer", command=jouer, font=("Arial", 20), bg="blue", fg="white", padx=30, pady=15)
bouton_jouer.place(relx=0.5, rely=0.4, anchor="center")

# Ajouter un bouton simple pour la Wi-Fi en bas à droite
bouton_wifi = tk.Button(fenetre, text="Wi-Fi", command=wifi, font=("Arial", 12), bg="green", fg="white")
bouton_wifi.place(x=largeur_ecran-100, y=hauteur_ecran-50)

# Créer un bouton pour fermer la fenêtre
bouton_fermer = tk.Button(fenetre, text="Fermer", command=fermer_fenetre, font=("Arial", 12), bg="red", fg="white")
bouton_fermer.place(x=largeur_ecran-80, y=20)

# Afficher la fenêtre
fenetre.mainloop()

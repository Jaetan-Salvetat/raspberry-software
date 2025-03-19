import tkinter as tk
from tkinter import ttk

import os
import sys
import subprocess

# Fonction pour fermer la fenêtre
def fermer_fenetre():
    fenetre.quit()

# Fonction pour valider le choix de l'âge
def valider_age():
    age_selectionne = age_var.get()  # Récupère l'âge sélectionné
    print(f"Âge sélectionné: {age_selectionne}")
    
    # Afficher un message à l'utilisateur avec l'âge sélectionné
    message_label.config(text=f"Vous avez sélectionné {age_selectionne} ans.")
    
    # Ici, vous pouvez lancer un autre script ou effectuer une action en fonction de l'âge
    # Par exemple:
    # fenetre.quit()  # Ferme la fenêtre après validation
    # subprocess.Popen(['python', 'autre_script.py', str(age_selectionne)])

# Créer la fenêtre principale
fenetre = tk.Tk()
fenetre.title("Choix de l'âge")

# Masquer la barre de menu et les boutons de la fenêtre
fenetre.overrideredirect(True)  # Supprimer la barre de titre
fenetre.geometry("1920x1080")  # Taille de la fenêtre

# Récupérer la taille de l'écran
largeur_ecran = fenetre.winfo_screenwidth()
hauteur_ecran = fenetre.winfo_screenheight()

# Adapter la fenêtre à la taille de l'écran
fenetre.geometry(f"{largeur_ecran}x{hauteur_ecran}+0+0")

# Charger l'image à afficher avec tk.PhotoImage (remplace PIL par tkinter)
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

# Créer un cadre pour contenir les éléments centraux
frame_central = tk.Frame(fenetre, bg="white", padx=30, pady=30, bd=2, relief=tk.RAISED)
frame_central.place(relx=0.5, rely=0.4, anchor="center")

# Ajouter un titre
label_titre = tk.Label(frame_central, text="Sélectionnez votre âge", font=("Arial", 24, "bold"), bg="white")
label_titre.pack(pady=(0, 20))

# Créer une variable pour stocker l'âge sélectionné
age_var = tk.IntVar(value=10)  # Valeur par défaut: 10

# Créer un menu déroulant pour l'âge
age_menu = ttk.Combobox(frame_central, textvariable=age_var, font=("Arial", 16), width=10)
age_menu['values'] = list(range(1, 21))  # Valeurs de 1 à 20
age_menu.pack(pady=20)

# Ajouter un bouton pour valider le choix
bouton_valider = tk.Button(frame_central, text="Valider", command=valider_age, 
                          font=("Arial", 16), bg="blue", fg="white", padx=20, pady=10)
bouton_valider.pack(pady=20)

# Ajouter un label pour afficher l'âge sélectionné après la validation
message_label = tk.Label(fenetre, font=("Arial", 16), bg="white", fg="green")
message_label.place(relx=0.5, rely=0.8, anchor="center")

# Créer un bouton pour fermer la fenêtre
bouton_fermer = tk.Button(fenetre, text="Fermer", command=fermer_fenetre, font=("Arial", 12), bg="red", fg="white")
bouton_fermer.place(x=largeur_ecran-80, y=20)

# Afficher la fenêtre
fenetre.mainloop()

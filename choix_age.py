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
    age_selectionne = age_var.get()
    print(f"Âge sélectionné: {age_selectionne}")
    # Ici, vous pourriez lancer un autre script ou effectuer une action en fonction de l'âge
    # Par exemple:
    # fenetre.destroy()
    # subprocess.Popen(['python', 'autre_script.py', str(age_selectionne)])

# Fonction pour l'action du bouton "Wi-Fi"
def wifi():
    print("Wi-Fi action!")

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

# Charger l'image à afficher (utiliser le même chemin que dans le script précédent)
image_path = "C:/Users/valen/Downloads/th.png"  # Chemin de l'image
try:
    image = Image.open(image_path)
    # Adapter l'image à la taille de la fenêtre
    image = image.resize((largeur_ecran, hauteur_ecran), Image.Resampling.LANCZOS)
    # Convertir l'image pour Tkinter
    photo = ImageTk.PhotoImage(image)
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

# Ajouter un bouton simple pour la Wi-Fi en bas à droite
bouton_wifi = tk.Button(fenetre, text="Wi-Fi", command=wifi, font=("Arial", 12), bg="green", fg="white")
bouton_wifi.place(x=largeur_ecran-100, y=hauteur_ecran-50)

# Créer un bouton pour fermer la fenêtre
bouton_fermer = tk.Button(fenetre, text="Fermer", command=fermer_fenetre, font=("Arial", 12), bg="red", fg="white")
bouton_fermer.place(x=largeur_ecran-80, y=20)

# Afficher la fenêtre
fenetre.mainloop()
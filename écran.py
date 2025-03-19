import tkinter as tk
from PIL import Image, ImageTk
import os

# Création de la fenêtre principale
root = tk.Tk()
root.title("Fenêtre Adaptative")

# Récupération de la taille de l'écran
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()

# Ajustement automatique de la taille de la fenêtre en plein écran sans bordures
root.overrideredirect(True)  # Supprime la bordure et la barre de titre
root.geometry(f"{screen_width}x{screen_height}")
root.attributes("-topmost", True)  # S'assure que la fenêtre reste au premier plan

# Vérifier si le fichier image existe
image_path = "C:/Users/valen/Downloads/th.png"
if not os.path.exists(image_path):
    print(f"Erreur: L'image à l'emplacement {image_path} n'a pas été trouvée.")
else:
    # Charger l'image de fond
    img = Image.open(image_path)

def resize_background(event):
    """Redimensionne l'image de fond en fonction de la taille de la fenêtre."""
    if img:  # S'assurer que l'image a bien été chargée
        new_width = event.width
        new_height = event.height
        resized_img = img.resize((new_width, new_height), Image.LANCZOS)
        background_image = ImageTk.PhotoImage(resized_img)
        display.config(image=background_image)
        display.image = background_image  # Garder une référence à l'image

# Création du label d'affichage de l'image
display = tk.Label(root)
display.place(x=0, y=0, relwidth=1, relheight=1)

# Lier l'événement de redimensionnement à la fonction correspondante
root.bind("<Configure>", resize_background)

# Ajout d'un bouton pour fermer la fenêtre
def close_window():
    root.destroy()

tk.Button(root, text="Fermer la fenêtre", command=close_window, font=("Arial", 14), bg="red", fg="white").pack(side="bottom", pady=20)

# Fonction pour l'action "Jouer"
def jouer_action():
    print("Action de jeu ici")

# Créer un bouton rond pour jouer au centre de l'image
bouton_jouer = tk.Button(root, text="Jouer", command=jouer_action, relief="solid", width=8, height=3, 
                         font=("Arial", 14, "bold"), bg="blue", fg="white", borderwidth=2, 
                         highlightthickness=0, activebackground="lightblue", activeforeground="white")
bouton_jouer.place(relx=0.5, rely=0.5, anchor="center")

# Lancement de la boucle principale
root.mainloop()

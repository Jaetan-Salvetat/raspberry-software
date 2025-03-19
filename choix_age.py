import tkinter as tk
from PIL import Image, ImageTk

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

# Charger l'image de fond
image_path = "C:/Users/valen/Downloads/th.png"
img = Image.open(image_path)
background_image = None  # Variable globale pour stocker l'image redimensionnée

def resize_background(event=None):
    """Redimensionne l'image de fond en fonction de la taille de la fenêtre."""
    global background_image
    new_width = root.winfo_width()
    new_height = root.winfo_height()
    resized_img = img.resize((new_width, new_height), Image.LANCZOS)
    background_image = ImageTk.PhotoImage(resized_img)
    display.config(image=background_image)

# Création du label d'affichage de l'image
display = tk.Label(root)
display.place(x=0, y=0, relwidth=1, relheight=1)

# Appliquer le redimensionnement initial
resize_background()

# Lier l'événement de redimensionnement à la fonction correspondante
root.bind("<Configure>", resize_background)

# Ajout d'un label pour afficher la résolution
tk.Label(root, text=f"Résolution : {screen_width}x{screen_height}", font=("Arial", 16), bg="white").pack(pady=20)

# Ajout d'un bouton pour fermer la fenêtre
def close_window():
    root.destroy()

tk.Button(root, text="Fermer la fenêtre", command=close_window, font=("Arial", 14), bg="red", fg="white").pack(side="bottom", pady=20)

# Ajout d'un bouton rond pour jouer, légèrement décentré
def jouer():
    print("Jeu lancé !")

# Création d'un canvas pour dessiner un bouton rond
canvas = tk.Canvas(root, width=100, height=100, highlightthickness=0, bg="deepskyblue")
canvas.place(relx=0.5, rely=0.5, anchor="center", x=10, y=10)  # Décalé de 1 cm

# Dessiner un cercle
circle = canvas.create_oval(10, 10, 90, 90, fill="deepskyblue", outline="white", width=3)

# Ajouter du texte au centre du bouton
text = canvas.create_text(50, 50, text="Jouer", font=("Arial", 14), fill="white")

# Rendre le bouton interactif
def on_click(event):
    jouer()

canvas.tag_bind(circle, "<Button-1>", on_click)
canvas.tag_bind(text, "<Button-1>", on_click)

# Lancement de la boucle principale
root.mainloop()

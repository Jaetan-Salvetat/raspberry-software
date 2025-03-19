import ttkbootstrap as ttk
import tkinter as tk
import os
from base_page import BasePage
from widgets import AppButton
from PIL import Image, ImageTk


class HomePage(BasePage):
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        self.setup_ui()
    
    def setup_ui(self):
        self.main_frame = ttk.Frame(self, bootstyle="light")
        self.main_frame.pack(expand=True, fill="both", padx=40, pady=40)
        
        self.create_title()
        self.create_buttons()
    
    def create_title(self):
        title_frame = ttk.Frame(self.main_frame, bootstyle="light")
        title_frame.pack(pady=20)
        
        assets_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "assets")
        image_path = os.path.join(assets_dir, "th.png")
        
        try:
            img = Image.open(image_path)
            # Redimensionner l'image à 200x200 pixels
            img = img.resize((200, 200), Image.LANCZOS)
            photo = ImageTk.PhotoImage(img)
            
            logo_label = tk.Label(title_frame, image=photo)
            logo_label.image = photo
            logo_label.pack(pady=10)
        except Exception as e:
            print(f"Erreur lors du chargement de l'image: {e}")
        
        subtitle_label = ttk.Label(
            title_frame,
            text="Quiz éducatif interactif",
            font=("Arial", 18, "normal"),
            bootstyle="info"
        )
        subtitle_label.pack(pady=5)
    
    def create_buttons(self):
        buttons_frame = ttk.Frame(self.main_frame, bootstyle="light")
        buttons_frame.pack(pady=20, padx=40, fill="x")
        
        play_button = AppButton(
            buttons_frame,
            text="JOUER !",
            command=self.play_game
        )
        play_button.pack(pady=15)
        
        age_button = AppButton(
            buttons_frame,
            text="CHOIX D'ÂGE",
            command=lambda: self.controller.show_page("AgeSelectorPage")
        )
        age_button.pack(pady=15)
        
        wifi_button = AppButton(
            buttons_frame,
            text="WIFI MANAGER",
            command=self.open_wifi_manager
        )
        wifi_button.pack(pady=15)
    
    def play_game(self):
        print("Le bouton Jouer a été cliqué")
        pass
    
    def open_wifi_manager(self):
        print("Le bouton WiFi Manager a été cliqué")
        pass
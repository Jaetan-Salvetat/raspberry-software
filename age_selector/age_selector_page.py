import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from base_page import BasePage
from widgets import AppButton

class AgeSelectorPage(BasePage):
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        self.age_value = ttk.IntVar(value=6)
        
        self.setup_ui()
    
    def setup_ui(self):
        banner = ttk.Frame(self, bootstyle="primary", height=100)
        banner.pack(fill="x")
        banner.pack_propagate(False)
        
        banner_label = ttk.Label(banner, text="Ludo-Bot", font=("Arial", 26, "bold"), 
                               bootstyle="inverse-primary")
        banner_label.pack(side="top", pady=30)
        
        main_container = ttk.Frame(self, bootstyle="light")
        main_container.pack(fill="both", expand=True, padx=40, pady=40)
        
        center_panel = ttk.Frame(main_container, bootstyle="light-border")
        center_panel.pack(fill="both", expand=True)
        
        self.center_frame = ttk.Frame(center_panel, bootstyle="light")
        self.center_frame.pack(fill="both", expand=True, padx=30, pady=30)
        
        self.create_title()
        self.create_age_selector()
        self.create_buttons()
    
    def create_title(self):
        self.title_label = ttk.Label(
            self.center_frame, 
            text="Choisis ton âge", 
            font=("Arial", 28, "bold"),
            bootstyle="primary"
        )
        self.title_label.pack(pady=20)
    
    def create_age_selector(self):
        self.age_frame = ttk.Frame(self.center_frame, bootstyle="light")
        self.age_frame.pack(pady=30)
        
        self.age_display = ttk.Label(
            self.age_frame, 
            text=f"Âge: {self.age_value.get()} ans", 
            font=("Arial", 22, "bold"),
            bootstyle="primary"
        )
        self.age_display.pack(pady=10)
        
        self.age_slider = ttk.Scale(
            self.age_frame,
            from_=3,
            to=10,
            orient="horizontal",
            length=300,
            variable=self.age_value,
            command=self.update_age_display,
            bootstyle="info"
        )
        self.age_slider.pack(pady=5)
        
        self.create_age_markers()
    
    def create_age_markers(self):
        self.markers_frame = ttk.Frame(self.age_frame, bootstyle="light")
        self.markers_frame.pack(fill="x")
        
        for age in range(3, 11):
            marker = ttk.Label(
                self.markers_frame, 
                text=str(age), 
                font=("Arial", 14),
                bootstyle="info"
            )
            position = (age - 3) / 7
            marker.place(relx=position, anchor="n")
    
    def create_buttons(self):
        self.buttons_frame = ttk.Frame(self.center_frame, bootstyle="light")
        self.buttons_frame.pack(pady=30, fill="x", padx=20)
        
        self.back_button = AppButton(
            self.buttons_frame,
            text="Retour",
            icon="⬅️",
            command=lambda: self.controller.show_page("HomePage")
        )
        self.back_button.pack(side="left", padx=20, ipadx=10, ipady=5)
        
        self.validate_button = AppButton(
            self.buttons_frame,
            text="Valider",
            icon="✅",
            command=self.valider_age
        )
        self.validate_button.pack(side="right", padx=20, ipadx=10, ipady=5)
    
    def update_age_display(self, event=None):
        age = int(self.age_value.get())
        self.age_display.config(text=f"Âge: {age} ans")
        
        # Mise à jour visuelle du slider
        if age <= 5:
            self.age_display.config(bootstyle="secondary")
        elif age <= 8:
            self.age_display.config(bootstyle="info")
        else:
            self.age_display.config(bootstyle="warning")
    
    def valider_age(self):
        selected_age = int(self.age_value.get())
        print(f"Âge sélectionné: {selected_age} ans")
        pass
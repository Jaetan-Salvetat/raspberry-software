import tkinter as tk
import sys

class SimpleApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Exemple de Navigation")
        self.attributes("-fullscreen", True)
        
        self.container = tk.Frame(self)
        self.container.pack(side="top", fill="both", expand=True)
        self.container.grid_rowconfigure(0, weight=1)
        self.container.grid_columnconfigure(0, weight=1)
        
        self.frames = {}
        
        self.create_pages()
        
        self.show_page("Screen1")
    
    def create_pages(self):
        page_classes = [Screen1, Screen2]
        
        for page_class in page_classes:
            page = page_class(self.container, self)
            self.frames[page_class.__name__] = page
            page.grid(row=0, column=0, sticky="nsew")
    
    def show_page(self, page_name):
        frame = self.frames[page_name]
        frame.tkraise()

class BasePage(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller

class Screen1(BasePage):
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        center_frame = tk.Frame(self)
        center_frame.place(relx=0.5, rely=0.5, anchor="center")
        
        title_label = tk.Label(center_frame, text="Screen 1", font=("Helvetica", 24, "bold"))
        title_label.pack(pady=20)
        
        self.counter = 0
        self.counter_label = tk.Label(center_frame, text=f"Compteur: {self.counter}", font=("Helvetica", 18))
        self.counter_label.pack(pady=20)
        
        increment_button = tk.Button(center_frame, text="Incrémenter", font=("Helvetica", 14),
                                  command=self.increment_counter)
        increment_button.pack(pady=10)
        
        next_button = tk.Button(center_frame, text="Aller à Screen 2", font=("Helvetica", 14),
                             command=lambda: controller.show_page("Screen2"))
        next_button.pack(pady=10)
        
        quit_button = tk.Button(center_frame, text="Quitter", font=("Helvetica", 14),
                             command=lambda: sys.exit())
        quit_button.pack(pady=10)
    
    def increment_counter(self):
        self.counter += 1
        self.counter_label.config(text=f"Compteur: {self.counter}")

class Screen2(BasePage):
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        center_frame = tk.Frame(self)
        center_frame.place(relx=0.5, rely=0.5, anchor="center")
        
        title_label = tk.Label(center_frame, text="Screen 2", font=("Helvetica", 24, "bold"))
        title_label.pack(pady=20)
        
        info_text = """Ceci est un exemple d'écran secondaire.
        
Vous pouvez naviguer entre les écrans en utilisant les boutons.
Le compteur de l'écran 1 conserve sa valeur lorsque vous
revenez depuis cet écran."""
        
        text_label = tk.Label(center_frame, text=info_text, font=("Helvetica", 14), justify="left")
        text_label.pack(pady=30)
        
        back_button = tk.Button(center_frame, text="Retour à Screen 1", font=("Helvetica", 14),
                             command=lambda: controller.show_page("Screen1"))
        back_button.pack(pady=20)

if __name__ == "__main__":
    app = SimpleApp()
    app.mainloop()
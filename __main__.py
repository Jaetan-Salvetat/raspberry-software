import ttkbootstrap as ttk
from ttkbootstrap.constants import *
import os
from home.home_page import HomePage
from age_selector.age_selector_page import AgeSelectorPage
from theme import get_theme

class SimpleApp(ttk.Window):
    def __init__(self):
        super().__init__(themename="flatly")
        
        theme = get_theme()
        self.style.register_theme(theme)
        self.style.theme_use("ludobot")
        
        self.title("Ludo-Bot")
        self.attributes("-fullscreen", True)
        
        style = self.style
        style.configure('.', font=("Helvetica", 12))
        style.configure('TLabel', font=("Helvetica", 12))
        
        self.setup_container()
        self.create_pages()
        self.show_page("HomePage")
        
    def setup_container(self):
        self.container = ttk.Frame(self, bootstyle="light")
        self.container.pack(side="top", fill="both", expand=True)
        self.container.grid_rowconfigure(0, weight=1)
        self.container.grid_columnconfigure(0, weight=1)
        
        self.frames = {}
    
    def create_pages(self):
        page_classes = [HomePage, AgeSelectorPage]
        
        for page_class in page_classes:
            page = page_class(self.container, self)
            self.frames[page_class.__name__] = page
            page.grid(row=0, column=0, sticky="nsew")
    
    def show_page(self, page_name):
        if page_name not in self.frames:
            print(f"ERREUR: La page {page_name} n'existe pas!")
            return
        
        frame = self.frames[page_name]
        frame.tkraise()

if __name__ == "__main__":
    app = SimpleApp()
    app.mainloop()  
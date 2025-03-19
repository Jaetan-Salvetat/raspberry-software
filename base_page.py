import ttkbootstrap as ttk

class BasePage(ttk.Frame):
    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent, bootstyle="light")
        self.controller = controller
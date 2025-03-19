import tkinter as tk
import ttkbootstrap as ttk

class Bootstyle:
    SOLID_SUCCESS = "success"
    SOLID_PRIMARY = "primary"
    SOLID_SECONDARY = "secondary"
    SOLID_DANGER = "danger"
    SOLID_WARNING = "warning"
    SOLID_INFO = "info"
    SOLID_DARK = "dark"
    SOLID_DISABLED = "disabled"

    OUTLINE_SUCCESS = "success-outline"
    OUTLINE_PRIMARY = "primary-outline"
    OUTLINE_SECONDARY = "secondary-outline"
    OUTLINE_DANGER = "danger-outline"
    OUTLINE_WARNING = "warning-outline"
    OUTLINE_INFO = "info-outline"
    OUTLINE_DARK = "dark-outline"
    OUTLINE_DISABLED = "disabled-outline"

    LINK_SUCCESS = "success-link"
    LINK_PRIMARY = "primary-link"
    LINK_DANGER = "danger-link"
    LINK_WARNING = "warning-link"
    LINK_INFO = "info-link"
    LINK_DARK = "dark-link"

class AppButton(ttk.Button):
    def __init__(
        self, 
        parent, 
        text="", 
        command=None,
        icon=None,
        bootstyle=Bootstyle.SOLID_PRIMARY,
        **kwargs
    ):
        display_text = text
        if icon:
            display_text = f"{icon} {text}"
        
        if "padding" not in kwargs:
            kwargs["padding"] = (10, 5)
            
        super().__init__(parent, text=display_text, command=command, **kwargs)

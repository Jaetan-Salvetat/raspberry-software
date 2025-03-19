from PIL import Image, ImageTk
import os
import tkinter as tk
from tkinter import Label

def create_image_label(parent, image_path, size=None):
    try:
        img = Image.open(image_path)
        
        if size:
            img = img.resize(size, Image.LANCZOS)
            
        photo_img = ImageTk.PhotoImage(img)
        label = Label(parent, image=photo_img)
        label.image = photo_img
        
        return label
    except Exception as e:
        print(f"Error creating image label from {image_path}: {e}")
        return None

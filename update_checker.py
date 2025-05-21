import os
import sys
import json
import tkinter as tk
from tkinter import ttk
import urllib.request
import tempfile
import zipfile
import subprocess
import shutil
import threading
from urllib.error import URLError

REPO_OWNER = "Jaetan-Salvetat"
REPO_NAME = "raspberry-software"
GITHUB_API_URL = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/releases/latest"
VERSION_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "version.py")
TEMP_DIR = tempfile.gettempdir()
UPDATE_SCRIPT_NAME = "update_ludobot.sh"

class UpdateChecker:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("LudoBot - Mise à jour")
        self.root.geometry("400x150")
        self.root.configure(bg="#f0f0f0")
        self.root.resizable(False, False)
        
        self.current_version = self.get_current_version()
        self.latest_version = None
        self.download_url = None
        self.app_dir = os.path.dirname(os.path.abspath(__file__))
        
        self.setup_ui()
        
    def setup_ui(self):
        main_frame = tk.Frame(self.root, bg="#f0f0f0")
        main_frame.pack(padx=20, pady=20, fill=tk.BOTH, expand=True)
        
        self.title_label = tk.Label(main_frame, text="Vérification des mises à jour", font=("Arial", 12, "bold"), bg="#f0f0f0")
        self.title_label.pack(anchor=tk.W, pady=(0, 10))
        
        self.status_label = tk.Label(main_frame, text="Recherche de nouvelles versions...", bg="#f0f0f0")
        self.status_label.pack(anchor=tk.W, pady=(0, 10))
        
        self.progress_frame = tk.Frame(main_frame, bg="#f0f0f0")
        self.progress_frame.pack(fill=tk.X, pady=(0, 10))
        
        self.progress_bar = ttk.Progressbar(self.progress_frame, orient=tk.HORIZONTAL, length=360, mode="determinate")
        self.progress_bar.pack(fill=tk.X)
        
        self.root.update_idletasks()
        
    def get_current_version(self):
        try:
            with open(VERSION_FILE, "r") as f:
                content = f.read()
                version_str = content.split('=')[1].strip().strip('"').strip("'")
                return version_str
        except Exception:
            return "0.0.0"
    
    def check_for_updates(self):
        self.status_label.config(text=f"Version actuelle: {self.current_version}")
        self.root.update_idletasks()
        
        try:
            response = urllib.request.urlopen(GITHUB_API_URL)
            data = json.loads(response.read().decode())
            
            self.latest_version = data["tag_name"].replace("v", "")
            
            for asset in data["assets"]:
                if asset["name"].endswith(".zip"):
                    self.download_url = asset["browser_download_url"]
                    break
            
            if self.is_newer_version():
                self.status_label.config(text=f"Nouvelle version disponible: {self.latest_version}")
                self.root.update_idletasks()
                self.download_update()
            else:
                self.status_label.config(text="Aucune mise à jour disponible")
                self.root.after(2000, self.root.destroy)
                
        except URLError:
            self.status_label.config(text="Erreur de connexion au serveur")
            self.root.after(2000, self.root.destroy)
            
    def is_newer_version(self):
        if not self.latest_version:
            return False
        
        # Conversion en tuples d'entiers pour comparaison correcte
        current_parts = [int(x) for x in self.current_version.split('.')]
        latest_parts = [int(x) for x in self.latest_version.split('.')]
        
        # Comparer les parties une par une
        for i in range(max(len(current_parts), len(latest_parts))):
            # Si la version actuelle a moins de composants que la dernière, compléter avec 0
            current = current_parts[i] if i < len(current_parts) else 0
            # Si la dernière version a moins de composants que l'actuelle, compléter avec 0
            latest = latest_parts[i] if i < len(latest_parts) else 0
            
            if latest > current:
                return True
            elif current > latest:
                return False
        
        # Si toutes les parties sont égales
        return False
    
    def download_update(self):
        if not self.download_url:
            self.status_label.config(text="Aucun lien de téléchargement disponible")
            self.root.after(2000, self.root.destroy)
            return
        
        self.status_label.config(text=f"Téléchargement de la version {self.latest_version}...")
        self.root.update_idletasks()
        
        download_path = os.path.join(TEMP_DIR, f"LudoBot-v{self.latest_version}.zip")
        
        def download_thread():
            try:
                with urllib.request.urlopen(self.download_url) as response, open(download_path, 'wb') as out_file:
                    total_size = int(response.info().get('Content-Length', 0))
                    downloaded = 0
                    block_size = 8192
                    
                    while True:
                        buffer = response.read(block_size)
                        if not buffer:
                            break
                            
                        downloaded += len(buffer)
                        out_file.write(buffer)
                        
                        progress = downloaded / total_size if total_size > 0 else 0
                        self.progress_bar["value"] = progress * 100
                        self.root.update_idletasks()
                
                self.root.after(0, lambda: self.prepare_update(download_path))
                
            except Exception as e:
                self.root.after(0, lambda: self.status_label.config(text=f"Erreur lors du téléchargement"))
                self.root.after(2000, self.root.destroy)
        
        thread = threading.Thread(target=download_thread)
        thread.daemon = True
        thread.start()
    
    def prepare_update(self, download_path):
        self.status_label.config(text="Préparation de la mise à jour...")
        self.root.update_idletasks()
        
        script_path = os.path.join(TEMP_DIR, UPDATE_SCRIPT_NAME)
        
        script_content = f"""#!/bin/bash

APP_DIR="{self.app_dir}"
DOWNLOAD_PATH="{download_path}"
EXTRACT_DIR="{TEMP_DIR}/LudoBot-update"
TIMESTAMP=$(date +%s)
BACKUP_DIR="{TEMP_DIR}/LudoBot-backup-$TIMESTAMP"

echo "Starting LudoBot update to version {self.latest_version}..."

mkdir -p "$EXTRACT_DIR"
mkdir -p "$BACKUP_DIR"

echo "Extracting update package..."
unzip -q "$DOWNLOAD_PATH" -d "$EXTRACT_DIR"

echo "Backing up current version..."
cp -r "$APP_DIR"/* "$BACKUP_DIR"

echo "Installing new version..."
cp -rf "$EXTRACT_DIR"/*/* "$APP_DIR"

echo "Cleaning up..."
rm -rf "$EXTRACT_DIR"
rm "$DOWNLOAD_PATH"
rm "$0"

echo "Update complete. Restarting LudoBot..."
cd "$APP_DIR" && ./run_ludobot.sh &

exit 0
"""
        
        with open(script_path, 'w') as f:
            f.write(script_content)
            
        os.chmod(script_path, 0o755)
        
        self.status_label.config(text="Installation de la mise à jour...")
        self.root.update_idletasks()
        
        subprocess.Popen([script_path])
        self.root.after(1000, self.root.destroy)
        
    def run(self):
        threading.Thread(target=self.check_for_updates, daemon=True).start()
        self.root.mainloop()

def main():
    # Vérifier si une mise à jour est disponible sans afficher l'interface
    checker = UpdateChecker()
    current_version = checker.get_current_version()
    
    try:
        response = urllib.request.urlopen(GITHUB_API_URL)
        data = json.loads(response.read().decode())
        latest_version = data["tag_name"].replace("v", "")
        
        # Conversion en tuples d'entiers pour comparaison correcte
        current_parts = [int(x) for x in current_version.split('.')]
        latest_parts = [int(x) for x in latest_version.split('.')]
        newer_version_available = False
        
        # Comparer les parties une par une
        for i in range(max(len(current_parts), len(latest_parts))):
            current = current_parts[i] if i < len(current_parts) else 0
            latest = latest_parts[i] if i < len(latest_parts) else 0
            
            if latest > current:
                newer_version_available = True
                break
            elif current > latest:
                break
        
        # Ne lancer l'interface que si une mise à jour est disponible
        if newer_version_available:
            app = UpdateChecker()
            app.run()
        else:
            print(f"Version actuelle ({current_version}) est à jour. Dernière version: {latest_version}")
            
    except Exception as e:
        print(f"Erreur lors de la vérification des mises à jour: {e}")

if __name__ == "__main__":
    main()

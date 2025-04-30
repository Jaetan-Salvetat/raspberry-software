import subprocess
import re
import time
import platform
import os
from PySide6.QtCore import QObject, Signal, Slot, Property, QTimer

class WifiManager(QObject):
    """
    Gestionnaire WiFi simple et robuste qui utilise directement les commandes système
    pour gérer les connexions WiFi sur Windows.
    """
    networksChanged = Signal()
    connectionStatusChanged = Signal(str)
    
    def __init__(self):
        super().__init__()
        self._networks = []
        self._current_network = ""
        self._timer = QTimer()
        self._timer.timeout.connect(self.scan_networks)
        self._timer.start(5000)  # Scan toutes les 5 secondes
        
        # Scan initial
        self.scan_networks()
    
    @Property(list, notify=networksChanged)
    def networks(self):
        return self._networks
    
    @Slot(result=str)
    def currentNetwork(self):
        try:
            result = subprocess.check_output(["netsh", "wlan", "show", "interfaces"], 
                                           text=True, encoding='cp850')
            for line in result.splitlines():
                if "SSID" in line and "BSSID" not in line:
                    ssid = line.split(":")[1].strip()
                    if ssid:
                        self._current_network = ssid
                        return ssid
            return "Non connecté"
        except Exception as e:
            print(f"Erreur lors de la récupération du réseau actuel: {e}")
            return "Non connecté"
    
    @Slot()
    def scan_networks(self):
        try:
            # Récupérer le réseau actuel
            current = self.currentNetwork()
            
            # Récupérer la liste des réseaux disponibles
            result = subprocess.check_output(["netsh", "wlan", "show", "networks", "mode=bssid"], 
                                           text=True, encoding='cp850')
            
            networks = []
            ssid = None
            signal = None
            security = None
            
            for line in result.splitlines():
                # Nouveau réseau
                if "SSID" in line and "BSSID" not in line:
                    # Si on avait déjà un réseau en traitement, l'ajouter à la liste
                    if ssid and ssid not in [n["ssid"] for n in networks]:
                        networks.append({
                            "ssid": ssid,
                            "security": security if security else "Open",
                            "signal": signal if signal else 0,
                            "connected": ssid == current
                        })
                    
                    # Extraire le nouveau SSID
                    ssid_match = re.search(r"SSID\s+\d+\s+:\s+(.*)", line)
                    if ssid_match:
                        ssid = ssid_match.group(1).strip()
                        signal = None
                        security = None
                
                # Type de sécurité
                elif "Authentication" in line:
                    auth_match = re.search(r"Authentication\s+:\s+(.*)", line)
                    if auth_match:
                        security = auth_match.group(1).strip()
                
                # Force du signal
                elif "Signal" in line:
                    signal_match = re.search(r"Signal\s+:\s+(\d+)%", line)
                    if signal_match:
                        # Convertir le pourcentage en niveau (0-4)
                        signal_percent = int(signal_match.group(1))
                        signal = min(4, signal_percent // 20)
            
            # Ajouter le dernier réseau traité
            if ssid and ssid not in [n["ssid"] for n in networks]:
                networks.append({
                    "ssid": ssid,
                    "security": security if security else "Open",
                    "signal": signal if signal else 0,
                    "connected": ssid == current
                })
            
            # Trier les réseaux par force de signal (décroissant)
            networks.sort(key=lambda x: x["signal"], reverse=True)
            
            # Mettre à jour la liste des réseaux si elle a changé
            if networks != self._networks:
                self._networks = networks
                self.networksChanged.emit()
                
        except Exception as e:
            print(f"Erreur lors du scan des réseaux: {e}")
    
    @Slot(str, str, str)
    def connect_to_network(self, ssid, password, security_type=None):
        """
        Se connecte à un réseau WiFi en utilisant directement les commandes Windows.
        
        Args:
            ssid (str): Nom du réseau WiFi
            password (str): Mot de passe du réseau WiFi
            security_type (str, optional): Type de sécurité (WPA/WPA2, WEP, Aucune). Si None, détecté automatiquement.
        """
        try:
            self.connectionStatusChanged.emit(f"Tentative de connexion à {ssid}...")
            print(f"Tentative de connexion au réseau: {ssid}")
            
            # Déterminer si le réseau est ouvert ou sécurisé
            is_open = False
            if security_type:
                is_open = security_type == "Aucune"
            else:
                # Rechercher dans les réseaux détectés
                for network in self._networks:
                    if network["ssid"] == ssid:
                        is_open = network["security"] == "Open"
                        break
            
            # Supprimer l'ancien profil s'il existe pour éviter les conflits
            try:
                print(f"Suppression du profil existant pour {ssid}")
                subprocess.run(["netsh", "wlan", "delete", "profile", f"name={ssid}"], 
                             check=False, capture_output=True, text=True)
                time.sleep(1)
            except Exception as e:
                print(f"Erreur lors de la suppression du profil: {e}")
            
            # Pour un réseau ouvert
            if is_open:
                print(f"Connexion à un réseau ouvert: {ssid}")
                # Créer un profil simple pour réseau ouvert
                profile_content = f"""<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>{ssid}</name>
    <SSIDConfig>
        <SSID>
            <name>{ssid}</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>open</authentication>
                <encryption>none</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
        </security>
    </MSM>
</WLANProfile>"""
            else:
                # Déterminer le type d'authentification et de chiffrement
                auth_type = "WPA2PSK"  # Par défaut
                encryption = "AES"      # Par défaut
                
                if security_type:
                    if security_type == "WEP":
                        auth_type = "open"
                        encryption = "WEP"
                    elif security_type == "WPA/WPA2":
                        auth_type = "WPA2PSK"
                        encryption = "AES"
                
                print(f"Connexion à un réseau sécurisé: {ssid} (Auth: {auth_type}, Encryption: {encryption})")
                
                # Créer un profil pour réseau sécurisé
                profile_content = f"""<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>{ssid}</name>
    <SSIDConfig>
        <SSID>
            <name>{ssid}</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>{auth_type}</authentication>
                <encryption>{encryption}</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>{password}</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>"""
            
            # Écrire le profil dans un fichier temporaire
            profile_path = f"{ssid}_profile.xml"
            try:
                with open(profile_path, "w", encoding="utf-8") as f:
                    f.write(profile_content)
                print(f"Profil créé: {profile_path}")
            except Exception as e:
                self.connectionStatusChanged.emit(f"Erreur lors de la création du profil: {str(e)}")
                print(f"Erreur lors de la création du profil: {e}")
                return
            
            # Ajouter le nouveau profil
            print(f"Ajout du profil pour {ssid}")
            add_result = subprocess.run(
                ["netsh", "wlan", "add", "profile", f"filename={profile_path}"],
                capture_output=True, text=True, check=False
            )
            
            if add_result.returncode != 0:
                error_msg = f"Erreur lors de l'ajout du profil: {add_result.stderr}"
                self.connectionStatusChanged.emit(error_msg)
                print(error_msg)
                return
            else:
                print(f"Profil ajouté avec succès: {add_result.stdout}")
            
            # Se connecter au réseau
            print(f"Connexion au réseau {ssid}")
            connect_result = subprocess.run(
                ["netsh", "wlan", "connect", f"name={ssid}"],
                capture_output=True, text=True, check=False
            )
            
            # Supprimer le fichier temporaire
            try:
                os.remove(profile_path)
                print(f"Fichier temporaire supprimé: {profile_path}")
            except Exception as e:
                print(f"Erreur lors de la suppression du fichier temporaire: {e}")
            
            if connect_result.returncode != 0:
                error_msg = f"Erreur lors de la connexion: {connect_result.stderr}"
                self.connectionStatusChanged.emit(error_msg)
                print(error_msg)
                return
            else:
                print(f"Commande de connexion exécutée: {connect_result.stdout}")
            
            # Vérifier la connexion après un délai
            print("Vérification de la connexion dans 5 secondes...")
            QTimer.singleShot(5000, self._check_connection_status)
            
        except Exception as e:
            error_msg = f"Erreur lors de la connexion au réseau: {str(e)}"
            self.connectionStatusChanged.emit(error_msg)
            print(f"Erreur lors de la connexion au réseau: {e}")
    
    def _check_connection_status(self):
        current = self.currentNetwork()
        if current != "Non connecté":
            success_msg = f"Connecté à {current}"
            self.connectionStatusChanged.emit(success_msg)
            print(success_msg)
        else:
            error_msg = "Échec de connexion"
            self.connectionStatusChanged.emit(error_msg)
            print(error_msg)
        
        # Mettre à jour la liste des réseaux
        self.scan_networks()

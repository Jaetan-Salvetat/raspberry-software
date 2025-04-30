import subprocess
import re
import json
from PySide6.QtCore import QObject, Signal, Slot, Property

class WifiController(QObject):
    """
    Contrôleur pour gérer les connexions Wi-Fi sur Windows
    """
    wifiListChanged = Signal()
    connectionStatusChanged = Signal(str)
    
    def __init__(self):
        super().__init__()
        self._wifi_list = []
        self._current_network = ""
        self._connection_status = "Déconnecté"
    
    @Property(list, notify=wifiListChanged)
    def wifiList(self):
        return self._wifi_list
    
    @Property(str, notify=connectionStatusChanged)
    def connectionStatus(self):
        return self._connection_status
    
    @Slot(result=list)
    def scanNetworks(self):
        """Scanne les réseaux Wi-Fi disponibles"""
        try:
            # Utiliser netsh pour récupérer les réseaux Wi-Fi disponibles
            output = subprocess.check_output(
                ["netsh", "wlan", "show", "networks"], 
                universal_newlines=True,
                encoding='cp850'  # Encodage pour Windows en français
            )
            
            # Analyser la sortie pour extraire les informations sur les réseaux
            networks = []
            ssid_pattern = r"SSID\s+\d+\s+:\s+(.*)"
            signal_pattern = r"Signal\s+:\s+(\d+)%"
            security_pattern = r"Authentification\s+:\s+(.*)"
            
            current_network = {}
            for line in output.split('\n'):
                ssid_match = re.search(ssid_pattern, line)
                if ssid_match:
                    if current_network and 'ssid' in current_network:
                        networks.append(current_network)
                    current_network = {'ssid': ssid_match.group(1).strip()}
                
                signal_match = re.search(signal_pattern, line)
                if signal_match and 'ssid' in current_network:
                    current_network['signal'] = int(signal_match.group(1))
                
                security_match = re.search(security_pattern, line)
                if security_match and 'ssid' in current_network:
                    current_network['security'] = security_match.group(1).strip()
            
            # Ajouter le dernier réseau
            if current_network and 'ssid' in current_network:
                networks.append(current_network)
            
            # Trier les réseaux par puissance du signal (décroissant)
            networks.sort(key=lambda x: x.get('signal', 0), reverse=True)
            
            # Mettre à jour la liste des réseaux
            self._wifi_list = networks
            self.wifiListChanged.emit()
            
            # Récupérer le réseau actuel
            self.getCurrentNetwork()
            
            return networks
        
        except Exception as e:
            print(f"Erreur lors du scan des réseaux Wi-Fi: {e}")
            return []
    
    @Slot()
    def getCurrentNetwork(self):
        """Récupère le réseau Wi-Fi actuellement connecté"""
        try:
            output = subprocess.check_output(
                ["netsh", "wlan", "show", "interfaces"], 
                universal_newlines=True,
                encoding='cp850'
            )
            
            ssid_pattern = r"SSID\s+:\s+(.*)"
            state_pattern = r"État\s+:\s+(.*)"
            
            ssid_match = re.search(ssid_pattern, output)
            state_match = re.search(state_pattern, output)
            
            if ssid_match and state_match:
                self._current_network = ssid_match.group(1).strip()
                state = state_match.group(1).strip()
                
                if "connecté" in state.lower():
                    self._connection_status = f"Connecté à {self._current_network}"
                else:
                    self._connection_status = "Déconnecté"
            else:
                self._connection_status = "Déconnecté"
            
            self.connectionStatusChanged.emit(self._connection_status)
            return self._connection_status
        
        except Exception as e:
            print(f"Erreur lors de la récupération du réseau actuel: {e}")
            self._connection_status = f"Erreur: {str(e)}"
            self.connectionStatusChanged.emit(self._connection_status)
            return self._connection_status
    
    @Slot(str, str, result=bool)
    def connectToNetwork(self, ssid, password=""):
        """Se connecte à un réseau Wi-Fi spécifique"""
        try:
            # Créer un profil XML pour la connexion
            profile_name = f"LudoBot_{ssid}"
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
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
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
            with open(f"{profile_name}.xml", "w") as f:
                f.write(profile_content)
            
            # Ajouter le profil
            subprocess.call(
                ["netsh", "wlan", "add", "profile", f"filename={profile_name}.xml"]
            )
            
            # Se connecter au réseau
            subprocess.call(
                ["netsh", "wlan", "connect", f"name={ssid}"]
            )
            
            # Mettre à jour le statut de connexion
            self._connection_status = f"Tentative de connexion à {ssid}..."
            self.connectionStatusChanged.emit(self._connection_status)
            
            # Vérifier si la connexion a réussi
            import time
            time.sleep(2)  # Attendre que la connexion s'établisse
            self.getCurrentNetwork()
            
            return "connecté" in self._connection_status.lower()
        
        except Exception as e:
            print(f"Erreur lors de la connexion au réseau {ssid}: {e}")
            self._connection_status = f"Erreur: {str(e)}"
            self.connectionStatusChanged.emit(self._connection_status)
            return False
    
    @Slot(result=bool)
    def disconnectFromNetwork(self):
        """Se déconnecte du réseau Wi-Fi actuel"""
        try:
            subprocess.call(["netsh", "wlan", "disconnect"])
            self._connection_status = "Déconnecté"
            self.connectionStatusChanged.emit(self._connection_status)
            return True
        except Exception as e:
            print(f"Erreur lors de la déconnexion: {e}")
            return False

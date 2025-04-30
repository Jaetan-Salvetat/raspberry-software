import time
import pywifi
from pywifi import const
from PySide6.QtCore import QObject, Signal, Slot, Property, QTimer

class PyWifiController(QObject):
    networksChanged = Signal()
    connectionStatusChanged = Signal(str)
    
    def __init__(self):
        super().__init__()
        self._networks = []
        self._current_network = ""
        self._wifi = pywifi.PyWiFi()
        self._iface = self._wifi.interfaces()[0]  # Prendre la première interface WiFi
        
        # Timer pour scanner périodiquement les réseaux
        self._timer = QTimer()
        self._timer.timeout.connect(self.scan_networks)
        self._timer.start(10000)  # Scan every 10 seconds
        
        # Initial scan
        self.scan_networks()
    
    @Property(list, notify=networksChanged)
    def networks(self):
        return self._networks
    
    @Slot(result=str)
    def currentNetwork(self):
        try:
            status = self._iface.status()
            if status == const.IFACE_CONNECTED:
                profile = self._iface.network_profiles()[0]
                self._current_network = profile.ssid
                return profile.ssid
            return "Non connecté"
        except Exception as e:
            print(f"Error getting current network: {e}")
            return "Non connecté"
    
    @Slot()
    def scan_networks(self):
        try:
            # Scan des réseaux
            self._iface.scan()
            time.sleep(2)  # Attendre que le scan soit terminé
            
            # Récupérer les résultats du scan
            scan_results = self._iface.scan_results()
            
            # Convertir les résultats en format lisible
            networks = []
            current_network = self.currentNetwork()
            
            for result in scan_results:
                # Déterminer le type de sécurité
                security = "Open"
                if result.akm:
                    # Utiliser des valeurs numériques au lieu des constantes qui peuvent varier
                    # AKM_TYPE_WPA2PSK = 4, AKM_TYPE_WPAPSK = 2
                    if 4 in result.akm or 2 in result.akm:
                        security = "WPA/WPA2"
                    # WEP n'est généralement plus utilisé, mais on peut le détecter autrement
                    elif result.auth == 1:  # AUTH_ALG_SHARED = 1 (typique pour WEP)
                        security = "WEP"
                
                # Calculer la force du signal (0-4)
                signal_strength = min(4, max(0, (result.signal + 80) // 20))
                
                # Ajouter le réseau à la liste
                networks.append({
                    "ssid": result.ssid,
                    "security": security,
                    "signal": signal_strength,
                    "connected": result.ssid == current_network
                })
            
            # Trier les réseaux par force de signal (décroissant)
            networks.sort(key=lambda x: x["signal"], reverse=True)
            
            # Mettre à jour la liste des réseaux
            self._networks = networks
            self.networksChanged.emit()
            
        except Exception as e:
            print(f"Error scanning networks: {e}")
    
    @Slot(str, str)
    def connect_to_network(self, ssid, password):
        try:
            # Créer un profil de connexion
            profile = pywifi.Profile()
            profile.ssid = ssid
            
            # Configurer la sécurité en fonction du type de réseau
            # Utiliser des valeurs numériques au lieu des constantes
            # AUTH_ALG_OPEN = 0, AKM_TYPE_NONE = 0, CIPHER_TYPE_NONE = 0
            # AKM_TYPE_WPA2PSK = 4, CIPHER_TYPE_CCMP = 4
            if not password:  # Réseau ouvert
                profile.auth = 0  # AUTH_ALG_OPEN
                profile.akm.append(0)  # AKM_TYPE_NONE
                profile.cipher = 0  # CIPHER_TYPE_NONE
            else:  # Réseau sécurisé (WPA/WPA2)
                profile.auth = 0  # AUTH_ALG_OPEN
                profile.akm.append(4)  # AKM_TYPE_WPA2PSK
                profile.cipher = 4  # CIPHER_TYPE_CCMP
                profile.key = password
            
            # Supprimer les profils existants
            self._iface.remove_all_network_profiles()
            
            # Ajouter le nouveau profil
            profile_id = self._iface.add_network_profile(profile)
            
            # Se connecter au réseau
            self.connectionStatusChanged.emit(f"Connexion à {ssid} en cours...")
            self._iface.connect(profile_id)
            
            # Vérifier la connexion après un délai
            QTimer.singleShot(5000, lambda: self._check_connection(ssid))
            
        except Exception as e:
            self.connectionStatusChanged.emit(f"Erreur de connexion: {str(e)}")
            print(f"Error connecting to network: {e}")
    
    def _check_connection(self, ssid):
        # Vérifier si la connexion a réussi
        status = self._iface.status()
        if status == const.IFACE_CONNECTED:
            self.connectionStatusChanged.emit(f"Connecté à {ssid}")
            self.scan_networks()  # Mettre à jour la liste des réseaux
        else:
            self.connectionStatusChanged.emit(f"Échec de connexion à {ssid}")

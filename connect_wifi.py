import subprocess
import os
import time
import sys
print("test")
def connect_to_wifi(ssid, password=None):
    """
    Se connecte à un réseau WiFi sous Windows.
    
    Args:
        ssid (str): Nom du réseau WiFi
        password (str, optional): Mot de passe du réseau. None pour un réseau ouvert.
    """
    print(f"Tentative de connexion au réseau '{ssid}'...")
    
    # Déterminer le type d'authentification et de chiffrement
    auth_type = "WPA2PSK"  # Par défaut
    encryption_type = "AES"  # Par défaut
    
    if password:
        # Créer un profil XML pour le réseau
        profile_xml = f"""<?xml version="1.0"?>
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
                <encryption>{encryption_type}</encryption>
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
    else:
        # Réseau ouvert
        profile_xml = f"""<?xml version="1.0"?>
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
    
    # Écrire le profil dans un fichier
    profile_path = f"{ssid}.xml"
    with open(profile_path, "w", encoding="utf-8") as f:
        f.write(profile_xml)
    
    try:
        # Supprimer le profil s'il existe déjà
        subprocess.run(["netsh", "wlan", "delete", "profile", f"name={ssid}"], 
                      check=False, capture_output=True)
        time.sleep(1)  # Attendre un peu
        
        # Ajouter le profil
        print("Ajout du profil réseau...")
        add_result = subprocess.run(["netsh", "wlan", "add", "profile", f"filename={profile_path}"], 
                                   capture_output=True, text=True)
        print(f"Résultat: {add_result.stdout + add_result.stderr}")
        
        # Connecter au réseau
        print(f"Connexion au réseau {ssid}...")
        connect_result = subprocess.run(["netsh", "wlan", "connect", f"name={ssid}"], 
                                       capture_output=True, text=True)
        print(f"Résultat: {connect_result.stdout + connect_result.stderr}")
        
        # Vérifier la connexion
        print("Vérification de la connexion...")
        time.sleep(5)  # Attendre que la connexion s'établisse
        
        check_result = subprocess.check_output(["netsh", "wlan", "show", "interfaces"], 
                                              text=True, encoding='cp850')
        
        connected_ssid = None
        for line in check_result.splitlines():
            if "SSID" in line and "BSSID" not in line:
                connected_ssid = line.split(":")[1].strip()
                break
        
        if connected_ssid == ssid:
            print(f"Connexion réussie au réseau '{ssid}'!")
        else:
            print(f"Échec de la connexion. Réseau actuel: '{connected_ssid or 'Non connecté'}'")
            
    except Exception as e:
        print(f"Erreur lors de la connexion: {str(e)}")
    
    finally:
        # Supprimer le fichier temporaire
        if os.path.exists(profile_path):
            os.remove(profile_path)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python connect_wifi.py <nom_du_reseau> [mot_de_passe]")
        print("Exemple réseau protégé: python connect_wifi.py MonReseau MonMotDePasse")
        print("Exemple réseau ouvert: python connect_wifi.py ReseauPublic")
        sys.exit(1)
    
    ssid = sys.argv[1]
    password = sys.argv[2] if len(sys.argv) > 2 else None
    
    connect_to_wifi(ssid, password)

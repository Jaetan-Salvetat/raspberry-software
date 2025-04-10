from PySide6.QtCore import QObject, Signal, Property, Slot


class SettingsController(QObject):

    def __init__(self):
        super().__init__()
        self._volume = 50
        self._vibration_enabled = True
        
        # Liste des langues disponibles
        self._language_codes = ["fr", "en"]
        self._language_names = ["Français", "English"]
        
        # Langue sélectionnée (index dans la liste)
        self._current_language_index = 0

    def initialize_settings(self):
        print("Settings initialized")

    @property
    def volume(self):
        return self._volume
        
    @property
    def vibration_enabled(self):
        return self._vibration_enabled
        
    @Slot(int)
    def set_volume(self, volume):
        self._volume = volume
    
    @property
    def vibration_enabled(self):
        return self._vibration_enabled
        
    @Slot(bool)
    def set_vibration_enabled(self, enabled):
        self._vibration_enabled = enabled
    
    @property
    def language_code(self):
        return self._language_codes[self._current_language_index]
    
    @property
    def language_name(self):
        return self._language_names[self._current_language_index]
    
    @property
    def language_codes(self):
        return self._language_codes
    
    @property
    def language_names(self):
        return self._language_names
    
    @Slot(int)
    def set_language(self, index):
        if 0 <= index < len(self._language_codes):
            self._current_language_index = index
    
    @Slot()
    def save_settings(self):
        print("Settings saved")
        # Ici, vous pourriez enregistrer les paramètres dans un fichier
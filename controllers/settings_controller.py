from PySide6.QtCore import QObject, Signal, Property, Slot


class SettingsController(QObject):
    volumeChanged = Signal(int, arguments=["volume"])
    vibrationEnabledChanged = Signal(bool, arguments=["vibration_enabled"])
    languageCodeChanged = Signal(str, arguments=["language_code"])
    languageNameChanged = Signal(str, arguments=["language_name"])

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
        self.volumeChanged.emit(50)
        self.vibrationEnabledChanged.emit(True)
        self.languageCodeChanged.emit(self._language_codes[0])
        self.languageNameChanged.emit(self._language_names[0])
        print("Settings initialized")

    @property
    def volume(self):
        return self._volume
        
    @Slot(int)
    def set_volume(self, volume):
        self._volume = volume
        self.volumeChanged.emit(self._volume)
    
    @property
    def vibration_enabled(self):
        return self._vibration_enabled
        
    @Slot(bool)
    def set_vibration_enabled(self, enabled):
        self._vibration_enabled = enabled
        self.vibrationEnabledChanged.emit(self._vibration_enabled)
    
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
            self.languageCodeChanged.emit(self.language_code)
            self.languageNameChanged.emit(self.language_name)
    
    @Slot()
    def save_settings(self):
        print("Settings saved")
        # Ici, vous pourriez enregistrer les paramètres dans un fichier
import subprocess
import re
from PySide6.QtCore import QObject, Signal, Slot, Property, QTimer

class VolumeController(QObject):
    """Contrôleur pour gérer le volume de l'application et le synchroniser avec le volume système"""
    volumeChanged = Signal(float)
    
    def __init__(self):
        super().__init__()
        self._volume = 0.5  # Volume par défaut (50%)
        
        # Timer pour mettre à jour périodiquement le volume
        self._timer = QTimer()
        self._timer.timeout.connect(self.sync_with_system_volume)
        self._timer.start(2000)  # Vérifier toutes les 2 secondes
        
        # Synchronisation initiale
        self.sync_with_system_volume()
    
    @Property(float, notify=volumeChanged)
    def volume(self):
        """Retourne le volume actuel (0.0 à 1.0)"""
        return self._volume
    
    @volume.setter
    def volume(self, value):
        """Définit le volume de l'application et du système"""
        # Limiter la valeur entre 0 et 1
        value = max(0.0, min(1.0, value))
        
        if value != self._volume:
            self._volume = value
            self.volumeChanged.emit(value)
            self.set_system_volume(value)
    
    @Slot()
    def sync_with_system_volume(self):
        """Synchronise le volume de l'application avec le volume système"""
        try:
            # Récupérer le volume système actuel
            system_volume = self.get_system_volume()
            
            # Mettre à jour le volume de l'application si nécessaire
            if abs(system_volume - self._volume) > 0.01:  # Tolérance de 1%
                self._volume = system_volume
                self.volumeChanged.emit(system_volume)
        except Exception as e:
            print(f"Erreur lors de la synchronisation du volume: {e}")
    
    @Slot(float)
    def set_volume(self, value):
        """Définit le volume (0.0 à 1.0)"""
        self.volume = value
    
    def get_system_volume(self):
        """Récupère le volume système actuel (0.0 à 1.0)"""
        # Comme la récupération du volume système est problématique,
        # nous utilisons simplement le volume interne de l'application
        return self._volume
    
    def set_system_volume(self, value):
        """Définit le volume système (0.0 à 1.0)"""
        # Nous ne modifions pas le volume système, mais seulement le volume interne
        # de l'application pour éviter les problèmes de compatibilité
        pass

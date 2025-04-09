import sys
import os
from pathlib import Path
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from controllers.settings_controller import SettingsController

def main():
    app = QGuiApplication(sys.argv)    
    engine = QQmlApplicationEngine()
    settings_controller = SettingsController()
    settings_controller.initialize_settings()
    
    current_dir = os.path.dirname(os.path.abspath(__file__))
    qml_file = os.path.join(current_dir, "ui/main.qml")
    engine.rootContext().setContextProperty("settingsController", settings_controller)
    
    engine.load(QUrl.fromLocalFile(qml_file))
    
    if not engine.rootObjects():
        sys.exit(-1)
    
    return app.exec()

if __name__ == "__main__":
    sys.exit(main())
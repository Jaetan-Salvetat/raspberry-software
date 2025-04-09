import sys
import os
from pathlib import Path
from qtpy.QtCore import QUrl
from qtpy.QtGui import QGuiApplication
from qtpy.QtQml import QQmlApplicationEngine

def main():
    """
    Main entry point for the application
    """
    app = QGuiApplication(sys.argv)
    
    engine = QQmlApplicationEngine()
    
    current_dir = os.path.dirname(os.path.abspath(__file__))
    qml_file = os.path.join(current_dir, "ui/main.qml")
    
    engine.load(QUrl.fromLocalFile(qml_file))
    
    if not engine.rootObjects():
        sys.exit(-1)
    
    return app.exec()

if __name__ == "__main__":
    sys.exit(main())
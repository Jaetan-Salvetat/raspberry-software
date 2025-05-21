import sys
from cx_Freeze import setup, Executable

build_exe_options = {
    "packages": [
        "PySide6", 
        "PySide6.QtCore", 
        "PySide6.QtGui", 
        "PySide6.QtWidgets", 
        "PySide6.QtQml", 
        "PySide6.QtQuick"
    ],
    "excludes": [
        "tkinter", 
        "unittest", 
        "http", 
        "xml", 
        "pydoc",
        "PySide6.QtAsyncio",
        "PySide6.QtWebEngine",
        "PySide6.QtWebEngineCore",
        "PySide6.QtWebEngineWidgets"
    ],
    "include_files": [
        ("ui", "ui"),
        ("quizzes", "quizzes"),
        ("version.py", "version.py"),
        ("update_checker.py", "update_checker.py")
    ],
    "bin_includes": [
        "libGL.so.1"
    ],
    "include_msvcr": True
}

executables = [
    Executable(
        "main.py",
        target_name="LudoBot",
        base=None,
        icon="ui/assets/logo.png"
    )
]

setup(
    name="LudoBot",
    version="0.1.0",
    description="Application éducative avec des quiz pour enfants",
    options={"build_exe": build_exe_options},
    executables=executables
)

import sys
from cx_Freeze import setup, Executable

build_exe_options = {
    "packages": [
        "PySide6.QtCore", 
        "PySide6.QtGui", 
        "PySide6.QtWidgets", 
        "PySide6.QtQml", 
        "PySide6.QtQuick",
        "PySide6.QtQuick.Controls", 
        "PySide6.QtQuick.Layouts", 
        "PySide6.QtQuick.Window", 
        "PySide6.QtQuick.Effects"
    ],
    "excludes": [
        "tkinter", 
        "unittest", 
        "http", 
        "pydoc",
        "doctest",
        "distutils",
        "pip",
        "setuptools",
        "PySide6.QtAsyncio",
        "PySide6.QtWebEngine",
        "PySide6.QtWebEngineCore",
        "PySide6.QtWebEngineWidgets",
        "PySide6.QtSql",
        "PySide6.QtTest",
        "PySide6.Qt3DCore",
        "PySide6.Qt3DInput",
        "PySide6.Qt3DLogic",
        "PySide6.Qt3DRender",
        "PySide6.Qt3DAnimation",
        "PySide6.Qt3DExtras"
    ],
    "include_files": [
        ("ui", "ui"),
        ("quizzes", "quizzes"),
        ("version.py", "version.py"),
        ("update_checker.py", "update_checker.py")
    ],
    "bin_excludes": [
        "libstdc++.so.6",
        "libgcc_s.so.1"
    ],
    "bin_includes": [
        "libGL.so.1"
    ],
    "zip_includes": [],
    "include_msvcr": True,
    "optimize": 2
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

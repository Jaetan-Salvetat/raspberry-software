# Raspberry Pi Fullscreen Application

A Qt6/QML-based fullscreen application for Raspberry Pi with a clean home page interface featuring 3 centered buttons.

## Requirements

- Python 3.6+
- PySide6 6.4.0+
- QtPy 2.3.0+
- csv (module standard Python)
- random (module standard Python)
- os (module standard Python)

## Installation

Install the required dependencies:

```bash
pip install PySide6==6.4.0 QtPy==2.3.0
```

## Structure des fichiers CSV

Les fichiers CSV pour les quiz doivent être placés dans le dossier `quizzes/` et suivre ce format :

```
id;langue;question;réponse1;réponse2;réponse3;réponse4;difficulté;anecdote;url
```

Où :
- `réponse1` est considérée comme la réponse correcte
- `anecdote` est un texte informatif affiché après avoir répondu à la question

## Exécution

Pour lancer l'application :

```bash
python main.py
# ou
python3 main.py
```

## Structure

- `main.py` - Main Python entry point for the application
- `ui/main.qml` - QML interface definition with fullscreen layout and buttons

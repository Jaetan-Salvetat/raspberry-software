from ttkbootstrap.style import ThemeDefinition

def get_ludobot_theme():
    # Définir les couleurs basées sur l'image du logo LudoBot
    return {
        "type": "light",
        "colors": {
            "primary": "#1e466e",     # Bleu foncé principal (comme le fond)
            "secondary": "#4badc1",   # Bleu clair secondaire
            "success": "#44d7e8",     # Turquoise (yeux du robot)
            "info": "#75b3d7",        # Bleu ciel
            "warning": "#f5a70a",     # Orange ambré (remplace le jaune doux)
            "danger": "#e63946",      # Rouge franc (remplace le rouge-orangé rosé)
            "light": "#eef5f9",       # Blanc légèrement bleuté
            "dark": "#1a2c3f",        # Bleu très foncé (contours)
            
            # Arrière-plan et texte
            "bg": "#ffffff",          # Blanc
            "fg": "#1e466e",          # Bleu foncé
            
            # Sélection
            "selectbg": "#44d7e8",    # Turquoise
            "selectfg": "#ffffff",    # Blanc
            
            # Autres éléments d'interface
            "border": "#d9e2ec",      # Gris bleuté clair
            "inputfg": "#1e466e",     # Bleu foncé
            "inputbg": "#f8f9fa",     # Blanc légèrement grisé
            "active": "#44d7e8",      # État actif des widgets (ex: boutons pressés) - turquoise
        }
    }

def get_theme():
    theme_data = get_ludobot_theme()
    # Créer la définition du thème (avec tous les paramètres correct)
    theme = ThemeDefinition(
        name="ludobot",
        themetype=theme_data["type"],
        colors=theme_data["colors"]
    )
    return theme

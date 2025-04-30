import os
import csv
from PySide6.QtCore import QObject, Slot, Signal, Property

class CSVReader(QObject):
    """
    Classe pour lire les fichiers CSV et exposer les valeurs aux fichiers QML
    """
    
    def __init__(self, parent=None):
        super().__init__(parent)
        print("CSVReader initialisé")
    
    @Slot(str, int, int, result=str)
    def readCellValue(self, filename, row, col):
        """
        Lit la valeur d'une cellule spécifique dans un fichier CSV
        
        Args:
            filename (str): Nom du fichier CSV
            row (int): Index de ligne (0-based)
            col (int): Index de colonne (0-based)
            
        Returns:
            str: Valeur de la cellule
        """
        try:
            # Chemin du dossier quizzes (relatif au dossier courant)
            quizzes_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "quizzes")
            file_path = os.path.join(quizzes_dir, filename)
            
            print(f"Lecture du fichier CSV: {file_path}")
            print(f"Recherche de la valeur à la position [{row}][{col}]")
            
            # Vérifier que le fichier existe
            if not os.path.exists(file_path):
                print(f"Erreur: Le fichier {file_path} n'existe pas")
                return f"Fichier non trouvé: {filename}"
            
            # Lire le fichier CSV
            with open(file_path, encoding="ISO-8859-1") as csvfile:
                reader = csv.reader(csvfile, delimiter=";", quotechar="'")
                
                # Convertir en liste pour accéder par index
                rows = list(reader)
                
                # Vérifier que la ligne existe
                if row >= len(rows):
                    print(f"Erreur: La ligne {row} n'existe pas dans le fichier")
                    return f"Ligne {row} non trouvée"
                
                # Vérifier que la colonne existe
                if col >= len(rows[row]):
                    print(f"Erreur: La colonne {col} n'existe pas dans la ligne {row}")
                    return f"Colonne {col} non trouvée dans la ligne {row}"
                
                # Récupérer la valeur
                value = rows[row][col]
                print(f"Valeur trouvée: {value}")
                return value
                
        except Exception as e:
            print(f"Erreur lors de la lecture du fichier CSV: {e}")
            return f"Erreur: {str(e)}"

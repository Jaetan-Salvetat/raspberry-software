import sys
import os
import csv
import subprocess
from pathlib import Path
from PySide6.QtCore import QObject, Slot, QUrl, Property, Signal
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, QmlElement, QmlSingleton
# Utiliser les contrôleurs du dossier controllers
from controllers.settings_controller import SettingsController
from controllers.wifi_controller import WifiController as WifiControllerFromControllers
from controllers.volume_controller_fixed import VolumeController
from wifi_manager_fixed import WifiManager
from WifiController import WifiController  # Import direct depuis le dossier principal
from QuizController import QuizController
from CSVQuizLoader import CSVQuizLoader
from SubjectLoader import SubjectLoader
from CSVLoader3Ans import CSVLoader3Ans  # Import du nouveau chargeur pour les enfants de 3 ans

# Classe pour lire le fichier CSV directement
class CSVReaderSingleton(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        print("CSVReaderSingleton initialisé")
    
    @Slot(str, int, int, result=str)
    def readCellValue(self, filename, row, col):
        """Lit la valeur d'une cellule dans un fichier CSV"""
        try:
            # Chemin du dossier quizzes
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
                rows = list(reader)
                
                if row < len(rows) and col < len(rows[row]):
                    value = rows[row][col]
                    print(f"Valeur trouvée: {value}")
                    return value
                else:
                    return "Index hors limites"
                
        except Exception as e:
            print(f"Erreur lors de la lecture du fichier CSV: {e}")
            return f"Erreur: {str(e)}"
    
    @Slot(str, int, result="QVariantList")
    def loadQuestions(self, filename, age):
        """Charge les questions et réponses depuis un fichier CSV en fonction de l'âge"""
        try:
            # Chemin du dossier quizzes
            quizzes_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "quizzes")
            file_path = os.path.join(quizzes_dir, filename)
            
            print(f"Chargement des questions depuis {file_path} pour l'âge {age}")
            
            # Vérifier que le fichier existe
            if not os.path.exists(file_path):
                print(f"Erreur: Le fichier {file_path} n'existe pas")
                return []
            
            # Utiliser directement les colonnes B, C, D, E, F, G pour toutes les questions
            # B (indice 1) pour les questions
            # C (indice 2) pour les bonnes réponses
            # D, E, F, G (indices 3, 4, 5, 6) pour les propositions de réponses
            question_index = 1  # Colonne B
            answer_index = 2    # Colonne C
            choices_indices = [3, 4, 5, 6]  # Colonnes D, E, F, G
            
            print(f"Indices utilisés pour l'âge {age}:")
            print(f"  - question_index: {question_index}")
            print(f"  - answer_index: {answer_index}")
            print(f"  - choices_indices: {choices_indices}")
            
            questions = []
            
            # Lire le fichier CSV
            with open(file_path, encoding="ISO-8859-1") as csvfile:
                reader = csv.reader(csvfile, delimiter=";", quotechar="'")
                next(reader)  # Ignorer l'en-tête
                
                for row_num, item in enumerate(reader, 1):
                    if len(item) <= max(question_index, answer_index):
                        print(f"Ligne {row_num} ignorée car pas assez de colonnes: {len(item)}")
                        continue
                    
                    # Vérifier que la question et la réponse ne sont pas vides
                    if not item[question_index] or not item[answer_index]:
                        print(f"Ligne {row_num} ignorée car question ou réponse vide")
                        continue
                    
                    # Récupérer les choix non vides
                    choices = []
                    for idx in choices_indices:
                        if idx < len(item) and item[idx]:
                            choices.append(item[idx])
                    
                    # S'assurer que la réponse correcte est dans les choix
                    correct_answer = item[answer_index]
                    if correct_answer not in choices:
                        choices.insert(0, correct_answer)
                    
                    # S'assurer qu'il y a au moins 2 choix
                    while len(choices) < 2:
                        choices.append(f"Option {len(choices)+1}")
                    
                    # Mélanger les réponses pour plus de difficulté
                    import random
                    random.shuffle(choices)
                    
                    q = {
                        'id': str(row_num),
                        'question': item[question_index],
                        'answers': choices,
                        'correct': correct_answer,
                        'anecdote': ""
                    }
                    questions.append(q)
                    print(f"Question ajoutée: {q['question']}")
                    print(f"  - Réponse correcte: {q['correct']}")
                    print(f"  - Options: {q['answers']}")
            
            # Sélectionner 10 questions aléatoires (ou toutes si moins de 10)
            if len(questions) > 10:
                import random
                questions = random.sample(questions, 10)
                print(f"Sélection de 10 questions aléatoires parmi {len(questions)} disponibles")
            
            print(f"Nombre de questions chargées: {len(questions)}")
            return questions
                
        except Exception as e:
            print(f"Erreur lors du chargement des questions: {e}")
            return []

def main():
    app = QGuiApplication(sys.argv)
    
    # Set application name and organization
    app.setApplicationName("LudoBot")
    app.setOrganizationName("LudoBot")
    app.setOrganizationDomain("ludobot.org")
    
    # Lancer le vérificateur de mise à jour en arrière-plan
    update_checker_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "update_checker.py")
    subprocess.Popen([sys.executable, update_checker_path], start_new_session=True)
    
    os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"
    
    # Créer l'instance du lecteur CSV et l'exposer au contexte QML
    csv_reader = CSVReaderSingleton()
    settings_controller = SettingsController()
    wifi_controller = WifiControllerFromControllers()  # Utiliser le contrôleur WiFi du dossier controllers
    volume_controller = VolumeController()  # Créer l'instance du contrôleur de volume
    quiz_controller = QuizController()  # Créez l'instance
    csv_quiz_loader = CSVQuizLoader()  # Créer l'instance du nouveau chargeur CSV
    subject_loader = SubjectLoader()  # Créer l'instance du chargeur de matières
    csv_loader_3ans = CSVLoader3Ans()  # Créer l'instance du chargeur pour les enfants de 3 ans
    
    engine = QQmlApplicationEngine()
    
    current_dir = os.path.dirname(os.path.abspath(__file__))
    qml_file = os.path.join(current_dir, "ui/main.qml")
    
    engine.rootContext().setContextProperty("settingsController", settings_controller)
    engine.rootContext().setContextProperty("wifiController", wifi_controller)
    engine.rootContext().setContextProperty("volumeController", volume_controller)  # Exposer le contrôleur de volume
    engine.rootContext().setContextProperty("csvReader", csv_reader)
    engine.rootContext().setContextProperty("quizController", quiz_controller)  # Enregistrez-le
    engine.rootContext().setContextProperty("csvQuizLoader", csv_quiz_loader)  # Exposer le nouveau chargeur CSV
    engine.rootContext().setContextProperty("subjectLoader", subject_loader)  # Exposer le chargeur de matières
    engine.rootContext().setContextProperty("csvLoader3Ans", csv_loader_3ans)  # Exposer le chargeur pour les enfants de 3 ans
    
    engine.load(QUrl.fromLocalFile(qml_file))
    
    if not engine.rootObjects():
        sys.exit(-1)
    
    return app.exec()

if __name__ == "__main__":
    sys.exit(main())
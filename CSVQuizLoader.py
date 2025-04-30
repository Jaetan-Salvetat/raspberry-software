import os
import csv
import random
from PySide6.QtCore import QObject, Slot, Signal

class CSVQuizLoader(QObject):
    """
    Classe pour charger les questions de quiz à partir de fichiers CSV
    """
    
    # Signal émis lorsque les questions sont chargées
    questionsLoaded = Signal(list)
    
    def __init__(self, parent=None):
        super().__init__(parent)
        self.questions = []
        print("CSVQuizLoader initialisé")
    
    @Slot(str, int, result="QVariantList")
    def loadQuestions(self, subject, age):
        """
        Charge les questions depuis un fichier CSV en fonction de la matière et de l'âge
        """
        print(f"Chargement des questions pour la matière: {subject}, âge: {age}")
        
        # Chemin du dossier quizzes
        quizzes_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "quizzes")
        
        # Déterminer le nom du fichier CSV en fonction de la matière
        # Mappage des noms de matières avec les noms de fichiers réels
        subject_mapping = {
            "maths": "maths",
            "culturegeneral": "culturegeneral",
            "geographie": "geographie",
            "histoire": "histoire",
            "science": "science"
        }
        
        # Utiliser le mappage pour obtenir le nom de fichier correct
        print(f"Matière reçue: '{subject}'")
        print(f"Mappages disponibles: {subject_mapping}")
        
        file_name = subject_mapping.get(subject, subject)
        print(f"Nom de fichier après mappage: '{file_name}'")
        
        csv_filename = f"{file_name}.csv"
        file_path = os.path.join(quizzes_dir, csv_filename)
        
        print(f"Chemin complet du fichier: {file_path}")
        print(f"Le fichier existe: {os.path.exists(file_path)}")
        
        # Vérifier que le fichier existe
        if not os.path.exists(file_path):
            print(f"Erreur: Le fichier {file_path} n'existe pas")
            return self._getDefaultQuestions()
        
        try:
            # Lire le fichier CSV
            questions = self._readCSVFile(file_path, age)
            
            # S'il n'y a pas de questions, utiliser les questions par défaut
            if not questions:
                print("Aucune question trouvée dans le fichier CSV, utilisation des questions par défaut")
                return self._getDefaultQuestions()
            
            # Sélectionner 10 questions aléatoires (ou toutes si moins de 10)
            if len(questions) > 10:
                questions = random.sample(questions, 10)
                print(f"Sélection de 10 questions aléatoires parmi {len(questions)} disponibles")
            
            # Mettre à jour les questions
            self.questions = questions
            print(f"Nombre de questions chargées: {len(self.questions)}")
            
            # Émettre le signal
            self.questionsLoaded.emit(self.questions)
            
            return self.questions
            
        except Exception as e:
            print(f"Erreur lors du chargement des questions: {e}")
            return self._getDefaultQuestions()
    
    def _readCSVFile(self, file_path, age):
        """
        Lit un fichier CSV et extrait les questions
        """
        questions = []
        
        # Utiliser directement la colonne B (index 1) pour les questions
        print(f"Utilisation de la colonne B pour les questions, indépendamment de l'âge {age}")
        
        # Indices fixes pour les questions et réponses
        question_index = 1  # Colonne B pour la question
        answer_index = 2    # Colonne C pour la réponse
        
        print(f"Utilisation de la colonne {question_index} (B) pour les questions et {answer_index} (C) pour les réponses")
        
        try:
            # Lire le fichier CSV
            with open(file_path, encoding="ISO-8859-1") as csvfile:
                reader = csv.reader(csvfile, delimiter=";", quotechar="'")
                next(reader)  # Ignorer l'en-tête
                
                # Parcourir les lignes du fichier CSV
                for row_num, row in enumerate(reader, 1):
                    if len(row) <= max(question_index, answer_index):
                        print(f"Ligne {row_num} ignorée car pas assez de colonnes: {len(row)}")
                        continue
                    
                    # Récupérer la question et la réponse correcte
                    question_text = row[question_index] if question_index < len(row) else ""
                    correct_answer = row[answer_index] if answer_index < len(row) else ""
                    
                    # Vérifier que la question n'est pas vide
                    if not question_text:
                        print(f"Ligne {row_num} ignorée car question vide")
                        continue
                    
                    # Si la réponse est vide, utiliser une réponse par défaut
                    if not correct_answer:
                        print(f"Réponse vide pour la ligne {row_num}, utilisation d'une réponse par défaut")
                        correct_answer = "Réponse non disponible"
                    
                    # Récupérer les choix de réponses
                    choices = []
                    # Les choix sont dans les colonnes D, E, F, G (indices 3, 4, 5, 6)
                    choices_indices = [3, 4, 5, 6]
                    for idx in choices_indices:
                        if idx < len(row) and row[idx]:
                            choices.append(row[idx])
                    
                    # S'assurer que la réponse correcte est dans les choix
                    if correct_answer not in choices:
                        choices.append(correct_answer)
                    
                    # S'assurer qu'il y a au moins 2 choix
                    while len(choices) < 2:
                        choices.append(f"Option {len(choices)+1}")
                    
                    # Mélanger les réponses pour plus de difficulté
                    random.shuffle(choices)
                    
                    # Créer la question
                    q = {
                        'id': str(row_num),
                        'question': question_text,
                        'answers': choices,
                        'correct': correct_answer,
                        'anecdote': ""
                    }
                    
                    # Ajouter la question à la liste
                    questions.append(q)
                    print(f"Question ajoutée: {q['question']}")
                    print(f"  - Réponse correcte: {q['correct']}")
                    print(f"  - Options: {', '.join(q['answers'])}")
            
            return questions
            
        except Exception as e:
            print(f"Erreur lors de la lecture du fichier CSV: {e}")
            return []
    
    def _getDefaultQuestions(self):
        """
        Retourne une liste de questions par défaut
        """
        return [
            {
                'id': '1',
                'question': 'Quelle est la capitale de la France?',
                'answers': ['Paris', 'Londres', 'Berlin', 'Madrid'],
                'correct': 'Paris',
                'anecdote': ''
            },
            {
                'id': '2',
                'question': 'Combien font 2 + 2?',
                'answers': ['4', '3', '5', '6'],
                'correct': '4',
                'anecdote': ''
            },
            {
                'id': '3',
                'question': 'De quelle couleur est le ciel par temps clair?',
                'answers': ['Bleu', 'Rouge', 'Vert', 'Jaune'],
                'correct': 'Bleu',
                'anecdote': ''
            }
        ]

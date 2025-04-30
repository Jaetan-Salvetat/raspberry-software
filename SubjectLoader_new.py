import os
import csv
import random
from PySide6.QtCore import QObject, Slot, Signal

class SubjectLoader(QObject):
    """
    Classe pour charger les questions de quiz à partir de fichiers CSV spécifiques à chaque matière
    """
    
    # Signal émis lorsque les questions sont chargées
    questionsLoaded = Signal(list)
    
    def __init__(self, parent=None):
        super().__init__(parent)
        self.questions = []
        print("SubjectLoader initialisé")
    
    @Slot(str, int, result="QVariantList")
    def loadQuestions(self, subject, age):
        """
        Charge les questions depuis un fichier CSV spécifique à la matière
        """
        print(f"Chargement des questions pour la matière: {subject}, âge: {age}")
        
        # Vérification du type de subject
        if not isinstance(subject, str):
            print(f"ERREUR: subject n'est pas une chaîne de caractères mais un {type(subject)}")
            # Convertir en chaîne de caractères si possible
            try:
                subject = str(subject)
                print(f"Conversion de subject en chaîne de caractères: {subject}")
            except:
                print("Impossible de convertir subject en chaîne de caractères")
                subject = "maths"  # Valeur par défaut
        
        # S'assurer que le sujet n'est pas vide
        if not subject or subject.strip() == "":
            print("ERREUR: subject est vide, utilisation de maths par défaut")
            subject = "maths"
        
        # Chemin du dossier quizzes
        quizzes_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "quizzes")
        
        # Force l'utilisation des fichiers CSV spécifiques à chaque matière
        if subject == "maths" or subject == "Maths" or subject == "mathématiques" or subject == "Mathématiques":
            print(f"DEBUG - Utilisation du fichier maths.csv pour la matière '{subject}'")
            csv_filename = "maths.csv"
        elif subject == "culturegeneral" or subject == "culturegénéral" or subject == "culture" or subject == "Culture Générale":
            print(f"DEBUG - Utilisation du fichier culturegeneral.csv pour la matière '{subject}'")
            csv_filename = "culturegeneral.csv"
        elif subject == "science" or subject == "sciences" or subject == "Sciences":
            print(f"DEBUG - Utilisation du fichier science.csv pour la matière '{subject}'")
            csv_filename = "science.csv"
        elif subject == "histoire" or subject == "history" or subject == "Histoire":
            print(f"DEBUG - Utilisation du fichier histoire.csv pour la matière '{subject}'")
            csv_filename = "histoire.csv"
        elif subject == "geographie" or subject == "géographie" or subject == "Géographie":
            print(f"DEBUG - Utilisation du fichier geographie.csv pour la matière '{subject}'")
            csv_filename = "geographie.csv"
        else:
            print(f"DEBUG - Matière '{subject}' non reconnue, utilisation de maths.csv par défaut")
            csv_filename = "maths.csv"
            
        file_path = os.path.join(quizzes_dir, csv_filename)
        print(f"DEBUG - Chemin du fichier CSV: {file_path}")
        
        # Vérifier si le fichier existe
        if not os.path.exists(file_path):
            print(f"ERREUR: Le fichier CSV '{file_path}' n'existe pas")
            return self.create_default_questions(subject)
        
        # Charger les questions depuis le fichier CSV
        try:
            questions = []
            with open(file_path, 'r', encoding='utf-8') as f:
                reader = csv.reader(f, delimiter=';')
                next(reader)  # Ignorer l'en-tête
                
                for row_num, row in enumerate(reader, 1):
                    if len(row) < 5:  # Vérifier qu'il y a assez de colonnes
                        print(f"AVERTISSEMENT: Ligne {row_num} ignorée, pas assez de colonnes")
                        continue
                    
                    # Déterminer la colonne de question en fonction de l'âge
                    question_col = 1  # Colonne par défaut (3-5 ans)
                    if 6 <= age <= 8:
                        question_col = 2
                    elif age >= 9:
                        question_col = 3
                    
                    # S'assurer que la colonne existe
                    if question_col >= len(row):
                        print(f"AVERTISSEMENT: Ligne {row_num} ignorée, colonne de question {question_col} n'existe pas")
                        continue
                    
                    question = row[question_col].strip()
                    if not question:
                        print(f"AVERTISSEMENT: Ligne {row_num} ignorée, pas de question pour l'âge {age}")
                        continue
                    
                    # Extraire les réponses possibles (colonnes 4 et suivantes)
                    answers = []
                    for i in range(4, min(8, len(row))):
                        if i < len(row) and row[i].strip():
                            answers.append(row[i].strip())
                    
                    # S'assurer qu'il y a au moins une réponse
                    if not answers:
                        print(f"AVERTISSEMENT: Ligne {row_num} ignorée, pas de réponses")
                        continue
                    
                    # La première réponse est considérée comme correcte
                    correct_answer = answers[0]
                    
                    # Mélanger les réponses
                    random.shuffle(answers)
                    
                    q = {
                        'question': question,
                        'answers': answers,
                        'correct': correct_answer
                    }
                    
                    questions.append(q)
                    print(f"Question ajoutée: {q['question']}")
            
            # Vérifier si des questions ont été chargées
            if not questions:
                print(f"AVERTISSEMENT: Aucune question chargée depuis {file_path}, utilisation de questions par défaut")
                return self.create_default_questions(subject)
            
            # Sélectionner 10 questions aléatoires (ou toutes si moins de 10)
            if len(questions) > 10:
                questions = random.sample(questions, 10)
            
            print(f"Nombre de questions chargées: {len(questions)}")
            return questions
            
        except Exception as e:
            print(f"Erreur lors du chargement des questions: {e}")
            return self.create_default_questions(subject)
    
    def create_default_questions(self, subject):
        """
        Retourne une liste de questions par défaut pour une matière donnée
        """
        print(f"Création de questions par défaut pour la matière: {subject}")
        
        # Questions par défaut pour les mathématiques
        if subject == "maths" or subject == "mathématiques":
            return [
                {
                    'question': 'Combien font 2 + 2 ?',
                    'answers': ['4', '3', '5', '6'],
                    'correct': '4'
                },
                {
                    'question': 'Combien font 5 x 3 ?',
                    'answers': ['15', '8', '12', '10'],
                    'correct': '15'
                },
                {
                    'question': 'Quel est le résultat de 10 - 7 ?',
                    'answers': ['3', '2', '4', '5'],
                    'correct': '3'
                }
            ]
        # Questions par défaut pour la culture générale
        elif subject == "culturegeneral" or subject == "culture":
            return [
                {
                    'question': 'Quelle est la capitale de la France ?',
                    'answers': ['Paris', 'Lyon', 'Marseille', 'Bordeaux'],
                    'correct': 'Paris'
                },
                {
                    'question': 'Qui a peint la Joconde ?',
                    'answers': ['Léonard de Vinci', 'Pablo Picasso', 'Vincent Van Gogh', 'Claude Monet'],
                    'correct': 'Léonard de Vinci'
                }
            ]
        # Questions par défaut pour les sciences
        elif subject == "science" or subject == "sciences":
            return [
                {
                    'question': 'Quelle est la formule chimique de l\'eau ?',
                    'answers': ['H2O', 'CO2', 'O2', 'H2SO4'],
                    'correct': 'H2O'
                },
                {
                    'question': 'Quelle planète est la plus proche du Soleil ?',
                    'answers': ['Mercure', 'Vénus', 'Terre', 'Mars'],
                    'correct': 'Mercure'
                }
            ]
        # Questions par défaut pour l'histoire
        elif subject == "histoire" or subject == "history":
            return [
                {
                    'question': 'En quelle année a eu lieu la Révolution française ?',
                    'answers': ['1789', '1914', '1945', '1815'],
                    'correct': '1789'
                },
                {
                    'question': 'Qui était le premier président des États-Unis ?',
                    'answers': ['George Washington', 'Abraham Lincoln', 'Thomas Jefferson', 'John Adams'],
                    'correct': 'George Washington'
                }
            ]
        # Questions par défaut pour la géographie
        elif subject == "geographie" or subject == "géographie":
            return [
                {
                    'question': 'Quel est le plus grand océan du monde ?',
                    'answers': ['Océan Pacifique', 'Océan Atlantique', 'Océan Indien', 'Océan Arctique'],
                    'correct': 'Océan Pacifique'
                },
                {
                    'question': 'Quel est le plus grand pays du monde en superficie ?',
                    'answers': ['Russie', 'Canada', 'Chine', 'États-Unis'],
                    'correct': 'Russie'
                }
            ]
        # Questions par défaut génériques pour les autres matières
        else:
            return [
                {
                    'question': 'Question par défaut 1',
                    'answers': ['Oui', 'Non', 'Peut-être'],
                    'correct': 'Oui'
                },
                {
                    'question': 'Question par défaut 2',
                    'answers': ['Vrai', 'Faux'],
                    'correct': 'Vrai'
                }
            ]

import os
import csv
import random
from PySide6.QtCore import QObject, Slot, Signal

class CSVLoader3Ans(QObject):
    """
    Classe spécialisée pour charger les questions depuis les fichiers CSV pour les enfants de 3 ans
    """
    
    # Signal émis lorsque les questions sont chargées
    questionsLoaded = Signal(list)
    
    def __init__(self, parent=None):
        super().__init__(parent)
        print("CSVLoader3Ans initialisé")
    
    @Slot(str, result="QVariantList")
    def loadQuestions(self, filename):
        """
        Charge les questions depuis un fichier CSV spécifique pour les enfants de 3 ans
        """
        print(f"Chargement des questions pour les enfants de 3 ans depuis: {filename}")
        
        # Chemin du dossier quizzes
        quizzes_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "quizzes")
        file_path = os.path.join(quizzes_dir, filename)
        
        print(f"Chemin du fichier: {file_path}")
        
        # Vérifier que le fichier existe
        if not os.path.exists(file_path):
            print(f"Erreur: Le fichier {file_path} n'existe pas")
            return []
        
        questions = []
        
        try:
            # Ouvrir le fichier CSV avec différents encodages possibles
            encodings = ['utf-8', 'latin-1', 'ISO-8859-1', 'cp1252']
            
            for encoding in encodings:
                try:
                    with open(file_path, encoding=encoding) as csvfile:
                        # Utiliser un sniffer pour détecter le délimiteur
                        dialect = csv.Sniffer().sniff(csvfile.read(1024))
                        csvfile.seek(0)
                        
                        # Si le sniffer n'a pas détecté de délimiteur, utiliser le point-virgule par défaut
                        if not dialect.delimiter or dialect.delimiter.isalnum():
                            dialect.delimiter = ';'
                        
                        reader = csv.reader(csvfile, dialect)
                        
                        # Ignorer l'en-tête
                        header = next(reader)
                        
                        # Utiliser directement les colonnes spécifiées
                        # Colonne B (indice 1) pour les questions
                        question_idx = 1
                        # Colonne C (indice 2) pour la bonne réponse
                        answer_idx = 2
                        # Colonnes D, E, F, G (indices 3, 4, 5, 6) pour les réponses proposées
                        choice_indices = [3, 4, 5, 6]
                        
                        print(f"Utilisation des colonnes fixes: Question={question_idx+1}, Réponse={answer_idx+1}, Choix={[i+1 for i in choice_indices]}")
                        
                        # Lire les données
                        for row in reader:
                            if len(row) <= max(question_idx, answer_idx, *choice_indices):
                                continue  # Ligne incomplète
                            
                            question_text = row[question_idx].strip()
                            correct_answer = row[answer_idx].strip()
                            
                            # Ignorer les lignes sans question ou réponse
                            if not question_text or not correct_answer:
                                continue
                            
                            # Récupérer les choix
                            choices = [correct_answer]  # Inclure la bonne réponse
                            for idx in choice_indices:
                                if idx < len(row) and row[idx].strip():
                                    choice = row[idx].strip()
                                    if choice and choice != correct_answer and choice not in choices:
                                        choices.append(choice)
                            
                            # S'assurer qu'il y a au moins 2 choix
                            if len(choices) < 2:
                                # Ajouter des choix par défaut si nécessaire
                                default_choices = ["Rouge", "Bleu", "Vert", "Jaune"]
                                for choice in default_choices:
                                    if choice not in choices:
                                        choices.append(choice)
                                    if len(choices) >= 4:
                                        break
                            
                            # Limiter à 4 choix maximum
                            if len(choices) > 4:
                                # Garder la bonne réponse et 3 autres choix aléatoires
                                other_choices = [c for c in choices if c != correct_answer]
                                random.shuffle(other_choices)
                                choices = [correct_answer] + other_choices[:3]
                            
                            # Mélanger les choix
                            random.shuffle(choices)
                            
                            # Créer la question
                            question = {
                                'question': question_text,
                                'answers': choices,
                                'correct': correct_answer
                            }
                            
                            questions.append(question)
                        
                        # Si des questions ont été trouvées, sortir de la boucle des encodages
                        if questions:
                            break
                    
                except Exception as e:
                    print(f"Erreur avec l'encodage {encoding}: {e}")
                    continue
            
            # Sélectionner 10 questions aléatoires (ou toutes si moins de 10)
            if len(questions) > 10:
                questions = random.sample(questions, 10)
            
            print(f"Nombre de questions chargées: {len(questions)}")
            return questions
            
        except Exception as e:
            print(f"Erreur lors du chargement des questions: {e}")
            return []

import os
import csv
import random
from PySide6.QtCore import QObject, Signal, Slot

class TestCSVLoader(QObject):
    def __init__(self):
        super().__init__()
        print("TestCSVLoader initialisé")
    
    def load_questions(self, filename):
        """
        Charge les questions depuis un fichier CSV spécifique pour les enfants de 3 ans
        """
        print(f"Chargement des questions depuis: {filename}")
        
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
                    print(f"Essai avec l'encodage: {encoding}")
                    with open(file_path, encoding=encoding) as csvfile:
                        content = csvfile.read(1024)
                        csvfile.seek(0)
                        
                        # Déterminer le délimiteur
                        delimiter = ';'
                        if ',' in content and ';' not in content:
                            delimiter = ','
                        
                        print(f"Utilisation du délimiteur: '{delimiter}'")
                        
                        reader = csv.reader(csvfile, delimiter=delimiter)
                        
                        # Afficher l'en-tête pour vérification
                        header = next(reader)
                        print(f"En-tête: {header}")
                        
                        # Utiliser directement les colonnes spécifiées
                        # Colonne B (indice 1) pour les questions
                        question_idx = 1
                        # Colonne C (indice 2) pour la bonne réponse
                        answer_idx = 2
                        # Colonnes D, E, F, G (indices 3, 4, 5, 6) pour les réponses proposées
                        choice_indices = [3, 4, 5, 6]
                        
                        print(f"Utilisation des colonnes: Question={question_idx+1}, Réponse={answer_idx+1}, Choix={[i+1 for i in choice_indices]}")
                        
                        # Lire les données
                        row_count = 0
                        for row in reader:
                            row_count += 1
                            print(f"Ligne {row_count}: {row}")
                            
                            if len(row) <= max(question_idx, answer_idx):
                                print(f"  Ligne incomplète, ignorée")
                                continue
                            
                            question_text = row[question_idx].strip() if question_idx < len(row) else ""
                            correct_answer = row[answer_idx].strip() if answer_idx < len(row) else ""
                            
                            # Ignorer les lignes sans question ou réponse
                            if not question_text or not correct_answer:
                                print(f"  Question ou réponse vide, ignorée")
                                continue
                            
                            # Récupérer les choix
                            choices = [correct_answer]  # Inclure la bonne réponse
                            for idx in choice_indices:
                                if idx < len(row) and row[idx].strip():
                                    choice = row[idx].strip()
                                    if choice and choice != correct_answer and choice not in choices:
                                        choices.append(choice)
                            
                            print(f"  Question: {question_text}")
                            print(f"  Réponse correcte: {correct_answer}")
                            print(f"  Choix: {choices}")
                            
                            # S'assurer qu'il y a au moins 2 choix
                            if len(choices) < 2:
                                print(f"  Pas assez de choix, ajout de choix par défaut")
                                # Ajouter des choix par défaut si nécessaire
                                default_choices = ["Rouge", "Bleu", "Vert", "Jaune"]
                                for choice in default_choices:
                                    if choice not in choices:
                                        choices.append(choice)
                                    if len(choices) >= 4:
                                        break
                            
                            # Limiter à 4 choix maximum
                            if len(choices) > 4:
                                print(f"  Trop de choix, limitation à 4")
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
                            print(f"  Question ajoutée: {question}")
                        
                        # Si des questions ont été trouvées, sortir de la boucle des encodages
                        if questions:
                            print(f"Questions trouvées avec l'encodage {encoding}, sortie de la boucle")
                            break
                    
                except Exception as e:
                    print(f"Erreur avec l'encodage {encoding}: {e}")
                    continue
            
            print(f"Nombre total de questions chargées: {len(questions)}")
            return questions
            
        except Exception as e:
            print(f"Erreur lors du chargement des questions: {e}")
            return []

# Exécuter le test
if __name__ == "__main__":
    loader = TestCSVLoader()
    questions = loader.load_questions("couleurs.csv")
    
    print("\nRésumé des questions chargées:")
    for i, q in enumerate(questions):
        print(f"{i+1}. {q['question']} - Réponse: {q['correct']} - Choix: {q['answers']}")

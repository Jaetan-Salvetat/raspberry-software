import csv
import random
import os
from PySide6.QtCore import QObject, Slot, Signal, Property

class QuizController(QObject):
    questionChanged = Signal(dict)

    def __init__(self):
        super().__init__()
        self.questions = []
        self.current_question = None

    @Slot(str, int, result="QVariant")
    def loadQuestions(self, matiere, age):
        print(f"Recherche de questions pour la matière: {matiere}, âge: {age}")
        # Chemin du dossier quizzes (relatif au dossier courant)
        quizzes_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "quizzes")
        
        # Déterminer le nom du fichier CSV en fonction de la matière
        try:
            # Utiliser le même format que dans TestPage3.qml
            questions = []
            
            # Chemin du fichier CSV
            csv_filename = f"{matiere}.csv"
            print(f"Chargement des questions depuis {csv_filename}")
            
            # Utiliser directement les colonnes B, C, D, E, F, G pour toutes les questions
            # B (indice 1) pour les questions
            # C (indice 2) pour les bonnes réponses
            # D, E, F, G (indices 3, 4, 5, 6) pour les propositions de réponses
            question_index = 1  # Colonne B
            answer_index = 2    # Colonne C
            choices_indices = [3, 4, 5, 6]  # Colonnes D, E, F, G
            
            # Chemin du dossier quizzes
            quizzes_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "quizzes")
            file_path = os.path.join(quizzes_dir, csv_filename)
            
            # Vérifier que le fichier existe
            if not os.path.exists(file_path):
                print(f"Erreur: Le fichier {file_path} n'existe pas")
                return self._getDefaultQuestions()
            
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
                    
                    # Vérifier que la question et la réponse ne sont pas vides
                    if not question_text or not correct_answer:
                        print(f"Ligne {row_num} ignorée car question ou réponse vide")
                        continue
                    
                    # Récupérer les choix de réponses
                    choices = []
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
            
        except Exception as e:
            print(f"Erreur lors du chargement des questions: {e}")
            return self._getDefaultQuestions()
        
        # Réinitialiser l'index et le score
        self.currentQuestionIndex = 0
        self.score = 0
        
        # Utiliser la première question pour commencer
        if self.questions:
            self.current_question = self.questions[0]
            self.questionChanged.emit(self.current_question)
        
        return self.questions
    
    def _getDefaultQuestions(self):
        """Retourne un ensemble de questions par défaut en cas d'erreur"""
        print("Utilisation des questions par défaut")
        
        # Questions par défaut
        default_questions = [
            {
                "id": "1",
                "question": "Quelle est la couleur du ciel ?",
                "answers": ["Bleu", "Rouge", "Vert", "Jaune"],
                "correct": "Bleu",
                "anecdote": "Le ciel apparaît bleu à cause de la diffusion de la lumière."
            },
            {
                "id": "2",
                "question": "Combien font 2 + 2 ?",
                "answers": ["3", "4", "5", "6"],
                "correct": "4",
                "anecdote": "L'addition est une opération mathématique de base."
            },
            {
                "id": "3",
                "question": "Quelle est la capitale de la France ?",
                "answers": ["Londres", "Berlin", "Paris", "Madrid"],
                "correct": "Paris",
                "anecdote": "Paris est surnommée la Ville Lumière."
            },
            {
                "id": "4",
                "question": "Quel animal miaule ?",
                "answers": ["Chien", "Chat", "Vache", "Poule"],
                "correct": "Chat",
                "anecdote": "Les chats communiquent par miaulements."
            },
            {
                "id": "5",
                "question": "Quelle est la couleur d'une banane mûre ?",
                "answers": ["Verte", "Rouge", "Jaune", "Bleue"],
                "correct": "Jaune",
                "anecdote": "Les bananes sont d'abord vertes puis deviennent jaunes en mûrissant."
            },
            {
                "id": "6",
                "question": "Combien de pattes a une araignée ?",
                "answers": ["4", "6", "8", "10"],
                "correct": "8",
                "anecdote": "Les araignées ont 8 pattes et font partie des arachnides."
            },
            {
                "id": "7",
                "question": "Quelle est la forme de la Terre ?",
                "answers": ["Plate", "Carrée", "Ronde", "Triangulaire"],
                "correct": "Ronde",
                "anecdote": "La Terre est en réalité un sphéroïde aplati aux pôles."
            },
            {
                "id": "8",
                "question": "Quel est le plus grand océan du monde ?",
                "answers": ["Atlantique", "Indien", "Arctique", "Pacifique"],
                "correct": "Pacifique",
                "anecdote": "L'océan Pacifique couvre environ un tiers de la surface de la Terre."
            },
            {
                "id": "9",
                "question": "Combien de jours y a-t-il dans une semaine ?",
                "answers": ["5", "6", "7", "8"],
                "correct": "7",
                "anecdote": "Les 7 jours de la semaine sont nommés d'après des planètes et divinités."
            },
            {
                "id": "10",
                "question": "Quel est le plus grand mammifère terrestre ?",
                "answers": ["Girafe", "Éléphant d'Afrique", "Rhinocéros", "Hippopotame"],
                "correct": "Éléphant d'Afrique",
                "anecdote": "L'éléphant d'Afrique peut peser jusqu'à 7 tonnes."
            }
        ]
        
        # Mélanger les questions
        random.shuffle(default_questions)
        
        # Limiter à 10 questions
        self.questions = default_questions[:10]
        
        # Utiliser la première question pour commencer
        if self.questions:
            self.current_question = self.questions[0]
            self.questionChanged.emit(self.current_question)
        
        return self.questions
    
    @Slot()
    def nextQuestion(self):
        if self.currentQuestionIndex < len(self.questions) - 1:
            self.currentQuestionIndex += 1
            self.current_question = self.questions[self.currentQuestionIndex]
            self.questionChanged.emit(self.current_question)
            return True
        return False
    
    @Slot()
    def previousQuestion(self):
        if self.currentQuestionIndex > 0:
            self.currentQuestionIndex -= 1
            self.current_question = self.questions[self.currentQuestionIndex]
            self.questionChanged.emit(self.current_question)
            return True
        return False
    
    @Slot(str)
    def checkAnswer(self, answer):
        if self.current_question and answer == self.current_question["correct"]:
            self.score += 1
            return True
        return False
    
    @Slot(result=int)
    def getScore(self):
        return self.score
    
    @Slot(result=int)
    def getQuestionCount(self):
        return len(self.questions)
    
    @Slot(result=int)
    def getCurrentQuestionIndex(self):
        return self.currentQuestionIndex
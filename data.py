import csv
import random

class Question:
    list_questions = []

    def __init__(self, quiz_type):
        self.quiz_type = quiz_type  # Type de quiz (maths, code, etc.)
        self.id = None
        self.question = None
        self.rep1 = None
        self.rep2 = None
        self.rep3 = None
        self.rep4 = None
        self.anecdote = None
        self.reponse = None

    def load_question(self):
        file_name = f"{self.quiz_type}.csv"  # Exemple : "maths.csv", "code.csv", etc.
        self.list_questions = []  # Réinitialiser la liste des questions

        try:
            with open(file_name, encoding="ISO-8859-1") as csvfile:
                reader = csv.reader(csvfile, delimiter=";", quotechar="'")
                for item in reader:
                    q = Question(self.quiz_type)
                    q.id = item[0]
                    q.question = item[2]
                    q.rep1 = item[3]
                    q.rep2 = item[4]
                    q.rep3 = item[5]
                    q.rep4 = item[6]
                    q.anecdote = item[8]
                    q.reponse = item[3]

                    self.list_questions.append(q)

            question = random.choice(self.list_questions)
            return question

        except FileNotFoundError:
            print(f"Erreur : Le fichier {file_name} n'a pas été trouvé.")
            return None

    def remove_question(self, q):
        self.list_questions.remove(q)

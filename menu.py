from tkinter import *
from data import Question  # Assurez-vous que vous avez bien la classe Question dans data.py
import tkinter.messagebox as messagebox
import QuizInterface  # Pour démarrer l'interface du quiz

class Menu:
    def __init__(self, type1, type2, folder_path=""):
        
        self.type1 = type1  # Le type général (ex: 'general')
        self.type2 = type2  # Le type spécifique (ex: 'maths')
        self.folder_path = folder_path  # Chemin vers le dossier où les fichiers CSV sont stockés
        self.window = Tk()
        self.window.title(f"{type1} & {type2} Quiz")
        self.window.geometry("800x500")
        self.window.resizable(False, False)

        # Initialiser la question avec le type de quiz et le dossier des fichiers CSV
        self.question = Question(self.type1, self.folder_path)
        self.current_question = self.question.load_question()  # Charger une question depuis le fichier CSV

        self.good_answer = 0
        self.question_number = 1

        # Affichage des résultats
        self.lbl_resultat = Label(self.window, text=f"Question n° {self.question_number}/10 {self.good_answer} bonne(s) réponse(s)", font=("Calibri", 12, "bold"))
        self.lbl_resultat.pack(pady=10)

        # Affichage de la question
        self.txt_question = Message(self.window, text="Une question ?", font=("Calibri", 16, "bold"), width=750)
        self.txt_question.pack(pady=20)

        font_button = "Calibri 12"

        # Réponses sous forme de boutons
        self.frm1 = Frame(self.window)
        self.frm1.pack(pady=20)

        self.btn1 = Button(self.frm1, text="Réponse 1", font=font_button, width=30, height=3, command=lambda: self.check_answer(self.btn1))
        self.btn1.pack(side=LEFT, padx=40)

        self.btn2 = Button(self.frm1, text="Réponse 2", font=font_button, width=30, height=3, command=lambda: self.check_answer(self.btn2))
        self.btn2.pack(side=LEFT, padx=40)

        self.frm2 = Frame(self.window)
        self.frm2.pack(pady=20)

        self.btn3 = Button(self.frm2, text="Réponse 3", font=font_button, width=30, height=3, command=lambda: self.check_answer(self.btn3))
        self.btn3.pack(side=LEFT, padx=40)

        self.btn4 = Button(self.frm2, text="Réponse 4", font=font_button, width=30, height=3, command=lambda: self.check_answer(self.btn4))
        self.btn4.pack(side=LEFT, padx=40)

        self.txt_anecdote = Message(self.window, font="Calibri 16", width=750)
        self.txt_anecdote.pack(side=BOTTOM, pady=20)

        self.show_question()

    def show_question(self):
        """Afficher la question et les réponses"""
        self.txt_question.config(text=self.current_question.question)
        self.btn1.config(text=self.current_question.rep1)
        self.btn2.config(text=self.current_question.rep2)
        self.btn3.config(text=self.current_question.rep3)
        self.btn4.config(text=self.current_question.rep4)

    def check_answer(self, button):
        """Vérifier si la réponse est correcte"""
        if button.cget("text") == self.current_question.reponse:
            button.config(bg="LightGreen", state=DISABLED)
            self.good_answer += 1
        else:
            button.config(bg="Tomato")
            for btn in [self.btn1, self.btn2, self.btn3, self.btn4]:
                btn.config(state=DISABLED)

        # Afficher la bonne réponse
        for btn in [self.btn1, self.btn2, self.btn3, self.btn4]:
            if btn.cget("text") == self.current_question.reponse:
                btn.config(bg="LightGreen")

        self.txt_anecdote.config(text=self.current_question.anecdote)

        # Passer à la question suivante après 5 secondes
        self.after(5000, self.next_question)

    def next_question(self):
        """Passer à la question suivante"""
        self.question_number += 1
        self.lbl_resultat.config(text=f"Question n° {self.question_number}/10 {self.good_answer} bonne(s) réponse(s)")

        if self.question_number == 11:
            msg = f"Résultat : {self.good_answer} bonne(s) réponse(s) sur 10 questions.\nMerci d'avoir joué à ce quiz."
            messagebox.showinfo("Partie terminée", msg)
            self.window.quit()
            return

        self.current_question = self.question.load_question()  # Chargement d'une nouvelle question
        self.show_question()

    def run(self):
        """Lancer l'interface"""
        self.window.mainloop()


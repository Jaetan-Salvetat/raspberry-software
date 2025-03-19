from tkinter import *
import tkinter.messagebox as messagebox
from data import Question
import os
class QuizInterface(Tk):
    def __init__(self, quiz_type, folder_path=""):
        super().__init__()

        self.quiz_type = quiz_type  # Le type de quiz(maths, code, etc.)
        self.quiz_type = quiz_type
        self.folder_path = folder_path
        self.file_path = os.path.join(self.folder_path, f"{self.quiz_type}.csv")
        print(f"Fichier CSV attendu: {self.file_path}")

        # Si vous devez charger des questions depuis le CSV, assurez-vous de traiter le fichier ici.
        if os.path.exists(self.file_path):
            # Code pour charger les questions
            pass
        else:
            print(f"Le fichier {self.file_path} n'existe pas.")
        
        
        
        
        self.title(f"Quiz - {quiz_type.capitalize()}")
        screen_width = self.winfo_screenwidth()
        screen_height = self.winfo_screenheight()
        w = int(screen_width / 2 - 800 / 2)
        h = int(screen_height / 2 - 500 / 2)
        self.geometry(f"800x500+{w}+{h}")
        self.resizable(False, False)

        # Initialisation de la question
        self.question = Question(self.quiz_type)  # On passe le type de quiz à la classe Question
        self.good_answer = 0
        self.question_number = 1

        self.lbl_resultat = Label(self, text=f"Question n° {self.question_number}/10 {self.good_answer} bonne(s) réponse(s)")
        self.lbl_resultat.pack()

        self.txt_question = Message(self, text="Une question ?", font=("Calibri", 16, "bold"), width=750)
        self.txt_question.pack()

        font_button = "Calibri 12"

        self.frm1 = Frame(self)
        self.frm1.pack(pady=20)

        self.btn1 = Button(self.frm1, text="Réponse 1", font=font_button, width=30, height=5,
                           command=lambda: self.check_answer(self.btn1))
        self.btn1.pack(side=LEFT, padx=40)

        self.btn2 = Button(self.frm1, text="Réponse 2", font=font_button, width=30, height=5,
                           command=lambda: self.check_answer(self.btn2))
        self.btn2.pack(side=LEFT, padx=40)

        self.frm2 = Frame(self)
        self.frm2.pack(pady=20)

        self.btn3 = Button(self.frm2, text="Réponse 3", font=font_button, width=30, height=5,
                           command=lambda: self.check_answer(self.btn3))
        self.btn3.pack(side=LEFT, padx=40)

        self.btn4 = Button(self.frm2, text="Réponse 4", font=font_button, width=30, height=5,
                           command=lambda: self.check_answer(self.btn4))
        self.btn4.pack(side=LEFT, padx=40)

        self.txt_anecdote = Message(self, font="Calibri 16", width=750)
        self.txt_anecdote.pack(side=BOTTOM, pady=20)

        # Charger la première question en fonction du quiz_type
        self.q = self.question.load_question()
        self.show_question()

        self.btn_color = self.btn1.cget("bg")
        self.buttons = [self.btn1, self.btn2, self.btn3, self.btn4]

    def show_question(self):
        """Afficher la question et les réponses"""
        self.txt_question.config(text=self.q.question)
        self.btn1.config(text=self.q.rep1)
        self.btn2.config(text=self.q.rep2)
        self.btn3.config(text=self.q.rep3)
        self.btn4.config(text=self.q.rep4)

    def check_answer(self, button):
        """Vérifier si la réponse est correcte"""
        if button.cget("text") == self.q.reponse:
            button.config(bg="LightGreen", state=DISABLED)
            self.good_answer += 1
        else:
            button.config(bg="Tomato")
            for btn in self.buttons:
                btn.config(state=DISABLED)

        # Afficher la bonne réponse
        for btn in self.buttons:
            if btn.cget("text") == self.q.reponse:
                btn.config(bg="LightGreen")

        self.txt_anecdote.config(text=self.q.anecdote)

        # Passer à la question suivante après 5 secondes
        self.after(5000, self.next_question)

    def next_question(self):
        """Passer à la question suivante"""
        self.question_number += 1
        self.lbl_resultat.config(text=f"Question n° {self.question_number}/10 {self.good_answer} bonne(s) réponse(s)")

        if self.question_number == 11:
            msg = f"Résultat : {self.good_answer} bonne(s) réponse(s) sur 10 questions.\nMerci d'avoir joué à ce quiz."
            messagebox.showinfo("Partie terminée", msg)
            self.quit()
            return

        for btn in self.buttons:
            btn.config(bg=self.btn_color, state=NORMAL)

        self.txt_anecdote.config(text="")
        self.q = self.question.load_question()
        self.show_question()

if __name__ == "__main__":
    quiz_interface = QuizInterface(quiz_type="maths")  # Spécifiez ici le type de quiz à lancer
    quiz_interface.mainloop()

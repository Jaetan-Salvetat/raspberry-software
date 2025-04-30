import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "."

Page {
    id: quizSimpleInterface
    background: Rectangle { color: "#F5F5F5" }
    
    // Propriétés pour les paramètres du quiz
    property string questionSubject: "maths"
    property int selectedAge: 6
    property int correctAnswers: 0
    property int questionNumber: 1
    property int totalQuestions: 10
    
    // Questions et état
    property var questions: []
    property var currentQuestion: null
    property bool questionAnswered: false
    
    // Symboles pour les boutons de réponse
    property var buttonSymbols: [
        "▲",  // Triangle
        "◆",  // Losange
        "●",  // Cercle
        "■"   // Carré
    ]
    
    // Couleurs pour les boutons de réponse
    property var buttonColors: [
        "#2979FF", // Bleu
        "#FFC107", // Jaune/Orange
        "#9C27B0", // Violet
        "#FF5722"  // Orange
    ]
    
    // Charger les questions depuis le CSV
    function loadQuestions() {
        console.log("Chargement des questions pour: " + questionSubject + ", âge: " + selectedAge)
        
        try {
            // Déterminer le nom du fichier CSV en fonction de la matière
            var filename = questionSubject.toLowerCase()
            
            console.log("DEBUG - Vérification des chargeurs disponibles:")
            console.log("DEBUG - csvReader disponible: " + (typeof csvReader !== "undefined" && csvReader !== null))
            console.log("DEBUG - subjectLoader disponible: " + (typeof subjectLoader !== "undefined" && subjectLoader !== null))
            
            // Mapping des matières vers les noms de fichiers pour les enfants de 3 ans
            if (selectedAge === 3) {
                if (filename === "couleurs") {
                    console.log("Utilisation du fichier couleurs.csv")
                } else if (filename === "formes") {
                    console.log("Utilisation du fichier formes.csv")
                } else if (filename === "animaux") {
                    console.log("Utilisation du fichier animaux.csv")
                } else if (filename === "corps humain") {
                    filename = "corps humain"
                    console.log("Utilisation du fichier corps humain.csv")
                } else if (filename === "sons") {
                    console.log("Utilisation du fichier sons.csv")
                } else if (filename === "objets") {
                    console.log("Utilisation du fichier objets.csv")
                } else if (filename === "émotions" || filename === "emotions") {
                    filename = "emotions"
                    console.log("Utilisation du fichier emotions.csv")
                } else {
                    console.log("Matière non reconnue pour l'âge 3 ans: " + filename + ", utilisation du fichier couleurs.csv par défaut")
                    filename = "couleurs"
                }
            } else {
                // Mapping pour les autres âges
                if (filename === "culturegénéral") {
                    console.log("Utilisation du fichier culturegeneral.csv")
                    filename = "culturegeneral"
                } else if (filename === "géographie") {
                    console.log("Utilisation du fichier geographie.csv")
                    filename = "geographie"
                } else if (filename === "science") {
                    console.log("Utilisation du fichier science.csv")
                } else if (filename === "histoire") {
                    console.log("Utilisation du fichier histoire.csv")
                } else if (filename === "maths") {
                    console.log("Utilisation du fichier maths.csv")
                } else {
                    console.log("Matière non reconnue: " + filename + ", utilisation du fichier maths.csv par défaut")
                    filename = "maths"
                }
            }
            
            console.log("DEBUG - Tentative de chargement du fichier: " + filename + ".csv")
            
            // Essayer de charger les questions depuis les fichiers CSV
            var result = null
            
            // Pour les enfants de 3 ans, utiliser notre chargeur spécialisé
            if (selectedAge === 3 && typeof csvLoader3Ans !== "undefined" && csvLoader3Ans !== null) {
                console.log("Utilisation du chargeur spécialisé pour les enfants de 3 ans")
                try {
                    result = csvLoader3Ans.loadQuestions(filename + ".csv")
                    console.log("Résultat du chargement avec csvLoader3Ans: " + (result ? "OK, " + result.length + " questions" : "NULL"))
                } catch (e) {
                    console.error("Erreur lors du chargement avec csvLoader3Ans: " + e)
                }
            }
            
            // Si le chargeur spécialisé a échoué ou pour les autres âges, essayer avec csvReader
            if (!result && typeof csvReader !== "undefined" && csvReader !== null) {
                console.log("Tentative avec csvReader pour charger " + filename + ".csv")
                try {
                    result = csvReader.loadQuestions(filename + ".csv", selectedAge)
                    console.log("Résultat du chargement avec csvReader: " + (result ? "OK, " + result.length + " questions" : "NULL"))
                } catch (e) {
                    console.error("Erreur lors du chargement avec csvReader: " + e)
                }
            }
            
            // Si csvReader a échoué, essayer avec subjectLoader
            if (!result && typeof subjectLoader !== "undefined" && subjectLoader !== null) {
                console.log("Tentative avec subjectLoader pour charger " + filename)
                try {
                    result = subjectLoader.loadQuestions(filename, selectedAge)
                    console.log("Résultat du chargement avec subjectLoader: " + (result ? "OK, " + result.length + " questions" : "NULL"))
                } catch (e) {
                    console.error("Erreur lors du chargement avec subjectLoader: " + e)
                }
            }
            
            if (result && result.length > 0) {
                questions = result
                console.log("Questions chargées avec succès: " + questions.length + " questions")
            } else {
                console.log("Aucune question chargée depuis les fichiers CSV, utilisation des questions par défaut")
                questions = createDefaultQuestions(filename)
                console.log("Questions par défaut créées: " + questions.length + " questions")
            }
            
            if (questions && questions.length > 0) {
                currentQuestion = questions[0]
                questionNumber = 1
                totalQuestions = questions.length
                console.log("Première question: " + currentQuestion.question)
            } else {
                console.error("Aucune question trouvée")
                currentQuestion = {
                    question: "Aucune question disponible",
                    answers: ["Retour"],
                    correct: "Retour"
                }
            }
        } catch (e) {
            console.error("Erreur: " + e)
            currentQuestion = {
                question: "Erreur: " + e,
                answers: ["Retour"],
                correct: "Retour"
            }
        }
    }
    
    // Créer des questions par défaut pour une matière donnée
    function createDefaultQuestions(subject) {
        console.log("Création de questions par défaut pour la matière: " + subject)
        
        // Questions par défaut pour les différentes matières
        if (subject === "couleurs") {
            return [
                {
                    question: "Quelle est la couleur du ciel ?",
                    answers: ["Bleu", "Rouge", "Vert", "Jaune"],
                    correct: "Bleu"
                },
                {
                    question: "Quelle est la couleur de l'herbe ?",
                    answers: ["Vert", "Rouge", "Bleu", "Jaune"],
                    correct: "Vert"
                },
                {
                    question: "Quelle est la couleur d'une fraise ?",
                    answers: ["Rouge", "Vert", "Bleu", "Jaune"],
                    correct: "Rouge"
                }
            ]
        } else if (subject === "formes") {
            return [
                {
                    question: "Quelle forme a une balle ?",
                    answers: ["Cercle", "Carré", "Triangle", "Rectangle"],
                    correct: "Cercle"
                },
                {
                    question: "Quelle forme a une boîte ?",
                    answers: ["Carré", "Cercle", "Triangle", "Étoile"],
                    correct: "Carré"
                }
            ]
        } else if (subject === "animaux") {
            return [
                {
                    question: "Quel animal fait 'miaou' ?",
                    answers: ["Chat", "Chien", "Vache", "Mouton"],
                    correct: "Chat"
                },
                {
                    question: "Quel animal fait 'meuh' ?",
                    answers: ["Vache", "Chien", "Chat", "Poule"],
                    correct: "Vache"
                }
            ]
        } else if (subject === "corps humain") {
            return [
                {
                    question: "Avec quoi voit-on ?",
                    answers: ["Les yeux", "Les oreilles", "Le nez", "La bouche"],
                    correct: "Les yeux"
                },
                {
                    question: "Avec quoi entend-on ?",
                    answers: ["Les oreilles", "Les yeux", "Le nez", "La bouche"],
                    correct: "Les oreilles"
                }
            ]
        } else if (subject === "sons") {
            return [
                {
                    question: "Quel animal fait 'wouf wouf' ?",
                    answers: ["Chien", "Chat", "Vache", "Mouton"],
                    correct: "Chien"
                },
                {
                    question: "Quel animal fait 'cocorico' ?",
                    answers: ["Coq", "Poule", "Canard", "Dinde"],
                    correct: "Coq"
                }
            ]
        } else if (subject === "objets") {
            return [
                {
                    question: "Avec quoi mange-t-on ?",
                    answers: ["Cuillère", "Ballon", "Crayon", "Livre"],
                    correct: "Cuillère"
                },
                {
                    question: "Avec quoi écrit-on ?",
                    answers: ["Crayon", "Ballon", "Cuillère", "Chaise"],
                    correct: "Crayon"
                }
            ]
        } else if (subject === "emotions") {
            return [
                {
                    question: "Comment te sens-tu quand tu reçois un cadeau ?",
                    answers: ["Content", "Triste", "En colère", "Peur"],
                    correct: "Content"
                },
                {
                    question: "Comment te sens-tu quand tu perds ton jouet préféré ?",
                    answers: ["Triste", "Content", "En colère", "Surpris"],
                    correct: "Triste"
                }
            ]
        } else if (subject === "mathématiques" || subject === "mathematiques" || subject === "maths") {
            return [
                {
                    question: "mathématique",
                    answers: ["La neige", "merde", "L'eau", "Le sable"],
                    correct: "La neige"
                },
                {
                    question: "Quelle forme est un ballon ?",
                    answers: ["Rond", "Carré", "Triangle", "Rectangle"],
                    correct: "Rond"
                },
                {
                    question: "Combien font 1 + 1 ?",
                    answers: ["2", "1", "3", "4"],
                    correct: "2"
                },
                {
                    question: "Quel est le plus grand ?",
                    answers: ["Éléphant", "Souris", "Chat", "Fourmi"],
                    correct: "Éléphant"
                },
                {
                    question: "Combien de doigts as-tu sur une main ?",
                    answers: ["5", "3", "4", "10"],
                    correct: "5"
                },
                {
                    question: "Quelle forme est une boîte ?",
                    answers: ["Carré", "Cercle", "Triangle", "Ovale"],
                    correct: "Carré"
                },
                {
                    question: "Quelle couleur est le ciel ?",
                    answers: ["Bleu", "Vert", "Rouge", "Jaune"],
                    correct: "Bleu"
                },
                {
                    question: "Quel animal est le plus petit ?",
                    answers: ["Fourmi", "Chien", "Vache", "Lion"],
                    correct: "Fourmi"
                },
                {
                    question: "Combien font 2 + 1 ?",
                    answers: ["3", "2", "4", "5"],
                    correct: "3"
                },
                {
                    question: "Quelle forme est le soleil ?",
                    answers: ["Cercle", "Carré", "Triangle", "Rectangle"],
                    correct: "Cercle"
                }
            ]
        } else {
            // Questions génériques par défaut
            return [
                {
                    question: "Question par défaut 1",
                    answers: ["Réponse 1", "Réponse 2", "Réponse 3", "Réponse 4"],
                    correct: "Réponse 1"
                },
                {
                    question: "Question par défaut 2",
                    answers: ["Réponse 1", "Réponse 2", "Réponse 3", "Réponse 4"],
                    correct: "Réponse 1"
                }
            ]
        }
    }
    
    // Vérifier si la réponse est correcte
    function checkAnswer(index) {
        if (!questionAnswered) {
            questionAnswered = true
            
            var selectedAnswer = currentQuestion.answers[index]
            var isCorrect = (selectedAnswer === currentQuestion.correct)
            
            if (isCorrect) {
                correctAnswers++
                console.log("Bonne réponse!")
            } else {
                console.log("Mauvaise réponse!")
            }
            
            // Passer à la question suivante après 2 secondes
            autoNextTimer.start()
        }
    }
    
    // Passer à la question suivante
    function nextQuestion() {
        questionNumber++
        questionAnswered = false
        
        if (questionNumber > questions.length) {
            // Fin du quiz
            stackView.pop()
        } else {
            currentQuestion = questions[questionNumber - 1]
            
            // Réinitialiser les couleurs des boutons
            resetButtonColors()
        }
    }
    
    // Réinitialiser les couleurs des boutons
    function resetButtonColors() {
        // Cette fonction sera appelée pour réinitialiser les couleurs des boutons
        // à chaque nouvelle question
        console.log("Réinitialisation des couleurs des boutons")
        
        // Attendre que les éléments du Repeater soient créés
        Qt.callLater(function() {
            for (var i = 0; i < buttonRepeater.count; i++) {
                var item = buttonRepeater.itemAt(i)
                if (item) {
                    item.color = buttonColors[i]
                    console.log("Bouton " + i + " réinitialisé à la couleur " + buttonColors[i])
                }
            }
        })
    }
    
    // Initialisation
    Component.onCompleted: {
        loadQuestions()
    }
    
    // Timer pour passer automatiquement à la question suivante
    Timer {
        id: autoNextTimer
        interval: 2000
        repeat: false
        onTriggered: {
            nextQuestion()
        }
    }
    
    // Bouton de retour en haut à gauche
    RoundButton {
        id: backButton
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 16
        icon.source: "assets/icons/arrow_back.svg"
        icon.width: 32
        icon.height: 32
        flat: true
        onClicked: stackView.pop()
        z: 10 // S'assurer que le bouton est au-dessus des autres éléments
    }
    
    // Interface utilisateur principale
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        
        // Espace pour le bouton de retour
        Item {
            Layout.preferredHeight: 40
        }
        
        // Barre de score en haut
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: "#E8F5E9"
            border.color: "#81C784"
            border.width: 1
            radius: 20
            
            Rectangle {
                anchors.centerIn: parent
                width: scoreText.width + 40
                height: 30
                radius: 15
                color: "#81C784"
                
                Text {
                    id: scoreText
                    anchors.centerIn: parent
                    text: "Question " + questionNumber + "/" + totalQuestions + " - Score: " + correctAnswers
                    color: "black"
                    font.pixelSize: 16
                    font.bold: true
                }
            }
        }
        
        Item { Layout.preferredHeight: 20 } // Espacement
        
        // Zone de question
        Rectangle {
            Layout.fillWidth: true
            Layout.margins: 20
            Layout.preferredHeight: parent.height * 0.25
            color: "#FFE082" // Jaune pastel
            radius: 20
            border.color: "#FFD54F"
            border.width: 2
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20
                
                // Icône point d'interrogation
                Rectangle {
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 60
                    radius: 30
                    color: "#FFC107"
                    
                    Text {
                        anchors.centerIn: parent
                        text: "?"
                        color: "black"
                        font.pixelSize: 36
                        font.bold: true
                    }
                }
                
                // Texte de la question
                Text {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: currentQuestion ? currentQuestion.question : "Chargement..."
                    color: "black"
                    font.pixelSize: 84 // Texte agrandi x3
                    font.bold: true
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        
        Item { Layout.preferredHeight: 20 } // Espacement
        
        // Grille de boutons de réponse
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            columns: 2
            rows: 2
            columnSpacing: 20
            rowSpacing: 20
            
            Repeater {
                id: buttonRepeater
                model: currentQuestion ? Math.min(currentQuestion.answers.length, 4) : 0
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: buttonColors[index]
                    radius: 10
                    
                    property bool isCorrect: currentQuestion ? 
                                            currentQuestion.answers[index] === currentQuestion.correct : false
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15
                        
                        // Symbole géométrique
                        Text {
                            text: buttonSymbols[index]
                            color: "white"
                            font.pixelSize: 72 // Agrandi x2
                            font.bold: true
                        }
                        
                        // Texte de la réponse
                        Text {
                            Layout.fillWidth: true
                            text: currentQuestion ? currentQuestion.answers[index] : ""
                            color: "white"
                            font.pixelSize: 72 // Agrandi x3
                            font.bold: true
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }
                    }
                    
                    // Zone de clic
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (!questionAnswered) {
                                checkAnswer(index)
                                
                                // Effet visuel pour la réponse
                                if (isCorrect) {
                                    parent.color = "#4CAF50" // Vert pour bonne réponse
                                } else {
                                    parent.color = "#F44336" // Rouge pour mauvaise réponse
                                    
                                    // Mettre en évidence la bonne réponse
                                    for (var i = 0; i < 4; i++) {
                                        var item = repeater.itemAt(i)
                                        if (item && item.isCorrect) {
                                            item.color = "#4CAF50"
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

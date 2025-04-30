import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "."

Page {
    id: objetsQuizPage
    background: Rectangle { color: Style.backgroundColor }
    
    // Propriétés pour les paramètres du quiz
    property int selectedAge: 3
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
    
    // Initialiser les questions au chargement de la page
    Component.onCompleted: {
        console.log("DEBUG - ObjetsQuizPage.qml - Component.onCompleted")
        loadQuestions()
    }
    
    // Charger les questions depuis le CSV
    function loadQuestions() {
        console.log("DEBUG - Début du chargement des questions sur les objets")
        console.log("DEBUG - Âge: " + selectedAge)
        
        try {
            // Utiliser subjectLoader pour charger les questions
            var result = null
            try {
                // Essayer d'abord avec subjectLoader
                if (typeof subjectLoader !== "undefined" && subjectLoader !== null) {
                    console.log("Chargement avec subjectLoader...")
                    result = subjectLoader.loadQuestions("objets", selectedAge)
                    console.log("Résultat du chargement avec subjectLoader: " + (result ? "OK" : "NULL"))
                }
            } catch (e) {
                console.error("ERREUR avec subjectLoader: " + e)
            }
            
            // Si subjectLoader a échoué, essayer avec quizController
            if (!result && typeof quizController !== "undefined" && quizController !== null) {
                console.log("Tentative avec quizController...")
                result = quizController.loadQuestions("objets", selectedAge)
                console.log("Résultat du chargement avec quizController: " + (result ? "OK" : "NULL"))
            }
            
            // Si quizController a échoué, essayer avec csvQuizLoader
            if (!result && typeof csvQuizLoader !== "undefined" && csvQuizLoader !== null) {
                console.log("Tentative avec csvQuizLoader...")
                result = csvQuizLoader.loadQuestions("Objets.csv", selectedAge)
                console.log("Résultat du chargement avec csvQuizLoader: " + (result ? "OK" : "NULL"))
            }
            
            if (result) {
                questions = result
                console.log("Nombre de questions chargées: " + questions.length)
                if (questions.length > 0) {
                    showQuestion()
                } else {
                    console.error("ERREUR: Aucune question chargée")
                }
            } else {
                console.error("ERREUR: Aucun résultat retourné par les chargeurs de questions")
                // Créer des questions par défaut directement dans QML
                questions = [
                    {
                        question: "Qu'utilise-t-on pour manger ?",
                        answers: ["Une cuillère", "Un marteau", "Un crayon", "Une chaussure"],
                        correct: "Une cuillère"
                    },
                    {
                        question: "Qu'utilise-t-on pour dessiner ?",
                        answers: ["Un crayon", "Une fourchette", "Un téléphone", "Une chaise"],
                        correct: "Un crayon"
                    },
                    {
                        question: "Qu'utilise-t-on pour s'asseoir ?",
                        answers: ["Une chaise", "Un livre", "Une pomme", "Un ballon"],
                        correct: "Une chaise"
                    }
                ]
                showQuestion()
            }
        } catch (e) {
            console.error("ERREUR CRITIQUE lors du chargement des questions: " + e)
        }
    }
    
    // Afficher une question
    function showQuestion() {
        if (questionNumber > totalQuestions || questionNumber > questions.length) {
            // Fin du quiz
            showResults()
            return
        }
        
        // Récupérer la question actuelle
        currentQuestion = questions[questionNumber - 1]
        questionAnswered = false
        
        // Mettre à jour l'interface
        questionText.text = currentQuestion.question
        
        // Mélanger les réponses
        var shuffledAnswers = shuffleArray(currentQuestion.answers.slice())
        
        // Mettre à jour les boutons de réponse
        for (var i = 0; i < 4; i++) {
            if (i < shuffledAnswers.length) {
                answerButtons.children[i].text = shuffledAnswers[i]
                answerButtons.children[i].visible = true
            } else {
                answerButtons.children[i].visible = false
            }
        }
    }
    
    // Fonction pour mélanger un tableau
    function shuffleArray(array) {
        for (var i = array.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1))
            var temp = array[i]
            array[i] = array[j]
            array[j] = temp
        }
        return array
    }
    
    // Vérifier la réponse
    function checkAnswer(answer) {
        if (questionAnswered) return
        
        questionAnswered = true
        var isCorrect = (answer === currentQuestion.correct)
        
        if (isCorrect) {
            correctAnswers++
            feedbackText.text = "Bravo ! C'est la bonne réponse !"
            feedbackText.color = "#4CAF50" // Vert
        } else {
            feedbackText.text = "Ce n'est pas la bonne réponse. La réponse correcte est : " + currentQuestion.correct
            feedbackText.color = "#F44336" // Rouge
        }
        
        feedbackText.visible = true
        nextButton.visible = true
    }
    
    // Passer à la question suivante
    function nextQuestion() {
        questionNumber++
        feedbackText.visible = false
        nextButton.visible = false
        showQuestion()
    }
    
    // Afficher les résultats
    function showResults() {
        questionText.text = "Quiz terminé !"
        answerButtons.visible = false
        feedbackText.text = "Vous avez obtenu " + correctAnswers + " bonnes réponses sur " + totalQuestions + "."
        feedbackText.color = "#2979FF" // Bleu
        feedbackText.visible = true
        nextButton.text = "Recommencer"
        nextButton.visible = true
        nextButton.onClicked = function() {
            // Réinitialiser le quiz
            questionNumber = 1
            correctAnswers = 0
            nextButton.text = "Question suivante"
            answerButtons.visible = true
            loadQuestions()
        }
    }
    
    // Contenu principal
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        
        // Titre et progression
        RowLayout {
            Layout.fillWidth: true
            
            Label {
                text: "Question " + questionNumber + " / " + totalQuestions
                font.pixelSize: 18
                font.family: appFont.family
                color: Style.textColorPrimary
            }
            
            Item { Layout.fillWidth: true }
            
            Label {
                text: "Score: " + correctAnswers
                font.pixelSize: 18
                font.family: appFont.family
                color: Style.textColorPrimary
            }
        }
        
        // Question
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: questionText.contentHeight + 40
            color: Style.surfaceColor
            radius: 10
            
            Label {
                id: questionText
                anchors.fill: parent
                anchors.margins: 20
                text: "Chargement de la question..."
                font.pixelSize: 22
                font.family: appFont.family
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Style.textColorPrimary
            }
        }
        
        // Réponses
        GridLayout {
            id: answerButtons
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: 15
            columnSpacing: 15
            
            // Boutons de réponse (4 maximum)
            Repeater {
                model: 4
                
                Button {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: 80
                    
                    contentItem: ColumnLayout {
                        spacing: 5
                        
                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            width: 30
                            height: 30
                            radius: 15
                            color: buttonColors[index]
                            
                            Label {
                                anchors.centerIn: parent
                                text: buttonSymbols[index]
                                font.pixelSize: 16
                                font.bold: true
                                color: "white"
                            }
                        }
                        
                        Label {
                            Layout.fillWidth: true
                            text: "Réponse " + (index + 1)
                            font.pixelSize: 16
                            font.family: appFont.family
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            color: Style.textColorPrimary
                        }
                    }
                    
                    background: Rectangle {
                        color: parent.pressed ? Qt.darker(Style.surfaceColor, 1.1) : Style.surfaceColor
                        radius: 10
                        border.width: 2
                        border.color: buttonColors[index]
                    }
                    
                    onClicked: {
                        checkAnswer(text)
                    }
                }
            }
        }
        
        // Feedback et bouton suivant
        Label {
            id: feedbackText
            Layout.fillWidth: true
            text: ""
            font.pixelSize: 18
            font.family: appFont.family
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }
        
        Button {
            id: nextButton
            Layout.alignment: Qt.AlignHCenter
            text: "Question suivante"
            font.pixelSize: 18
            font.family: appFont.family
            visible: false
            onClicked: nextQuestion()
            Material.background: Style.accentColor
            highlighted: true
            padding: 15
        }
    }
}

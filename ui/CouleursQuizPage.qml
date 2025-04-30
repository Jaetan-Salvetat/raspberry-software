import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "."

Page {
    id: couleursQuizPage
    background: Rectangle { color: Style.backgroundColor }
    
    // Propriétés pour les paramètres du quiz
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
        console.log("DEBUG - CouleursQuizPage.qml - Component.onCompleted")
        loadQuestions()
    }
    
    // Charger les questions depuis le CSV
    function loadQuestions() {
        console.log("DEBUG - Début du chargement des questions de couleurs")
        console.log("DEBUG - Âge: " + selectedAge)
        
        try {
            // Utiliser quizController comme solution de secours si subjectLoader ne fonctionne pas
            var result = null
            try {
                // Essayer d'abord avec subjectLoader
                if (typeof subjectLoader !== "undefined" && subjectLoader !== null) {
                    console.log("Chargement avec subjectLoader...")
                    result = subjectLoader.loadQuestions("couleurs", selectedAge)
                    console.log("Résultat du chargement avec subjectLoader: " + (result ? "OK" : "NULL"))
                }
            } catch (e) {
                console.error("ERREUR avec subjectLoader: " + e)
            }
            
            // Si subjectLoader a échoué, essayer avec quizController
            if (!result && typeof quizController !== "undefined" && quizController !== null) {
                console.log("Tentative avec quizController...")
                result = quizController.loadQuestions("couleurs", selectedAge)
                console.log("Résultat du chargement avec quizController: " + (result ? "OK" : "NULL"))
            }
            
            if (result) {
                questions = result
                console.log("Nombre de questions chargées: " + questions.length)
            } else {
                console.error("ERREUR: Aucun résultat retourné par les chargeurs de questions")
                // Créer des questions par défaut directement dans QML
                questions = [
                    {
                        question: "Quelle est la capitale de la France ?",
                        answers: ["Paris", "Lyon", "Marseille", "Bordeaux"],
                        correct: "Paris"
                    },
                    {
                        question: "Qui a peint la Joconde ?",
                        answers: ["Léonard de Vinci", "Pablo Picasso", "Vincent Van Gogh", "Claude Monet"],
                        correct: "Léonard de Vinci"
                    },
                    {
                        question: "Où est l'endroit où nous dormons ?",
                        answers: ["La salle de bain", "Notre chambre", "Le salon", "La cuisine"],
                        correct: "Notre chambre"
                    }
                ]
                console.log("Questions par défaut créées: " + questions.length)
            }
            
            if (questions && questions.length > 0) {
                currentQuestion = questions[0]
                questionNumber = 1
                totalQuestions = questions.length
                console.log("Première question: " + currentQuestion.question)
                
                // Initialiser les couleurs des boutons
                resetButtonColors()
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
    
    // Vérifier si la réponse est correcte
    function checkAnswer(index) {
        if (!questionAnswered) {
            questionAnswered = true
            
            var selectedAnswer = currentQuestion.answers[index]
            var isCorrect = (selectedAnswer === currentQuestion.correct)
            
            if (isCorrect) {
                correctAnswers++
                console.log("Bonne réponse!")
                robotFace.state = "happy" // Visage robot heureux
            } else {
                console.log("Mauvaise réponse!")
                robotFace.state = "sad" // Visage robot triste
            }
            
            // Passer à la question suivante après 2 secondes
            autoNextTimer.start()
        }
    }
    
    // Passer à la question suivante
    function nextQuestion() {
        questionNumber++
        questionAnswered = false
        
        if (questionNumber <= totalQuestions) {
            currentQuestion = questions[questionNumber - 1]
            
            // Réinitialiser les couleurs des boutons
            resetButtonColors()
            
            // Réinitialiser l'état du visage robot
            robotFace.state = ""
        } else {
            showResults()
        }
    }
    
    // Réinitialiser les couleurs des boutons
    function resetButtonColors() {
        // Cette fonction sera appelée pour réinitialiser les couleurs des boutons
        // à chaque nouvelle question
        console.log("Réinitialisation des couleurs des boutons")
        
        // Utiliser un Timer pour s'assurer que les boutons sont créés
        resetColorsTimer.start()
    }
    
    // Timer pour réinitialiser les couleurs des boutons
    Timer {
        id: resetColorsTimer
        interval: 10
        repeat: false
        onTriggered: {
            for (var i = 0; i < buttonRepeater.count; i++) {
                var item = buttonRepeater.itemAt(i)
                if (item) {
                    item.color = buttonColors[i]
                    console.log("Bouton " + i + " réinitialisé à la couleur " + buttonColors[i])
                }
            }
        }
    }
    
    // Afficher les résultats
    function showResults() {
        console.log("Affichage des résultats: " + correctAnswers + "/" + totalQuestions)
        quizContent.visible = false
        resultsPage.visible = true
        
        // Mettre à jour le score
        resultScore.text = "Ton score est de " + correctAnswers + "/" + totalQuestions
        
        // Mettre à jour le message en fonction du score
        var percentage = (correctAnswers / totalQuestions) * 100
        if (percentage >= 80) {
            resultMessage.text = "Excellent travail !"
            resultRobotFace.state = "happy"
        } else if (percentage >= 50) {
            resultMessage.text = "Bon travail !"
            resultRobotFace.state = "happy"
        } else {
            resultMessage.text = "Continue à t'entraîner !"
            resultRobotFace.state = "sad"
        }
        
        // Démarrer le timer pour retourner à la page des matières
        returnTimer.start()
    }
    
    // Recommencer le quiz
    function restartQuiz() {
        questionNumber = 1
        correctAnswers = 0
        questionAnswered = false
        
        resultsPage.visible = false
        quizContent.visible = true
        
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
    
    // Timer pour retourner à la page des matières
    Timer {
        id: returnTimer
        interval: 5000
        repeat: false
        onTriggered: {
            stackView.pop()
        }
    }
    
    // Interface utilisateur principale
    Item {
        id: quizContent
        anchors.fill: parent
        visible: true
        
        // Affichage du score en haut
        Rectangle {
            id: scoreBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40
            color: "#E8F5E9"
            
            Text {
                anchors.centerIn: parent
                text: "Question " + questionNumber + "/" + totalQuestions + " - Score: " + correctAnswers
                color: "#2E7D32"
                font.pixelSize: 18
                font.bold: true
            }
        }
        
        // Zone de question avec le visage robot
        Rectangle {
            id: questionBox
            anchors.top: scoreBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            height: parent.height * 0.25
            color: "#FFE082" // Jaune pastel
            radius: 10
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15
                
                // Visage robot expressif (à gauche)
                Rectangle {
                    id: robotFace
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 80
                    color: "#64B5F6" // Bleu clair
                    radius: width / 2
                    
                    Text {
                        anchors.centerIn: parent
                        text: "?"
                        font.pixelSize: 40
                        font.bold: true
                        color: "#0D47A1"
                    }
                    
                    // Yeux du robot (cachés par défaut, visibles dans les états)
                    Rectangle {
                        id: leftEye
                        width: parent.width * 0.2
                        height: parent.height * 0.2
                        radius: height / 2
                        color: "#0D47A1"
                        x: parent.width * 0.25
                        y: parent.height * 0.3
                        visible: false
                    }
                    
                    Rectangle {
                        id: rightEye
                        width: parent.width * 0.2
                        height: parent.height * 0.2
                        radius: height / 2
                        color: "#0D47A1"
                        x: parent.width * 0.55
                        y: parent.height * 0.3
                        visible: false
                    }
                    
                    // Bouche du robot (cachée par défaut, visible dans les états)
                    Rectangle {
                        id: mouth
                        width: parent.width * 0.5
                        height: parent.height * 0.1
                        radius: height / 2
                        color: "#0D47A1"
                        x: parent.width * 0.25
                        y: parent.height * 0.65
                        visible: false
                        
                        Rectangle {
                            id: mouthCover
                            visible: false
                            width: parent.width
                            height: parent.height / 2
                            color: "#64B5F6"
                            anchors.bottom: parent.bottom
                        }
                    }
                    
                    // États du visage robot
                    states: [
                        State {
                            name: "happy"
                            PropertyChanges { target: leftEye; visible: true; height: parent.height * 0.15; radius: height / 2 }
                            PropertyChanges { target: rightEye; visible: true; height: parent.height * 0.15; radius: height / 2 }
                            PropertyChanges { target: mouth; visible: true; height: parent.height * 0.15; radius: height / 2 }
                            PropertyChanges { target: mouthCover; visible: false }
                        },
                        State {
                            name: "sad"
                            PropertyChanges { target: leftEye; visible: true; height: parent.height * 0.05; radius: 0 }
                            PropertyChanges { target: rightEye; visible: true; height: parent.height * 0.05; radius: 0 }
                            PropertyChanges { target: mouth; visible: true; height: parent.height * 0.15; radius: 0 }
                            PropertyChanges { target: mouthCover; visible: true }
                        }
                    ]
                }
                
                // Texte de la question (à droite)
                Text {
                    Layout.fillWidth: true
                    text: currentQuestion ? currentQuestion.question : "Chargement..."
                    wrapMode: Text.WordWrap
                    font.pixelSize: 28
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    color: "#000000"
                }
            }
        }
        
        // Grille de boutons pour les réponses
        Grid {
            id: answersGrid
            anchors.top: questionBox.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
            columns: 2
            spacing: 10
            
            Repeater {
                id: buttonRepeater
                model: currentQuestion ? Math.min(currentQuestion.answers.length, 4) : 0
                
                Rectangle {
                    id: answerButton
                    width: (answersGrid.width - answersGrid.spacing) / 2
                    height: (answersGrid.height - answersGrid.spacing) / 2
                    color: buttonColors[index]
                    radius: 10
                    
                    property bool isCorrect: currentQuestion && currentQuestion.answers[index] === currentQuestion.correct
                    
                    // Symbole du bouton (forme simple en haut)
                    Item {
                        id: symbolShape
                        width: 80
                        height: 80
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        // Carré (index 0)
                        Rectangle {
                            anchors.fill: parent
                            visible: index === 0
                            color: "white"
                            border.width: 2
                            border.color: buttonColors[0]
                        }
                        
                        // Cercle (index 1)
                        Rectangle {
                            anchors.fill: parent
                            visible: index === 1
                            color: "white"
                            radius: width / 2
                            border.width: 2
                            border.color: buttonColors[1]
                        }
                        
                        // Triangle (index 2)
                        Canvas {
                            anchors.fill: parent
                            visible: index === 2
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                
                                // Dessiner un triangle équilatéral
                                ctx.beginPath();
                                ctx.moveTo(width/2, 0);          // Sommet
                                ctx.lineTo(0, height);           // Coin gauche
                                ctx.lineTo(width, height);       // Coin droit
                                ctx.closePath();
                                
                                // Remplir en blanc
                                ctx.fillStyle = "white";
                                ctx.fill();
                                
                                // Bordure violette
                                ctx.lineWidth = 2;
                                ctx.strokeStyle = buttonColors[2];
                                ctx.stroke();
                            }
                        }
                        
                        // Losange (index 3)
                        Canvas {
                            anchors.fill: parent
                            visible: index === 3
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                
                                // Dessiner un losange
                                ctx.beginPath();
                                ctx.moveTo(width/2, 0);          // Sommet
                                ctx.lineTo(0, height/2);         // Gauche
                                ctx.lineTo(width/2, height);     // Bas
                                ctx.lineTo(width, height/2);     // Droite
                                ctx.closePath();
                                
                                // Remplir en blanc
                                ctx.fillStyle = "white";
                                ctx.fill();
                                
                                // Bordure orange
                                ctx.lineWidth = 2;
                                ctx.strokeStyle = buttonColors[3];
                                ctx.stroke();
                            }
                        }
                    }
                    
                    // Texte de la réponse (centré et agrandi)
                    Text {
                        anchors.top: symbolShape.bottom
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 15
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: currentQuestion ? currentQuestion.answers[index] : ""
                        wrapMode: Text.WordWrap
                        color: "white"
                        font.pixelSize: 66  // Taille triplée
                        font.bold: true
                        elide: Text.ElideRight
                        maximumLineCount: 2
                    }
                    
                    // Zone cliquable
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (!questionAnswered) {
                                // Changer la couleur du bouton en fonction de la réponse
                                if (isCorrect) {
                                    answerButton.color = "#4CAF50" // Vert pour une bonne réponse
                                } else {
                                    answerButton.color = "#F44336" // Rouge pour une mauvaise réponse
                                    
                                    // Montrer la bonne réponse
                                    for (var i = 0; i < buttonRepeater.count; i++) {
                                        var item = buttonRepeater.itemAt(i)
                                        if (item && item.isCorrect) {
                                            item.color = "#4CAF50"
                                            break
                                        }
                                    }
                                }
                                
                                // Vérifier la réponse
                                checkAnswer(index)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Page de résultats
    Item {
        id: resultsPage
        anchors.fill: parent
        visible: false
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 32
            spacing: 32
            
            Text {
                Layout.fillWidth: true
                text: "Félicitations !"
                color: Style.textColorPrimary
                font.pixelSize: 48
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }
            
            // Visage robot expressif pour les résultats
            Rectangle {
                id: resultRobotFace
                Layout.preferredWidth: 200
                Layout.preferredHeight: 200
                Layout.alignment: Qt.AlignHCenter
                color: "#64B5F6" // Bleu clair
                radius: width / 2
                
                // États du visage robot
                states: [
                    State {
                        name: "happy"
                        PropertyChanges { target: resultLeftEye; height: parent.height * 0.15; radius: height / 2 }
                        PropertyChanges { target: resultRightEye; height: parent.height * 0.15; radius: height / 2 }
                        PropertyChanges { target: resultMouth; height: parent.height * 0.15; radius: height / 2 }
                        PropertyChanges { target: resultMouthCover; visible: false }
                    },
                    State {
                        name: "sad"
                        PropertyChanges { target: resultLeftEye; height: parent.height * 0.05; radius: 0 }
                        PropertyChanges { target: resultRightEye; height: parent.height * 0.05; radius: 0 }
                        PropertyChanges { target: resultMouth; height: parent.height * 0.15; radius: 0 }
                        PropertyChanges { target: resultMouthCover; visible: true }
                    }
                ]
                
                // Yeux
                Rectangle {
                    id: resultLeftEye
                    width: parent.width * 0.2
                    height: parent.height * 0.2
                    radius: height / 2
                    color: "#0D47A1"
                    x: parent.width * 0.25
                    y: parent.height * 0.3
                }
                
                Rectangle {
                    id: resultRightEye
                    width: parent.width * 0.2
                    height: parent.height * 0.2
                    radius: height / 2
                    color: "#0D47A1"
                    x: parent.width * 0.55
                    y: parent.height * 0.3
                }
                
                // Bouche
                Rectangle {
                    id: resultMouth
                    width: parent.width * 0.5
                    height: parent.height * 0.15
                    radius: height / 2
                    color: "#0D47A1"
                    x: parent.width * 0.25
                    y: parent.height * 0.65
                    
                    Rectangle {
                        id: resultMouthCover
                        visible: false
                        width: parent.width
                        height: parent.height / 2
                        color: "#64B5F6"
                        anchors.bottom: parent.bottom
                    }
                }
            }
            
            Text {
                id: resultScore
                Layout.fillWidth: true
                text: "Ton score est de 0/0"
                color: Style.textColorPrimary
                font.pixelSize: 36
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }
            
            Text {
                id: resultMessage
                Layout.fillWidth: true
                text: "Bravo !"
                color: Style.textColorPrimary
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }
            
            Text {
                Layout.fillWidth: true
                text: "Retour à la page des matières dans 5 secondes..."
                color: Style.textColorSecondary
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}

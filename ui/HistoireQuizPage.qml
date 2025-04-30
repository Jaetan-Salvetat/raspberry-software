import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "."

Page {
    id: histoireQuizPage
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
        console.log("DEBUG - HistoireQuizPage.qml - Component.onCompleted")
        loadQuestions()
    }
    
    // Charger les questions depuis le CSV
    function loadQuestions() {
        console.log("DEBUG - Début du chargement des questions d'histoire")
        console.log("DEBUG - Âge: " + selectedAge)
        
        try {
            // Utiliser quizController comme solution de secours si subjectLoader ne fonctionne pas
            var result = null
            try {
                // Essayer d'abord avec subjectLoader
                if (typeof subjectLoader !== "undefined" && subjectLoader !== null) {
                    console.log("Chargement avec subjectLoader...")
                    result = subjectLoader.loadQuestions("histoire", selectedAge)
                    console.log("Résultat du chargement avec subjectLoader: " + (result ? "OK" : "NULL"))
                }
            } catch (e) {
                console.error("ERREUR avec subjectLoader: " + e)
            }
            
            // Si subjectLoader a échoué, essayer avec quizController
            if (!result && typeof quizController !== "undefined" && quizController !== null) {
                console.log("Tentative avec quizController...")
                result = quizController.loadQuestions("histoire", selectedAge)
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
                        question: "Qui a découvert l'Amérique en 1492 ?",
                        answers: ["Christophe Colomb", "Jacques Cartier", "Napoléon Bonaparte", "Louis XIV"],
                        correct: "Christophe Colomb"
                    },
                    {
                        question: "Quel roi a fait construire le château de Versailles ?",
                        answers: ["Louis XIV", "Louis XVI", "François Ier", "Henri IV"],
                        correct: "Louis XIV"
                    },
                    {
                        question: "Quelle période est appelée la Préhistoire ?",
                        answers: ["Avant l'invention de l'écriture", "Pendant les dinosaures", "Au Moyen Âge", "Pendant l'Antiquité"],
                        correct: "Avant l'invention de l'écriture"
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
                    
                    // Transitions entre les états
                    transitions: [
                        Transition {
                            from: ""; to: "happy"
                            ParallelAnimation {
                                PropertyAnimation { target: leftEye; properties: "height,radius"; duration: 300 }
                                PropertyAnimation { target: rightEye; properties: "height,radius"; duration: 300 }
                                PropertyAnimation { target: mouth; properties: "height,radius"; duration: 300 }
                            }
                        },
                        Transition {
                            from: ""; to: "sad"
                            ParallelAnimation {
                                PropertyAnimation { target: leftEye; properties: "height,radius"; duration: 300 }
                                PropertyAnimation { target: rightEye; properties: "height,radius"; duration: 300 }
                                PropertyAnimation { target: mouth; properties: "height,radius"; duration: 300 }
                            }
                        },
                        Transition {
                            from: "happy"; to: ""
                            ParallelAnimation {
                                PropertyAnimation { target: leftEye; properties: "height,radius"; duration: 300 }
                                PropertyAnimation { target: rightEye; properties: "height,radius"; duration: 300 }
                                PropertyAnimation { target: mouth; properties: "height,radius"; duration: 300 }
                            }
                        },
                        Transition {
                            from: "sad"; to: ""
                            ParallelAnimation {
                                PropertyAnimation { target: leftEye; properties: "height,radius"; duration: 300 }
                                PropertyAnimation { target: rightEye; properties: "height,radius"; duration: 300 }
                                PropertyAnimation { target: mouth; properties: "height,radius"; duration: 300 }
                            }
                        }
                    ]
                }
                
                // Texte de la question
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
    Rectangle {
        id: resultsPage
        anchors.fill: parent
        visible: false
        color: "#F5F5F5"
        
        Rectangle {
            id: confettiBackground
            anchors.fill: parent
            color: "transparent"
            
            // Effet de confetti pour les bons scores
            Canvas {
                id: confettiCanvas
                anchors.fill: parent
                visible: correctAnswers >= (totalQuestions * 0.6) // Visible si score > 60%
                property var confetti: []
                property bool initialized: false
                
                Component.onCompleted: {
                    // Créer les confettis
                    if (!initialized) {
                        var confettiColors = ["#FF5722", "#FFC107", "#2979FF", "#9C27B0", "#4CAF50"];
                        for (var i = 0; i < 50; i++) {
                            confetti.push({
                                x: Math.random() * width,
                                y: Math.random() * height * 0.5,
                                size: 5 + Math.random() * 10,
                                color: confettiColors[Math.floor(Math.random() * confettiColors.length)],
                                speed: 1 + Math.random() * 3,
                                angle: Math.random() * Math.PI * 2
                            });
                        }
                        initialized = true;
                        confettiAnimation.start();
                    }
                }
                
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    
                    for (var i = 0; i < confetti.length; i++) {
                        var c = confetti[i];
                        ctx.fillStyle = c.color;
                        ctx.beginPath();
                        ctx.rect(c.x, c.y, c.size, c.size);
                        ctx.fill();
                    }
                }
                
                Timer {
                    id: confettiAnimation
                    interval: 50
                    repeat: true
                    running: confettiCanvas.visible && resultsPage.visible
                    onTriggered: {
                        for (var i = 0; i < confettiCanvas.confetti.length; i++) {
                            var c = confettiCanvas.confetti[i];
                            c.y += c.speed;
                            c.x += Math.sin(c.angle) * 2;
                            c.angle += 0.02;
                            
                            // Réinitialiser les confettis qui sortent de l'écran
                            if (c.y > confettiCanvas.height) {
                                c.y = -c.size;
                                c.x = Math.random() * confettiCanvas.width;
                            }
                        }
                        confettiCanvas.requestPaint();
                    }
                }
            }
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 32
            spacing: 32
            
            // Titre avec animation
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "#E3F2FD"
                radius: 20
                border.width: 2
                border.color: "#90CAF9"
                
                Text {
                    id: titleText
                    anchors.centerIn: parent
                    text: correctAnswers >= (totalQuestions * 0.6) ? "Félicitations !" : "Quiz Terminé !"
                    color: "#0D47A1"
                    font.pixelSize: 48
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    
                    SequentialAnimation {
                        running: resultsPage.visible
                        loops: Animation.Infinite
                        
                        NumberAnimation {
                            target: titleText
                            property: "scale"
                            from: 1.0
                            to: 1.1
                            duration: 1000
                            easing.type: Easing.OutQuad
                        }
                        
                        NumberAnimation {
                            target: titleText
                            property: "scale"
                            from: 1.1
                            to: 1.0
                            duration: 1000
                            easing.type: Easing.InQuad
                        }
                    }
                }
            }
            
            // Visage robot expressif pour les résultats (SVG)
            Rectangle {
                id: resultRobotContainer
                Layout.preferredWidth: 250
                Layout.preferredHeight: 250
                Layout.alignment: Qt.AlignHCenter
                color: "transparent"
                
                Image {
                    id: robotHappyImage
                    anchors.fill: parent
                    source: "assets/robot_happy.svg"
                    visible: correctAnswers >= (totalQuestions * 0.5) // Visible si score >= 50%
                    fillMode: Image.PreserveAspectFit
                    
                    SequentialAnimation {
                        running: robotHappyImage.visible && resultsPage.visible
                        loops: Animation.Infinite
                        
                        NumberAnimation {
                            target: robotHappyImage
                            property: "rotation"
                            from: -5
                            to: 5
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                        
                        NumberAnimation {
                            target: robotHappyImage
                            property: "rotation"
                            from: 5
                            to: -5
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
                
                Image {
                    id: robotSadImage
                    anchors.fill: parent
                    source: "assets/robot_sad.svg"
                    visible: correctAnswers < (totalQuestions * 0.5) // Visible si score < 50%
                    fillMode: Image.PreserveAspectFit
                    
                    SequentialAnimation {
                        running: robotSadImage.visible && resultsPage.visible
                        loops: Animation.Infinite
                        
                        NumberAnimation {
                            target: robotSadImage
                            property: "y"
                            from: 0
                            to: 10
                            duration: 1500
                            easing.type: Easing.InOutQuad
                        }
                        
                        NumberAnimation {
                            target: robotSadImage
                            property: "y"
                            from: 10
                            to: 0
                            duration: 1500
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
            
            // Score avec barre de progression
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "#E8F5E9"
                radius: 15
                border.width: 2
                border.color: "#A5D6A7"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 5
                    
                    Text {
                        id: resultScore
                        Layout.fillWidth: true
                        text: "Ton score est de " + correctAnswers + "/" + totalQuestions
                        color: "#2E7D32"
                        font.pixelSize: 28
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 20
                        color: "#C8E6C9"
                        radius: 10
                        
                        Rectangle {
                            id: progressBar
                            height: parent.height
                            width: 0
                            radius: 10
                            color: getScoreColor(correctAnswers / totalQuestions)
                            
                            NumberAnimation {
                                target: progressBar
                                property: "width"
                                from: 0
                                to: (correctAnswers / totalQuestions) * parent.width
                                duration: 1000
                                easing.type: Easing.OutCubic
                                running: resultsPage.visible
                            }
                        }
                    }
                }
            }
            
            // Message personnalisé
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "#FFF8E1"
                radius: 15
                border.width: 2
                border.color: "#FFECB3"
                
                Text {
                    id: resultMessage
                    anchors.fill: parent
                    anchors.margins: 15
                    text: getResultMessage(correctAnswers / totalQuestions)
                    color: "#FF6F00"
                    font.pixelSize: 24
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                }
            }
            
            // Bouton pour rejouer
            Rectangle {
                Layout.preferredWidth: 200
                Layout.preferredHeight: 60
                Layout.alignment: Qt.AlignHCenter
                color: replayMouseArea.pressed ? "#1976D2" : "#2196F3"
                radius: 30
                
                Text {
                    anchors.centerIn: parent
                    text: "Rejouer"
                    color: "white"
                    font.pixelSize: 24
                    font.bold: true
                }
                
                MouseArea {
                    id: replayMouseArea
                    anchors.fill: parent
                    onClicked: restartQuiz()
                }
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
    
    // Fonction pour obtenir la couleur en fonction du score
    function getScoreColor(scoreRatio) {
        if (scoreRatio >= 0.8) return "#4CAF50";      // Vert
        else if (scoreRatio >= 0.6) return "#8BC34A"; // Vert clair
        else if (scoreRatio >= 0.4) return "#FFC107"; // Jaune
        else if (scoreRatio >= 0.2) return "#FF9800"; // Orange
        else return "#F44336";                        // Rouge
    }
    
    // Fonction pour obtenir un message personnalisé en fonction du score
    function getResultMessage(scoreRatio) {
        if (scoreRatio >= 0.9) return "Excellent ! Tu es un véritable expert en histoire !"
        else if (scoreRatio >= 0.7) return "Très bien ! Tu connais bien ton histoire !"
        else if (scoreRatio >= 0.5) return "Bien joué ! Continue à apprendre l'histoire !"
        else if (scoreRatio >= 0.3) return "Pas mal, mais tu peux faire mieux. Essaie encore !"
        else return "Continue à t'entraîner, tu vas t'améliorer !";
    }
}

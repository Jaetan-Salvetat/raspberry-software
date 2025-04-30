import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects 1.0

Page {
    id: questionPage
    title: "Question"
    background: Rectangle { color: Style.backgroundColor }
    
    property var currentQuestion: ({})
    property string questionSubject: "maths"
    property int correctAnswers: 0
    property int questionNumber: 1
    property bool showFeedback: false
    property bool lastAnswerCorrect: false
    
    // Réception du signal Python
    Connections {
        target: quizController
        function onQuestionChanged(question) {
            currentQuestion = question
            console.log("Question reçue:", JSON.stringify(question))
        }
    }

    Component.onCompleted: {
        console.log("QuestionPage chargée, demande de question pour:", questionSubject)
        if (quizController) {
            quizController.nextQuestion(questionSubject)
        } else {
            console.error("quizController n'est pas disponible!")
        }
    }

    header: ToolBar {
        id: toolbar
        height: 70
        Material.background: Style.surfaceColor
        Material.elevation: Style.elevation2

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Style.spacingMedium
            anchors.rightMargin: Style.spacingMedium

            RoundButton {
                id: backButton
                icon.source: "assets/icons/arrow_back.svg"
                icon.width: 24
                icon.height: 24
                flat: true
                onClicked: stackView.pop()
                Material.foreground: Style.textColorPrimary
            }

            Label {
                text: "Question"
                font.pixelSize: Style.fontSizeXLarge
                font.family: appFont.family
                font.weight: Font.Medium
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: Style.textColorPrimary
            }

            Item { width: backButton.width }
        }
    }

    // Contenu principal de la page
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: Math.min(parent.height * 0.04, 32)

        // Rectangle de question adaptatif
        Rectangle {
            color: "#FFE082" // jaune pastel cartoon
            radius: Math.min(height/2, 48)
            border.color: "#FFD54F"
            border.width: 3
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(questionLayout.implicitHeight + 36, parent.height * 0.2)
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: parent.height * 0.05

            // Layout interne pour le contenu de la question
            RowLayout {
                id: questionLayout
                anchors.fill: parent
                anchors.margins: 18
                spacing: 12
                
                Image {
                    source: "assets/icons/chat_bubble_cartoon.svg"
                    Layout.preferredWidth: 56 * 2.5
                    Layout.preferredHeight: 56 * 2.5
                    fillMode: Image.PreserveAspectFit
                    visible: true
                }
                
                Text {
                    id: questionText
                    text: currentQuestion.question || "Chargement de la question..."
                    font.pixelSize: Math.min(32 * 2.5, parent.width * 0.125 + 16)
                    font.family: "Comic Sans MS, Comic Sans, Arial Rounded MT Bold, Arial, sans-serif"
                    font.bold: true
                    color: "#222"
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.fillWidth: true
                }
            }
        }
        
        // Grille de boutons de réponse adaptative
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height * 0.6
            Layout.alignment: Qt.AlignHCenter
            
            columns: parent.width < 600 ? 1 : 2
            rowSpacing: Math.min(24, parent.height * 0.03)
            columnSpacing: Math.min(24, parent.width * 0.03)
            
            property var btnColors: ["#2979FF", "#FFC107", "#7E57C2", "#FF9800"] // bleu, jaune, violet, orange
            property var btnShapes: [
                "▲", // triangle
                "◆", // losange
                "●", // cercle
                "■"  // carré
            ]
            
            Repeater {
                model: currentQuestion.answers || ["Chargement...", "Chargement...", "Chargement...", "Chargement..."]
                delegate: Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 80 * 2.5
                    radius: Math.min(height/4, 18 * 2.5)
                    color: parent.btnColors[index % parent.btnColors.length]
                    border.color: Qt.darker(color, 1.1)
                    border.width: mouseArea.containsMouse ? 3 * 2.5 : 1 * 2.5
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Math.min(10 * 2.5, parent.width * 0.02 * 2.5)
                        spacing: Math.min(18 * 2.5, parent.width * 0.03 * 2.5)
                        
                        Text {
                            text: parent.parent.parent.btnShapes[index % parent.parent.parent.btnShapes.length]
                            font.pixelSize: Math.min(32 * 2.5, parent.height * 0.4 * 2.5)
                            font.bold: true
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Layout.preferredWidth: parent.height * 0.5
                        }
                        
                        Text {
                            text: modelData
                            font.pixelSize: Math.min(24 * 2.5, parent.height * 0.3 * 2.5)
                            font.bold: true
                            color: "white"
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }
                    
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !showFeedback
                        
                        onClicked: function() {
                            console.log("Réponse sélectionnée: " + modelData)
                            // Vérification de la réponse
                            if (modelData === currentQuestion.correct) {
                                console.log("Bonne réponse!")
                                correctAnswers++
                                lastAnswerCorrect = true
                            } else {
                                console.log("Mauvaise réponse!")
                                lastAnswerCorrect = false
                            }
                            
                            // Afficher le feedback et l'anecdote
                            showFeedback = true
                            
                            // Passer à la question suivante après 3 secondes
                            feedbackTimer.start()
                        }
                        
                        scale: pressed ? 0.96 : (containsMouse ? 1.03 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 100 } }
                    }
                }
            }
        }
        

    }
    
    // Visage robot expressif
    Item {
        id: robotFaceContainer
        width: 200
        height: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        visible: showFeedback
        
        Rectangle {
            id: robotFace
            width: parent.width
            height: parent.height
            radius: width / 2
            color: "#E0E0E0"
            border.width: 4
            border.color: "#BDBDBD"
            
            // Yeux du robot
            Rectangle {
                id: leftEye
                width: parent.width * 0.2
                height: lastAnswerCorrect ? width : width / 2
                radius: width / 2
                color: "#333333"
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.3
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.25
                
                // Animation de clignotement
                SequentialAnimation {
                    running: showFeedback
                    loops: 1
                    PropertyAnimation {
                        target: leftEye
                        property: "height"
                        to: 2
                        duration: 150
                    }
                    PropertyAnimation {
                        target: leftEye
                        property: "height"
                        to: lastAnswerCorrect ? leftEye.width : leftEye.width / 2
                        duration: 150
                    }
                }
            }
            
            Rectangle {
                id: rightEye
                width: parent.width * 0.2
                height: lastAnswerCorrect ? width : width / 2
                radius: width / 2
                color: "#333333"
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.3
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.25
                
                // Animation de clignotement
                SequentialAnimation {
                    running: showFeedback
                    loops: 1
                    PropertyAnimation {
                        target: rightEye
                        property: "height"
                        to: 2
                        duration: 150
                    }
                    PropertyAnimation {
                        target: rightEye
                        property: "height"
                        to: lastAnswerCorrect ? rightEye.width : rightEye.width / 2
                        duration: 150
                    }
                }
            }
            
            // Bouche du robot
            Rectangle {
                id: mouth
                width: parent.width * 0.5
                height: parent.height * 0.1
                radius: lastAnswerCorrect ? height / 2 : 0
                color: "#333333"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.25
                anchors.horizontalCenter: parent.horizontalCenter
                
                // Forme de la bouche selon la réponse
                states: [
                    State {
                        when: lastAnswerCorrect
                        PropertyChanges {
                            target: mouth
                            height: parent.height * 0.1
                            width: parent.width * 0.5
                            radius: height / 2
                        }
                    },
                    State {
                        when: !lastAnswerCorrect
                        PropertyChanges {
                            target: mouth
                            height: parent.height * 0.05
                            width: parent.width * 0.4
                            radius: 0
                        }
                    }
                ]
                
                Behavior on height { NumberAnimation { duration: 300 } }
                Behavior on width { NumberAnimation { duration: 300 } }
                Behavior on radius { NumberAnimation { duration: 300 } }
            }
        }
    }
    
    // Affichage de l'anecdote
    Rectangle {
        id: anecdoteBox
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: robotFaceContainer.top
        anchors.bottomMargin: 20
        width: parent.width * 0.8
        height: anecdoteText.implicitHeight + 40
        color: "#E3F2FD"
        radius: 15
        border.color: "#90CAF9"
        border.width: 2
        visible: showFeedback && currentQuestion.anecdote && currentQuestion.anecdote.length > 0
        
        Text {
            id: anecdoteText
            anchors.centerIn: parent
            width: parent.width - 40
            text: currentQuestion.anecdote || ""
            font.pixelSize: 18
            font.family: "Comic Sans MS, Arial, sans-serif"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }
    }
    
    // Affichage du score
    Rectangle {
        id: scoreBox
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        width: scoreText.implicitWidth + 40
        height: scoreText.implicitHeight + 20
        color: "#E8F5E9"
        radius: 10
        border.color: "#A5D6A7"
        border.width: 2
        
        Text {
            id: scoreText
            anchors.centerIn: parent
            text: "Question " + questionNumber + "/10 - Score: " + correctAnswers
            font.pixelSize: 18
            font.bold: true
            font.family: "Arial, sans-serif"
        }
    }
    
    // Timer pour passer à la question suivante
    Timer {
        id: feedbackTimer
        interval: 3000
        repeat: false
        onTriggered: {
            showFeedback = false
            questionNumber++
            
            if (questionNumber > 10) {
                // Fin du quiz après 10 questions
                stackView.pop()
                // Afficher un message de fin
                var dialog = resultDialogComponent.createObject(questionPage, {
                    score: correctAnswers,
                    total: 10
                })
                dialog.open()
            } else {
                // Charger la question suivante
                quizController.nextQuestion(questionSubject)
            }
        }
    }
    
    // Composant de dialogue pour le résultat final
    Component {
        id: resultDialogComponent
        Dialog {
            id: resultDialog
            title: "Résultat du quiz"
            modal: true
            anchors.centerIn: parent
            width: Math.min(parent.width * 0.8, 500)
            
            property int score: 0
            property int total: 10
            
            contentItem: ColumnLayout {
                spacing: 20
                
                Text {
                    text: "Félicitations !"
                    font.pixelSize: 24
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Text {
                    text: "Vous avez obtenu " + score + " bonne(s) réponse(s) sur " + total + "."
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
                
                Button {
                    text: "Retour au menu"
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: {
                        resultDialog.close()
                        stackView.pop()
                    }
                }
            }
            
            onClosed: destroy()
        }
    }
}
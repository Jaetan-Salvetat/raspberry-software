import QtQuick
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Effects
import "."

Page {
    id: playPage3
    background: Rectangle { 
        color: Style.backgroundColor 
        
        // Logo en tant qu'image de fond avec transparence
        Image {
            id: backgroundLogo
            source: "assets/LudoBot.png"
            width: parent.width * 1.5
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.7 // Position plus basse sur l'écran
            opacity: 0.07 // Très léger pour ne pas gêner la lecture
            fillMode: Image.PreserveAspectFit
            z: 0 // S'assurer qu'il reste en arrière-plan
        }
    }

    property QtObject quizController
    // L'âge peut être passé en paramètre
    property int selectedAge: (typeof selectedAge !== 'undefined') ? selectedAge : 6
    // Le mode peut être passé en paramètre
    property string appMode: (typeof appMode !== 'undefined') ? appMode : "parent"
    
    // Fonction pour obtenir les matières adaptées à l'âge de l'enfant
    function getSubjectsForAge(age) {
        // Retourne les matières adaptées à l'âge de l'enfant selon la liste fournie
        if (age === 3) {
            return [
                {name: "Couleurs", icon: "🎨", color: "#4CAF50", iconBg: "#E8F5E9", page: "CouleursQuizPage.qml"},
                {name: "Formes", icon: "⬛", color: "#F57C00", iconBg: "#FFF3E0", page: "FormesQuizPage.qml"},
                {name: "Animaux", icon: "🐘", color: "#388E3C", iconBg: "#E8F5E9", page: "AnimauxQuizPage.qml"},
                {name: "Corps humain", icon: "👋", color: "#FFB74D", iconBg: "#FFF8E1", page: "CorpsHumainQuizPage.qml"},
                {name: "Sons", icon: "🔊", color: "#4CAF50", iconBg: "#E8F5E9", page: "SonsQuizPage.qml"},
                {name: "Objets", icon: "🎁", color: "#F57C00", iconBg: "#FFF3E0", page: "ObjetsQuizPage.qml"},
                {name: "Émotions", icon: "😊", color: "#388E3C", iconBg: "#E8F5E9", page: "EmotionsQuizPage.qml"}
            ];
        } else if (age === 4) {
            return [
                {name: "Comparaison", icon: "📏", color: "#2E86C1", iconBg: "#D6EAF8", page: "MathsQuizPage.qml"},
                {name: "Habitats", icon: "🏠", color: "#1A5276", iconBg: "#AED6F1", page: "CultureQuizPage.qml"},
                {name: "Alimentation", icon: "🍎", color: "#58D68D", iconBg: "#D5F5E3", page: "ScienceQuizPage.qml"},
                {name: "Chiffres", icon: "123", color: "#82E0AA", iconBg: "#E8F8F5", page: "HistoireQuizPage.qml"},
                {name: "Formes", icon: "⭐", color: "#3498DB", iconBg: "#EBF5FB", page: "GeographieQuizPage.qml"},
                {name: "Vocabulaire", icon: "📝", color: "#27AE60", iconBg: "#D4EFDF", page: "MathsQuizPage.qml"},
                {name: "Objets utiles", icon: "🔨", color: "#1ABC9C", iconBg: "#E8F6F3", page: "CultureQuizPage.qml"}
            ];
        } else if (age === 5) {
            return [
                {name: "Alphabet", icon: "ABC", color: "#2E86C1", iconBg: "#D6EAF8", page: "MathsQuizPage.qml"},
                {name: "Sons initiaux", icon: "🔈", color: "#1A5276", iconBg: "#AED6F1", page: "CultureQuizPage.qml"},
                {name: "Numération", icon: "123", color: "#58D68D", iconBg: "#D5F5E3", page: "ScienceQuizPage.qml"},
                {name: "Contraires", icon: "⚖️", color: "#82E0AA", iconBg: "#E8F8F5", page: "HistoireQuizPage.qml"},
                {name: "Temps", icon: "📅", color: "#3498DB", iconBg: "#EBF5FB", page: "GeographieQuizPage.qml"},
                {name: "Routines", icon: "🧹", color: "#27AE60", iconBg: "#D4EFDF", page: "MathsQuizPage.qml"},
                {name: "Émotions", icon: "❤️", color: "#1ABC9C", iconBg: "#E8F6F3", page: "CultureQuizPage.qml"}
            ];
        } else if (age === 6) {
            return [
                {name: "Lecture", icon: "📖", color: "#2E86C1", iconBg: "#D6EAF8", page: "MathsQuizPage.qml"},
                {name: "Calculs simples", icon: "123", color: "#1A5276", iconBg: "#AED6F1", page: "CultureQuizPage.qml"},
                {name: "Classement", icon: "🔢", color: "#58D68D", iconBg: "#D5F5E3", page: "ScienceQuizPage.qml"},
                {name: "Temps", icon: "⏰", color: "#82E0AA", iconBg: "#E8F8F5", page: "HistoireQuizPage.qml"},
                {name: "École", icon: "🏫", color: "#3498DB", iconBg: "#EBF5FB", page: "GeographieQuizPage.qml"},
                {name: "Formes complexes", icon: "📐", color: "#27AE60", iconBg: "#D4EFDF", page: "MathsQuizPage.qml"},
                {name: "Nature", icon: "🌿", color: "#1ABC9C", iconBg: "#E8F6F3", page: "CultureQuizPage.qml"}
            ];
        } else if (age === 7) {
            return [
                {name: "Compréhension", icon: "📝", color: "#2E86C1", iconBg: "#D6EAF8", page: "MathsQuizPage.qml"},
                {name: "Problèmes", icon: "🧩", color: "#1A5276", iconBg: "#AED6F1", page: "CultureQuizPage.qml"},
                {name: "Suites", icon: "🔄", color: "#58D68D", iconBg: "#D5F5E3", page: "ScienceQuizPage.qml"},
                {name: "Émotions", icon: "😊", color: "#82E0AA", iconBg: "#E8F8F5", page: "HistoireQuizPage.qml"},
                {name: "Géographie simple", icon: "🗺️", color: "#3498DB", iconBg: "#EBF5FB", page: "GeographieQuizPage.qml"},
                {name: "Mois/saisons", icon: "🍂", color: "#27AE60", iconBg: "#D4EFDF", page: "MathsQuizPage.qml"},
                {name: "Classification", icon: "📋", color: "#1ABC9C", iconBg: "#E8F6F3", page: "CultureQuizPage.qml"}
            ];
        } else if (age === 8) {
            return [
                {name: "Lecture", icon: "📚", color: "#2E86C1", iconBg: "#D6EAF8", page: "MathsQuizPage.qml"},
                {name: "Multiplications", icon: "✖️", color: "#1A5276", iconBg: "#AED6F1", page: "CultureQuizPage.qml"},
                {name: "Tri", icon: "📊", color: "#58D68D", iconBg: "#D5F5E3", page: "ScienceQuizPage.qml"},
                {name: "Pays francophones", icon: "🇫🇷", color: "#82E0AA", iconBg: "#E8F8F5", page: "HistoireQuizPage.qml"},
                {name: "Écologie", icon: "♻️", color: "#3498DB", iconBg: "#EBF5FB", page: "GeographieQuizPage.qml"},
                {name: "Sciences", icon: "🌱", color: "#27AE60", iconBg: "#D4EFDF", page: "MathsQuizPage.qml"},
                {name: "Météo", icon: "🌤️", color: "#1ABC9C", iconBg: "#E8F6F3", page: "CultureQuizPage.qml"}
            ];
        } else if (age === 9) {
            return [
                {name: "Problèmes complexes", icon: "🧩", color: "#2E86C1", iconBg: "#D6EAF8", page: "MathsQuizPage.qml"},
                {name: "Lecture + questions", icon: "🔍", color: "#1A5276", iconBg: "#AED6F1", page: "CultureQuizPage.qml"},
                {name: "Grammaire", icon: "🔤", color: "#58D68D", iconBg: "#D5F5E3", page: "ScienceQuizPage.qml"},
                {name: "Histoire simple", icon: "⏳", color: "#82E0AA", iconBg: "#E8F8F5", page: "HistoireQuizPage.qml"},
                {name: "Géographie", icon: "🌍", color: "#3498DB", iconBg: "#EBF5FB", page: "GeographieQuizPage.qml"},
                {name: "Écologie", icon: "🌎", color: "#27AE60", iconBg: "#D4EFDF", page: "MathsQuizPage.qml"},
                {name: "Logique", icon: "💡", color: "#1ABC9C", iconBg: "#E8F6F3", page: "CultureQuizPage.qml"}
            ];
        } else {
            // Pour les 10 ans, on conserve les matières standard
            return [
                {name: "Mathématiques", icon: "123", color: "#2E86C1", iconBg: "#D6EAF8", page: "MathsQuizPage.qml"},
                {name: "Culture Générale", icon: "?", color: "#1A5276", iconBg: "#AED6F1", page: "CultureQuizPage.qml"},
                {name: "Sciences", icon: "⚗", color: "#58D68D", iconBg: "#D5F5E3", page: "ScienceQuizPage.qml"},
                {name: "Histoire", icon: "⏳", color: "#82E0AA", iconBg: "#E8F8F5", page: "HistoireQuizPage.qml"},
                {name: "Géographie", icon: "🌍", color: "#3498DB", iconBg: "#EBF5FB", page: "GeographieQuizPage.qml"}
            ];
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
                text: "Choisissez un quiz"
                font.pixelSize: Style.fontSizeXLarge
                font.family: appFont.family
                font.weight: Font.Medium
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: Style.textColorPrimary
            }
            
            // Sélecteur d'âge
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: Style.spacingSmall
                
                Label {
                    text: "Âge:"
                    font.pixelSize: Style.fontSizeMedium
                    font.family: appFont.family
                    color: Style.textColorPrimary
                }
                
                // ComboBox visible seulement en mode parent
                ComboBox {
                    id: ageSelector
                    visible: appMode === "parent"
                    enabled: appMode === "parent"
                    model: [3, 4, 5, 6, 7, 8, 9, 10]
                    currentIndex: selectedAge - 3 // Conversion de l'âge en index (3 ans = index 0)
                    onCurrentIndexChanged: {
                        selectedAge = ageSelector.currentIndex + 3
                        // Si on veut sauvegarder l'âge global pour le mode enfant :
                        if (typeof root !== 'undefined' && root.globalSelectedAge !== undefined) {
                            root.globalSelectedAge = selectedAge
                        }
                    }
                    delegate: ItemDelegate {
                        width: ageSelector.width
                        contentItem: Text {
                            text: modelData
                            font.pixelSize: Style.fontSizeMedium
                            font.family: appFont.family
                            color: Style.textColorPrimary
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }
                    }
                }
                // Affichage simple de l'âge en mode enfant
                Text {
                    visible: appMode === "enfant"
                    text: selectedAge + " ans"
                    font.pixelSize: Style.fontSizeMedium
                    font.family: appFont.family
                    color: Style.textColorPrimary
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            

        }
    }

    ScrollView {
        id: horizontalScrollView
        anchors.fill: parent
        anchors.margins: Style.spacingMedium
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip: true
        contentWidth: quizRow.width

        // Centrer le contenu verticalement
        Item {
            width: quizRow.width
            height: parent.height
            
            // Rangée horizontale pour les cartes
            Row {
                id: quizRow
                spacing: Style.spacingLarge * 2
                anchors.centerIn: parent
                

                // Modèle de données pour les matières
                Repeater {
                    model: getSubjectsForAge(selectedAge)
                    
                    delegate: Item {
                        id: quizSquare
                        width: 400
                        height: 500
                        
                        property int animationDuration: Style.animationDurationFast

                        Rectangle {
                            id: cardBackground
                            width: parent.width
                            height: parent.width
                            anchors.top: parent.top
                            color: Style.surfaceColor
                            radius: Style.radiusMedium
                            
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                shadowEnabled: true
                                shadowColor: Qt.rgba(0, 0, 0, 0.15)
                                shadowHorizontalOffset: 0
                                shadowVerticalOffset: 2
                                shadowBlur: 8
                            }

                            states: [
                                State {
                                    name: "pressed"
                                    PropertyChanges {
                                        target: cardBackground
                                        scale: 0.95
                                    }
                                }
                            ]

                            transitions: [
                                Transition {
                                    to: "pressed"
                                    NumberAnimation { properties: "scale"; duration: quizSquare.animationDuration; easing.type: Easing.OutQuad }
                                },
                                Transition {
                                    from: "pressed"
                                    NumberAnimation { properties: "scale"; duration: quizSquare.animationDuration; easing.type: Easing.OutQuad }
                                }
                            ]
                            
                            Rectangle {
                                id: colorBar
                                width: parent.width
                                height: Style.spacingMedium * 3
                                color: modelData.color
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                radius: parent.radius
                                
                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    height: parent.height / 2
                                    color: parent.color
                                }
                            }

                            Item {
                                anchors.fill: parent
                                anchors.topMargin: colorBar.height + Style.spacingMedium * 2
                                anchors.leftMargin: Style.spacingMedium * 2
                                anchors.rightMargin: Style.spacingMedium * 2
                                anchors.bottomMargin: Style.spacingMedium * 2

                                Rectangle {
                                    id: iconBackground
                                    width: parent.width * 0.6
                                    height: width
                                    radius: width / 2
                                    color: modelData.iconBg
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.icon
                                        font.pixelSize: parent.width * 0.5
                                        font.weight: Font.Bold
                                        font.family: appFont.family
                                        color: modelData.color
                                    }
                                }

                                // Play icon position adjusted down by approximately 1cm (about 40-50 logical pixels)
                                // Original bottomMargin was Style.spacingMedium * 3
                                Image {
                                    id: playIcon
                                    source: "assets/icons/play_circle.svg"
                                    sourceSize.width: 72
                                    sourceSize.height: 72
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    
                                    // Position adjusted to be closer to the bottom
                                    y: parent.height - height - Style.spacingMedium
                                    
                                    layer.enabled: true
                                    layer.effect: MultiEffect {
                                        colorization: 1.0
                                        colorizationColor: "black"
                                    }
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onPressed: cardBackground.state = "pressed"
                                onReleased: cardBackground.state = ""
                                onCanceled: cardBackground.state = ""
                                onClicked: {
                                    console.log("Quiz " + modelData.name + " selected");
                                    console.log("DEBUG - Navigation vers " + modelData.page);
                                    
                                    // Approche générique pour tous les âges
                                    if (selectedAge === 3) {
                                        // Pour les enfants de 3 ans, utiliser QuizSimpleInterface
                                        var subject = modelData.name.toLowerCase();
                                        console.log("DEBUG - Redirection vers QuizSimpleInterface.qml avec sujet: " + subject);
                                        stackView.push("QuizSimpleInterface.qml", {
                                            "questionSubject": subject,
                                            "selectedAge": selectedAge
                                        });
                                    } else {
                                        // Pour les autres âges, utiliser la page spécifiée dans modelData.page
                                        stackView.push(modelData.page, {
                                            "selectedAge": selectedAge
                                        });
                                    }
                                    console.log("DEBUG - Passage vers la page effectué");
                                    // Le contrôleur de quiz est géré directement dans la page de quiz
                                    // Pas besoin d'appeler startQuiz ici
                                }
                            }
                        }

                        Text {
                            text: modelData.name
                            font.pixelSize: Style.fontSizeMedium * 2
                            font.weight: Font.Medium
                            font.family: appFont.family
                            color: Style.textColorPrimary
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            maximumLineCount: 2
                            anchors.top: cardBackground.bottom
                            anchors.topMargin: Style.spacingMedium
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }

    // Indicateur de défilement horizontal
    PageIndicator {
        id: indicator
        count: Math.ceil(quizRow.width / horizontalScrollView.width)
        currentIndex: Math.floor(horizontalScrollView.contentItem.contentX / (horizontalScrollView.width - Style.spacingMedium * 2))
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: Style.spacingMedium
        visible: count > 1
        
        delegate: Rectangle {
            implicitWidth: 10
            implicitHeight: 10
            radius: width / 2
            color: index === indicator.currentIndex ? Style.accentColor : Style.textColorTertiary
            opacity: index === indicator.currentIndex ? 1 : 0.5
        }
    }

    // Simple touch area for swipe navigation
    MouseArea {
        anchors.fill: parent
        property real startX: 0
        property real threshold: 50
        
        onPressed: function(mouse) {
            startX = mouse.x
        }
        
        onReleased: function(mouse) {
            var delta = mouse.x - startX
            if (Math.abs(delta) > threshold) {
                if (delta > 0 && horizontalScrollView.contentItem.contentX > 0) {
                    // Swipe right - go to previous
                    horizontalScrollView.contentItem.contentX -= horizontalScrollView.width * 0.8
                } else if (delta < 0 && horizontalScrollView.contentItem.contentX < quizRow.width - horizontalScrollView.width) {
                    // Swipe left - go to next
                    horizontalScrollView.contentItem.contentX += horizontalScrollView.width * 0.8
                }
            }
        }
        
        // Allow child mouse areas to handle their own events
        propagateComposedEvents: true
    }
}
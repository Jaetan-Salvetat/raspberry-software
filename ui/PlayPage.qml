import QtQuick
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Effects
import "."

Page {
    id: playPage
    background: Rectangle { color: Style.backgroundColor }

    property QtObject quizController

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

            Item { width: backButton.width }
        }
    }

    ListView {
        id: quizList
        anchors.fill: parent
        anchors.margins: Style.spacingMedium
        spacing: Style.spacingMedium
        clip: true
        model: [
            {name: "Mathématiques", icon: "123", color: "#2979FF", iconBg: "#BBDEFB"},
            {name: "Culture Générale", icon: "?", color: "#F50057", iconBg: "#F8BBD0"},
            {name: "Sciences", icon: "⚗", color: "#00BFA5", iconBg: "#B2DFDB"},
            {name: "Histoire", icon: "⏳", color: "#FFC107", iconBg: "#FFECB3"},
            {name: "Géographie", icon: "🌍", color: "#673AB7", iconBg: "#D1C4E9"}
        ]
        delegate: QuizCard {
            width: quizList.width
            quizName: modelData.name
            quizIcon: modelData.icon
            cardColor: modelData.color
            iconBgColor: modelData.iconBg
            onClicked: {
                console.log("Quiz " + modelData.name + " selected")
                if (typeof quizController !== "undefined" && quizController) {
                    quizController.startQuiz(modelData.name.toLowerCase())
                }
            }
        }

        header: Item {
            width: parent.width
            height: Style.spacingLarge
        }
        
        footer: Item {
            width: parent.width
            height: Style.spacingLarge
        }

        ScrollBar.vertical: ScrollBar {}
    }

    component QuizCard: Item {
        id: quizCard
        property string quizName: ""
        property string quizIcon: ""
        property string cardColor: Style.primaryColor
        property string iconBgColor: "white"
        property int animationDuration: Style.animationDurationFast
        
        signal clicked()

        height: 100

        Rectangle {
            id: cardBackground
            anchors.fill: parent
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
                        scale: 0.98
                        layer.effect.shadowVerticalOffset: 1
                        layer.effect.shadowBlur: 4
                    }
                }
            ]

            transitions: [
                Transition {
                    to: "pressed"
                    ParallelAnimation {
                        NumberAnimation { properties: "scale"; duration: quizCard.animationDuration; easing.type: Easing.OutQuad }
                        NumberAnimation { target: cardBackground.layer.effect; properties: "shadowVerticalOffset,shadowBlur"; duration: quizCard.animationDuration; easing.type: Easing.OutQuad }
                    }
                },
                Transition {
                    from: "pressed"
                    ParallelAnimation {
                        NumberAnimation { properties: "scale"; duration: quizCard.animationDuration; easing.type: Easing.OutQuad }
                        NumberAnimation { target: cardBackground.layer.effect; properties: "shadowVerticalOffset,shadowBlur"; duration: quizCard.animationDuration; easing.type: Easing.OutQuad }
                    }
                }
            ]
        }

        Rectangle {
            id: colorBar
            width: Style.spacingMedium
            height: parent.height
            color: quizCard.cardColor
            radius: Style.radiusMedium
            anchors.left: parent.left
        }

        RowLayout {
            anchors {
                fill: parent
                leftMargin: Style.spacingMedium + Style.spacingMedium
                rightMargin: Style.spacingMedium
                topMargin: Style.spacingMedium
                bottomMargin: Style.spacingMedium
            }
            spacing: Style.spacingLarge

            Rectangle {
                width: 60
                height: 60
                radius: Style.radiusLarge
                color: quizCard.iconBgColor
                Layout.alignment: Qt.AlignVCenter

                Text {
                    anchors.centerIn: parent
                    text: quizCard.quizIcon
                    font.pixelSize: 30
                    font.weight: Font.Bold
                    font.family: appFont.family
                    color: quizCard.cardColor
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.spacingTiny

                Text {
                    text: quizCard.quizName
                    font.pixelSize: Style.fontSizeLarge
                    font.weight: Font.Medium
                    font.family: appFont.family
                    color: Style.textColorPrimary
                    Layout.fillWidth: true
                }

                Text {
                    text: "Appuyez pour commencer"
                    font.pixelSize: Style.fontSizeSmall
                    font.family: appFont.family
                    color: Style.textColorSecondary
                    Layout.fillWidth: true
                }
            }

            Image {
                source: "assets/icons/play_circle.svg"
                sourceSize.width: 36
                sourceSize.height: 36
                Layout.alignment: Qt.AlignVCenter
                opacity: 0.6
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: cardBackground.state = "pressed"
            onReleased: cardBackground.state = ""
            onCanceled: cardBackground.state = ""
            onClicked: quizCard.clicked()
        }
    }
}

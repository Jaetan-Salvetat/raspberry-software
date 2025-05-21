import QtQuick
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Effects
import "."

Page {
    id: ageSelectionPage
    background: Rectangle { color: Style.backgroundColor }

    property int selectedAge: 3

    Rectangle {
        anchors.fill: parent
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

        Item {
            id: headerSection
            width: parent.width
            height: parent.height * 0.4
            anchors.top: parent.top

            Image {
                id: logoImage
                source: "assets/LudoBot.png"
                width: 300
                height: 300
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                
                // Animation subtile de pulsation
                SequentialAnimation on scale {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 1.05; duration: 2000; easing.type: Easing.InOutQuad }
                    NumberAnimation { from: 1.05; to: 1.0; duration: 2000; easing.type: Easing.InOutQuad }
                }

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#80000000"
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 4
                    shadowBlur: 15
                    colorization: 0.1
                    colorizationColor: Style.accentColor
                }
            }

            Text {
                id: titleText
                text: "Quel âge as-tu ?"
                color: Style.textColorPrimary
                font {
                    family: appFont.family
                    pixelSize: Style.fontSizeHeader
                    weight: Font.Bold
                }
                anchors {
                    top: logoImage.bottom
                    topMargin: Style.spacingSmall
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Text {
                id: subtitleText
                text: "Choisis ton âge pour commencer"
                color: Style.textColorSecondary
                font {
                    family: appFont.family
                    pixelSize: Style.fontSizeMedium
                }
                anchors {
                    top: titleText.bottom
                    topMargin: Style.spacingTiny
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            id: menuSection
            anchors {
                top: headerSection.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            color: "transparent"

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width * 0.9, 600)
                spacing: Style.spacingLarge

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Style.spacingLarge

                    RoundButton {
                        text: "-"
                        font.pixelSize: Style.fontSizeXXLarge
                        font.weight: Font.Bold
                        Material.background: Style.primaryColor
                        Material.foreground: "white"
                        enabled: selectedAge > 3
                        onClicked: selectedAge--
                    }

                    Text {
                        text: selectedAge
                        font.pixelSize: 72
                        font.family: appFont.family
                        font.weight: Font.Bold
                        color: Style.textColorPrimary
                        Layout.minimumWidth: 120
                        horizontalAlignment: Text.AlignHCenter
                    }

                    RoundButton {
                        text: "+"
                        font.pixelSize: Style.fontSizeXXLarge
                        font.weight: Font.Bold
                        Material.background: Style.primaryColor
                        Material.foreground: "white"
                        enabled: selectedAge < 10
                        onClicked: selectedAge++
                    }
                }

                Text {
                    text: "ans"
                    font.pixelSize: Style.fontSizeLarge
                    font.family: appFont.family
                    font.weight: Font.Medium
                    color: Style.textColorSecondary
                    Layout.alignment: Qt.AlignHCenter
                }

                RoundButton {
                    Layout.alignment: Qt.AlignHCenter
                    icon.source: "assets/icons/play_circle.svg"
                    icon.width: 48
                    icon.height: 48
                    icon.color: "white"
                    width: 80
                    height: 80
                    Material.background: Style.primaryColor
                    Material.foreground: "white"
                    Material.elevation: Style.elevation2
                    onClicked: stackView.push("PlayPage.qml", {selectedAge: selectedAge})
                }
            }
        }
    }

    RoundButton {
        id: backButton
        anchors {
            left: parent.left
            top: parent.top
            margins: Style.spacingMedium
        }
        icon.source: "assets/icons/arrow_back.svg"
        icon.width: 24
        icon.height: 24
        flat: true
        onClicked: stackView.pop()
        Material.foreground: Style.textColorPrimary
    }
}

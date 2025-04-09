import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "."

ApplicationWindow {
    id: root
    visible: true
    width: Screen.width
    height: Screen.height
    title: "LudoBot"
    flags: Qt.Window | Qt.FramelessWindowHint
    visibility: Window.FullScreen
    color: Style.primaryColor

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: homePage
    }

    Component {
        id: homePage
        Rectangle {
            color: Style.primaryColor

            Image {
                id: logoImage
                source: "assets/LudoBot.png"
                width: 200
                height: 200
                anchors {
                    top: parent.top
                    topMargin: 60
                    horizontalCenter: parent.horizontalCenter
                }
                fillMode: Image.PreserveAspectFit
            }

            Text {
                id: titleText
                text: "LudoBot"
                color: Style.textColorLight
                font {
                    pixelSize: Style.fontSizeHeader
                    bold: true
                }
                anchors {
                    top: logoImage.bottom
                    topMargin: Style.spacingMedium
                    horizontalCenter: parent.horizontalCenter
                }
            }

            ColumnLayout {
                anchors {
                    top: titleText.bottom
                    topMargin: Style.spacingLarge
                    horizontalCenter: parent.horizontalCenter
                }
                spacing: Style.spacingMedium
                width: parent.width * 0.4

                MainMenuButton {
                    text: "Jouer"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    onClicked: stackView.push("PlayPage.qml")
                }

                MainMenuButton {
                    text: "Wifi"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    onClicked: stackView.push("WifiPage.qml")
                }

                MainMenuButton {
                    text: "Réglage"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    onClicked: stackView.push("SettingsPage.qml")
                }

                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    Layout.topMargin: Style.spacingSmall
                    font.pixelSize: Style.fontSizeLarge
                    font.bold: true
                    background: Rectangle {
                        color: Style.dangerColor
                        radius: Style.radiusSmall
                    }
                    contentItem: Text {
                        text: "Quitter"
                        font: parent.font
                        color: Style.textColorLight
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: Qt.quit()
                }
            }
        }
    }

    component MainMenuButton: Button {
        font.pixelSize: Style.fontSizeLarge
        font.bold: true

        background: Rectangle {
            color: Style.accentColor
            radius: Style.radiusSmall
        }
        
        contentItem: Text {
            text: parent.text
            font: parent.font
            color: Style.textColorDark
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}

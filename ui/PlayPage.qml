import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."

Rectangle {
    id: playPage
    color: Style.primaryColor

    Text {
        id: titleText
        text: "Jouer"
        color: Style.textColorLight
        font {
            pixelSize: Style.fontSizeHeader
            bold: true
        }
        anchors {
            top: parent.top
            topMargin: Style.spacingLarge
            horizontalCenter: parent.horizontalCenter
        }
    }

    Button {
        id: backButton
        anchors {
            left: parent.left
            top: parent.top
            margins: Style.spacingMedium
        }
        width: 50
        height: 50
        background: Rectangle {
            color: "transparent"
            border.color: Style.textColorLight
            border.width: 2
            radius: 25
        }
        contentItem: Text {
            text: "←"
            color: Style.textColorLight
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: stackView.pop()
    }

    ColumnLayout {
        anchors {
            top: titleText.bottom
            topMargin: Style.spacingLarge * 2
            horizontalCenter: parent.horizontalCenter
        }
        spacing: Style.spacingMedium
        width: parent.width * 0.6

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: Style.accentColor
            radius: Style.radiusMedium

            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Quiz Mathématiques selected")
            }

            RowLayout {
                anchors {
                    fill: parent
                    margins: Style.spacingMedium
                }
                spacing: Style.spacingMedium

                Rectangle {
                    width: 60
                    height: 60
                    radius: 30
                    color: "white"
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        anchors.centerIn: parent
                        text: "123"
                        font.pixelSize: 24
                        font.bold: true
                        color: Style.primaryColor
                    }
                }

                Text {
                    text: "Quiz Mathématiques"
                    font.pixelSize: Style.fontSizeLarge
                    font.bold: true
                    color: Style.textColorDark
                    Layout.fillWidth: true
                }

                Text {
                    text: "→"
                    font.pixelSize: 30
                    color: Style.textColorDark
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: Style.accentColor
            radius: Style.radiusMedium

            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Quiz Général selected")
            }

            RowLayout {
                anchors {
                    fill: parent
                    margins: Style.spacingMedium
                }
                spacing: Style.spacingMedium

                Rectangle {
                    width: 60
                    height: 60
                    radius: 30
                    color: "white"
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        anchors.centerIn: parent
                        text: "?"
                        font.pixelSize: 30
                        font.bold: true
                        color: Style.primaryColor
                    }
                }

                Text {
                    text: "Quiz Culture Générale"
                    font.pixelSize: Style.fontSizeLarge
                    font.bold: true
                    color: Style.textColorDark
                    Layout.fillWidth: true
                }

                Text {
                    text: "→"
                    font.pixelSize: 30
                    color: Style.textColorDark
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: Style.accentColor
            radius: Style.radiusMedium

            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Quiz Sciences selected")
            }

            RowLayout {
                anchors {
                    fill: parent
                    margins: Style.spacingMedium
                }
                spacing: Style.spacingMedium

                Rectangle {
                    width: 60
                    height: 60
                    radius: 30
                    color: "white"
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        anchors.centerIn: parent
                        text: "⚗"
                        font.pixelSize: 30
                        font.bold: true
                        color: Style.primaryColor
                    }
                }

                Text {
                    text: "Quiz Sciences"
                    font.pixelSize: Style.fontSizeLarge
                    font.bold: true
                    color: Style.textColorDark
                    Layout.fillWidth: true
                }

                Text {
                    text: "→"
                    font.pixelSize: 30
                    color: Style.textColorDark
                }
            }
        }
    }
}

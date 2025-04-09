import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."

Rectangle {
    id: settingsPage
    color: Style.primaryColor

    property QtObject controller: settingsController

    Image {
        id: logoImage
        source: "assets/LudoBot.png"
        width: 120
        height: 120
        anchors {
            top: parent.top
            topMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    Text {
        id: titleText
        text: "Réglages"
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

    ScrollView {
        id: settingsScrollView
        anchors {
            top: titleText.bottom
            topMargin: Style.spacingLarge * 2
            left: parent.left
            right: parent.right
            leftMargin: Style.spacingLarge
            rightMargin: Style.spacingLarge
        }
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        ColumnLayout {
            id: settingsColumn
            spacing: Style.spacingMedium
            width: settingsScrollView.width

            SettingsCard {
                title: "Volume"
                iconSource: "assets/volume.svg"
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: Style.spacingSmall
                    Layout.fillWidth: true
                    Layout.topMargin: Style.spacingSmall
                    Layout.bottomMargin: Style.spacingSmall

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Style.spacingSmall

                        Text {
                            text: "Volume principal"
                            color: Style.textColorDark
                            font.pixelSize: Style.fontSizeSmall
                        }

                        Slider {
                            id: volumeSlider
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            implicitHeight: 40
                            height: 40
                            from: 0
                            to: 100
                            value: controller.volume || 0
                            live: true
                            snapMode: Slider.SnapAlways
                            stepSize: 1
                            onValueChanged: volumeText.text = Math.round(value) + "%"
                            onPressedChanged: {
                                if (!pressed)
                                    controller.set_volume(Math.round(value))
                            }
                            
                            background: Rectangle {
                                x: volumeSlider.leftPadding
                                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                width: volumeSlider.availableWidth
                                height: 8
                                radius: 4
                                color: "#dddddd"

                                Rectangle {
                                    width: volumeSlider.visualPosition * parent.width
                                    height: parent.height
                                    color: Style.accentColor
                                    radius: 3
                                }
                            }

                            handle: Rectangle {
                                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                width: 20
                                height: 20
                                radius: 10
                                color: Style.accentColor
                                border.color: "white"
                                border.width: 2
                            }
                        }

                        Text {
                            id: volumeText
                            text: Math.round(volumeSlider.value || 0) + "%"
                            color: Style.textColorDark
                            font.pixelSize: Style.fontSizeMedium
                            font.bold: true
                            Layout.preferredWidth: 60
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }
            }

            SettingsCard {
                title: "Vibration"
                iconSource: "assets/vibration.svg"
                Layout.fillWidth: true

                RowLayout {
                    spacing: Style.spacingSmall
                    Layout.fillWidth: true
                    Layout.topMargin: Style.spacingSmall
                    Layout.bottomMargin: Style.spacingSmall

                    Text {
                        text: "Activer les vibrations"
                        color: Style.textColorDark
                        font.pixelSize: Style.fontSizeSmall
                        Layout.fillWidth: true
                    }

                    Switch {
                        id: vibrationSwitch
                        checked: controller.vibration_enabled
                        onCheckedChanged: controller.set_vibration_enabled(vibrationSwitch.checked)
                        
                        indicator: Rectangle {
                            implicitWidth: 48
                            implicitHeight: 26
                            x: vibrationSwitch.leftPadding
                            y: parent.height / 2 - height / 2
                            radius: 13
                            color: vibrationSwitch.checked ? Style.accentColor : "#cccccc"
                            border.color: vibrationSwitch.checked ? Style.accentColor : "#999999"

                            Rectangle {
                                x: vibrationSwitch.checked ? parent.width - width - 2 : 2
                                y: 2
                                width: 22
                                height: 22
                                radius: 11
                                color: "white"
                            }
                        }
                    }
                }
            }

            SettingsCard {
                title: "Langue"
                iconSource: "assets/language.svg"
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: Style.spacingSmall
                    Layout.bottomMargin: Style.spacingSmall
                    spacing: Style.spacingSmall

                    Text {
                        text: "Sélectionnez la langue"
                        color: Style.textColorDark
                        font.pixelSize: Style.fontSizeSmall
                    }

                    ComboBox {
                        id: languageCombo
                        model: ["Français", "English"]
                        currentIndex: 0
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        font.pixelSize: Style.fontSizeMedium
                        popup.font.pixelSize: Style.fontSizeMedium
                        
                        onActivated: {
                            controller.set_language(currentIndex)
                        }
                    }
                }
            }

            Button {
                text: "Enregistrer"
                Layout.fillWidth: true

                Layout.preferredHeight: 50
                Layout.topMargin: Style.spacingMedium
                font.pixelSize: Style.fontSizeMedium
                font.bold: true

                background: Rectangle {
                    color: Style.accentColor
                    radius: Style.radiusMedium
                }

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    controller.save_settings()
                    stackView.pop()
                }
            }
        }
    }

    component SettingsCard: Rectangle {
        id: settingsCard
        property string title: ""
        property string iconSource: ""
        default property alias content: contentLayout.children

        color: Style.cardColor
        radius: Style.radiusMedium
        implicitHeight: headerRow.height + contentLayout.height + 40
        Layout.fillWidth: true

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Style.shadowColor
            opacity: 0.1
            z: -1
        }

        ColumnLayout {
            anchors {
                fill: parent
                margins: 15
            }
            spacing: 5

            RowLayout {
                id: headerRow
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: iconSource
                    sourceSize.width: 24
                    sourceSize.height: 24
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: title
                    font.pixelSize: 18
                    font.bold: true
                    color: "#333333"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#e0e0e0"
            }

            ColumnLayout {
                id: contentLayout
                Layout.fillWidth: true
                spacing: 10
            }
        }
    }
    
    Popup {
        id: savePopup
        anchors.centerIn: parent
        width: 250
        height: 100
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        background: Rectangle {
            color: Style.cardColor
            radius: Style.radiusMedium
            border.color: Style.accentColor
            border.width: 2
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.spacingSmall
            spacing: Style.spacingMedium
            
            Text {
                text: "Paramètres sauvegardés !"
                font.pixelSize: Style.fontSizeMedium
                font.bold: true
                color: Style.textColorDark
                Layout.alignment: Qt.AlignHCenter
            }
            
            Button {
                text: "OK"
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 80

                background: Rectangle {
                    color: Style.accentColor
                    radius: Style.radiusMedium
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: Style.fontSizeSmall
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}

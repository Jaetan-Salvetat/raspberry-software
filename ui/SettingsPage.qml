import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."

Rectangle {
    id: settingsPage
    color: Style.primaryColor

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
        visible: false // We'll create this image later if needed
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

    // Back button with modern styling
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
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: Style.spacingLarge
            leftMargin: Style.spacingLarge
            rightMargin: Style.spacingLarge
            bottomMargin: Style.spacingLarge
        }
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        ColumnLayout {
            id: settingsColumn
            width: settingsScrollView.width - 80
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            // Volume setting
            SettingsCard {
                title: "Volume"
                iconSource: "assets/volume.svg"
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Volume principal"
                            color: "#333333"
                            font.pixelSize: 16
                        }

                        Slider {
                            id: volumeSlider
                            Layout.fillWidth: true
                            from: 0
                            to: 100
                            value: 75
                            stepSize: 1
                            
                            background: Rectangle {
                                x: volumeSlider.leftPadding
                                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                width: volumeSlider.availableWidth
                                height: 4
                                radius: 2
                                color: "#e0e0e0"

                                Rectangle {
                                    width: volumeSlider.visualPosition * parent.width
                                    height: parent.height
                                    color: Style.accentColor
                                    radius: 2
                                }
                            }

                            handle: Rectangle {
                                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                width: 16
                                height: 16
                                radius: 8
                                color: "white"
                                border.color: Style.accentColor
                                border.width: 2
                            }
                        }

                        Text {
                            text: volumeSlider.value.toFixed(0) + "%"
                            color: "#333333"
                            font.pixelSize: 16
                            Layout.preferredWidth: 40
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    CheckBox {
                        text: "Effets sonores"
                        checked: true
                        Layout.fillWidth: true
                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: 16
                            color: "#333333"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: parent.indicator.width + parent.spacing
                        }
                    }
                }
            }

            // Brightness setting
            SettingsCard {
                title: "Luminosité"
                iconSource: "assets/brightness.svg"
                Layout.fillWidth: true

                RowLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10

                    Text {
                        text: "Niveau de luminosité"
                        color: "#333333"
                        font.pixelSize: 16
                    }

                    Slider {
                        id: brightnessSlider
                        Layout.fillWidth: true
                        from: 10
                        to: 100
                        value: 80
                        stepSize: 1
                        
                        background: Rectangle {
                            x: brightnessSlider.leftPadding
                            y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                            width: brightnessSlider.availableWidth
                            height: 4
                            radius: 2
                            color: "#e0e0e0"

                            Rectangle {
                                width: brightnessSlider.visualPosition * parent.width
                                height: parent.height
                                color: settingsPage.accentColor
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
                            y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                            width: 16
                            height: 16
                            radius: 8
                            color: "white"
                            border.color: settingsPage.accentColor
                            border.width: 2
                        }
                    }

                    Text {
                        text: brightnessSlider.value.toFixed(0) + "%"
                        color: "#333333"
                        font.pixelSize: 16
                        Layout.preferredWidth: 40
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }

            // Language setting
            SettingsCard {
                title: "Langue"
                iconSource: "assets/language.svg"
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10
                    spacing: 10

                    ComboBox {
                        id: languageCombo
                        model: ["Français", "English", "Español"]
                        currentIndex: 0
                        Layout.fillWidth: true
                        font.pixelSize: 16
                        popup.font.pixelSize: 16
                    }
                }
            }

            // Game difficulty setting
            SettingsCard {
                title: "Difficulté du jeu"
                iconSource: "assets/difficulty.svg"
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10
                    spacing: 10

                    ButtonGroup { id: difficultyGroup }

                    RadioButton {
                        checked: true
                        text: "Facile"
                        ButtonGroup.group: difficultyGroup
                        Layout.fillWidth: true
                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: 16
                            color: "#333333"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: parent.indicator.width + parent.spacing
                        }
                    }

                    RadioButton {
                        text: "Normale"
                        ButtonGroup.group: difficultyGroup
                        Layout.fillWidth: true
                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: 16
                            color: "#333333"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: parent.indicator.width + parent.spacing
                        }
                    }

                    RadioButton {
                        text: "Difficile"
                        ButtonGroup.group: difficultyGroup
                        Layout.fillWidth: true
                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: 16
                            color: "#333333"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: parent.indicator.width + parent.spacing
                        }
                    }
                }
            }

            // Save button
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
                    // Save settings logic would go here
                    stackView.pop()
                }
            }
        }
    }

    // Custom component for settings cards
    component SettingsCard: Rectangle {
        id: settingsCard
        property string title: ""
        property string iconSource: ""
        default property alias content: contentLayout.children

        color: Style.cardColor
        radius: Style.radiusMedium
        height: headerRow.height + contentLayout.height + 30
        Layout.fillWidth: true

        // Shadow effect for the card
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
}

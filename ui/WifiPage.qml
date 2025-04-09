import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."

Rectangle {
    id: wifiPage
    color: Style.primaryColor

    Text {
        id: titleText
        text: "Configuration Wifi"
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

    // WiFi configuration content
    Rectangle {
        id: wifiCard
        color: Style.cardColor
        radius: Style.radiusMedium
        anchors {
            top: titleText.bottom
            topMargin: Style.spacingLarge
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: Style.spacingLarge
            rightMargin: Style.spacingLarge
            bottomMargin: Style.spacingLarge
        }

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
                margins: Style.spacingMedium
            }
            spacing: Style.spacingMedium

            // Network selection header
            Text {
                text: "Réseaux disponibles"
                font.pixelSize: Style.fontSizeMedium
                font.bold: true
                color: Style.textColorDark
            }

            // Network list
            ListView {
                id: networkList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: ["LudoBot_Network", "Home_Wifi", "Guest_Network", "School_Wifi"]
                delegate: Rectangle {
                    width: networkList.width
                    height: 60
                    color: index % 2 === 0 ? "#f7f7f7" : "#ffffff"

                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: Style.spacingMedium
                            rightMargin: Style.spacingMedium
                        }
                        spacing: Style.spacingMedium

                        Text {
                            text: "ǁ"
                            font.pixelSize: Style.fontSizeMedium
                            color: Style.primaryColor
                        }

                        Text {
                            text: modelData
                            font.pixelSize: Style.fontSizeMedium
                            color: Style.textColorDark
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "Connecter"
                            font.pixelSize: Style.fontSizeSmall
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
                            onClicked: {
                                passwordDialog.networkName = modelData
                                passwordDialog.open()
                            }
                        }
                    }
                }
            }

            // Add network button
            Button {
                text: "Ajouter un réseau manuellement"
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                font.pixelSize: Style.fontSizeMedium
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
                onClicked: addNetworkDialog.open()
            }
        }
    }

    // Password Dialog
    Dialog {
        id: passwordDialog
        property string networkName: ""
        title: "Se connecter à " + networkName
        modal: true
        anchors.centerIn: parent
        standardButtons: Dialog.Ok | Dialog.Cancel
        width: 400

        ColumnLayout {
            width: parent.width
            spacing: Style.spacingMedium

            Text {
                text: "Mot de passe:"
                color: Style.textColorDark
                font.pixelSize: Style.fontSizeMedium
            }

            TextField {
                id: passwordField
                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "Entrez le mot de passe"
                font.pixelSize: Style.fontSizeMedium
            }

            CheckBox {
                text: "Afficher le mot de passe"
                onCheckedChanged: {
                    passwordField.echoMode = checked ? TextInput.Normal : TextInput.Password
                }
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: Style.fontSizeSmall
                    color: Style.textColorDark
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: parent.indicator.width + parent.spacing
                }
            }
        }

        onAccepted: {
            console.log("Connecting to " + networkName + " with password " + passwordField.text)
            passwordField.text = ""
        }

        onRejected: {
            passwordField.text = ""
        }
    }

    // Add Network Dialog
    Dialog {
        id: addNetworkDialog
        title: "Ajouter un réseau WiFi"
        modal: true
        anchors.centerIn: parent
        standardButtons: Dialog.Ok | Dialog.Cancel
        width: 400

        ColumnLayout {
            width: parent.width
            spacing: Style.spacingMedium

            Text {
                text: "Nom du réseau (SSID):"
                color: Style.textColorDark
                font.pixelSize: Style.fontSizeMedium
            }

            TextField {
                id: ssidField
                Layout.fillWidth: true
                placeholderText: "Entrez le nom du réseau"
                font.pixelSize: Style.fontSizeMedium
            }

            Text {
                text: "Mot de passe:"
                color: Style.textColorDark
                font.pixelSize: Style.fontSizeMedium
            }

            TextField {
                id: newPasswordField
                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "Entrez le mot de passe"
                font.pixelSize: Style.fontSizeMedium
            }

            CheckBox {
                text: "Afficher le mot de passe"
                onCheckedChanged: {
                    newPasswordField.echoMode = checked ? TextInput.Normal : TextInput.Password
                }
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: Style.fontSizeSmall
                    color: Style.textColorDark
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: parent.indicator.width + parent.spacing
                }
            }

            ComboBox {
                id: securityType
                model: ["WPA/WPA2", "WEP", "Aucune"]
                Layout.fillWidth: true
                font.pixelSize: Style.fontSizeMedium
            }
        }

        onAccepted: {
            console.log("Adding network " + ssidField.text + " with security " + securityType.currentText)
            ssidField.text = ""
            newPasswordField.text = ""
        }

        onRejected: {
            ssidField.text = ""
            newPasswordField.text = ""
        }
    }
}

import QtQuick
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Effects
import "."

Page {
    id: wifiTestPage
    background: Rectangle { color: Style.backgroundColor }
    
    property int selectedAge: 6  // Âge par défaut (non utilisé dans cette page)
    property string statusMessage: ""

    // Dialogue pour entrer le mot de passe WiFi
    Dialog {
        id: passwordDialog
        title: "Connexion Wi-Fi"
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.9, 400)

        property string networkSsid: ""

        ColumnLayout {
            width: parent.width
            spacing: Style.spacingMedium

            Label {
                text: "Entrez le mot de passe pour \"" + passwordDialog.networkSsid + "\""
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            TextField {
                id: passwordField
                placeholderText: "Mot de passe"
                echoMode: TextInput.Password
                Layout.fillWidth: true
            }
        }

        onAccepted: {
            if (passwordField.text) {
                var ssid = passwordDialog.networkSsid
                wifiController.connect_to_network(ssid, passwordField.text)
                statusMessage = "Tentative de connexion à " + ssid + "..."
                passwordField.text = ""
            }
        }

        onRejected: {
            passwordField.text = ""
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
                text: "Configuration Wi-Fi"
                font.pixelSize: Style.fontSizeXLarge
                font.family: appFont.family
                font.weight: Font.Medium
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: Style.textColorPrimary
            }

            // Espace équivalent au bouton de gauche pour centrer le titre
            Item { width: backButton.width }
        }
    }
    
    // Contenu principal de la page WiFi
    Item {
        id: wifiContent
        anchors.fill: parent
        visible: true

        ColumnLayout {
            id: columnLayout
            anchors.fill: parent
            anchors.margins: Style.spacingLarge
            spacing: Style.spacingMedium

            // Message de statut
            Label {
                id: statusLabel
                text: statusMessage
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
                color: Style.textColorSecondary
                visible: text !== ""
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            // Réseau actuel
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
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

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Style.spacingMedium
                    spacing: Style.spacingMedium

                    Image {
                        source: "assets/icons/wifi.svg"
                        sourceSize.width: 24
                        sourceSize.height: 24
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        Label {
                            text: "Réseau actuel"
                            font.pixelSize: Style.fontSizeSmall
                            font.family: appFont.family
                            color: Style.textColorSecondary
                        }

                        Label {
                            text: wifiController ? wifiController.currentNetwork() : "Non connecté"
                            font.pixelSize: Style.fontSizeMedium
                            font.family: appFont.family
                            font.weight: Font.Medium
                            color: Style.textColorPrimary
                        }
                    }

                    Button {
                        text: "Actualiser"
                        font.family: appFont.family
                        Material.background: Style.accentColor
                        Material.foreground: "white"
                        onClicked: {
                            if (wifiController) {
                                wifiController.scan_networks()
                                statusMessage = "Recherche des réseaux Wi-Fi..."
                            }
                        }
                    }
                }
            }

            // Liste des réseaux WiFi
            Label {
                text: "Réseaux disponibles"
                font.pixelSize: Style.fontSizeLarge
                font.family: appFont.family
                font.weight: Font.Medium
                color: Style.textColorPrimary
                Layout.topMargin: Style.spacingMedium
            }

            ListView {
                id: networkList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: Style.spacingSmall
                model: wifiController ? wifiController.networks : []

                delegate: ItemDelegate {
                    id: networkItem
                    width: parent.width
                    height: 72
                    
                    Rectangle {
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
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: Style.spacingMedium
                            spacing: Style.spacingMedium

                            Image {
                                source: "assets/icons/wifi.svg"
                                sourceSize.width: 24
                                sourceSize.height: 24
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                opacity: 0.8
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                Label {
                                    text: modelData.ssid
                                    font.pixelSize: Style.fontSizeMedium
                                    font.family: appFont.family
                                    font.weight: Font.Medium
                                    color: Style.textColorPrimary
                                    Layout.fillWidth: true
                                }
                                
                                Label {
                                    text: modelData.connected ? "Connecté" : (modelData.security !== "Open" ? "Sécurisé" : "Ouvert")
                                    font.pixelSize: Style.fontSizeSmall
                                    font.family: appFont.family
                                    color: Style.textColorSecondary
                                    Layout.fillWidth: true
                                }
                            }
                            
                            Image {
                                source: "assets/icons/lock.svg"
                                sourceSize.width: 20
                                sourceSize.height: 20
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: 20
                                opacity: 0.6
                                visible: modelData.security !== "Open"
                            }
                        }
                    }
                    
                    onClicked: {
                        if (modelData.security !== "Open") {
                            passwordDialog.networkSsid = modelData.ssid
                            passwordDialog.open()
                        } else {
                            wifiController.connect_to_network(modelData.ssid, "")
                            statusMessage = "Tentative de connexion à " + modelData.ssid + "..."
                        }
                    }
                }
                
                ScrollBar.vertical: ScrollBar {}
            }
        }
    }
    
    function showResultPage() {
        returnToSubjectsTimer.start()
    }
    
    // Timer pour retourner à la page des matières après 5 secondes
    Timer {
        id: returnToSubjectsTimer
        interval: 5000
        repeat: false
        onTriggered: {
            console.log("Retour automatique à la page des matières")
            stackView.pop()
        }
    }
    
    // Page de félicitations (invisible au début)
    Item {
        id: congratulationsPage
        anchors.fill: parent
        visible: false
        
        Rectangle {
            anchors.fill: parent
            color: Style.backgroundColor
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 30
                
                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: "Félicitations !"
                    font.pixelSize: 40
                    font.bold: true
                    font.family: "Comic Sans MS, Arial, sans-serif"
                    color: Style.primaryColor
                }
                
                Text {
                    id: congratulationsScore
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: "Tu as obtenu 0 points sur 10 !"
                    font.pixelSize: 30
                    font.bold: true
                    wrapMode: Text.WordWrap
                }
                
                Text {
                    id: congratulationsMessage
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: "Bravo ! Tu as très bien réussi !"
                    font.pixelSize: 26
                    wrapMode: Text.WordWrap
                }
                
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 200
                    color: "transparent"
                    
                    Rectangle {
                        id: robotFaceResult
                        anchors.fill: parent
                        radius: width / 2
                        color: "#64B5F6"
                        border.color: "#1976D2"
                        border.width: 4
                        
                        // États du visage robot
                        states: [
                            State {
                                name: "happy"
                                PropertyChanges { target: resultLeftEye; height: parent.height * 0.2; radius: height / 2 }
                                PropertyChanges { target: resultRightEye; height: parent.height * 0.2; radius: height / 2 }
                                PropertyChanges { target: resultMouth; height: parent.height * 0.15; radius: height / 2 }
                                PropertyChanges { target: resultMouthCover; visible: false }
                            },
                            State {
                                name: "sad"
                                PropertyChanges { target: resultLeftEye; height: parent.height * 0.05; radius: 0 }
                                PropertyChanges { target: resultRightEye; height: parent.height * 0.05; radius: 0 }
                                PropertyChanges { target: resultMouth; height: parent.height * 0.15; radius: 0 }
                                PropertyChanges { target: resultMouthCover; visible: true }
                            }
                        ]
                        
                        // Yeux
                        Rectangle {
                            id: resultLeftEye
                            width: parent.width * 0.2
                            height: parent.height * 0.2
                            radius: height / 2
                            color: "#0D47A1"
                            x: parent.width * 0.25
                            y: parent.height * 0.3
                        }
                        
                        Rectangle {
                            id: resultRightEye
                            width: parent.width * 0.2
                            height: parent.height * 0.2
                            radius: height / 2
                            color: "#0D47A1"
                            x: parent.width * 0.55
                            y: parent.height * 0.3
                        }
                        
                        // Bouche
                        Rectangle {
                            id: resultMouth
                            width: parent.width * 0.5
                            height: parent.height * 0.15
                            radius: height / 2
                            color: "#0D47A1"
                            x: parent.width * 0.25
                            y: parent.height * 0.65
                            
                            Rectangle {
                                id: resultMouthCover
                                visible: false
                                width: parent.width
                                height: parent.height / 2
                                color: "#64B5F6"
                                anchors.bottom: parent.bottom
                            }
                        }
                    }
                }
                
                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: "Retour à la page des matières dans 5 secondes..."
                    font.pixelSize: 20
                    font.italic: true
                }
            }
        }
    }
}

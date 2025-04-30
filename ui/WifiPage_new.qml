import QtQuick
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Effects
import "."

Page {
    id: wifiPage
    background: Rectangle { color: Style.backgroundColor }

    // Dialogue pour saisir le mot de passe
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
                font.family: appFont.family
            }

            TextField {
                id: passwordField
                placeholderText: "Mot de passe"
                echoMode: TextInput.Password
                Layout.fillWidth: true
                font.family: appFont.family
            }

            CheckBox {
                text: "Afficher le mot de passe"
                font.family: appFont.family
                Material.accent: Style.accentColor
                onCheckedChanged: {
                    passwordField.echoMode = checked ? TextInput.Normal : TextInput.Password
                }
            }
        }

        onAccepted: {
            if (passwordField.text) {
                wifiController.connect_to_network(networkSsid, passwordField.text)
                passwordField.text = ""
            }
        }

        onRejected: {
            passwordField.text = ""
        }
    }

    // En-tête avec bouton de retour
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
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: Style.textColorPrimary
            }

            RoundButton {
                id: refreshButton
                icon.source: "assets/icons/refresh.svg"
                icon.width: 24
                icon.height: 24
                flat: true
                onClicked: {
                    refreshAnimation.start()
                    if (wifiController) {
                        wifiController.scan_networks()
                        // Le statut sera mis à jour via le signal connectionStatusChanged
                    }
                }
                Material.foreground: Style.textColorPrimary
                
                RotationAnimation {
                    id: refreshAnimation
                    target: refreshButton
                    from: 0
                    to: 360
                    duration: 600
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    // Connexion du signal connectionStatusChanged au statusLabel
    Connections {
        target: wifiController
        function onConnectionStatusChanged(status) {
            statusLabel.text = status
        }
    }

    // Contenu principal
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingLarge
        spacing: Style.spacingMedium

        // Message de statut
        Label {
            id: statusLabel
            text: ""
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
            visible: wifiController && wifiController.currentNetwork() !== "Non connecté"

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
                        text: wifiController ? wifiController.currentNetwork() : "Non connecté"
                        font.pixelSize: Style.fontSizeMedium
                        font.family: appFont.family
                        font.weight: Font.Medium
                        color: Style.textColorPrimary
                        Layout.fillWidth: true
                    }

                    Label {
                        text: "Connecté"
                        font.pixelSize: Style.fontSizeSmall
                        font.family: appFont.family
                        color: Style.accentColor
                        Layout.fillWidth: true
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
                            source: getSignalIcon(modelData.signal || 0)
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
                                text: modelData.connected ? "Connecté" : (modelData.security === "Open" ? "Réseau ouvert" : "Sécurisé")
                                font.pixelSize: Style.fontSizeSmall
                                font.family: appFont.family
                                color: modelData.connected ? Style.accentColor : Style.textColorSecondary
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
                        // Utiliser le signal connectionStatusChanged du contrôleur WiFi pour mettre à jour le statut
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }

        // Bouton pour ajouter un réseau manuellement
        Button {
            text: "Ajouter un réseau manuellement"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Style.spacingMedium
            font.pixelSize: Style.fontSizeMedium
            font.family: appFont.family
            Material.background: Style.accentColor
            Material.foreground: "white"
            onClicked: addNetworkDialog.open()
        }
    }

    // Dialogue pour entrer le mot de passe
    Dialog {
        id: passwordDialog
        property string networkName: ""
        title: "Se connecter à " + networkName
        modal: true
        parent: Overlay.overlay
        anchors.centerIn: parent
        width: Math.min(parent.width - 64, 400)
        padding: Style.spacingLarge
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        Material.background: Style.surfaceColor
        Material.elevation: Style.elevation4

        enter: Transition {
            NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: Style.animationDurationNormal; easing.type: Easing.OutQuint }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: Style.animationDurationNormal; easing.type: Easing.OutCubic }
        }
        
        exit: Transition {
            NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: Style.animationDurationNormal; easing.type: Easing.OutQuint }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: Style.animationDurationNormal; easing.type: Easing.OutCubic }
        }

        contentItem: ColumnLayout {
            spacing: Style.spacingLarge
            Layout.fillWidth: true

            Label {
                text: "Mot de passe Wi-Fi:"
                color: Style.textColorPrimary
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
            }

            TextField {
                id: connectPasswordField
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                echoMode: TextInput.Password
                placeholderText: "Entrez le mot de passe"
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
                Material.accent: Style.accentColor
                
                background: Rectangle {
                    color: Style.backgroundColor
                    border.color: connectPasswordField.activeFocus ? Style.accentColor : Style.textColorSecondary
                    border.width: connectPasswordField.activeFocus ? 2 : 1
                    radius: Style.radiusSmall
                }
            }

            CheckBox {
                text: "Afficher le mot de passe"
                Layout.leftMargin: -Style.spacingSmall
                font.family: appFont.family
                Material.accent: Style.accentColor
                onCheckedChanged: {
                    connectPasswordField.echoMode = checked ? TextInput.Normal : TextInput.Password
                }
            }
            
            RowLayout {
                Layout.topMargin: Style.spacingMedium
                Layout.fillWidth: true
                spacing: Style.spacingMedium

                Item { Layout.fillWidth: true }

                Button {
                    text: "Annuler"
                    flat: true
                    font.family: appFont.family
                    font.pixelSize: Style.fontSizeMedium
                    onClicked: {
                        connectPasswordField.text = ""
                        passwordDialog.close()
                    }
                    Material.foreground: Style.textColorPrimary
                }

                Button {
                    text: "Connecter"
                    font.family: appFont.family
                    font.pixelSize: Style.fontSizeMedium
                    Material.background: Style.accentColor
                    highlighted: true
                    onClicked: {
                        var networkName = passwordDialog.networkName || "";
                        console.log("Connecting to " + networkName + " with password " + connectPasswordField.text)
                        if (typeof wifiController !== "undefined" && wifiController) {
                            wifiController.connect_to_network(networkName, connectPasswordField.text)
                            // Utiliser le signal connectionStatusChanged du contrôleur WiFi pour mettre à jour le statut
                            // au lieu d'accéder directement à statusLabel
                        }
                        connectPasswordField.text = ""
                        passwordDialog.close()
                    }
                }
            }
        }
    }

    // Dialogue pour ajouter un réseau manuellement
    Dialog {
        id: addNetworkDialog
        title: "Ajouter un réseau WiFi"
        modal: true
        parent: Overlay.overlay
        anchors.centerIn: parent
        width: Math.min(parent.width - 64, 400)
        padding: Style.spacingLarge
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        Material.background: Style.surfaceColor
        Material.elevation: Style.elevation4

        enter: Transition {
            NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: Style.animationDurationNormal; easing.type: Easing.OutQuint }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: Style.animationDurationNormal; easing.type: Easing.OutCubic }
        }
        
        exit: Transition {
            NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: Style.animationDurationNormal; easing.type: Easing.OutQuint }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: Style.animationDurationNormal; easing.type: Easing.OutCubic }
        }

        contentItem: ColumnLayout {
            spacing: Style.spacingLarge
            Layout.fillWidth: true

            Label {
                text: "Nom du réseau (SSID):"
                color: Style.textColorPrimary
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
            }

            TextField {
                id: ssidField
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                placeholderText: "Entrez le nom du réseau"
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
                Material.accent: Style.accentColor
                
                background: Rectangle {
                    color: Style.backgroundColor
                    border.color: ssidField.activeFocus ? Style.accentColor : Style.textColorSecondary
                    border.width: ssidField.activeFocus ? 2 : 1
                    radius: Style.radiusSmall
                }
            }

            Label {
                text: "Type de sécurité:"
                color: Style.textColorPrimary
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
            }

            ComboBox {
                id: securityType
                model: ["WPA/WPA2", "WEP", "Aucune"]
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
                Material.foreground: Style.textColorPrimary
                Material.accent: Style.accentColor
            }

            Label {
                text: "Mot de passe:"
                color: Style.textColorPrimary
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
                visible: securityType.currentText !== "Aucune"
            }

            TextField {
                id: newPasswordField
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                echoMode: TextInput.Password
                placeholderText: "Entrez le mot de passe"
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
                Material.accent: Style.accentColor
                visible: securityType.currentText !== "Aucune"
                
                background: Rectangle {
                    color: Style.backgroundColor
                    border.color: newPasswordField.activeFocus ? Style.accentColor : Style.textColorSecondary
                    border.width: newPasswordField.activeFocus ? 2 : 1
                    radius: Style.radiusSmall
                }
            }

            CheckBox {
                text: "Afficher le mot de passe"
                Layout.leftMargin: -Style.spacingSmall
                font.family: appFont.family
                Material.accent: Style.accentColor
                visible: securityType.currentText !== "Aucune"
                onCheckedChanged: {
                    newPasswordField.echoMode = checked ? TextInput.Normal : TextInput.Password
                }
            }

            RowLayout {
                Layout.topMargin: Style.spacingMedium
                Layout.fillWidth: true
                spacing: Style.spacingMedium

                Item { Layout.fillWidth: true }

                Button {
                    text: "Annuler"
                    flat: true
                    font.family: appFont.family
                    font.pixelSize: Style.fontSizeMedium
                    onClicked: addNetworkDialog.close()
                    Material.foreground: Style.textColorPrimary
                }

                Button {
                    text: "Ajouter"
                    font.family: appFont.family
                    font.pixelSize: Style.fontSizeMedium
                    Material.background: Style.accentColor
                    highlighted: true
                    onClicked: {
                        console.log("Adding network " + ssidField.text + " with security " + securityType.currentText)
                        if (typeof wifiController !== "undefined" && wifiController) {
                            wifiController.connect_to_network(ssidField.text, newPasswordField.text)
                            // Utiliser le signal connectionStatusChanged du contrôleur WiFi pour mettre à jour le statut
                        }
                        ssidField.text = ""
                        newPasswordField.text = ""
                        addNetworkDialog.close()
                    }
                }
            }
        }
    }

    // Fonction pour obtenir l'icône de signal en fonction de la force
    function getSignalIcon(strength) {
        if (strength >= 4) return "assets/icons/wifi_full.svg"
        else if (strength === 3) return "assets/icons/wifi_good.svg"
        else if (strength === 2) return "assets/icons/wifi_fair.svg"
        else return "assets/icons/wifi_weak.svg"
    }

    // Connexion au signal de changement d'état
    Connections {
        target: wifiController
        function onConnectionStatusChanged(status) {
            statusLabel.text = status
        }
    }

    // Initialisation
    Component.onCompleted: {
        if (wifiController) {
            wifiController.scan_networks()
            // Le statut sera mis à jour via le signal connectionStatusChanged
        }
    }
}

import QtQuick
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Effects
import "."

Page {
    id: wifiPage
    background: Rectangle { color: Style.backgroundColor }

    property QtObject wifiController

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
                text: "Configuration WiFi"
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
                    if (typeof wifiController !== "undefined" && wifiController) {
                        wifiController.refreshNetworks()
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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingMedium
        spacing: Style.spacingMedium

        Pane {
            Layout.fillWidth: true
            Material.background: Style.surfaceColor
            Material.elevation: Style.elevation1
            padding: Style.spacingMedium
            Layout.preferredHeight: 60
            
            background: Rectangle {
                color: Style.surfaceColor
                radius: Style.radiusMedium
            }

            RowLayout {
                anchors.fill: parent
                spacing: Style.spacingMedium

                Image {
                    source: "assets/icons/wifi.svg"
                    sourceSize.width: 32
                    sourceSize.height: 32
                    Layout.alignment: Qt.AlignVCenter
                }

                Label {
                    text: "Réseaux disponibles"
                    font.pixelSize: Style.fontSizeLarge
                    font.family: appFont.family
                    font.weight: Font.Medium
                    elide: Label.ElideRight
                    Layout.fillWidth: true
                    color: Style.textColorPrimary
                }
                
                Switch {
                    checked: true
                    Layout.alignment: Qt.AlignVCenter
                    Material.accent: Style.accentColor
                }
            }
        }

        ListView {
            id: networkList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: ["LudoBot_Network", "Home_Wifi", "Guest_Network", "School_Wifi", "Guest_5G"]
            spacing: Style.spacingSmall
            ScrollBar.vertical: ScrollBar {}

            delegate: NetworkItem {
                width: networkList.width
                networkName: modelData
                signalStrength: (5 - index) % 5 
                isConnected: index === 0
                onNetworkClicked: {
                    passwordDialog.networkName = modelData
                    passwordDialog.open()
                }
            }

            header: Item { height: Style.spacingSmall }
            footer: Item { height: Style.spacingSmall }
        }

        Button {
            id: addNetworkButton
            text: "Ajouter un réseau manuellement"
            icon.source: "assets/icons/add_circle.svg"
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            font.pixelSize: Style.fontSizeMedium
            font.family: appFont.family
            Material.background: Style.accentColor
            Material.foreground: "white"
            onClicked: addNetworkDialog.open()
        }
    }
    
    component NetworkItem: Pane {
        id: networkItem
        height: 80
        padding: 0
        Material.elevation: Style.elevation1
        Material.background: Style.surfaceColor

        property string networkName: ""
        property int signalStrength: 3
        property bool isConnected: false
        signal networkClicked()

        background: Rectangle {
            color: Style.surfaceColor
            radius: Style.radiusMedium
        }
        
        Rectangle {
            id: connectedIndicator
            width: 4
            height: parent.height
            color: Style.accentColor
            visible: isConnected
            anchors.left: parent.left
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Style.spacingMedium
            anchors.rightMargin: Style.spacingMedium
            spacing: Style.spacingMedium

            Image {
                source: getWifiIconByStrength(signalStrength)
                sourceSize.width: 24
                sourceSize.height: 24
                Layout.alignment: Qt.AlignVCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: networkName
                    font.pixelSize: Style.fontSizeMedium
                    font.family: appFont.family
                    color: Style.textColorPrimary
                }

                Text {
                    text: isConnected ? "Connecté" : "Sécurisé"
                    font.pixelSize: Style.fontSizeSmall
                    font.family: appFont.family
                    color: Style.textColorSecondary
                }
            }

            Button {
                text: isConnected ? "Déconnecter" : "Connecter"
                flat: true
                Material.foreground: isConnected ? Style.dangerColor : Style.primaryColor
                onClicked: networkItem.networkClicked()
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: networkItem.networkClicked()
            hoverEnabled: true

            onEntered: {
                parent.Material.elevation = Style.elevation2
                parent.scale = 1.01
            }

            onExited: {
                parent.Material.elevation = Style.elevation1
                parent.scale = 1.0
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: Style.animationDurationFast
                easing.type: Easing.OutQuad
            }
        }

        function getWifiIconByStrength(strength) {
            if (strength >= 4) return "assets/icons/wifi_full.svg"
            else if (strength === 3) return "assets/icons/wifi_good.svg"
            else if (strength === 2) return "assets/icons/wifi_fair.svg"
            else return "assets/icons/wifi_weak.svg"
        }
    }

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

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.spacingMedium

                Image {
                    source: "assets/icons/wifi.svg"
                    sourceSize.width: 36
                    sourceSize.height: 36
                    Layout.alignment: Qt.AlignVCenter
                }
                
                Label {
                    text: passwordDialog.title
                    font.pixelSize: Style.fontSizeLarge
                    font.family: appFont.family
                    font.weight: Font.Medium
                    Layout.fillWidth: true
                    color: Style.textColorPrimary
                    wrapMode: Text.WordWrap
                }
            }

            Label {
                text: "Mot de passe Wi-Fi:"
                color: Style.textColorPrimary
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
            }

            TextField {
                id: passwordField
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                echoMode: TextInput.Password
                placeholderText: "Entrez le mot de passe"
                font.pixelSize: Style.fontSizeMedium
                font.family: appFont.family
                Material.accent: Style.accentColor
                
                background: Rectangle {
                    color: Style.backgroundColor
                    border.color: passwordField.activeFocus ? Style.accentColor : Style.textColorSecondary
                    border.width: passwordField.activeFocus ? 2 : 1
                    radius: Style.radiusSmall
                }
            }

            CheckBox {
                text: "Afficher le mot de passe"
                Layout.leftMargin: -Style.spacingSmall
                font.family: appFont.family
                Material.accent: Style.accentColor
                onCheckedChanged: {
                    passwordField.echoMode = checked ? TextInput.Normal : TextInput.Password
                }
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: Style.fontSizeSmall
                    color: Style.textColorPrimary
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: parent.indicator.width + parent.spacing
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
                        passwordField.text = ""
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
                        console.log("Connecting to " + networkName + " with password " + passwordField.text)
                        if (typeof wifiController !== "undefined" && wifiController) {
                            wifiController.connectToNetwork(networkName, passwordField.text)
                        }
                        passwordField.text = ""
                        passwordDialog.close()
                    }
                }
            }
        }
    }

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

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.spacingMedium

                Image {
                    source: "assets/icons/add_circle.svg"
                    sourceSize.width: 36
                    sourceSize.height: 36
                    Layout.alignment: Qt.AlignVCenter
                }
                
                Label {
                    text: addNetworkDialog.title
                    font.pixelSize: Style.fontSizeLarge
                    font.family: appFont.family
                    font.weight: Font.Medium
                    Layout.fillWidth: true
                    color: Style.textColorPrimary
                    wrapMode: Text.WordWrap
                }
            }

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
                            wifiController.addNetwork(ssidField.text, newPasswordField.text, securityType.currentText)
                        }
                        ssidField.text = ""
                        newPasswordField.text = ""
                        addNetworkDialog.close()
                    }
                }
            }
        }
    }
}

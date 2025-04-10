import QtQuick
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Effects
import "."

ApplicationWindow {
    id: root
    visible: true
    width: Screen.width
    height: Screen.height
    title: "LudoBot"
    flags: Qt.Window | Qt.FramelessWindowHint
    visibility: Window.FullScreen
    Material.theme: Style.isDarkTheme ? Material.Dark : Material.Light
    Material.accent: Style.accentColor
    Material.primary: Style.primaryColor
    Material.background: Style.backgroundColor

    property font appFont: Qt.font({
        family: "Roboto, Arial, Helvetica, sans-serif",
        pixelSize: Style.fontSizeMedium
    })

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: homePage
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: Style.animationDurationNormal
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: Style.animationDurationNormal
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: Style.animationDurationNormal
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: Style.animationDurationNormal
            }
        }
    }

    Component {
        id: homePage
        Page {
            background: Rectangle {
                color: Style.backgroundColor
            }

            Rectangle {
                anchors.fill: parent
                color: Style.backgroundColor

                Item {
                    id: headerSection
                    width: parent.width
                    height: parent.height * 0.4
                    anchors.top: parent.top

                    Image {
                        id: logoImage
                        source: "assets/LudoBot.png"
                        width: 200
                        height: 200
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit

                        layer.enabled: true
                        layer.effect: MultiEffect {
                            shadowEnabled: true
                            shadowColor: "#80000000"
                            shadowHorizontalOffset: 0
                            shadowVerticalOffset: 4
                            shadowBlur: 12
                        }
                    }

                    Text {
                        id: titleText
                        text: "LudoBot"
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
                        text: "Apprenez en vous amusant"
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

                    GridLayout {
                        anchors.centerIn: parent
                        width: Math.min(parent.width * 0.9, 600)
                        columnSpacing: Style.spacingMedium
                        rowSpacing: Style.spacingMedium
                        columns: width > 500 ? 2 : 1

                        Button {
                            Layout.fillWidth: true
                            text: "Jouer"
                            Layout.preferredHeight: 80
                            Material.background: Style.primaryColor
                            Material.foreground: "white"
                            Material.elevation: Style.elevation2
                            onClicked: stackView.push("PlayPage.qml")
                            
                            contentItem: RowLayout {
                                spacing: Style.spacingMedium
                                Item { width: Style.spacingMedium }
                                Image {
                                    source: "assets/icons/play_circle.svg"
                                    sourceSize.width: 24
                                    sourceSize.height: 24
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    fillMode: Image.PreserveAspectFit
                                }
                                Text {
                                    text: parent.parent.text
                                    font {
                                        family: appFont.family
                                        pixelSize: Style.fontSizeLarge
                                        weight: Font.Medium
                                    }
                                    color: "white"
                                    Layout.fillWidth: true
                                }
                            }
                        }



                        Button {
                            Layout.fillWidth: true
                            text: "Réglages"
                            Layout.preferredHeight: 80
                            Material.background: Style.primaryColor
                            Material.foreground: "white"
                            Material.elevation: Style.elevation2
                            onClicked: stackView.push("SettingsPage.qml")
                            
                            contentItem: RowLayout {
                                spacing: Style.spacingMedium
                                Item { width: Style.spacingMedium }
                                Image {
                                    source: "assets/icons/settings.svg"
                                    sourceSize.width: 24
                                    sourceSize.height: 24
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    fillMode: Image.PreserveAspectFit
                                }
                                Text {
                                    text: parent.parent.text
                                    font {
                                        family: appFont.family
                                        pixelSize: Style.fontSizeLarge
                                        weight: Font.Medium
                                    }
                                    color: "white"
                                    Layout.fillWidth: true
                                }
                            }
                        }

                        Button {
                            Layout.fillWidth: true
                            text: "Quitter"
                            Layout.preferredHeight: 80
                            Material.background: Style.dangerColor
                            Material.foreground: "white"
                            Material.elevation: Style.elevation2
                            onClicked: Qt.quit()
                            
                            contentItem: RowLayout {
                                spacing: Style.spacingMedium
                                Item { width: Style.spacingMedium }
                                Image {
                                    source: "assets/icons/power.svg"
                                    sourceSize.width: 24
                                    sourceSize.height: 24
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    fillMode: Image.PreserveAspectFit
                                }
                                Text {
                                    text: parent.parent.text
                                    font {
                                        family: appFont.family
                                        pixelSize: Style.fontSizeLarge
                                        weight: Font.Medium
                                    }
                                    color: "white"
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

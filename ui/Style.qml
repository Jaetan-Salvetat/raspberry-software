pragma Singleton
import QtQuick

QtObject {
    readonly property color primaryColor: "#2979FF"
    readonly property color primaryVariantColor: "#2d6d9e"
    readonly property color accentColor: "#00E5FF"
    readonly property color accentVariantColor: "#5ed4f4"
    readonly property color backgroundLight: "#FAFAFA"
    readonly property color backgroundDark: "#121212"
    readonly property color surfaceLight: "#FFFFFF"
    readonly property color surfaceDark: "#1E1E1E"
    readonly property color cardLight: "#FFFFFF"
    readonly property color cardDark: "#2C2C2C"
    readonly property color textPrimaryLight: "#1a1a1a"
    readonly property color textSecondaryLight: "#757575"
    readonly property color textPrimaryDark: "#FFFFFF"
    readonly property color textSecondaryDark: "#B0B0B0"
    readonly property color dangerColor: "#FF5252"
    readonly property color successColor: "#4CAF50"
    readonly property color warningColor: "#FFC107"
    readonly property color infoColor: "#2196F3"
    
    readonly property int fontSizeXSmall: 12
    readonly property int fontSizeSmall: 14
    readonly property int fontSizeMedium: 16
    readonly property int fontSizeLarge: 20
    readonly property int fontSizeXLarge: 24
    readonly property int fontSizeXXLarge: 32
    readonly property int fontSizeHeader: 36
    
    readonly property int radiusSmall: 4
    readonly property int radiusMedium: 8
    readonly property int radiusLarge: 16
    readonly property int radiusXLarge: 24
    
    readonly property int spacingTiny: 4
    readonly property int spacingSmall: 8
    readonly property int spacingMedium: 16
    readonly property int spacingLarge: 24
    readonly property int spacingXLarge: 32
    readonly property int spacingXXLarge: 48
    
    readonly property int elevation0: 0
    readonly property int elevation1: 1
    readonly property int elevation2: 2
    readonly property int elevation4: 4
    readonly property int elevation8: 8
    readonly property int elevation16: 16
    
    readonly property int animationDurationFast: 150
    readonly property int animationDurationNormal: 250
    readonly property int animationDurationSlow: 350
    
    property bool isDarkTheme: true
    
    readonly property color backgroundColor: isDarkTheme ? backgroundDark : backgroundLight
    readonly property color surfaceColor: isDarkTheme ? surfaceDark : surfaceLight
    readonly property color cardColor: isDarkTheme ? cardDark : cardLight
    readonly property color textColorPrimary: isDarkTheme ? textPrimaryDark : textPrimaryLight
    readonly property color textColorSecondary: isDarkTheme ? textSecondaryDark : textSecondaryLight
    
    readonly property var defaultShadow: {
        "color": "#33000000",
        "offsetX": 0,
        "offsetY": 2,
        "radius": 6,
        "samples": 17
    }
}

pragma Singleton
import QtQuick

QtObject {
    // Couleurs basées sur l'image LudoBot
    readonly property color primaryColor: "#2d6d9e"      // Bleu foncé (fond principal)
    readonly property color accentColor: "#5ed4f4"       // Cyan accent (boutons, sélections)
    readonly property color textColorLight: "white"      // Texte clair pour fond foncé
    readonly property color textColorDark: "#1a1a1a"     // Texte foncé pour fond clair
    readonly property color cardColor: "#ffffff"         // Blanc pour les cartes
    readonly property color shadowColor: "#25476b"       // Ombre du bleu plus foncé
    readonly property color dangerColor: "#d9534f"       // Rouge pour bouton Quitter
    
    // Tailles de police
    readonly property int fontSizeSmall: 14
    readonly property int fontSizeMedium: 18
    readonly property int fontSizeLarge: 22
    readonly property int fontSizeHeader: 32
    
    // Rayons arrondis
    readonly property int radiusSmall: 5
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 20
    
    // Espacements
    readonly property int spacingSmall: 10
    readonly property int spacingMedium: 20
    readonly property int spacingLarge: 40
}

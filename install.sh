#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

INSTALL_DIR="$HOME/LudoBot"
mkdir -p "$INSTALL_DIR"

echo "Installation de LudoBot dans $INSTALL_DIR..."
cp -r "$SCRIPT_DIR"/* "$INSTALL_DIR/"

chmod +x "$INSTALL_DIR/LudoBot"

mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/ludobot.desktop" << EOL
[Desktop Entry]
Type=Application
Name=LudoBot
Comment=Application éducative pour enfants
Exec=$INSTALL_DIR/LudoBot
Terminal=false
Categories=Education;
EOL

cat > "$HOME/Desktop/LudoBot.desktop" << EOL
[Desktop Entry]
Type=Application
Name=LudoBot
Comment=Application éducative pour enfants
Exec=$INSTALL_DIR/LudoBot
Icon=$INSTALL_DIR/ui/assets/logo.png
Terminal=false
Categories=Education;
EOL

chmod +x "$HOME/Desktop/LudoBot.desktop"

echo "Installation terminée. LudoBot démarrera automatiquement au prochain démarrage."
echo "Pour lancer LudoBot maintenant, exécutez $INSTALL_DIR/LudoBot"

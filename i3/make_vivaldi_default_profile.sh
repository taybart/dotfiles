# First, find your target profile directory name
# ls ~/.config/vivaldi/
 # or check vivaldi://about for path

# Create a custom desktop file with your specific profile
cat > ~/.local/share/applications/vivaldi-default-profile.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Name=Vivaldi (Default Profile)
GenericName=Web Browser
Comment=Browse the Web
Exec=/usr/bin/vivaldi-stable --profile-directory="Default" %U
Terminal=false
Type=Application
Icon=vivaldi
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF

# Update desktop database
update-desktop-database ~/.local/share/applications/

# Set this as the default handler for http/https
xdg-mime default vivaldi-default-profile.desktop x-scheme-handler/http
xdg-mime default vivaldi-default-profile.desktop x-scheme-handler/https

# Also set via xdg-settings
xdg-settings set default-web-browser vivaldi-default-profile.desktop

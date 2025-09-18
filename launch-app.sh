#!/bin/bash

# Launch script for TypeMyClipboard.app bundle

APP_PATH="./TypeMyClipboard.app"

# Check if the app bundle exists
if [ ! -d "$APP_PATH" ]; then
    echo "Error: TypeMyClipboard.app not found."
    echo "Please build the app bundle first using: ./build-app-bundle.sh"
    exit 1
fi

echo "Launching TypeMyClipboard.app..."
echo "Look for your custom icon in the menu bar!"

# Launch the application
open "$APP_PATH"

echo "Application launched successfully!"
echo ""
echo "The app is now running in the background."
echo "Click your custom icon in the menu bar to access the clipboard typing features."
echo ""
echo "To quit the app, use the Quit option in the menu or right-click the icon."

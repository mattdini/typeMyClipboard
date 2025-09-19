#!/bin/bash

# TypeMyClipboard DMG Creator
# This script creates a professional DMG installer for distribution

set -e

echo "💿 TypeMyClipboard DMG Creator"
echo "==============================="

# Check if the app bundle exists
if [ ! -d "TypeMyClipboard.app" ]; then
    echo "❌ Error: TypeMyClipboard.app not found!"
    echo "Please run './build-app-bundle.sh' first to build the app."
    exit 1
fi

# Check if hdiutil is available
if ! command -v hdiutil &> /dev/null; then
    echo "❌ Error: hdiutil command not found!"
    echo "This requires macOS to create DMG files."
    exit 1
fi

echo "🔨 Creating DMG installer..."

# Create a temporary directory for DMG contents
TEMP_DIR=$(mktemp -d)
echo "📁 Using temporary directory: $TEMP_DIR"

# Copy the app to the temporary directory
echo "📋 Copying app bundle to DMG..."
cp -R "TypeMyClipboard.app" "$TEMP_DIR/"

# Create a symbolic link to Applications folder
echo "🔗 Creating Applications link..."
ln -s /Applications "$TEMP_DIR/Applications"

# Create a README file for the DMG
echo "📝 Creating README..."
cat > "$TEMP_DIR/README.txt" << 'EOF'
TypeMyClipboard Installation Instructions
=========================================

1. Drag TypeMyClipboard.app to the Applications folder
2. Launch the app from Applications or Spotlight search
3. Grant accessibility permissions when prompted
4. The app will appear in your menu bar with your custom icon

Features:
- Types clipboard content character by character
- Real-time clipboard monitoring
- Custom application icon support
- Configurable typing delays

For support or updates, visit the project repository.

Enjoy using TypeMyClipboard!
EOF

# Set proper permissions
chmod -R 755 "$TEMP_DIR"
chmod +x "$TEMP_DIR/TypeMyClipboard.app/Contents/MacOS/TypeMyClipboard"

# Create the DMG
DMG_NAME="TypeMyClipboard-Installer.dmg"
echo "💿 Creating DMG file: $DMG_NAME"

# Remove existing DMG if it exists
if [ -f "$DMG_NAME" ]; then
    rm "$DMG_NAME"
fi

# Create the DMG
hdiutil create -volname "TypeMyClipboard Installer" \
    -srcfolder "$TEMP_DIR" \
    -ov -format UDZO \
    "$DMG_NAME"

# Clean up temporary directory
rm -rf "$TEMP_DIR"

# Get DMG size
DMG_SIZE=$(du -h "$DMG_NAME" | cut -f1)

echo ""
echo "✅ DMG created successfully!"
echo ""
echo "📦 DMG file: $DMG_NAME"
echo "📏 Size: $DMG_SIZE"
echo ""
echo "🚀 Distribution ready!"
echo "   Users can double-click the DMG to mount it,"
echo "   then drag the app to Applications to install."
echo ""
echo "🎯 The DMG includes:"
echo "   - TypeMyClipboard.app"
echo "   - Applications folder shortcut"
echo "   - Installation instructions"

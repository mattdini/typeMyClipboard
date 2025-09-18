#!/bin/bash

# Build script to create a proper .app bundle
# This creates a macOS application bundle without requiring Xcode

echo "Building TypeMyClipboard.app bundle..."

# Check if swift is available
if ! command -v swift &> /dev/null; then
    echo "Error: swift not found. Please install Swift or Xcode Command Line Tools."
    echo "You can install Xcode Command Line Tools with: xcode-select --install"
    exit 1
fi

# Create app bundle structure
APP_NAME="TypeMyClipboard"
APP_BUNDLE="${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "Creating app bundle structure..."

# Remove existing app bundle
rm -rf "$APP_BUNDLE"

# Create directory structure
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Build the executable
echo "Building executable..."
swift build -c release

if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

# Copy executable to app bundle
cp .build/release/TypeMyClipboard "$MACOS_DIR/TypeMyClipboard"
chmod +x "$MACOS_DIR/TypeMyClipboard"

# Copy icon to resources
if [ -f "icon.png" ]; then
    cp icon.png "$RESOURCES_DIR/icon.png"
    echo "✅ Icon copied to app bundle Resources folder"
    echo "   Source: $(pwd)/icon.png"
    echo "   Destination: $RESOURCES_DIR/icon.png"
else
    echo "⚠️  Warning: icon.png not found in project root"
    echo "   The app will use the default keyboard icon"
fi

# Create Info.plist
echo "Creating Info.plist..."
cat > "$CONTENTS_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>TypeMyClipboard</string>
    <key>CFBundleIconFile</key>
    <string>icon</string>
    <key>CFBundleIdentifier</key>
    <string>com.typemyclipboard.TypeMyClipboard</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>TypeMyClipboard</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSSupportsAutomaticTermination</key>
    <true/>
    <key>NSSupportsSuddenTermination</key>
    <true/>
</dict>
</plist>
EOF

# Create PkgInfo
echo "Creating PkgInfo..."
echo "APPL????" > "$CONTENTS_DIR/PkgInfo"

echo "App bundle created successfully!"
echo "Location: $(pwd)/$APP_BUNDLE"
echo ""
echo "To run the app:"
echo "  open $APP_BUNDLE"
echo "  or double-click $APP_BUNDLE in Finder"
echo ""
echo "The app will appear in your menu bar with your custom icon!"

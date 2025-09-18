# 📱 App Bundle Guide

## Overview

You now have a proper macOS `.app` bundle that can be distributed and installed like any other macOS application!

## What is a .app Bundle?

A `.app` bundle is a macOS application package that contains:
- **Executable** - The actual program
- **Resources** - Icons, images, and other assets
- **Metadata** - Info.plist with app information
- **Structure** - Proper macOS app organization

## Building the App Bundle

### Quick Build
```bash
./build-app-bundle.sh
```

### What Gets Created
```
TypeMyClipboard.app/
├── Contents/
│   ├── Info.plist          # App metadata
│   ├── PkgInfo             # Package type info
│   ├── MacOS/
│   │   └── TypeMyClipboard # Executable
│   └── Resources/
│       └── icon.png        # Your custom icon
```

## Using the App Bundle

### Launch Methods

**Method 1: Double-click in Finder**
- Navigate to the app in Finder
- Double-click `TypeMyClipboard.app`

**Method 2: Command line**
```bash
./launch-app.sh
```

**Method 3: Direct open**
```bash
open TypeMyClipboard.app
```

**Method 4: Spotlight**
- Press `Cmd + Space`
- Type "TypeMyClipboard"
- Press Enter

## App Bundle Features

### ✅ Professional Integration
- **Dock behavior** - No dock icon (menu bar only)
- **System integration** - Proper macOS app structure
- **Icon support** - Your custom icon in menu bar
- **Metadata** - Proper app identification

### ✅ Distribution Ready
- **Self-contained** - Everything needed is in the bundle
- **Portable** - Can be moved to Applications folder
- **Shareable** - Can be distributed to other users

### ✅ macOS Standards
- **LSUIElement** - Menu bar app (no dock icon)
- **Bundle identifier** - `com.typemyclipboard.TypeMyClipboard`
- **Version info** - Proper versioning
- **System requirements** - macOS 13.0+

## Installing the App

### Option 1: Applications Folder
```bash
# Copy to Applications folder
cp -R TypeMyClipboard.app /Applications/

# Launch from Applications
open /Applications/TypeMyClipboard.app
```

### Option 2: User Applications
```bash
# Copy to user Applications folder
cp -R TypeMyClipboard.app ~/Applications/

# Launch from user Applications
open ~/Applications/TypeMyClipboard.app
```

### Option 3: Custom Location
```bash
# Copy to any location
cp -R TypeMyClipboard.app /path/to/your/location/

# Launch from custom location
open /path/to/your/location/TypeMyClipboard.app
```

## App Bundle Contents

### Info.plist
```xml
<key>CFBundleExecutable</key>
<string>TypeMyClipboard</string>
<key>CFBundleIdentifier</key>
<string>com.typemyclipboard.TypeMyClipboard</string>
<key>LSUIElement</key>
<true/>
<key>LSMinimumSystemVersion</key>
<string>13.0</string>
```

### Key Properties
- **CFBundleExecutable**: `TypeMyClipboard`
- **CFBundleIdentifier**: `com.typemyclipboard.TypeMyClipboard`
- **LSUIElement**: `true` (menu bar app)
- **LSMinimumSystemVersion**: `13.0`

## Troubleshooting

### App Won't Launch
1. **Check permissions**: `chmod +x TypeMyClipboard.app/Contents/MacOS/TypeMyClipboard`
2. **Check executable**: `file TypeMyClipboard.app/Contents/MacOS/TypeMyClipboard`
3. **Check bundle**: `ls -la TypeMyClipboard.app/Contents/`

### Icon Not Appearing
1. **Check icon file**: `ls -la TypeMyClipboard.app/Contents/Resources/icon.png`
2. **Rebuild bundle**: `./build-app-bundle.sh`
3. **Restart app**: Quit and relaunch

### Accessibility Permissions
- The app will prompt for accessibility permissions on first launch
- Go to **System Preferences** > **Security & Privacy** > **Privacy** > **Accessibility**
- Add and enable the TypeMyClipboard app

## Distribution

### Sharing the App
```bash
# Create a zip file for distribution
zip -r TypeMyClipboard.zip TypeMyClipboard.app

# Share the zip file
# Recipients can unzip and run the app
```

### Code Signing (Optional)
For distribution outside of your Mac, you may want to code sign the app:
```bash
# Sign the app (requires Apple Developer account)
codesign --force --deep --sign "Developer ID Application: Your Name" TypeMyClipboard.app
```

## Advantages of App Bundle

### ✅ User Experience
- **Familiar interface** - Looks like any other Mac app
- **Easy installation** - Drag to Applications folder
- **System integration** - Proper macOS behavior
- **Professional appearance** - No terminal required

### ✅ Distribution
- **Self-contained** - All dependencies included
- **Portable** - Works on any compatible Mac
- **Shareable** - Easy to distribute
- **Installable** - Can be installed system-wide

### ✅ Maintenance
- **Easy updates** - Replace the entire bundle
- **Clean removal** - Delete the bundle to uninstall
- **Version control** - Proper versioning support
- **Metadata** - Rich app information

Your TypeMyClipboard app is now a proper macOS application! 🎉

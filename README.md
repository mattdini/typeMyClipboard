# typeMyClipboard

A macOS menu bar application that types out the contents of your clipboard when called. Perfect for quickly pasting text into applications that don't support standard paste operations or when you need to simulate actual typing.

## 🎯 Menu Bar Application
- Lives in your menu bar with a custom icon (or keyboard icon as fallback)
- Real-time clipboard monitoring
- One-click typing with customizable delays
- User-friendly interface with notifications
- No terminal required

## Features

- Reads clipboard content automatically
- Types text character by character using macOS accessibility APIs
- Configurable delay before typing starts
- Handles special characters and modifiers correctly
- Custom application icon support
- Real-time clipboard monitoring

## Requirements

- macOS 13.0 or later
- Accessibility permissions (required for typing simulation)

## Installation

1. Clone or download this repository
2. Build the .app bundle:
   ```bash
   ./build-app-bundle.sh
   ```
3. Launch the application:
   ```bash
   ./launch-app.sh
   ```
   Or simply double-click `TypeMyClipboard.app` in Finder

## Usage

1. **Launch the app** - Look for your custom icon in your menu bar
2. **Copy text** to your clipboard
3. **Click the menu bar icon** to see your clipboard content
4. **Choose an option**:
   - **Type Now** - Types immediately
   - **Type with 3s delay** - Gives you 3 seconds to focus on target app
   - **Refresh Clipboard** - Updates the displayed content

### Custom Icon

The application supports custom icons:
- Place your `icon.png` file (1024x1024 PNG) in the project root
- The app will automatically use your custom icon in the menu bar
- If no custom icon is found, it falls back to the system keyboard icon

### How It Works

1. The application reads the current clipboard content
2. It checks for accessibility permissions (required for typing simulation)
3. Gives you a 3-second countdown to focus on your target application
4. Types the clipboard content character by character

## Permissions

The first time you run the application, macOS will ask for accessibility permissions. You must grant these permissions for the application to work:

1. Go to **System Preferences** > **Security & Privacy** > **Privacy** > **Accessibility**
2. Click the lock icon and enter your password
3. Add the `typeMyClipboard` application to the list
4. Make sure it's checked/enabled

## Building from Source

```bash
# Build the app bundle
./build-app-bundle.sh

# Or manually with Swift Package Manager
swift build -c release
```

## Project Structure

```
typeMyClipboard/
├── Sources/TypeMyClipboard/       # Source code
│   └── main.swift                 # All-in-one GUI app
├── Package.swift                  # Swift Package Manager config
├── build-app-bundle.sh            # App bundle build script
├── launch-app.sh                  # App bundle launcher
├── icon.png                       # Custom icon (1024x1024 PNG)
├── TypeMyClipboard.app/           # Built app bundle
├── APP_BUNDLE_GUIDE.md            # App bundle documentation
└── README.md                      # This file
```

## Technical Details

- **Language**: Swift
- **Framework**: AppKit, Carbon (for keyboard events)
- **Architecture**: Menu bar application
- **Key Features**:
  - Clipboard reading using `NSPasteboard`
  - Accessibility permission checking using `AXIsProcessTrusted`
  - Keyboard event simulation using `CGEvent`
  - Character-by-character typing with proper key codes and modifiers

## Troubleshooting

### "Accessibility permissions are required"
- Make sure you've granted accessibility permissions in System Preferences
- The application must be in the Accessibility list and enabled

### "Could not read clipboard content"
- Make sure you have text copied to your clipboard
- The application only works with text content (not images or other data types)

### "Text appears in wrong case"
- This has been completely fixed in the latest version
- The app now properly handles uppercase, lowercase, and mixed case text
- Each character maintains its original case - no unwanted capitalization
- Rebuild the app if you're using an older version: `./build-app-bundle.sh`

### Build Issues
- Ensure you're running on macOS 13.0 or later
- Make sure you have the Swift compiler available

## License

This project is open source. Feel free to modify and distribute as needed.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

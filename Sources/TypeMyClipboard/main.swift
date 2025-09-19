import Cocoa
import Foundation

// Simple menu bar application
class MenuBarApp: NSObject, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private var menu: NSMenu!
    private var typeMyClipboard: TypeMyClipboard!
    
    override init() {
        super.init()
        setupMenuBar()
        typeMyClipboard = TypeMyClipboard()
    }
    
    private func setupMenuBar() {
        // Create status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        // Set icon
        if let button = statusItem.button {
            // Try to load custom icon from multiple locations
            var customIcon: NSImage?
            
            // Try app bundle Resources folder first
            if let bundle = Bundle.main.resourcePath {
                let bundleIconPath = "\(bundle)/icon.png"
                customIcon = NSImage(contentsOfFile: bundleIconPath)
            }
            
            // Try current directory as fallback
            if customIcon == nil {
                customIcon = NSImage(contentsOfFile: "icon.png")
            }
            
            // Use custom icon if found, otherwise use system icon
            if let icon = customIcon {
                icon.size = NSSize(width: 18, height: 18)
                button.image = icon
            } else {
                button.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "Type My Clipboard")
            }
            
            // Use a different approach - set the menu directly instead of using button action
            button.action = #selector(statusBarButtonClicked)
            button.target = self
        }
        
        // Create menu
        menu = NSMenu()
        menu.autoenablesItems = false
        menu.delegate = self
        
        // Add menu items
        updateMenu()
        
        statusItem.menu = menu
    }
    
    private func updateMenu() {
        // Clear existing items
        menu.removeAllItems()
        
        // Get clipboard content
        let clipboardContent = getClipboardContent()
        
        // Clipboard content display
        let displayText = clipboardContent.isEmpty ? "Clipboard is empty" : "📋 \(clipboardContent)"
        let contentItem = NSMenuItem(title: displayText, action: nil, keyEquivalent: "")
        contentItem.isEnabled = false
        menu.addItem(contentItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Type Now button
        let typeNowItem = NSMenuItem(title: "Type Now", action: #selector(typeNowClicked), keyEquivalent: "")
        typeNowItem.target = self
        typeNowItem.isEnabled = !clipboardContent.isEmpty
        menu.addItem(typeNowItem)
        
        // Type with delay
        let typeWithDelayItem = NSMenuItem(title: "Type with 3s delay", action: #selector(typeWithDelayClicked), keyEquivalent: "")
        typeWithDelayItem.target = self
        typeWithDelayItem.isEnabled = !clipboardContent.isEmpty
        menu.addItem(typeWithDelayItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Refresh clipboard
        let refreshItem = NSMenuItem(title: "Refresh Clipboard", action: #selector(refreshClicked), keyEquivalent: "r")
        refreshItem.target = self
        menu.addItem(refreshItem)
        
        // About
        let aboutItem = NSMenuItem(title: "About TypeMyClipboard", action: #selector(aboutClicked), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(title: "Quit TypeMyClipboard", action: #selector(quitClicked), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
    }
    
    private func getClipboardContent() -> String {
        // Get fresh clipboard content
        let pasteboard = NSPasteboard.general
        
        // Force a refresh by accessing the pasteboard multiple times
        let changeCount = pasteboard.changeCount
        
        // Small delay to ensure clipboard is fully updated
        Thread.sleep(forTimeInterval: 0.01)
        
        let content = pasteboard.string(forType: .string) ?? ""
        return content
    }
    
    // NSMenuDelegate method - called when menu is about to be displayed
    func menuWillOpen(_ menu: NSMenu) {
        // Refresh the menu content every time it's about to be displayed
        updateMenu()
    }
    
    @objc private func statusBarButtonClicked() {
        // This method is no longer needed since we use menuWillOpen
    }
    
    @objc private func typeNowClicked() {
        guard !getClipboardContent().isEmpty else { return }
        
        // Show notification
        showNotification(title: "TypeMyClipboard", body: "Typing clipboard content now...")
        
        // Type immediately
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.typeMyClipboard.typeText(self?.getClipboardContent() ?? "")
        }
    }
    
    @objc private func typeWithDelayClicked() {
        guard !getClipboardContent().isEmpty else { return }
        
        // Show notification
        showNotification(title: "TypeMyClipboard", body: "Will type in 3 seconds. Focus on target application now!")
        
        // Type with delay
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3.0)
            self?.typeMyClipboard.typeText(self?.getClipboardContent() ?? "")
        }
    }
    
    @objc private func refreshClicked() {
        updateMenu()
        showNotification(title: "TypeMyClipboard", body: "Clipboard refreshed")
    }
    
    @objc private func aboutClicked() {
        let alert = NSAlert()
        alert.messageText = "TypeMyClipboard"
        alert.informativeText = "A macOS menu bar application that types out your clipboard contents.\n\nVersion 1.0\n\nMake sure to grant accessibility permissions in System Preferences > Security & Privacy > Privacy > Accessibility"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Open Accessibility Settings")
        
        let response = alert.runModal()
        if response == .alertSecondButtonReturn {
            // Open System Preferences to Accessibility
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
        }
    }
    
    @objc private func quitClicked() {
        NSApplication.shared.terminate(nil)
    }
    
    private func showNotification(title: String, body: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = body
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.default.deliver(notification)
    }
}

// Core typing functionality
class TypeMyClipboard {
    
    func typeText(_ text: String) {
        // Check for accessibility permissions first
        guard checkAccessibilityPermissions() else {
            DispatchQueue.main.async {
                self.showAccessibilityError()
            }
            return
        }
        
        // Use a much simpler and more reliable approach
        for character in text {
            typeCharacter(character)
            // Small delay between characters
            Thread.sleep(forTimeInterval: 0.05)
        }
    }
    
    private func checkAccessibilityPermissions() -> Bool {
        let trusted = AXIsProcessTrusted()
        if !trusted {
            // Request accessibility permissions
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
            AXIsProcessTrustedWithOptions(options as CFDictionary)
        }
        return AXIsProcessTrusted()
    }
    
    private func showAccessibilityError() {
        let alert = NSAlert()
        alert.messageText = "Accessibility Permissions Required"
        alert.informativeText = "TypeMyClipboard needs accessibility permissions to type text. Please grant permissions in System Preferences > Security & Privacy > Privacy > Accessibility"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Open Settings")
        
        let response = alert.runModal()
        if response == .alertSecondButtonReturn {
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
        }
    }
    
    private func typeCharacter(_ character: Character) {
        // Handle special characters that need specific key codes
        switch character {
        case "\n":
            // Return/Enter key
            sendKeyEvent(keyCode: 36, keyDown: true)
            Thread.sleep(forTimeInterval: 0.01)
            sendKeyEvent(keyCode: 36, keyDown: false)
            return
        case "\t":
            // Tab key
            sendKeyEvent(keyCode: 48, keyDown: true)
            Thread.sleep(forTimeInterval: 0.01)
            sendKeyEvent(keyCode: 48, keyDown: false)
            return
        case " ":
            // Space key
            sendKeyEvent(keyCode: 49, keyDown: true)
            Thread.sleep(forTimeInterval: 0.01)
            sendKeyEvent(keyCode: 49, keyDown: false)
            return
        default:
            // For all other characters, use the proper key code mapping
            let (keyCode, modifiers) = getKeyCodeAndModifiers(for: character)
            
            // Send key down event
            sendKeyEvent(keyCode: keyCode, keyDown: true, modifiers: modifiers)
            Thread.sleep(forTimeInterval: 0.01)
            
            // Send key up event
            sendKeyEvent(keyCode: keyCode, keyDown: false, modifiers: modifiers)
        }
    }
    
    private func getKeyCodeAndModifiers(for character: Character) -> (CGKeyCode, CGEventFlags) {
        let originalString = String(character)
        let lowercaseString = originalString.lowercased()
        
        // Map characters to their key codes (lowercase)
        let keyMap: [Character: CGKeyCode] = [
            "a": 0, "b": 11, "c": 8, "d": 2, "e": 14, "f": 3, "g": 5, "h": 4,
            "i": 34, "j": 38, "k": 40, "l": 37, "m": 46, "n": 45, "o": 31,
            "p": 35, "q": 12, "r": 15, "s": 1, "t": 17, "u": 32, "v": 9,
            "w": 13, "x": 7, "y": 16, "z": 6,
            "0": 29, "1": 18, "2": 19, "3": 20, "4": 21, "5": 23,
            "6": 22, "7": 26, "8": 28, "9": 25,
            ".": 47, ",": 43, ";": 41, "'": 39, "[": 33, "]": 30,
            "\\": 42, "/": 44, "-": 27, "=": 24, "`": 50
        ]
        
        // Determine if we need shift modifier
        var modifiers: CGEventFlags = []
        var keyCode: CGKeyCode = 0
        
        // Handle special characters that need shift
        let shiftCharacters: [Character: (CGKeyCode, CGEventFlags)] = [
            "!": (18, .maskShift),  // 1 + shift
            "@": (19, .maskShift),  // 2 + shift
            "#": (20, .maskShift),  // 3 + shift
            "$": (21, .maskShift),  // 4 + shift
            "%": (23, .maskShift),  // 5 + shift
            "^": (22, .maskShift),  // 6 + shift
            "&": (26, .maskShift),  // 7 + shift
            "*": (28, .maskShift),  // 8 + shift
            "(": (25, .maskShift),  // 9 + shift
            ")": (29, .maskShift),  // 0 + shift
            "_": (27, .maskShift),  // - + shift
            "+": (24, .maskShift),  // = + shift
            "{": (33, .maskShift),  // [ + shift
            "}": (30, .maskShift),  // ] + shift
            "|": (42, .maskShift),  // \ + shift
            ":": (41, .maskShift),  // ; + shift
            "<": (43, .maskShift),  // , + shift
            ">": (47, .maskShift),  // . + shift
            "?": (44, .maskShift),  // / + shift
            "~": (50, .maskShift)   // ` + shift
        ]
        
        // Check if it's a special character that needs shift
        if let (specialKeyCode, specialModifiers) = shiftCharacters[character] {
            keyCode = specialKeyCode
            modifiers = specialModifiers
        } else {
            // Regular character mapping
            keyCode = keyMap[Character(lowercaseString)] ?? 0
            
            // Check if original character is uppercase (letters only)
            if originalString.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil {
                modifiers = .maskShift
            }
        }
        
        return (keyCode, modifiers)
    }
    
    private func sendKeyEvent(keyCode: CGKeyCode, keyDown: Bool, modifiers: CGEventFlags = []) {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown)
        
        // Always set the flags, even if empty, to ensure clean state
        event?.flags = modifiers
        
        event?.post(tap: .cghidEventTap)
    }
}

// Main application entry point
class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarApp: MenuBarApp?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the menu bar app
        menuBarApp = MenuBarApp()
        
        // Hide the dock icon since this is a menu bar app
        NSApp.setActivationPolicy(.accessory)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Cleanup if needed
    }
}

// Start the application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()

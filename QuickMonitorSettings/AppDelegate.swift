import Cocoa
import SwiftUI



class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    var statusItem: NSStatusItem!
    var popover = NSPopover()
    
    var configs: [MonitorConfig] = []
    var activeConfig: MonitorConfig?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("TESTTEST")
        // Load existing configs
        var loadedConfigs = ConfigManager.loadOrCreateConfig()
        
        // Detect current monitors
        let currentDisplayNames = getCurrentDisplayNames()
        
        // Check if any config matches the current setup
        let matchingConfig = loadedConfigs.first { $0.matchesDisplays(currentDisplayNames) }
        
        if matchingConfig == nil && !currentDisplayNames.isEmpty {
            // No match - create a new config for this setup
            print("📱 No matching config found for current setup, creating new config")
            let newConfig = createConfigForCurrentSetup(displayNames: currentDisplayNames)
            loadedConfigs.append(newConfig)
            ConfigManager.saveConfig(loadedConfigs)
        }
        
        configs = loadedConfigs
        
        // Set active config based on current monitors
        activeConfig = configs.first { $0.matchesDisplays(currentDisplayNames) }
        
        // Apply settings for the active config on launch
        if let active = activeConfig {
            print("🚀 Applying initial settings for: '\(active.name)'")
            applySettings(for: active)
        }
        
        // Create ContentView and pass the config
        let contentView = ContentView(configs: configs, activeConfig: activeConfig)
        
        // Attach popover
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        // Menu bar setup
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "bolt.circle", accessibilityDescription: "Menu Icon")
            button.action = #selector(togglePopover(_:))
        }
        
        
        NotificationCenter.default.addObserver(
                 self,
                 selector: #selector(screenParametersDidChange),
                 name: NSApplication.didChangeScreenParametersNotification,
                 object: nil
             )
        
    }

    @objc func screenParametersDidChange() {
           print("🖥 Screen configuration changed!")
           detectMonitorChanges()
       }
    
    func detectMonitorChanges() {
        let currentDisplayNames = getCurrentDisplayNames()
        
        print("📱 Current monitors connected:")
        for displayName in currentDisplayNames {
            print("  - \(displayName)")
        }
        
        // Check if any config matches the new setup
        let matchingConfig = configs.first { $0.matchesDisplays(currentDisplayNames) }
        
        if let match = matchingConfig {
            print("✅ Found matching config: '\(match.name)'")
            activeConfig = match
            
            // Log active config settings
            print("📋 Active Config Settings:")
            print("   - Name: \(match.name)")
            print("   - Dock Position: \(match.dockPosition)")
            print("   - Dock Auto-Hide: \(match.dockHide)")
            print("   - Monitors: \(match.displayNames.joined(separator: ", "))")
            
            // Apply the settings
            applySettings(for: match)
            
        } else {
            print("⚠️ No matching config found for this setup")
            
            // Auto-create new config if monitors are connected
            if !currentDisplayNames.isEmpty {
                print("🆕 Creating new config automatically...")
                let newConfig = createConfigForCurrentSetup(displayNames: currentDisplayNames)
                configs.append(newConfig)
                ConfigManager.saveConfig(configs)
                activeConfig = newConfig
                print("✅ Created config: '\(newConfig.name)'")
                
                // Log new config settings
                print("📋 Active Config Settings:")
                print("   - Name: \(newConfig.name)")
                print("   - Dock Position: \(newConfig.dockPosition)")
                print("   - Dock Auto-Hide: \(newConfig.dockHide)")
                print("   - Monitors: \(newConfig.displayNames.joined(separator: ", "))")
                
                // Apply the settings
                applySettings(for: newConfig)
            } else {
                activeConfig = nil
            }
        }
        
        // Update UI
        if let hostingVC = popover.contentViewController as? NSHostingController<ContentView> {
            hostingVC.rootView = ContentView(configs: configs, activeConfig: activeConfig)
        }
    }

    
    @objc func togglePopover(_ sender: Any?) {
        guard let button = statusItem.button else { return }
        
        // If the popover is already open, close it
        if popover.isShown {
            popover.performClose(sender)
        }
        // Otherwise, open it, anchored to the menu bar icon
        else {
            popover.show(relativeTo: button.bounds,
                         of: button,
                         preferredEdge: .minY)
            
            // Ensure the popover gets focus so keyboard works
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Get the names of all currently connected displays
    private func getCurrentDisplayNames() -> Set<String> {
        let screens = NSScreen.screens
        return Set(screens.map { DisplayUtils.friendlyName(for: $0) })
    }
    
    /// Create a new config based on current display setup
    private func createConfigForCurrentSetup(displayNames: Set<String>) -> MonitorConfig {
        // Generate a name based on the number of displays
        let configName = displayNames.count == 1 ? "Single Display" : "\(displayNames.count) Displays"
        
        return MonitorConfig(
            name: configName, 
            displayNames: Array(displayNames),
            dockPosition: "bottom",
            dockHide: false
        )
    }
    
    /// Apply dock settings from a config
    private func applySettings(for config: MonitorConfig) {
        print("🔧 Applying settings...")
        
        // Map dockPosition string to DockLocation enum
        // Note: "top" is not supported by macOS Dock, defaulting to bottom
        let dockLocation: DockLocation
        switch config.dockPosition.lowercased() {
        case "left":
            dockLocation = .left
        case "right":
            dockLocation = .right
        default: // "bottom" or "top"
            dockLocation = .bottom
        }
        
        // Apply dock position
        MacOSUtils.setDockLocation(dockLocation)
        print("  ✓ Dock position: \(config.dockPosition)")
        
        // Apply dock auto-hide
        MacOSUtils.setDockAutohide(config.dockHide)
        print("  ✓ Dock auto-hide: \(config.dockHide)")
        
        print("✅ Settings applied successfully!")
    }
}

import Foundation
import Combine
import SwiftUI
import UserNotifications

// bunch of glue here 
class AppState: ObservableObject {
    @Published var configs: [MonitorConfig] = []
    @Published var activeConfigId: UUID?
    
    var activeConfig: MonitorConfig? {
        guard let id = activeConfigId else { return nil }
        return configs.first { $0.id == id }
    }
    
    var hasMatchingConfig: Bool {
        let currentDisplays = getCurrentDisplayNames()
        return configs.contains(where: { $0.matchesDisplays(currentDisplays) })
    }
    
    init() {
        loadConfigs()
        requestNotificationPermission()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
    
    func loadConfigs() {
        configs = ConfigManager.loadOrCreateConfig()
    }
    
    func saveConfigs() {
        ConfigManager.saveConfig(configs)
    }
    
    func applyConfig(_ config: MonitorConfig) {
        let dockLocation: DockLocation
        switch config.dockPosition.lowercased() {
        case "left":
            dockLocation = .left
        case "right":
            dockLocation = .right
        default:
            dockLocation = .bottom
        }
        
        MacOSUtils.setDockLocation(dockLocation)
        MacOSUtils.setDockAutohide(config.dockHide)
        MacOSUtils.restartDock()
    }
    
    func detectAndApply() {
        let currentDisplayNames = getCurrentDisplayNames()
        
        if let match = configs.first(where: { $0.matchesDisplays(currentDisplayNames) }) {
            if activeConfigId != match.id {
                activeConfigId = match.id
                applyConfig(match)
                sendNotification(title: "Monitor Config Applied", body: "Applied configuration: \(match.name)")
            }
        } else {
            if !currentDisplayNames.isEmpty {
                let newConfig = createConfigForCurrentSetup(displayNames: currentDisplayNames)
                configs.append(newConfig)
                saveConfigs()
                activeConfigId = newConfig.id
                applyConfig(newConfig)
                sendNotification(title: "New Config Created", body: "Created and applied: \(newConfig.name)")
            } else {
                activeConfigId = nil
            }
        }
    }
    
    func getCurrentDisplayNames() -> Set<String> {
        let screens = NSScreen.screens
        return Set(screens.map { DisplayUtils.friendlyName(for: $0) })
    }
    
    func createConfigForCurrentSetup(displayNames: Set<String>) -> MonitorConfig {
        let configName = displayNames.count == 1 ? "Single Display" : "\(displayNames.count) Displays"
        
        return MonitorConfig(
            name: configName,
            displayNames: Array(displayNames),
            dockPosition: "bottom",
            dockHide: false
        )
    }
    
    func restartDock() {
        MacOSUtils.restartDock()
    }
}

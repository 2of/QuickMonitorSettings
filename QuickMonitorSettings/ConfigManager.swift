import Foundation

class ConfigManager {

    
    
    
    
    static func loadOrCreateConfig() -> [MonitorConfig] {
        let fileManager = FileManager.default
        
        // Application Support folder
        guard let appSupportDir = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            fatalError("Could not find Application Support directory")
        }
        
        let appFolder = appSupportDir.appendingPathComponent("QuickMonitorSettings")
        
        print("The app folder path is \(appFolder.path)")
        if !fileManager.fileExists(atPath: appFolder.path) {
            try? fileManager.createDirectory(at: appFolder, withIntermediateDirectories: true)
        }
        
        let configURL = appFolder.appendingPathComponent("MonitorConfig.json")
        
        // If file exists, read it
        if fileManager.fileExists(atPath: configURL.path) {
            do {
                let data = try Data(contentsOf: configURL)
                let configs = try JSONDecoder().decode([MonitorConfig].self, from: data)
                return configs
            } catch {
                print(" Failed to read config, using default: \(error)")
            }
        }
        
        // File doesn't exist - return empty array
        // Configs will be created automatically based on actual connected monitors
        return []
    }
    
    
    static func saveConfig(_ configs: [MonitorConfig]) {
           let fileManager = FileManager.default
           guard let appSupportDir = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
               print("⚠️ Could not find Application Support directory")
               return
           }
           let appFolder = appSupportDir.appendingPathComponent("QuickMonitorSettings")
        
      
           if !fileManager.fileExists(atPath: appFolder.path) {
               try? fileManager.createDirectory(at: appFolder, withIntermediateDirectories: true)
           }
           
           let configURL = appFolder.appendingPathComponent("MonitorConfig.json")
           
           do {
               let data = try JSONEncoder().encode(configs)
               try data.write(to: configURL)
               print("Saved MonitorConfig.json at \(configURL.path)")
           } catch {
               print("⚠️ Failed to save config: \(error)")
           }
       }
    
}

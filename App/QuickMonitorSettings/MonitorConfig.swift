//
//  MonitorConfig.swift
//  QuickMonitorSettings
//
//  Created by Noah King on 26/11/2025.
//

import Foundation

// Represents ONE monitor configuration (a setup with specific monitors)
struct MonitorConfig: Identifiable, Codable {
    var id = UUID()
    var name: String
    var displayNames: [String]  // List of monitor names in this setup
    var dockPosition: String     // Settings apply to the entire config
    var dockHide: Bool
    
    // New Fields 
    var stageManager: Bool = false
    var showRecentApps: Bool = true
    var magnification: Bool = false
    var dockSize: Double = 0.5 // 0.0 to 1.0
    var magnificationSize: Double = 1.0 // 0.0 to 1.0
    var minimizeEffect: String = "genie" // genie, scale
    
    var minimizeToApplication: Bool = false
    var animateOpening: Bool = true
    var showIndicators: Bool = true
        
    
    
    // sooo we compare all of the display names to match instead of using a unique key, it's cheeky but who has a bajillion monitors anyway.... riiight?
    func matchesDisplays(_ displayNames: Set<String>) -> Bool {
        return Set(self.displayNames) == displayNames
    }
}

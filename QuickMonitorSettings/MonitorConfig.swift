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
    
    /// Returns true if this config matches the given set of display names
    func matchesDisplays(_ displayNames: Set<String>) -> Bool {
        return Set(self.displayNames) == displayNames
    }
}

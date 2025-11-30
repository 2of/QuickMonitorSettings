//
//  QuickMonitorSettingsApp.swift
//  QuickMonitorSettings
//
//  Created by Noah King on 26/11/2025.
//

import SwiftUI
@main

struct QuickMonitorSettingsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

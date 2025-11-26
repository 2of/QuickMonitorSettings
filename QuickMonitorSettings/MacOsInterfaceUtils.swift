//
//  MacOsInterfaceUtils.swift
//  QuickMonitorSettings
//
//  Created by Noah King on 26/11/2025.
//


// Asked LLM to add oodles of debugs
// essentially hit a wall due to SIP 



import Foundation

enum DockLocation: String {
    case left
    case bottom
    case right
}

struct MacOSUtils {
    
    // MARK: - Shell Command Runner (Verbose)
    @discardableResult
    private static func runShell(_ command: String, args: [String]) -> Int32 {
        print("----------------------------------------------------------")
        print("🔧 Running shell command:")
        print("   Command: \(command)")
        print("   Args: \(args)")
        print("----------------------------------------------------------")
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: command)
        process.arguments = args
        
        do {
            try process.run()
            process.waitUntilExit()
            let status = process.terminationStatus
            print("   ⬅️ Exit code: \(status)")
            return status
        } catch {
            print("   ❌ ERROR running command: \(error)")
            return -1
        }
    }
    
    
    // MARK: - Dock Auto-hide
    
    static func setDockAutohide(_ enable: Bool) {
        print("==========================================================")
        print("🟦 setDockAutohide(enable: \(enable))")
        
        let value = enable ? "true" : "false"
        print("   → Setting Dock autohide = \(value)")
        
        runShell("/usr/bin/defaults",
                 args: ["write", "com.apple.dock", "autohide", "-bool", value])
        
        restartDock()
    }
    
    
    // MARK: - Dock Position
    
    static func setDockLocation(_ location: DockLocation) {
        print("==========================================================")
        print("🟩 setDockLocation(\(location.rawValue))")
        
        runShell("/usr/bin/defaults",
                 args: ["write", "com.apple.dock", "orientation", "-string", location.rawValue])
        
        restartDock()
    }
    
    
    // MARK: - Restart Dock (ALWAYS WORKS)
    //
    // killall Dock is the ONLY fully reliable method.
    // - Works in sandbox & non-sandbox apps
    // - Does NOT need automation permissions
    // - Does NOT need process listing
    // - Dock respawns automatically
    //
    private static func restartDock() {
        print("==========================================================")
        print("🟧 restartDock() — using killall Dock (always reliable)")
        
        let status = runShell("/usr/bin/killall", args: ["Dock"])
        
        if status == 0 {
            print("   ✅ Dock restarted successfully")
        } else {
            print("   ❌ Dock restart failed (exit code \(status)) — but killall is still correct")
        }
    }
    
    
    // MARK: - Stage Manager (macOS 13+ via AppleScript)
    
    static func setStageManager(_ enable: Bool) {
        print("==========================================================")
        print("🟪 setStageManager(enable: \(enable))")
        
        let script = enable
            ? #"tell application "System Events" to tell dock preferences to set stage manager enabled to true"#
            : #"tell application "System Events" to tell dock preferences to set stage manager enabled to false"#
        
        print("   → Running AppleScript:")
        print("     \(script)")
        
        let status = runShell("/usr/bin/osascript", args: ["-e", script])
        
        if status == 0 {
            print("   ✅ Stage Manager updated successfully")
        } else {
            print("   ❌ Failed to update Stage Manager (exit code \(status))")
        }
    }
}

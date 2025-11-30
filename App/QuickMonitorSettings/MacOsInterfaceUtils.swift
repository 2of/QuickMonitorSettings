import Foundation

enum DockLocation: String {
    case left
    case bottom
    case right
}

struct MacOSUtils {
    
    @discardableResult
    private static func runShell(_ command: String, args: [String]) -> Int32 {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: command)
        process.arguments = args
        
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus
        } catch {
            return -1
        }
    }
    
    static func setDockAutohide(_ enable: Bool) {
        let value = enable ? "true" : "false"
        runShell("/usr/bin/defaults",
                 args: ["write", "com.apple.dock", "autohide", "-bool", value])
    }
    
    static func setDockLocation(_ location: DockLocation) {
        runShell("/usr/bin/defaults",
                 args: ["write", "com.apple.dock", "orientation", "-string", location.rawValue])
    }
    
    static func restartDock() {
        runShell("/usr/bin/killall", args: ["Dock"])
    }
    
    static func setStageManager(_ enable: Bool) {
        let script = enable
            ? #"tell application "System Events" to tell dock preferences to set stage manager enabled to true"#
            : #"tell application "System Events" to tell dock preferences to set stage manager enabled to false"#
        
        runShell("/usr/bin/osascript", args: ["-e", script])
    }
    
    static func setDockSize(_ size: Int) {
        runShell("/usr/bin/defaults", args: ["write", "com.apple.dock", "tilesize", "-int", "\(size)"])
    }
    
    static func setMagnification(_ enable: Bool) {
        let value = enable ? "true" : "false"
        runShell("/usr/bin/defaults", args: ["write", "com.apple.dock", "magnification", "-bool", value])
    }
    
    static func setMagnificationSize(_ size: Int) {
        runShell("/usr/bin/defaults", args: ["write", "com.apple.dock", "largesize", "-int", "\(size)"])
    }
    
    static func setMinimizeEffect(_ effect: String) {
        runShell("/usr/bin/defaults", args: ["write", "com.apple.dock", "mineffect", "-string", effect])
    }
    
    static func setShowRecentApps(_ enable: Bool) {
        let value = enable ? "true" : "false"
        runShell("/usr/bin/defaults", args: ["write", "com.apple.dock", "show-recents", "-bool", value])
    }
    
    static func setMinimizeToApplication(_ enable: Bool) {
        let value = enable ? "true" : "false"
        runShell("/usr/bin/defaults", args: ["write", "com.apple.dock", "minimize-to-application", "-bool", value])
    }
    
    static func setAnimateOpening(_ enable: Bool) {
        let value = enable ? "true" : "false"
        runShell("/usr/bin/defaults", args: ["write", "com.apple.dock", "launchanim", "-bool", value])
    }
    
    static func setShowIndicators(_ enable: Bool) {
        let value = enable ? "true" : "false"
        runShell("/usr/bin/defaults", args: ["write", "com.apple.dock", "show-process-indicators", "-bool", value])
    }
}

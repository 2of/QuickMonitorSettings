import SwiftUI

struct ControlBar: View {
    @ObservedObject var appState: AppState
    let config: MonitorConfig
    
    var body: some View {
        VStack(spacing: 12) {
            // Row 1: Secondary Actions
            HStack(spacing: 12) {
                Button(action: {
                    appState.detectAndApply()
                }) {
                    Label("Reload", systemImage: "arrow.triangle.2.circlepath")
                }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    
                    Button(action: {
                        appState.restartDock()
                    }) {
                        Label("Restart Dock", systemImage: "power")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    
                    Spacer()
                    
                    Button(action: {
                        NSApplication.shared.terminate(nil)
                    }) {
                        Label("Quit", systemImage: "xmark.circle")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .controlSize(.small)
                }
                
                // Row 2: Primary Actions
                HStack(spacing: 12) {
                    Spacer()
                    
                    Button("Save") {
                        appState.saveConfigs()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.regular)
                    
                    Button("Apply & Save") {
                        appState.applyConfig(config)
                        appState.saveConfigs()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    .keyboardShortcut(.defaultAction)
                }
            }
            .padding(12)
            .background(.thinMaterial)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.2)),
                alignment: .top
            )
        }
    }


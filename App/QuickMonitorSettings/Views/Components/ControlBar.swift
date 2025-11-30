import SwiftUI

struct ControlBar: View {
    @ObservedObject var appState: AppState
    let config: MonitorConfig
    
    var body: some View {
        HStack(spacing: 12) {
            // Row 1: Secondary Actions
            
            Menu {
                Button(action: {
                    appState.detectAndApply()
                }) {
                    Label("Reload Config", systemImage: "arrow.triangle.2.circlepath")
                }
                
                Button(action: {
                    appState.restartDock()
                }) {
                    Label("Restart Dock", systemImage: "power")
                }
                
                Button(action: {
                    appState.openConfigDirectory()
                }) {
                    Label("Open Config Folder", systemImage: "folder")
                }
                
                Divider()
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Label("Quit", systemImage: "xmark.circle")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .menuStyle(.borderlessButton)
            .frame(width: 30, height: 30)
            
            Spacer()
     
                
           
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


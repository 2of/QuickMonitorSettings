import SwiftUI

struct ContentView: View {
    
    @ObservedObject var appState: AppState
    @State private var selectedConfigId: UUID?
    
    init(appState: AppState) {
        self.appState = appState
        _selectedConfigId = State(initialValue: appState.activeConfigId)
    }
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                if !appState.hasMatchingConfig {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("No config for current monitors")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        Button(action: createConfigFromCurrentMonitors) {
                            Label("Create Config from Current Setup", systemImage: "plus.circle.fill")
                                .font(.caption)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                    }
                    .padding(12)
                    .background(.orange.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
            
                }
                
                List(selection: $selectedConfigId) {
                    ForEach($appState.configs) { $config in
                        ConfigRow(config: config, isActive: appState.activeConfigId == config.id) {
                            deleteConfig(config)
                        }
                        .tag(config.id)
                    }
                }
                .navigationTitle("Configs")
                .toolbar {
                    Button(action: addConfig) {
                        Label("Add Config", systemImage: "plus")
                    }
                }
                .background(.ultraThinMaterial)
                .scrollContentBackground(.hidden)
                .frame(minWidth: 180)
            }
            
        } detail: {
            if let configId = selectedConfigId {
                ConfigDetailView(appState: appState, configId: configId)
                    .background(
                        LinearGradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .ignoresSafeArea()
                    )
            } else {
                VStack {
                    Image(systemName: "display.2")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("Select a configuration")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
    
    private func addConfig() {
        let currentDisplays = appState.getCurrentDisplayNames()
        let newConfig = appState.createConfigForCurrentSetup(displayNames: currentDisplays)
        
        appState.configs.append(newConfig)
        selectedConfigId = newConfig.id
        appState.saveConfigs()
    }
    
    private func deleteConfig(_ config: MonitorConfig) {
        if let index = appState.configs.firstIndex(where: { $0.id == config.id }) {
            appState.configs.remove(at: index)
            if selectedConfigId == config.id {
                selectedConfigId = appState.configs.first?.id
            }
            appState.saveConfigs()
        }
    }
    
    private func createConfigFromCurrentMonitors() {
        let currentDisplays = appState.getCurrentDisplayNames()
        let newConfig = appState.createConfigForCurrentSetup(displayNames: currentDisplays)
        
        appState.configs.append(newConfig)
        selectedConfigId = newConfig.id
        appState.activeConfigId = newConfig.id
        appState.saveConfigs()
    }
}

struct ConfigRow: View {
    let config: MonitorConfig
    let isActive: Bool
    let onDelete: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(config.name)
                    .font(.headline)
                Text("\(config.displayNames.count) Monitors")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            if isActive {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
            
            if isHovering {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
                .padding(.leading, 8)
            }
        }
        .padding(.vertical, 4)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

import SwiftUI

struct ContentView: View {
    
    @State private var configs: [MonitorConfig]
    @State private var selectedConfigId: UUID?
    let activeConfig: MonitorConfig?
    
    init(configs: [MonitorConfig], activeConfig: MonitorConfig? = nil) {
        _configs = State(initialValue: configs)
        _selectedConfigId = State(initialValue: configs.first?.id)
        self.activeConfig = activeConfig
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Active Config Banner
            if let active = activeConfig {
                ActiveConfigBanner(config: active)
            }
            
            Divider()
            
            // Main Config Management UI
            NavigationSplitView {
                List(selection: $selectedConfigId) {
                    ForEach($configs) { $config in
                        HStack {
                            TextField("Config Name", text: $config.name)
                            if activeConfig?.id == config.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .tag(config.id)
                    }
                    .onDelete { indexSet in
                        configs.remove(atOffsets: indexSet)
                        if selectedConfigId == nil, let first = configs.first {
                            selectedConfigId = first.id
                        }
                        save()
                    }
                }
                .navigationTitle("Configs")
                .toolbar {
                    Button(action: addConfig) {
                        Label("Add Config", systemImage: "plus")
                    }
                }
            } detail: {
                if let index = configs.firstIndex(where: { $0.id == selectedConfigId }) {
                    ConfigDetailView(config: $configs[index], onSave: save)
                } else {
                    Text("Select a config")
                        .foregroundColor(.secondary)
                }
            }
            .frame(minHeight: 350)
        }
        .frame(minWidth: 600, minHeight: 400)
        .onDisappear {
             save()
        }
    }
    
    private func addConfig() {
        let newConfig = MonitorConfig(
            name: "New Config", 
            displayNames: [],
            dockPosition: "bottom",
            dockHide: false
        )
        configs.append(newConfig)
        selectedConfigId = newConfig.id
        save()
    }
    
    private func save() {
        ConfigManager.saveConfig(configs)
    }
}

struct ActiveConfigBanner: View {
    let config: MonitorConfig
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .foregroundColor(.green)
                .font(.caption)
            
            Text("Active: \(config.name)")
                .font(.headline)
            
            Spacer()
            
            HStack(spacing: 12) {
                Label(config.dockPosition.capitalized, systemImage: "dock.rectangle")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if config.dockHide {
                    Label("Auto-hide", systemImage: "eye.slash")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.green.opacity(0.1))
    }
}

struct ConfigDetailView: View {
    @Binding var config: MonitorConfig
    var onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings for \(config.name)")
                .font(.title2)
                .bold()

            // Display list of monitors in this config
            VStack(alignment: .leading, spacing: 8) {
                Text("Monitors in this setup:")
                    .font(.headline)
                
                if config.displayNames.isEmpty {
                    Text("No monitors detected yet")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(config.displayNames, id: \.self) { displayName in
                        HStack {
                            Image(systemName: "display")
                                .foregroundColor(.blue)
                            Text(displayName)
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Divider()
            
            // Config-level settings
            VStack(alignment: .leading, spacing: 15) {
                Text("Settings for this config:")
                    .font(.headline)
                
                Grid(horizontalSpacing: 15, verticalSpacing: 12) {
                    GridRow {
                        Text("Dock Position:")
                            .foregroundColor(.secondary)
                            .gridColumnAlignment(.trailing)
                        Picker("", selection: $config.dockPosition) {
                            Text("Top").tag("top")
                            Text("Left").tag("left")
                            Text("Right").tag("right")
                            Text("Bottom").tag("bottom")
                        }
                        .labelsHidden()
                        .frame(width: 120)
                        .onChange(of: config.dockPosition) { _ in onSave() }
                    }
                    
                    GridRow {
                        Text("Dock Auto-Hide:")
                            .foregroundColor(.secondary)
                            .gridColumnAlignment(.trailing)
                        Toggle("", isOn: $config.dockHide)
                            .labelsHidden()
                            .onChange(of: config.dockHide) { _ in onSave() }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

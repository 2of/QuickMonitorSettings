import SwiftUI

struct ConfigDetailView: View {
    @ObservedObject var appState: AppState
    let configId: UUID

    private func asyncBinding<T>(_ binding: Binding<T>) -> Binding<T> {
        Binding(
            get: { binding.wrappedValue },
            set: { newValue in
                DispatchQueue.main.async { binding.wrappedValue = newValue }
            }
        )
    }

    var body: some View {
        if let index = appState.configs.firstIndex(where: { $0.id == configId }) {
            let configBinding = $appState.configs[index]

            ScrollView {
                VStack(spacing: 16) {

                    // MARK: - Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {

                            HStack {
                                TextField("Config Name", text: asyncBinding(configBinding.name))
                                    .font(.title2)
                                    .bold()
                                    .textFieldStyle(.plain)
                                
                                Menu {
                                    Button("Home") { configBinding.name.wrappedValue = "Home" }
                                    Button("Work") { configBinding.name.wrappedValue = "Work" }
                                    Button("Office") { configBinding.name.wrappedValue = "Office" }
                                    Button("Mobile") { configBinding.name.wrappedValue = "Mobile" }
                                    Button("Presentation") { configBinding.name.wrappedValue = "Presentation" }
                                    Button("Gaming") { configBinding.name.wrappedValue = "Gaming" }
                                } label: {
                                    Image(systemName: "tag")
                                        .foregroundColor(.secondary)
                                }
                                .menuStyle(.borderlessButton)
                            }

                            HStack {
                                Circle()
                                    .fill(appState.activeConfigId == configId ? Color.green : Color.gray)
                                    .frame(width: 8, height: 8)

                                Text(appState.activeConfigId == configId
                                     ? "Active"
                                     : "Inactive")
                                    .foregroundColor(
                                        appState.activeConfigId == configId ? .green : .secondary
                                    )
                            }
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                (appState.activeConfigId == configId
                                 ? Color.green.opacity(0.12)
                                 : Color.gray.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            )
                        }
                        Spacer()
                    }
                    .padding(.bottom, 4)



                    // MARK: - Monitors
                    GlassSection(title: "Monitors") {
                        if configBinding.wrappedValue.displayNames.isEmpty {
                            Text("No monitors detected yet")
                                .foregroundColor(.secondary)
                                .italic()
                                .font(.caption)
                        } else {
                            ForEach(configBinding.wrappedValue.displayNames, id: \.self) { displayName in
                                HStack {
                                    Image(systemName: "display")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                    Text(displayName)
                                        .font(.caption)
                                    Spacer()
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }



                    // MARK: - Dock Settings
                    GlassSection(title: "Dock Settings") {
                        VStack(spacing: 10) {

                            // Position
                            HStack {
                                Label("Position", systemImage: "dock.rectangle")
                                Spacer()
                                Picker("", selection: asyncBinding(configBinding.dockPosition)) {
                                    Text("Left").tag("left")
                                    Text("Bottom").tag("bottom")
                                    Text("Right").tag("right")
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 180)
                            }

                            Divider()
                            
                            
                         

                            // Minimize Effect
                            HStack {
                                Label("Minimize Effect", systemImage: "arrow.down.right.and.arrow.up.left")
                                Spacer()
                                Picker("", selection: asyncBinding(configBinding.minimizeEffect)) {
                                    Text("Genie").tag("genie")
                                    Text("Scale").tag("scale")
                                }
                                .pickerStyle(.menu)
                                .frame(width: 120)
                            }

                            Divider()

                            // Dock Size
                            HStack {
                                Label("Size", systemImage: "arrow.left.and.right")
                                Spacer()
                                Slider(value: asyncBinding(configBinding.dockSize), in: 0...1) {
                                    Text("Size")
                                } minimumValueLabel: {
                                    Image(systemName: "minus.magnifyingglass").font(.caption)
                                } maximumValueLabel: {
                                    Image(systemName: "plus.magnifyingglass").font(.caption)
                                }
                                .frame(width: 180)
                            }

                            Divider()
                            // Magnification toggle
                            HStack {
                                Label("Magnification", systemImage: "circle.grid.cross")
                                Spacer()
                                Toggle("", isOn: asyncBinding(configBinding.magnification))
                                    .toggleStyle(.switch)
                                    .labelsHidden()
                                    .controlSize(.small)
                            }

                            // Magnification Size slider
                            if configBinding.wrappedValue.magnification {
                                HStack {
                                    Label("Magnification Size", systemImage: "arrow.up.left.and.down.right.magnifyingglass")
                                    Spacer()
                                    Slider(value: asyncBinding(configBinding.magnificationSize), in: 0...1)
                                        .frame(width: 180)
                                }
                            }
                            
                            Divider()
                            
                            
                            HStack {
                                Label("Auto-hide Dock",
                                      systemImage: "eye.slash")
                                Spacer()
                                Toggle("", isOn: asyncBinding(configBinding.dockHide))
                                    .toggleStyle(.switch)
                                    .labelsHidden()
                                    .controlSize(.small)
                            }

                          
                            Divider()
                            
                   

                            HStack {
                                Label("Show recent apps",
                                      systemImage: "clock")
                                Spacer()
                                Toggle("", isOn: asyncBinding(configBinding.showRecentApps))
                                    .toggleStyle(.switch)
                                    .labelsHidden()
                                    .controlSize(.small)
                            }
                            
                            
                            

                           
                        }
                    }




                    // MARK: - Behavior
                    GlassSection(title: "Behavior") {
                        VStack(spacing: 10) {

                          

                            HStack {
                                Label("Stage Manager", systemImage: "square.on.square")
                                Spacer()
                                Toggle("", isOn: asyncBinding(configBinding.stageManager))
                                    .toggleStyle(.switch)
                                    .labelsHidden()
                                    .controlSize(.small)
                            }

                           
                        }
                    }


                    Spacer(minLength: 40)
                }
                .padding(12)
            }
            .safeAreaInset(edge: .bottom) {
                ControlBar(appState: appState, config: configBinding.wrappedValue)
            }

        } else {
            Text("Configuration not found")
        }
    }
}

import SwiftUI

struct MonitoringHomeView: View {
    @Binding var path: NavigationPath
    @State private var showMenu = false
    @StateObject private var viewModel = MonitoringHomeViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()

            VStack(spacing: 16) {
                HeaderView(showMenu: $showMenu, path: $path)

                ScrollView {
                    VStack(spacing: 16) {
                        SectionContainer(title: "") {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Temperatura")
                                        .font(.headline)
                                        .foregroundColor(.tertiaryColor)
                                    Text(String(format: "%.1f °C", viewModel.temperature))
                                        .font(.largeTitle.bold())
                                        .foregroundColor(.tertiaryColor)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("Humedad")
                                        .font(.headline)
                                        .foregroundColor(.tertiaryColor)
                                    Text(String(format: "%.1f %%", viewModel.humidity))
                                        .font(.largeTitle.bold())
                                        .foregroundColor(.tertiaryColor)
                                }
                            }
                        }

                        SectionContainer(title: "Notificaciones") {
                            if viewModel.notifications.isEmpty {
                                Text("No hay notificaciones")
                                    .foregroundColor(.tertiaryColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(viewModel.notifications) { notif in
                                        HStack {
                                            Circle()
                                                .fill(sensorColor(for: notif.sensor))
                                                .frame(width: 10, height: 10)

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(notif.message)
                                                    .font(.body)
                                                    .foregroundColor(.tertiaryColor)
                                                Text(formatNotificationDate(notif.timestamp))
                                                    .font(.caption)
                                                    .foregroundColor(.tertiaryColor.opacity(0.7))
                                            }
                                        }
                                        .padding(8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.secondaryColor)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }

            if showMenu {
                SideMenuView(isOpen: $showMenu, path: $path)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: showMenu)
        .navigationBarBackButtonHidden(true)
        .task { viewModel.fetch() }
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")) {
                viewModel.errorMessage = nil
            })
        }
    }
}

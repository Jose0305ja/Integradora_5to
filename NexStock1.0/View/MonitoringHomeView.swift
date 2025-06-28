import SwiftUI

struct MonitoringHomeView: View {
    @Binding var path: NavigationPath
    @State private var showMenu = false
    @StateObject private var viewModel = MonitoringHomeViewModel()
    @State private var recentAlerts: [NotificationModel] = []
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
                            if recentAlerts.isEmpty {
                                Text("No hay notificaciones")
                                    .foregroundColor(.tertiaryColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(recentAlerts) { alert in
                                        HStack(spacing: 10) {
                                            Image(systemName: alert.sensor == "Gas" ? "flame.fill" : "waveform.path.ecg")
                                                .foregroundColor(alert.sensor == "Gas" ? .red : .blue)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(alert.message)
                                                    .font(.subheadline.bold())
                                                Text(formattedDate(from: alert.timestamp))
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            if alert.status == "unread" {
                                                Circle()
                                                    .fill(Color.red)
                                                    .frame(width: 8, height: 8)
                                            }
                                        }
                                        .padding(.vertical, 6)
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
        .onAppear {
            NotificationService.shared.fetchNotifications(limit: 3) { notifications in
                recentAlerts = notifications
            }
        }
        .task { viewModel.fetch() }
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")) {
                viewModel.errorMessage = nil
            })
        }
    }
}

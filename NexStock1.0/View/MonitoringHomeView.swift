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
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        }

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
                                Text("No hay notificaciones nuevas")
                                    .foregroundColor(.tertiaryColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(viewModel.notifications) { notif in
                                        MonitoringNotificationCardView(notification: notif)
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
            if viewModel.notifications.isEmpty {
                viewModel.fetch()
            }
        }
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")) {
                viewModel.errorMessage = nil
            })
        }
    }
}

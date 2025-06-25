import SwiftUI

struct MonitoringHomeView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = MonitoringHomeViewModel()
    @State private var showMenu = false
    @State private var selectedNotification: MonitoringNotification?
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()

            VStack(spacing: 16) {
                HeaderView(showMenu: $showMenu, path: $path)

                ScrollView {
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            MonitoringInfoCard(title: "temperature".localized, value: String(format: "%.1f°C", viewModel.temperature))
                            MonitoringInfoCard(title: "humidity".localized, value: String(format: "%.1f%%", viewModel.humidity))
                        }

                        SectionContainer(title: "Notifications") {
                            ForEach(viewModel.notifications) { notification in
                                MonitoringNotificationCard(notification: notification)
                                    .onTapGesture { selectedNotification = notification }
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
        .sheet(item: $selectedNotification) { notif in
            NotificationDetailSheet(notification: notif)
        }
        .onAppear { viewModel.fetch() }
    }
}

struct MonitoringInfoCard: View {
    let title: String
    let value: String
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.tertiaryColor)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.tertiaryColor.opacity(0.7))
        }
        .frame(width: 120, height: 120)
        .background(Color.secondaryColor)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct MonitoringNotificationCard: View {
    let notification: MonitoringNotification
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notification.type)
                .font(.headline)
                .foregroundColor(.tertiaryColor)
            Text(notification.message)
                .font(.caption)
                .foregroundColor(.tertiaryColor.opacity(0.7))
            Text(notification.timestamp)
                .font(.caption2)
                .foregroundColor(.tertiaryColor.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondaryColor)
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

struct NotificationDetailSheet: View {
    let notification: MonitoringNotification

    var body: some View {
        VStack(spacing: 12) {
            Text(notification.type)
                .font(.title3)
            Text(notification.message)
                .font(.body)
            Text(notification.timestamp)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}

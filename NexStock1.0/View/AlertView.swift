//
//  AlertView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//

import SwiftUI

struct AlertView: View {
    @Binding var path: NavigationPath
    @State private var showMenu = false
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    @State private var allAlerts: [AlertNotification] = []

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HeaderView(showMenu: $showMenu, path: $path)

                Text("alerts".localized)
                    .font(.title.bold())
                    .padding(.horizontal)

                ScrollView {
                    let grouped = Dictionary(grouping: allAlerts) { alert in
                        alert.sensor
                    }

                    VStack(spacing: 12) {
                        ForEach(grouped.keys.sorted(), id: \.self) { key in
                            Text(key.uppercased())
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(grouped[key] ?? []) { alert in
                                AlertCardView(
                                    sensor: alert.sensor,
                                    icon: iconFor(sensor: alert.sensor),
                                    title: alert.sensor.uppercased(),
                                    message: alert.message,
                                    date: formattedDate(alert.timestamp)
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top, 10)
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
        .task {
            NotificationService.shared.fetchNotifications(limit: 50) { alerts in
                self.allAlerts = alerts
            }
        }

    private func iconFor(sensor: String) -> String {
        switch sensor.lowercased() {
        case "gas":
            return "flame.fill"
        case "vibration":
            return "waveform.path.ecg"
        case "humidity":
            return "drop.fill"
        default:
            return "exclamationmark.triangle"
        }
    }
}

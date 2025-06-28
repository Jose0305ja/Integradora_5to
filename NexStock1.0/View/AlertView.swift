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
    @State private var showSensorsStatus = false
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

                Button(action: { showSensorsStatus = true }) {
                    Text("\u{1F4E1} Estado de sensores")
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.secondaryColor)
                        .cornerRadius(8)
                        .foregroundColor(.tertiaryColor)
                }
                .padding(.horizontal)

                ScrollView {
                    let sorted = allAlerts.sorted { a, b in
                        if let d1 = ISO8601DateFormatter().date(from: a.timestamp),
                           let d2 = ISO8601DateFormatter().date(from: b.timestamp) {
                            return d1 > d2
                        }
                        return false
                    }

                    VStack(spacing: 12) {
                        ForEach(sorted) { alert in
                            let sensorLower = alert.sensor.lowercased()
                            let color: Color
                            if sensorLower.contains("gas") {
                                color = .red
                            } else if sensorLower.contains("vib") {
                                color = .yellow
                            } else {
                                color = .red
                            }

                            AlertCardView(
                                icon: alert.sensor == "Gas" ? "flame.fill" : "waveform.path.ecg",
                                title: alert.sensor.uppercased(),
                                message: alert.message,
                                date: formattedDate(alert.timestamp),
                                highlight: color
                            )
                            .padding(.horizontal)
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
        .sheet(isPresented: $showSensorsStatus) {
            SensorsStatusView()
                .environmentObject(localization)
                .environmentObject(theme)
        }
        .task {
            NotificationService.shared.fetchNotifications(limit: 50) { alerts in
                self.allAlerts = alerts.sorted { a, b in
                    if let d1 = ISO8601DateFormatter().date(from: a.timestamp),
                       let d2 = ISO8601DateFormatter().date(from: b.timestamp) {
                        return d1 > d2
                    }
                    return false
                }
            }
        }
    }
}

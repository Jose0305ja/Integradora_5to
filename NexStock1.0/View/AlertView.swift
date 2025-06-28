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

    @State private var alerts: [AlertModel] = []

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HeaderView(showMenu: $showMenu, path: $path)

                Text("alerts".localized)
                    .font(.title.bold())
                    .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(alerts) { alert in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(alert.message)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(formattedDate(alert.timestamp))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                Spacer()
                                Circle()
                                    .fill(sensorColor(for: alert.sensor))
                                    .frame(width: 12, height: 12)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(sensorColor(for: alert.sensor).opacity(0.3))
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
        .onAppear {
            MonitoringService.shared.fetchAlerts(limit: 20) { alerts in
                self.alerts = alerts
            }
        }
    }
}

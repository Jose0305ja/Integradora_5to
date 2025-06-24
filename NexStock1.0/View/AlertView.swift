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

    let alerts: [AlertModel] = [
        .init(sensor: "Sensor de movimiento", message: "Se ha detectado una vibración fuerte en la zona A.", time: "13:42", icon: "exclamationmark.triangle.fill", severity: .high),
        .init(sensor: "Sensor de gases", message: "Alta concentración de gas detectada en la cocina.", time: "12:10", icon: "exclamationmark.triangle.fill", severity: .medium),
        .init(sensor: "Sensor de humedad", message: "Aumento repentino de humedad detectado.", time: "2 de junio", icon: "exclamationmark.triangle.fill", severity: .low)
    ]

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
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: alert.icon)
                                    .foregroundColor(alert.severity.color)
                                    .font(.system(size: 18))
                                    .padding(.top, 2)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(alert.sensor)
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Text(alert.time)
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }

                                    Text(alert.message)
                                        .font(.body)
                                }
                                .padding(12)
                                .background(
                                    LinearGradient(
                                        colors: [alert.severity.color.opacity(0.2), Color.secondaryColor],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(10)
                            }
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
    }
} 

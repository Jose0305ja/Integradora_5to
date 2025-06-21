//
//  AppView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 16/06/25.
//

import SwiftUI

struct AppView: View {
    @State private var path = NavigationPath()
    @State private var showMenu = false // ✅ AGREGA ESTA LÍNEA

    var body: some View {
        NavigationStack(path: $path) {
            LoginView(path: $path)

                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(path: $path)
                    case .settings:
                        SettingsView(path: $path)
                    case .product:
                        MenuContainerView(
                            content: {
                                InventoryScreenView(path: $path)
                            },
                            path: $path,
                            showMenu: $showMenu
                        )
                    case .userManagement:
                        UserManagementView()
                    case .systemConfig:
                        SystemConfigView()
                    case .temperature:
                        TemperatureView(path: $path)
                    case .humidity:
                        HumidityView(path: $path)
                    case .alerts:
                        AlertView(path: $path)
                    }
                }
        }
    }
}

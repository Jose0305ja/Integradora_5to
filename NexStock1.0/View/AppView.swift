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
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        NavigationStack(path: $path) {
            LoginView(path: $path)

                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(path: $path)
                    case .settings:
                        SettingsView(path: $path)
                    case .financeHome:
                        FinanceHomeView(path: $path)
                    case .financeStatus:
                        FinanceStatusView(path: $path)
                    case .payroll:
                        PayrollView(path: $path)
                    case .financeAI:
                        FinanceAIView(path: $path)
                    case .financeAnalysis:
                        FinanceAnalysisView(path: $path)
                    case .product:
                        MenuContainerView(
                            content: {
                                InventoryScreenView(path: $path)
                            },
                            path: $path,
                            showMenu: $showMenu
                        )
                    case .expiring:
                        InventoryStatusListView(title: "expiring", status: "expiring", path: $path)
                    case .outOfStock:
                        InventoryStatusListView(title: "out_of_stock", status: "out_of_stock", path: $path)
                    case .belowMinimum:
                        InventoryStatusListView(title: "below_minimum", status: "low_stock", path: $path)
                    case .nearMinimum:
                        InventoryStatusListView(title: "near_minimum", status: "near_minimum", path: $path)
                    case .overstock:
                        InventoryStatusListView(title: "overstock", status: "overstock", path: $path)
                    case .shoppingList:
                        InventoryStatusListView(title: "shopping_list", status: "shopping_list", path: $path)
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

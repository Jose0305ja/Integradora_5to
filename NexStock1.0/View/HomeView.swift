//
//  HomeView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 06/06/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var path: NavigationPath
    @State private var showMenu = false
    @StateObject private var summaryVM = HomeSummaryViewModel()
    @State private var recentAlerts: [AlertNotification] = []
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager


    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                HeaderView(showMenu: $showMenu, path: $path)

                ScrollView {
                    VStack(alignment: .center, spacing: 30) {
                        SectionView(title: "finance".localized, cards: [
                            CardModel(title: "Utilidad", subtitle: "$7,584.00")
                        ])

                        SectionView(title: "monitoring".localized, cards: [
                            CardModel(title: "Movimiento", subtitle: "hace 15 min.")
                        ])

                        VStack(spacing: 12) {
                            ForEach(recentAlerts) { alert in
                                AlertCardView(
                                    icon: alert.sensor.lowercased() == "gas" ? "flame.fill" :
                                          alert.sensor.lowercased() == "humidity" ? "drop.fill" : "waveform.path.ecg",
                                    title: alert.sensor.uppercased(),
                                    message: alert.message,
                                    date: formattedDate(alert.timestamp),
                                    sensor: alert.sensor
                                )
                            }
                        }

                        if let summary = summaryVM.summary {
                            if let items = summary.expiring, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "expiring".localized,
                                    products: items.map { ProductModel(from: $0) }
                                )
                            }

                            if let items = summary.out_of_stock, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "out_of_stock".localized,
                                    products: items.map { ProductModel(from: $0) }
                                )
                            }

                            if let items = summary.low_stock, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "below_minimum".localized,
                                    products: items.map { ProductModel(from: $0) }
                                )
                            }

                            if let items = summary.near_minimum, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "near_minimum".localized,
                                    products: items.map { ProductModel(from: $0) }
                                )
                            }

                            if let items = summary.overstock, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "overstock".localized,
                                    products: items.map { ProductModel(from: $0) }
                                )
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
        .task {
            summaryVM.fetchSummary()
            NotificationService.shared.fetchNotifications(limit: 6) { alerts in
                self.recentAlerts = alerts
            }
        }
    }
}

#Preview {
    HomeView(path: .constant(NavigationPath()))
}

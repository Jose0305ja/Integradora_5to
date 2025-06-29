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
    @StateObject private var monitoringVM = MonitoringHomeViewModel()
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

                        VStack(alignment: .center, spacing: 10) {
                            Text("monitoring".localized)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .center)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    Button(action: { path.append(AppRoute.temperature) }) {
                                        CardView(model: CardModel(
                                            title: "temperature".localized,
                                            subtitle: String(format: "%.1f °C", monitoringVM.temperature),
                                            icon: "thermometer"
                                        ))
                                    }
                                    Button(action: { path.append(AppRoute.humidity) }) {
                                        CardView(model: CardModel(
                                            title: "humidity".localized,
                                            subtitle: String(format: "%.0f %%", monitoringVM.humidity),
                                            icon: "drop.fill"
                                        ))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        HStack {
                            Text("alerts".localized)
                                .font(.title3.bold())
                                .foregroundColor(.primary)

                            Spacer()

                            SeeMoreButton(label: "see_more".localized) {
                                path.append(AppRoute.alerts)
                            }
                        }
                        .padding(.horizontal)

                        VStack(spacing: 12) {
                            ForEach(recentAlerts) { alert in
                                AlertCardView(
                                    icon: alert.sensor == "Gas" ? "flame.fill" : "waveform.path.ecg",
                                    title: alert.sensor.uppercased(),
                                    message: alert.message,
                                    date: formattedDate(alert.timestamp),
                                    highlight: highlightColor(for: alert.sensor)
                                )
                            }
                        }

                        if let summary = summaryVM.summary {
                            if let items = summary.expiring, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "expiring".localized,
                                    products: items.map { ProductModel(from: $0) },
                                    onSeeAll: { path.append(AppRoute.expiring) }
                                )
                            }

                            if let items = summary.out_of_stock, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "out_of_stock".localized,
                                    products: items.map { ProductModel(from: $0) },
                                    onSeeAll: { path.append(AppRoute.outOfStock) }
                                )
                            }

                            if let items = summary.low_stock, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "below_minimum".localized,
                                    products: items.map { ProductModel(from: $0) },
                                    onSeeAll: { path.append(AppRoute.belowMinimum) }
                                )
                            }

                            if let items = summary.near_minimum, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "near_minimum".localized,
                                    products: items.map { ProductModel(from: $0) },
                                    onSeeAll: { path.append(AppRoute.nearMinimum) }
                                )
                            }

                            if let items = summary.overstock, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "overstock".localized,
                                    products: items.map { ProductModel(from: $0) },
                                    onSeeAll: { path.append(AppRoute.overstock) }
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
            monitoringVM.fetch()
            NotificationService.shared.fetchNotifications(limit: 6) { alerts in
                self.recentAlerts = alerts.sorted { a, b in
                    if let d1 = ISO8601DateFormatter().date(from: a.timestamp),
                       let d2 = ISO8601DateFormatter().date(from: b.timestamp) {
                        return d1 > d2
                    }
                    return false
                }
            }
        }
    }

    private func highlightColor(for sensor: String) -> Color {
        let lower = sensor.lowercased()
        if lower.contains("gas") {
            return .red
        } else if lower.contains("vib") {
            return .yellow
        } else {
            return .red
        }
    }
}

#Preview {
    HomeView(path: .constant(NavigationPath()))
}

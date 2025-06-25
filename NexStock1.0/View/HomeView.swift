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
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager
    @State private var selectedProduct: ProductModel? = nil


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

                        AlertSectionView(alerts: [
                            AlertModel(sensor: "Sensor de movimiento", message: "Movimiento detectado en zona 3", time: "14:22 h", icon: "exclamationmark.triangle.fill", severity: .high),
                            AlertModel(sensor: "Sensor de humedad", message: "Humedad superior al 80%", time: "13:45 h", icon: "exclamationmark.triangle.fill", severity: .medium),
                            AlertModel(sensor: "Sensor de temperatura", message: "Temperatura superior a 25 grados", time: "12:13 h", icon: "exclamationmark.triangle.fill", severity: .low)
                        ])

                        if let summary = summaryVM.summary {
                            if let items = summary.expiring, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "expiring".localized,
                                    products: items.map { ProductModel(from: $0) },
                                    onProductTap: { selectedProduct = $0 }
                                )
                            }
                            if let items = summary.out_of_stock, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "out_of_stock".localized,
                                    products: items.map { ProductModel(from: $0) },
                                    onProductTap: { selectedProduct = $0 }
                                )
                            }
                            if let items = summary.low_stock, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "below_minimum".localized,
                                    products: items.map { ProductModel(from: $0) },
                                    onProductTap: { selectedProduct = $0 }
                                )
                            }
                            if let items = summary.near_minimum, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "near_minimum".localized,
                                    products: items.map { ProductModel(from: $0) },
                                    onProductTap: { selectedProduct = $0 }
                                )
                            }
                            if let items = summary.overstock, !items.isEmpty {
                                HomeSummarySectionView(
                                    title: "overstock".localized,
                                    products: items.map { ProductModel(from: $0) },
                                    onProductTap: { selectedProduct = $0 }
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
        .sheet(item: $selectedProduct) {
            ProductDetailView(product: $0)
                .environmentObject(theme)
                .environmentObject(localization)
        }
        .task { summaryVM.fetchSummary() }
    }
}

#Preview {
    HomeView(path: .constant(NavigationPath()))
}

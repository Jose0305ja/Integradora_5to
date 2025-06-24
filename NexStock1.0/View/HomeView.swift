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
    @StateObject private var inventoryVM = InventoryHomeViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    /// Available product categories used for the home preview
    private let categories: [Category] = [
        .init(id: 1, name: "Alimentos"),
        .init(id: 2, name: "Bebidas"),
        .init(id: 3, name: "Insumos"),
        .init(id: 4, name: "Productos de limpieza")
    ]

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

                        ForEach(categories, id: \.id) { category in
                            if let products = inventoryVM.categorizedProducts[category.id], !products.isEmpty {
                                InventoryHomeSectionView(title: category.name, products: Array(products.prefix(5)))
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
        .task { await inventoryVM.fetchProducts() }
    }
}

#Preview {
    HomeView(path: .constant(NavigationPath()))
}

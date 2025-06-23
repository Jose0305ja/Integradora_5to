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

                        AlertSectionView(alerts: [
                            AlertModel(sensor: "Sensor de movimiento", message: "Movimiento detectado en zona 3", time: "14:22 h", icon: "exclamationmark.triangle.fill"),
                            AlertModel(sensor: "Sensor de humedad", message: "Humedad superior al 80%", time: "13:45 h", icon: "exclamationmark.triangle.fill"),
                            AlertModel(sensor: "Sensor de temperatura", message: "Temperatura superior a 25 grados", time: "12:13 h", icon: "exclamationmark.triangle.fill")
                        ])
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
    }
}

#Preview {
    HomeView(path: .constant(NavigationPath()))
}

//
//  SideMenuView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 08/06/25.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isOpen: Bool
    @Binding var path: NavigationPath
    @State private var activeMenu: String? = nil
    @EnvironmentObject var localization: LocalizationManager

    private var topSafeArea: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.safeAreaInsets.top ?? 44
    }

    var body: some View {
        ZStack(alignment: .leading) {
            if isOpen {
                Color.black
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isOpen = false
                        }
                    }
            }

            if isOpen {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                isOpen = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.fourthColor)
                                .padding(.trailing)
                        }
                    }

                    // Inicio
                    Button("home".localized) {
                        path.append(AppRoute.home)
                    }
                    .font(.title3.bold())
                    .foregroundColor(.fourthColor)

                    // Finanzas
                    Button {
                        withAnimation {
                            activeMenu = (activeMenu == "finanzas") ? nil : "finanzas"
                        }
                    } label: {
                        Text("finance".localized)
                            .font(.title3.bold())
                            .foregroundColor(.fourthColor)
                    }

                    if activeMenu == "finanzas" {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("home".localized)
                            Text("status".localized)
                            Text("payroll".localized)
                            Text("ai".localized)
                            Text("analysis".localized)
                        }
                        .font(.body)
                        .foregroundColor(.fourthColor)
                        .padding(.leading, 12)
                    }

                    // Inventario
                    Button {
                        withAnimation {
                            activeMenu = (activeMenu == "inventario") ? nil : "inventario"
                        }
                    } label: {
                        Text("inventory".localized)
                            .font(.title3.bold())
                            .foregroundColor(.fourthColor)
                    }

                    if activeMenu == "inventario" {
                        VStack(alignment: .leading, spacing: 6) {
                            Button("all".localized) {
                                path.append(AppRoute.product)
                            }

                            Text("Proveedores")
                            Text("Almacén")
                        }
                        .font(.body)
                        .foregroundColor(.fourthColor)
                        .padding(.leading, 12)
                    }

                    // Monitoreo
                    Button {
                        withAnimation {
                            activeMenu = (activeMenu == "monitoreo") ? nil : "monitoreo"
                        }
                    } label: {
                        Text("monitoring".localized)
                            .font(.title3.bold())
                            .foregroundColor(.fourthColor)
                    }

                    if activeMenu == "monitoreo" {
                        VStack(alignment: .leading, spacing: 6) {
                            Button {
                                path.append(AppRoute.temperature)
                            } label: {
                                Text("temperature".localized)
                            }

                            Button {
                                path.append(AppRoute.humidity)
                            } label: {
                                Text("humidity".localized)
                            }

                            Button {
                                path.append(AppRoute.alerts)
                            } label: {
                                Text("alerts".localized)
                            }
                        }
                        .font(.body)
                        .foregroundColor(.fourthColor)
                        .padding(.leading, 12)
                    }

                    Spacer()

                    // Configuración
                    Button {
                        path.append(AppRoute.settings)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "gearshape.fill")
                            Text("settings".localized)
                        }
                    }
                    .font(.title3.bold())
                    .foregroundColor(.fourthColor)
                    .padding(.bottom, 40)
                }
                .padding(.top, topSafeArea + 16)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondaryColor)
                .ignoresSafeArea()
                .transition(.move(edge: .leading))
                .animation(.easeInOut, value: isOpen)
            }
        }
    }
}

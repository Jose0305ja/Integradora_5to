//
//  UserManagementView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 09/06/25.
//


import SwiftUI

struct UserManagementView: View {
    let users: [UserTableModel] = [
        .init(username: "juan123", firstName: "Juan", lastName: "Pérez", role: "Administrador", isActive: true),
        .init(username: "ana_dev", firstName: "Ana", lastName: "López", role: "Editor", isActive: false),
        .init(username: "maria_g", firstName: "María", lastName: "Gómez", role: "Gerente", isActive: true),
        .init(username: "carlos_a", firstName: "Carlos", lastName: "Alvarez", role: "Administrador", isActive: true),
        .init(username: "laura_m", firstName: "Laura", lastName: "Martínez", role: "Gerente", isActive: false)
    ]

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        ZStack {
            Color.backColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                // 🔙 Botón y título
                HStack(spacing: 12) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .accessibilityLabel("Volver")
                    }

                    Text("users".localized)
                        .font(.title.bold())
                        .foregroundColor(.primary)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(users) { user in
                            HStack(alignment: .center) {
                                // 🟢 Estado circular
                                Circle()
                                    .fill(user.isActive ? Color.green : Color.red)
                                    .frame(width: 12, height: 12)

                                // 👤 Información de usuario
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(user.firstName) \(user.lastName)")
                                        .font(.headline)
                                        .foregroundColor(.fourthColor)

                                    Text(user.username)
                                        .font(.subheadline)
                                        .foregroundColor(.backColor)

                                    Text(user.role)
                                        .font(.caption)
                                        .foregroundColor(.primaryColor)
                                }

                                Spacer()

                                // 🎨 Colores adaptativos para estado
                                let isDarkMode = colorScheme == .dark
                                let activeBackground = isDarkMode ? Color.green.opacity(0.7) : Color.green.opacity(0.2)
                                let inactiveBackground = isDarkMode ? Color.red.opacity(0.7) : Color.red.opacity(0.2)
                                let activeTextColor = isDarkMode ? Color.white : Color.green
                                let inactiveTextColor = isDarkMode ? Color.white : Color.red

                                Text(user.isActive ? "Activo" : "Inactivo")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(user.isActive ? activeBackground : inactiveBackground)
                                    .foregroundColor(user.isActive ? activeTextColor : inactiveTextColor)
                                    .cornerRadius(8)

                                // ✏️🗑️ Botones de acción
                                HStack(spacing: 12) {
                                    Button {
                                        print("Editar \(user.username)")
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                            .foregroundColor(.accentColor)
                                    }

                                    Button {
                                        print("Eliminar \(user.username)")
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.secondaryColor.opacity(0.9))
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


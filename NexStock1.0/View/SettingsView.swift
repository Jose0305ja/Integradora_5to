//
//  SettingsView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 08/06/25.
//

import SwiftUI

enum UserRole {
    case admin, viewer
}

struct SettingsView: View {
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "es"
    @EnvironmentObject var localization: LocalizationManager
    @State private var notificationsEnabled = true
    @State private var userRole: UserRole = .admin
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            Color.backColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                // 🔙 Header
                HStack(alignment: .center, spacing: 12) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .accessibilityLabel("Volver")
                    }

                    Text("settings".localized)
                        .font(.title.bold())
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // 📜 Contenido
                ScrollView {
                    VStack(spacing: 30) {

                        // 🧑‍ Cuenta
                        SectionContainer(title: "account".localized) {
                            SettingRow(icon: "person.fill", title: "username".localized, subtitle: "Jose Rodriguez")
                            SettingRow(icon: "envelope.fill", title: "email".localized, subtitle: "jose@email.com")
                            SettingRow(icon: "key.fill", title: "change_password".localized)
                        }

                        // ⚙️ Preferencias
                        SectionContainer(title: "preferences".localized) {
                            VStack(alignment: .leading, spacing: 12) {

                                // 🎨 Apariencia
                                HStack(alignment: .center, spacing: 12) {
                                    Image(systemName: "paintbrush.fill")
                                        .foregroundColor(.fourthColor)
                                        .font(.body)

                                    Text("appearance".localized)
                                        .font(.body)
                                        .foregroundColor(.fourthColor)

                                    Picker("Apariencia", selection: $selectedAppearance) {
                                        Text("light".localized).tag("light")
                                        Text("dark".localized).tag("dark")
                                        Text("automatic".localized).tag("system")
                                    }
                                    .pickerStyle(MenuPickerStyle())

                                    Spacer()
                                }

                                // 🌐 Idioma
                                HStack(alignment: .center, spacing: 12) {
                                    Image(systemName: "globe")
                                        .foregroundColor(.fourthColor)
                                        .font(.body)

                                    Text("languages")
                                        .font(.body)
                                        .foregroundColor(.fourthColor)

                                    Picker("Idioma", selection: $selectedLanguage) {
                                        Text("Español 🇲🇽").tag("es")
                                        Text("English 🇺🇸").tag("en")
                                        Text("Français 🇫🇷").tag("fr")
                                        Text("Deutsch 🇩🇪").tag("de")
                                        Text("Italiano 🇮🇹").tag("it")
                                        Text("日本語 🇯🇵").tag("ja")
                                        Text("中文 🇨🇳").tag("zh")
                                    }
                                    .pickerStyle(MenuPickerStyle())

                                    Spacer()
                                }
                            }

                            // 🔔 Notificaciones
                            ToggleRow(icon: "bell.fill", title: "Notificaciones", isOn: $notificationsEnabled)
                        }

                        // 🛠️ Avanzado
                        if userRole == .admin {
                            Text("advanced_settings".localized)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .padding(.top, 4)

                            VStack(spacing: 8) {
                                SettingsTile(iconName: "person.3.fill", title: "Usuarios")
                                    .onTapGesture {
                                        path.append(AppRoute.userManagement)
                                    }

                                SettingsTile(iconName: "desktopcomputer", title: "Sistema")
                                    .onTapGesture {
                                        path.append(AppRoute.systemConfig)
                                    }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .onChange(of: selectedLanguage) { newLanguage in
            simulatePatchPreferences(language: newLanguage, theme: selectedAppearance)
        }
        .onChange(of: selectedAppearance) { newTheme in
            simulatePatchPreferences(language: selectedLanguage, theme: newTheme)
            applyAppearance()
        }
        .onAppear { applyAppearance() }
        .navigationBarBackButtonHidden(true)
    }

    // 👇 Aplica el tema visual
    private func applyAppearance() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else { return }

        switch selectedAppearance {
        case "light": window.overrideUserInterfaceStyle = .light
        case "dark": window.overrideUserInterfaceStyle = .dark
        default: window.overrideUserInterfaceStyle = .unspecified
        }
    }

    // 👇 Simula una petición PATCH
    private func simulatePatchPreferences(language: String, theme: String) {
        let preferences = UserPreferences(language: language, theme: theme)
        if let jsonData = try? JSONEncoder().encode(preferences),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("🔄 PATCH: https://auth.nexusutd.online/auth/users/:id/preferences")
            print("Body:")
            print(jsonString)
        } else {
            print("❌ Error al codificar preferencias")
        }
    }
}

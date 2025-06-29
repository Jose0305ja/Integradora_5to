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
    @EnvironmentObject var theme: ThemeManager
    @State private var notificationsEnabled = true
    @State private var userRole: UserRole = .admin
    @State private var showChangePassword = false
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
                                .onTapGesture { showChangePassword = true }
                        }

                        // ⚙️ Preferencias
                        SectionContainer(title: "preferences".localized) {
                            VStack(alignment: .leading, spacing: 12) {

                                // 🎨 Apariencia
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "paintbrush.fill")
                                        .foregroundColor(.fourthColor)
                                        .font(.body)

                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("appearance".localized)
                                            .font(.body)
                                            .foregroundColor(.fourthColor)

                                        HStack(spacing: 8) {
                                            OptionButton(label: "light".localized, isSelected: selectedAppearance == "light") {
                                                selectedAppearance = "light"
                                            }

                                            OptionButton(label: "dark".localized, isSelected: selectedAppearance == "dark") {
                                                selectedAppearance = "dark"
                                            }

                                            OptionButton(label: "automatic".localized, isSelected: selectedAppearance == "system") {
                                                selectedAppearance = "system"
                                            }
                                        }
                                    }

                                    Spacer()
                                }

                                // 🌐 Idioma
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "globe")
                                        .foregroundColor(.fourthColor)
                                        .font(.body)

                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("languages")
                                            .font(.body)
                                            .foregroundColor(.fourthColor)

                                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                                            OptionButton(label: "Español 🇲🇽", isSelected: selectedLanguage == "es") {
                                                selectedLanguage = "es"
                                            }

                                            OptionButton(label: "English 🇺🇸", isSelected: selectedLanguage == "en") {
                                                selectedLanguage = "en"
                                            }

                                            OptionButton(label: "Français 🇫🇷", isSelected: selectedLanguage == "fr") {
                                                selectedLanguage = "fr"
                                            }

                                            OptionButton(label: "Deutsch 🇩🇪", isSelected: selectedLanguage == "de") {
                                                selectedLanguage = "de"
                                            }

                                            OptionButton(label: "Italiano 🇮🇹", isSelected: selectedLanguage == "it") {
                                                selectedLanguage = "it"
                                            }

                                            OptionButton(label: "日本語 🇯🇵", isSelected: selectedLanguage == "ja") {
                                                selectedLanguage = "ja"
                                            }

                                            OptionButton(label: "中文 🇨🇳", isSelected: selectedLanguage == "zh") {
                                                selectedLanguage = "zh"
                                            }
                                        }
                                    }

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
                                SettingsTile(iconName: "person.3.fill", title: "users".localized)
                                    .onTapGesture {
                                        path.append(AppRoute.userManagement)
                                    }

                                SettingsTile(iconName: "desktopcomputer", title: "system".localized)
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
            localization.setLanguage(newLanguage)
            patchPreferences(language: newLanguage, theme: selectedAppearance)
        }
        .onChange(of: selectedAppearance) { newTheme in
            theme.setTheme(newTheme)
            patchPreferences(language: selectedLanguage, theme: newTheme)
        }
        .onAppear { applyAppearance() }
        .sheet(isPresented: $showChangePassword) {
            ChangePasswordSheet()
        }
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

    // 👇 Envía las preferencias actualizadas al backend
    private func patchPreferences(language: String, theme: String) {
        guard let id = AuthService.shared.userInfo?.id else { return }
        let prefs = UserPreferences(language: language, theme: theme)
        UserService.shared.patchPreferences(id: id, preferences: prefs) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//
//  NexStock1_0App.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 02/06/25.
//

import SwiftUI

@main
struct NexStock1_0App: App {
    @AppStorage("selectedAppearance") private var selectedAppearance = "system"
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var authService = AuthService.shared

    init() {
        applyAppearance()
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(localizationManager)
                .environmentObject(authService)
                .environmentObject(ThemeManager.shared)
        }
    }

    private func applyAppearance() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first else { return }

        switch selectedAppearance {
        case "light": window.overrideUserInterfaceStyle = .light
        case "dark": window.overrideUserInterfaceStyle = .dark
        default: window.overrideUserInterfaceStyle = .unspecified
        }
    }
}

import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @AppStorage("selectedAppearance") var selectedAppearance: String = "system" {
        didSet { applyAppearance() }
    }

    @Published var primaryColor: Color = Color("appPrimaryColor")
    @Published var secondaryColor: Color = Color("appSecondaryColor")
    @Published var tertiaryColor: Color = Color("appTertiaryColor")

    func setTheme(_ theme: String) {
        selectedAppearance = theme
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

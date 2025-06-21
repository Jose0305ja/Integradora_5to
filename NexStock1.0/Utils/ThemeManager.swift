import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var primaryColor: Color = Color("appPrimaryColor")
    @Published var secondaryColor: Color = Color("appSecondaryColor")
    @Published var tertiaryColor: Color = Color("appTertiaryColor")
}

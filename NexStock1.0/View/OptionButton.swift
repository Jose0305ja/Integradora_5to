import SwiftUI

struct OptionButton: View {
    var label: String
    var isSelected: Bool
    var action: () -> Void
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.footnote.weight(.semibold))
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(
                    LinearGradient(
                        colors: isSelected ? [Color.tertiaryColor, Color.primaryColor] : [Color.secondaryColor, Color.primaryColor.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundColor(isSelected ? Color.secondaryColor : Color.tertiaryColor)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.tertiaryColor.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color.primaryColor.opacity(0.2), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OptionButton(label: "Option", isSelected: true) {}
        .environmentObject(ThemeManager.shared)
        .environmentObject(LocalizationManager.shared)
}

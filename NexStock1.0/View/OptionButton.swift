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
                .font(.caption.bold())
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(isSelected ? Color.tertiaryColor : Color.secondaryColor)
                .foregroundColor(isSelected ? Color.secondaryColor : Color.tertiaryColor)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.tertiaryColor.opacity(0.5), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OptionButton(label: "Option", isSelected: true) {}
        .environmentObject(ThemeManager.shared)
        .environmentObject(LocalizationManager.shared)
}

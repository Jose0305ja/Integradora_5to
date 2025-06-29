import SwiftUI

struct SeeMoreButton: View {
    var label: String
    var action: () -> Void
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(label)
                Image(systemName: "chevron.right")
            }
            .font(.caption.bold())
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.secondaryColor)
            .foregroundColor(.tertiaryColor)
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
    SeeMoreButton(label: "See more") {}
        .environmentObject(ThemeManager.shared)
        .environmentObject(LocalizationManager.shared)
}

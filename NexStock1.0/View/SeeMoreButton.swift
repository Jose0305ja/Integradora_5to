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
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                LinearGradient(
                    colors: [Color.secondaryColor, Color.primaryColor.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(.tertiaryColor)
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
    SeeMoreButton(label: "See more") {}
        .environmentObject(ThemeManager.shared)
        .environmentObject(LocalizationManager.shared)
}

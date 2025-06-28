import SwiftUI

struct AlertCardView: View {
    let alert: AlertModel
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: alert.icon)
                .foregroundColor(alert.severity.color)
                .font(.title2)

            Text(alert.message)
                .font(.subheadline)
                .foregroundColor(.tertiaryColor)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .minimumScaleFactor(0.8)

            Text(alert.time)
                .font(.caption2)
                .foregroundColor(.tertiaryColor)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [alert.severity.color.opacity(0.2), Color.secondaryColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.tertiaryColor.opacity(0.2), lineWidth: 1)
        )
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

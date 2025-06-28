import SwiftUI

struct AlertCardView: View {
    let alert: AlertNotification
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(alert.sensor)
                .font(.headline)
                .foregroundColor(.tertiaryColor)
            Text(alert.message)
                .font(.body)
                .foregroundColor(.tertiaryColor)
            Text(alert.timestamp)
                .font(.caption)
                .foregroundColor(.tertiaryColor.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondaryColor)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

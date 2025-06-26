import SwiftUI

struct MonitoringNotificationCardView: View {
    let notification: MonitoringNotification
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notification.type.capitalized)
                .font(.headline)
                .foregroundColor(.tertiaryColor)
            Text(notification.message)
                .font(.body)
                .foregroundColor(.tertiaryColor)
            Text(notification.timestamp)
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

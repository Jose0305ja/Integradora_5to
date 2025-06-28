import SwiftUI

struct AlertCardView: View {
    var icon: String
    var title: String
    var message: String
    var date: String
    var sensor: String
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    private var sensorColor: Color {
        let lower = sensor.lowercased()
        if lower.contains("vib") || lower.contains("mov") {
            return .yellow
        } else if lower.contains("gas") {
            return .red
        } else if lower.contains("hum") {
            return .green
        } else {
            return .red
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(sensorColor)
                .font(.system(size: 18))
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(date)
                        .foregroundColor(.gray)
                        .font(.caption)
                }

                Text(message)
                    .font(.body)
            }
            .padding(12)
            .background(
                LinearGradient(
                    colors: [sensorColor.opacity(0.2), Color.secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(10)
        }
    }
}

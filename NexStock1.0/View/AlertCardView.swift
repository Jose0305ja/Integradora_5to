import SwiftUI

struct AlertCardView: View {
    var sensor: String
    var icon: String
    var title: String
    var message: String
    var date: String
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    private var backgroundColor: Color {
        switch sensor.lowercased() {
        case "gas":
            return Color.red.opacity(0.2)
        case "vibration":
            return Color.yellow.opacity(0.2)
        case "humidity":
            return Color.green.opacity(0.2)
        default:
            return Color.gray.opacity(0.1)
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.primary)
                    Text(title)
                        .font(.headline)
                }

                Text(message)
                    .font(.subheadline)

                Text(date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

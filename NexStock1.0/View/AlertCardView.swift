import SwiftUI

struct AlertCardView: View {
    var icon: String
    var title: String
    var message: String
    var date: String
    var sensor: String
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.primary)
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
            .background(backgroundColor)
            .cornerRadius(10)
        }
    }

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
}

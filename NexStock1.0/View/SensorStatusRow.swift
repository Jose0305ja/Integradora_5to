import SwiftUI

struct SensorStatusRow: View {
    let sensor: SensorStatus
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(sensor.status == "ok" ? Color.green : Color.red)
                .frame(width: 12, height: 12)

            Text(sensor.sensor.capitalized)
                .font(.body)
                .foregroundColor(.tertiaryColor)

            Spacer()

            Text(sensor.status.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(sensor.status == "ok" ? .green : .red)
        }
        .padding()
        .background(Color.secondaryColor)
        .cornerRadius(10)
    }
}

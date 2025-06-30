import SwiftUI

/// View showing a sensor statistic with a label and value.
struct SensorStatView: View {
    let label: String
    let value: String
    var highlight: Bool = false
    var highlightColor: Color = .red

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.tertiaryColor)
            Text(value)
                .font(.headline.monospacedDigit())
                .foregroundColor(highlight ? highlightColor : .tertiaryColor)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.secondaryColor)
        .cornerRadius(10)
    }
}

#if DEBUG
struct SensorStatView_Previews: PreviewProvider {
    static var previews: some View {
        SensorStatView(label: "Current", value: "25.1°C", highlight: true)
            .environmentObject(ThemeManager.shared)
    }
}
#endif

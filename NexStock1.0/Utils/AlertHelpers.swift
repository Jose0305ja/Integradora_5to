import SwiftUI

func sensorColor(for type: String) -> Color {
    switch type.lowercased() {
    case "gas": return .red
    case "vibration": return .yellow
    case "humidity": return .green
    default: return .gray
    }
}

func formattedDate(_ isoString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    guard let date = isoFormatter.date(from: isoString) else { return isoString }
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

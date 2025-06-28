import SwiftUI

func sensorColor(for sensor: String) -> Color {
    switch sensor.lowercased() {
    case "gas":
        return .red
    case "vibration":
        return .yellow
    case "humidity":
        return .green
    default:
        return .gray
    }
}

func formatNotificationDate(_ isoString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    if let date = isoFormatter.date(from: isoString) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    return isoString
}

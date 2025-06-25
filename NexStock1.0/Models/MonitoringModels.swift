import Foundation

struct MonitoringNotification: Identifiable, Codable {
    let id = UUID()
    let type: String
    let message: String
    let timestamp: String
}

struct MonitoringHomeResponse: Codable {
    let temperature: Double
    let humidity: Double
    let unread_notifications: [MonitoringNotification]
}

struct MonitoringGraphResponse: Codable {
    let current: Double
    let average: Double
    let min: Double
    let max: Double
    let points: [MonitoringPoint]
}

import Foundation

struct MonitoringNotification: Identifiable, Decodable {
    let id: Int
    let type: String
    let message: String
    let status: String
    let timestamp: String
}

struct MonitoringHomeResponse: Decodable {
    let message: String
    let temperature: Double
    let humidity: Double
    let unread_notifications: [MonitoringNotification]
}

struct TemperatureGraphResponse: Decodable {
    let message: String
    let current: Double
    let average: Double
    let min: Double
    let max: Double
    let temperature: [MonitoringPoint]
}

struct HumidityGraphResponse: Decodable {
    let message: String
    let current: Double
    let average: Double
    let min: Double
    let max: Double
    let humidity: [MonitoringPoint]
}

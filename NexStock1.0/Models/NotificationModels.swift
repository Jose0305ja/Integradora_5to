import Foundation

struct NotificationResponse: Codable {
    let message: String
    let notifications: [AlertNotification]
    let pagination: PaginationInfo
}

struct AlertNotification: Identifiable, Codable {
    let id: String
    let sensor: String
    let message: String
    let timestamp: String
    let status: String
}

struct PaginationInfo: Codable {
    let current_page: Int
    let total_pages: Int
    let next_page: Int
    let limit: Int
}

struct NotificationModel: Identifiable, Codable {
    let id: String
    let sensor: String
    let message: String
    let timestamp: String
    let status: String
}

struct NotificationsResponse: Codable {
    let message: String
    let notifications: [NotificationModel]
    let pagination: PaginationInfo
}

struct PaginationInfo: Codable {
    let current_page: Int
    let total_pages: Int
    let next_page: Int?
    let limit: Int
}

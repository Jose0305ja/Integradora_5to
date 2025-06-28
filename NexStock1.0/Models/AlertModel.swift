import Foundation

struct AlertModel: Identifiable, Codable {
    let id: String
    let sensor: String
    let message: String
    let timestamp: String
    let status: String
}

struct AlertsResponse: Codable {
    let message: String
    let notifications: [AlertModel]
    let pagination: PaginationInfo
}

struct PaginationInfo: Codable {
    let current_page: Int
    let total_pages: Int
    let next_page: Int
    let limit: Int
}

import Foundation

struct SearchResultResponse: Codable {
    let message: String
    let total: Int
    let results: [SearchProduct]
}

struct SearchProduct: Codable, Identifiable {
    /// A stable identifier generated on initialization since the
    /// backend search endpoint does not provide one.
    let id: UUID = UUID()
    let name: String
    let image_url: String
    let stock_actual: Int
    let category: String
    let sensor_type: String
}

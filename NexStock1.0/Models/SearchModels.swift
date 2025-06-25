import Foundation

struct SearchResultResponse: Codable {
    let message: String
    let total: Int
    let results: [SearchProduct]
}

struct SearchProduct: Codable, Identifiable {
    /// Unique identifier of the product returned by the backend
    let id: Int
    let name: String
    let image_url: String
    let stock_actual: Int
    let category: String
    let sensor_type: String
}

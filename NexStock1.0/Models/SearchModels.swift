import Foundation

struct SearchResultResponse: Codable {
    let message: String
    let total: Int
    let results: [SearchProduct]
}

struct SearchProduct: Identifiable, Codable {
    let id: String
    let name: String
    let image_url: String
    let stock_actual: Int
    let category: String
    let sensor_type: String
}

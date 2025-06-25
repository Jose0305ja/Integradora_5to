import Foundation

struct SearchResultResponse: Codable {
    let message: String
    let total: Int
    let results: [SearchProduct]
}

struct SearchProduct: Codable, Identifiable {
    var id: UUID { UUID() }
    let name: String
    let image_url: String
    let stock_actual: Int
    let category: String
    let sensor_type: String
}

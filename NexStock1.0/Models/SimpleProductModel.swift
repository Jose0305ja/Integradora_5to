import Foundation

struct ProductModel: Identifiable, Codable {
    /// Identifier provided by the backend
    let id: Int
    let name: String
    let image_url: String
    let stock_actual: Int
    let category: String
    let sensor_type: String
}

struct ProductResponse: Codable {
    let message: String
    let products: [ProductModel]
}

import Foundation

struct ProductModel: Identifiable, Codable {
    let id: String
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

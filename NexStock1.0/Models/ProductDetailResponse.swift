import Foundation

struct ProductDetailResponse: Codable {
    let message: String?
    let product: ProductDetailInfo
    /// Movements may be absent in the response so make it optional
    let movements: [ProductMovement]?
}

struct ProductDetailInfo: Identifiable, Codable {
    let id: String
    let name: String
    let image_url: String?
    let description: String?
    let brand: String?
    let category: String?
    let stock_actual: Int?
    let stock_minimum: Int?
    let stock_maximum: Int?
    let sensor_type: String?
    let last_updated: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image_url, description, brand, category, stock_actual
        case stock_minimum = "stock_min"
        case stock_maximum = "stock_max"
        case sensor_type
        case last_updated = "updated_at"
    }
}

/// Represents a single stock movement for a product
struct ProductMovement: Identifiable, Codable {
    /// Some older endpoints may include an id field
    let identifier: Int?
    let date: String?
    let time: String?
    let type: String
    let stock_before: Int?
    let quantity: Int
    let stock_after: Int?
    let comment: String?

    // Fields kept for backwards compatibility with previous endpoints
    let user: String?
    let created_at: String?

    var id: Int { identifier ?? Int(Date().timeIntervalSince1970) }
}

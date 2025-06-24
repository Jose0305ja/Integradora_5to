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
    let brand: String?
    let description: String?
    let image_url: String?
    let stock_actual: Int?
    let stock_min: Int?
    let stock_max: Int?
    let updated_at: String?
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

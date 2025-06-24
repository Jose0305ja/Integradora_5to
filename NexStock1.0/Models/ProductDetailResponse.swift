import Foundation

struct ProductDetailResponse: Codable {
    let message: String?
    let product: ProductDetailInfo
    let movements: [ProductMovement]
}

struct ProductDetailInfo: Identifiable, Codable {
    let id: Int
    let name: String
    let brand: String?
    let description: String?
    let image_url: String?
    let stock_actual: Int?
    let stock_min: Int?
    let stock_max: Int?
    let updated_at: String?
}

struct ProductMovement: Identifiable, Codable {
    let id: Int
    let type: String
    let quantity: Int
    let user: String
    let created_at: String
}

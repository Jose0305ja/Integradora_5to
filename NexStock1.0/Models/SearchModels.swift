import Foundation

struct SearchResultResponse: Codable {
    let message: String?
    let products: [SearchProduct]
}

/// Response for the new search endpoint
struct SearchProductsResponse: Codable {
    let results: [SearchProduct]
}

struct SearchProduct: Identifiable, Codable {
    /// Puede venir nulo si el producto no existe en inventario
    let id: String?
    let name: String
    let image_url: String
    let stock_actual: Int
    let category: String
    let sensor_type: String
}

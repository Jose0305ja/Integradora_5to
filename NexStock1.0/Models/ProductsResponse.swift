import Foundation

struct ProductsResponse: Codable {
    let message: String
    let products: [ProductModel]
}

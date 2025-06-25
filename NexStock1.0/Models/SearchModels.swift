import Foundation

struct SearchResultResponse: Codable {
    let message: String
    let total: Int
    let results: [SearchProduct]
}

struct SearchProduct: Codable, Identifiable {
    /// Unique identifier for the list diffing
    let id: UUID = UUID()
    /// Identifier provided by the backend used for further requests
    let serverID: String
    let name: String
    let image_url: String
    let stock_actual: Int
    let category: String
    let sensor_type: String

    enum CodingKeys: String, CodingKey {
        case serverID = "id"
        case name, image_url, stock_actual, category, sensor_type
    }

    /// Helper to transform the search result into a common `ProductModel`
    var asProductModel: ProductModel {
        ProductModel(
            id: serverID,
            name: name,
            image_url: image_url,
            stock_actual: stock_actual,
            category: category,
            sensor_type: sensor_type
        )
    }
}

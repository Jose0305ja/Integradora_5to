import Foundation

struct InventoryHomeResponse: Codable {
    let message: String?
    let expiring: [InventoryProduct]?
    let out_of_stock: [InventoryProduct]?
    let low_stock: [InventoryProduct]?
    let near_minimum: [InventoryProduct]?
    let overstock: [InventoryProduct]?
    let all: [InventoryProduct]?
}

struct InventoryProduct: Identifiable, Codable {
    let id: String
    let name: String
    let stock_actual: Int?
    let expiration_date: String?
    let image_url: String?
    let sensor_type: String?
    let stock_minimum: Int?
    let stock_maximum: Int?
}

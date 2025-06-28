import Foundation

extension ProductModel {
    init(from search: SearchProduct) {
        self.init(
            id: search.id ?? UUID().uuidString,
            name: search.name,
            image_url: search.image_url,
            stock_actual: search.stock_actual,
            stock_minimum: nil,
            stock_maximum: nil,
            brand: nil,
            category: search.category,
            sensor_type: search.sensor_type,
            last_updated: nil,
            description: nil,
            realId: search.id
        )
    }

    init(from inventory: InventoryProduct) {
        self.init(
            id: inventory.id ?? UUID().uuidString,
            name: inventory.name,
            image_url: inventory.image_url ?? "",
            stock_actual: inventory.stock_actual ?? 0,
            stock_minimum: inventory.stock_minimum,
            stock_maximum: inventory.stock_maximum,
            brand: nil,
            category: nil,
            sensor_type: inventory.sensor_type,
            last_updated: nil,
            description: nil,
            realId: inventory.id
        )
    }

    init(from detailed: DetailedProductModel) {
        self.init(
            id: String(detailed.id),
            name: detailed.name,
            image_url: detailed.image_url,
            stock_actual: 0,
            stock_minimum: detailed.stock_min,
            stock_maximum: detailed.stock_max,
            brand: detailed.brand,
            category: nil,
            sensor_type: detailed.input_method.rawValue,
            last_updated: nil,
            description: detailed.description
        )
    }
}

struct ProductResponse: Codable {
    let products: [ProductModel]
}

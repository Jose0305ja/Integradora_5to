import Foundation

extension ProductModel {
    init(from search: SearchProduct) {
        self.init(
            id: search.id,
            name: search.name,
            image_url: search.image_url,
            stock_actual: search.stock_actual,
            category: search.category,
            sensor_type: search.sensor_type,
            realId: search.id
        )
    }

    init(from inventory: InventoryProduct) {
        self.init(
            id: inventory.id,
            name: inventory.name,
            image_url: inventory.image_url ?? "",
            stock_actual: inventory.stock_actual ?? 0,
            category: "",
            sensor_type: inventory.sensor_type ?? "",
            realId: inventory.id
        )
    }

    init(from detailed: DetailedProductModel) {
        self.init(
            id: String(detailed.id),
            name: detailed.name,
            image_url: detailed.image_url,
            stock_actual: 0,
            category: "",
            sensor_type: detailed.input_method.rawValue,
            realId: String(detailed.id)
        )
    }
}

struct ProductResponse: Codable {
    let products: [ProductModel]
}

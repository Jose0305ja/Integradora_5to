import Foundation

extension ProductModel {
    init(from search: SearchProduct) {
        self.init(
            id: "0",
            name: search.name,
            image_url: search.image_url,
            stock_actual: search.stock_actual,
            category: search.category,
            sensor_type: search.sensor_type
        )
    }

    init(from inventory: InventoryProduct) {
        self.init(
            id: "0",
            name: inventory.name,
            image_url: inventory.image_url ?? "",
            stock_actual: inventory.stock_actual ?? 0,
            category: "",
            sensor_type: inventory.sensor_type ?? ""
        )
    }
}

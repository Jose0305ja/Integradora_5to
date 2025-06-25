import Foundation

extension ProductModel {
    init(from search: SearchProduct) {
        self.id = search.id.uuidString
        self.name = search.name
        self.image_url = search.image_url
        self.stock_actual = search.stock_actual
        self.category = search.category
        self.sensor_type = search.sensor_type
    }

    init(from inventory: InventoryProduct) {
        self.id = inventory.name
        self.name = inventory.name
        self.image_url = inventory.image_url ?? ""
        self.stock_actual = inventory.stock_actual ?? 0
        self.category = ""
        self.sensor_type = inventory.sensor_type ?? ""
    }
}

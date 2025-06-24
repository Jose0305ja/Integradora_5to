//
//  ProductModel.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 14/06/25.
//

import Foundation

enum InputMethod: String, Codable, CaseIterable {
    case manual
    case sensor
}

struct ProductModel: Identifiable, Codable {
    let id: Int
    let name: String
    let brand: String
    let description: String
    let category_id: Int
    let unit_type_id: Int
    let image_url: String
    let stock_min: Int
    let stock_max: Int
    let input_method: InputMethod

    init(id: Int = 0,
         name: String,
         brand: String,
         description: String,
         category_id: Int,
         unit_type_id: Int,
         image_url: String,
         stock_min: Int,
         stock_max: Int,
         input_method: InputMethod) {
        self.id = id
        self.name = name
        self.brand = brand
        self.description = description
        self.category_id = category_id
        self.unit_type_id = unit_type_id
        self.image_url = image_url
        self.stock_min = stock_min
        self.stock_max = stock_max
        self.input_method = input_method
    }

    var localized: String {
        NSLocalizedString(name, comment: "")
    }
}

struct Category: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}

struct UnitType: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}

let sampleProducts: [ProductModel] = [
    ProductModel(
        id: 1,
        name: "Manzana",
        brand: "Del Valle",
        description: "Manzana roja fresca",
        category_id: 1,
        unit_type_id: 1,
        image_url: "manzana",
        stock_min: 5,
        stock_max: 50,
        input_method: .manual
    ),
    ProductModel(
        id: 2,
        name: "Zanahoria",
        brand: "CampoFresco",
        description: "Zanahoria orgánica",
        category_id: 2,
        unit_type_id: 1,
        image_url: "zanahoria",
        stock_min: 10,
        stock_max: 100,
        input_method: .sensor
    )
]

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
    let id = UUID()
    let name: String
    let brand: String
    let description: String
    let category_id: Int
    let unit_type_id: Int
    let image_url: String
    let stock_min: Int
    let stock_max: Int
    let input_method: InputMethod

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

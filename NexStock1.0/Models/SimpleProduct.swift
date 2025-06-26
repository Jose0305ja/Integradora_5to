//
//  SimpleProduct.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 25/06/25.
//


import Foundation

struct ProductModel: Identifiable, Codable {
    let id: String
    let name: String
    let image_url: String
    let stock_actual: Int
    let category: String
    let sensor_type: String
}

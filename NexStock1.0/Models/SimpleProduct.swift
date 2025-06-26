//
//  SimpleProduct.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 25/06/25.
//


import Foundation

struct ProductModel: Identifiable, Codable {
    let id: String           // usado para UI y SwiftUI
    let name: String
    let image_url: String
    let stock_actual: Int
    let category: String
    let sensor_type: String

    // ⚠️ Solo para búsquedas sin ID real
    var realId: String? = nil
}

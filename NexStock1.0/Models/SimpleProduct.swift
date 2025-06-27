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

extension ProductModel {
    /// Returns the identifier to be used when requesting details from the back-end.
    /// Some sources (like InventoryHome) don't include a real id and instead
    /// generate a random UUID. In those cases this property returns `nil`.
    var backendID: String? {
        if let realId { return realId }
        // If `id` looks like a UUID it means it was generated locally and is not valid
        return UUID(uuidString: id) == nil ? id : nil
    }
}

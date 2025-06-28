//
//  SimpleProduct.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 25/06/25.
//


import Foundation

struct ProductModel: Identifiable, Codable {
    /// Identifier used in UI and SwiftUI views
    let id: String
    let name: String
    let image_url: String
    let stock_actual: Int

    /// Additional information that may be present when
    /// converting from `DetailedProductModel`
    let stock_minimum: Int?
    let stock_maximum: Int?
    let brand: String?
    let category: String
    let sensor_type: String
    let last_updated: String?
    let description: String?

    /// Real identifier returned by search endpoints
    /// to allow fetching details later on
    var realId: String? = nil
}

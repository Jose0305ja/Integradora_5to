import Foundation

struct ProductMovement: Identifiable, Codable {
    let id: Int
    let timestamp: String
    let type: String
    let quantity: Int
    let user: String?
}

struct ProductMovementResponse: Codable {
    let movements: [ProductMovement]
}

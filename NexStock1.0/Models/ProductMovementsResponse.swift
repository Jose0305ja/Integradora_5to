import Foundation

struct ProductMovementsResponse: Codable {
    let message: String?
    let movements: [ProductMovement]
}

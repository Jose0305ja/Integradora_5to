import Foundation

struct NewUserModel: Codable {
    let username: String
    let password: String
    let first_name: String
    let last_name: String
    let role_id: String
}

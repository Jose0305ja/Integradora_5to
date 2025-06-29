import Foundation

struct UserDetail: Codable {
    let id: String
    let username: String
    let first_name: String
    let last_name: String
    let role: RoleModel
}

struct UserDetailsResponse: Codable {
    let user: UserDetail
    let roles: [RoleModel]
}

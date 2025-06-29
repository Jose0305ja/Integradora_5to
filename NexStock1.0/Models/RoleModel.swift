import Foundation

struct RoleModel: Codable, Identifiable, Hashable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Backend might return id as Int or String
        if let intId = try? container.decode(Int.self, forKey: .id) {
            id = String(intId)
        } else if let strId = try? container.decode(String.self, forKey: .id) {
            id = strId
        } else {
            throw DecodingError.dataCorruptedError(forKey: .id,
                                                  in: container,
                                                  debugDescription: "Role id is neither Int nor String")
        }

        name = try container.decode(String.self, forKey: .name)
    }
}

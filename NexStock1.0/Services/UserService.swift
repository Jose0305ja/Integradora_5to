import Foundation

class UserService {
    static let shared = UserService()
    private let baseURL = NetworkConfig.authBaseURL

    func fetchUsers(completion: @escaping (Result<[UserTableModel], Error>) -> Void) {
        guard let token = AuthService.shared.token else {
            completion(.failure(NSError(domain: "UserService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }
        guard let url = URL(string: "\(baseURL)/auth/users") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[UserService] request error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let http = response as? HTTPURLResponse,
                  let data = data else {
                print("[UserService] invalid response or data")
                completion(.failure(NSError(domain: "UserService", code: 0, userInfo: nil)))
                return
            }

            print("[UserService] statusCode: \(http.statusCode)")
            if let body = String(data: data, encoding: .utf8) {
                print("[UserService] body: \n\(body)")
            }

            if http.statusCode != 200 {
                if let msg = try? JSONDecoder().decode([String: String].self, from: data)["message"] {
                    completion(.failure(NSError(domain: "UserService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])))
                } else {
                    completion(.failure(NSError(domain: "UserService", code: http.statusCode, userInfo: nil)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(UsersResponse.self, from: data)
                let mapped = decoded.users.map { apiUser in
                    UserTableModel(
                        username: apiUser.username,
                        firstName: apiUser.first_name,
                        lastName: apiUser.last_name,
                        role: apiUser.role.name,
                        isActive: apiUser.is_active
                    )
                }
                print("[UserService] decoded users count: \(mapped.count)")
                completion(.success(mapped))
            } catch {
                print("[UserService] decode error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}

struct UsersResponse: Decodable {
    let message: String
    let users: [APIUser]
}

struct APIUser: Decodable {
    let id: String
    let username: String
    let first_name: String
    let last_name: String
    let role: APIRole
    let is_active: Bool

    enum CodingKeys: String, CodingKey {
        case id, username, first_name, last_name, role, is_active
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let intId = try? container.decode(Int.self, forKey: .id) {
            id = String(intId)
        } else if let strId = try? container.decode(String.self, forKey: .id) {
            id = strId
        } else {
            throw DecodingError.dataCorruptedError(forKey: .id,
                                                  in: container,
                                                  debugDescription: "ID no es Int ni String")
        }

        username = try container.decode(String.self, forKey: .username)
        first_name = try container.decode(String.self, forKey: .first_name)
        last_name = try container.decode(String.self, forKey: .last_name)
        role = try container.decode(APIRole.self, forKey: .role)
        is_active = try container.decode(Bool.self, forKey: .is_active)
    }
}

struct APIRole: Decodable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // `id` might arrive as Int or String depending on backend version
        if let intId = try? container.decode(Int.self, forKey: .id) {
            id = String(intId)
        } else if let strId = try? container.decode(String.self, forKey: .id) {
            id = strId
        } else {
            throw DecodingError.dataCorruptedError(forKey: .id,
                                                  in: container,
                                                  debugDescription: "Role ID is neither Int nor String")
        }
        name = try container.decode(String.self, forKey: .name)
    }
}

extension UserService {
    func fetchRoles(completion: @escaping (Result<[RoleModel], Error>) -> Void) {
        guard let token = AuthService.shared.token else {
            completion(.failure(NSError(domain: "UserService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }
        guard let url = URL(string: "\(baseURL)/auth/roles") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let http = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "UserService", code: 0, userInfo: nil)))
                return
            }
            if http.statusCode != 200 {
                if let msg = try? JSONDecoder().decode([String: String].self, from: data)["message"] {
                    completion(.failure(NSError(domain: "UserService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])))
                } else {
                    completion(.failure(NSError(domain: "UserService", code: http.statusCode, userInfo: nil)))
                }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(RolesResponse.self, from: data)
                completion(.success(decoded.roles))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func createUser(_ user: NewUserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = AuthService.shared.token else {
            completion(.failure(NSError(domain: "UserService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }
        guard let url = URL(string: "\(baseURL)/auth/users") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            completion(.failure(error))
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let http = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "UserService", code: 0, userInfo: nil)))
                return
            }
            if http.statusCode != 200 && http.statusCode != 201 {
                if let msg = try? JSONDecoder().decode([String: String].self, from: data)["message"] {
                    completion(.failure(NSError(domain: "UserService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])))
                } else {
                    completion(.failure(NSError(domain: "UserService", code: http.statusCode, userInfo: nil)))
                }
                return
            }
            completion(.success(()))
        }.resume()
    }
}

struct RolesResponse: Decodable {
    let roles: [RoleModel]
}

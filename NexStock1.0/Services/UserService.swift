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
                completion(.failure(error))
                return
            }

            guard let http = response as? HTTPURLResponse,
                  let data = data else {
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
                completion(.success(mapped))
            } catch {
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
}

struct APIRole: Decodable {
    let id: Int
    let name: String
}

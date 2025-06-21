//
//  AuthService.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 02/06/25.
//

import Foundation

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var token: String? = nil

    var isAuthenticated: Bool {
        return token != nil
    }

    private let baseURL = "https://auth.nexusutd.online"

    func login(user: User, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 Enviando JSON:\n\(jsonString)")
            }
        } catch {
            return completion(.failure(error))
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)

                DispatchQueue.main.async {
                    self.token = decoded.accessToken
                }

                completion(.success(decoded))
            } catch {
                if let responseStr = String(data: data, encoding: .utf8) {
                    print("🔴 Falló la decodificación. Respuesta:\n\(responseStr)")
                }
                completion(.failure(error))
            }
        }.resume()
    }

    func logout() {
        token = nil
    }
}

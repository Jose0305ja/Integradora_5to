//
//  AuthService.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 02/06/25.
//

import Foundation
import SwiftUI

enum AuthError: LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Usuario y/o contraseña incorrectos"
        }
    }
}

class AuthService: ObservableObject {
    static let shared = AuthService()

    @Published var token: String? = nil
    @Published var logoURL: String? = nil
    @Published var userInfo: UserInfo? = nil

    var isAuthenticated: Bool {
        return token != nil
    }

    private let baseURL = NetworkConfig.authBaseURL

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

            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data else {
                return completion(.failure(AuthError.invalidCredentials))
            }

            if httpResponse.statusCode == 401 || httpResponse.statusCode == 400 {
                return completion(.failure(AuthError.invalidCredentials))
            }

            do {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)

                DispatchQueue.main.async {
                    self.token = decoded.accessToken
                    self.logoURL = decoded.settings.logo_url
                    self.userInfo = decoded.user
                    if let p = Color(hex: decoded.settings.color_primary) {
                        ThemeManager.shared.primaryColor = p
                    }
                    if let s = Color(hex: decoded.settings.color_secondary) {
                        ThemeManager.shared.secondaryColor = s
                    }
                    if let t = Color(hex: decoded.settings.color_tertiary) {
                        ThemeManager.shared.tertiaryColor = t
                    }
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
        userInfo = nil
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
}

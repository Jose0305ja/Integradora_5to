//
//  LoginViewModel.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 02/06/25.
//


import Foundation

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false

    func login(completion: @escaping (Bool) -> Void) {
        print("🔐 Intentando login con usuario: \(username)")
        isLoading = true
        errorMessage = nil
        let user = User(username: username, password: password)

        AuthService.shared.login(user: user) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    print("✅ Login exitoso. Token: \(response.accessToken)")
                    UserDefaults.standard.set(response.accessToken, forKey: "authToken")
                    self?.isLoggedIn = true
                    // Obtener configuraci\u00f3n del sistema al iniciar sesi\u00f3n
                    SystemConfigViewModel().fetchConfig()
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
}

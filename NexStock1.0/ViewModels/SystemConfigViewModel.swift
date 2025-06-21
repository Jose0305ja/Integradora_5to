import SwiftUI

class SystemConfigViewModel: ObservableObject {
    @Published var primaryColor: Color = .primaryColor
    @Published var secondaryColor: Color = .secondaryColor
    @Published var tertiaryColor: Color = .tertiaryColor
    @Published var logoImage: UIImage?
    @Published var logoURL: String?
    @Published var isUploading = false

    func fetchConfig(authService: AuthService) {
        guard let url = URL(string: "https://auth.nexusutd.online/auth/config") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authService.token ?? "")", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let response = try? JSONDecoder().decode(SystemConfigResponse.self, from: data) else { return }
            DispatchQueue.main.async {
                if let p = Color(hex: response.color_primary) { self.primaryColor = p }
                if let s = Color(hex: response.color_secondary) { self.secondaryColor = s }
                if let t = Color(hex: response.color_tertiary) { self.tertiaryColor = t }
                self.logoURL = response.logo_url
            }
        }.resume()
    }

    // Convierte Color → Hex
    private func hexString(from color: Color) -> String {
        UIColor(color).toHex ?? "#000000"
    }

    func saveColors(authService: AuthService) {
        let payload: [String: String] = [
            "color_primary": hexString(from: primaryColor),
            "color_secondary": hexString(from: secondaryColor),
            "color_tertiary": hexString(from: tertiaryColor)
        ]

        guard let url = URL(string: "https://auth.nexusutd.online/auth/config") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authService.token ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(payload)

        URLSession.shared.dataTask(with: request).resume()
    }

    @MainActor
    func updateLogo(authService: AuthService) async {
        guard let imageData = logoImage?.pngData() else { return }
        isUploading = true

        guard let firma = await obtenerURLFirmada(authService: authService) else {
            isUploading = false
            return
        }

        do {
            try await subirImagen(data: imageData, to: firma.upload_url)
            await sendLogoUrlToBackend(finalUrl: firma.final_url, authService: authService)
            logoURL = firma.final_url
        } catch {
            print("❌ Error actualizando logo:", error)
        }

        isUploading = false
    }

    private func obtenerURLFirmada(authService: AuthService) async -> UploadUrlResponse? {
        guard let url = URL(string: "https://auth.nexusutd.online/auth/config/upload-url?type=logo&ext=png") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authService.token ?? "")", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decoded = try? JSONDecoder().decode(UploadUrlResponse.self, from: data) {
                return decoded
            } else {
                let raw = String(data: data, encoding: .utf8)
                print("⚠️ Error decodificando firma. Respuesta cruda:", raw ?? "N/A")
                return nil
            }
        } catch {
            print("❌ Error al obtener URL firmada:", error)
            return nil
        }
    }

    private func subirImagen(data: Data, to urlString: String) async throws {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data
        request.setValue("image/png", forHTTPHeaderField: "Content-Type")
        _ = try await URLSession.shared.data(for: request)
    }

    private func sendLogoUrlToBackend(finalUrl: String, authService: AuthService) async {
        guard let url = URL(string: "https://auth.nexusutd.online/auth/config") else { return }

        let payload = ["logo_url": finalUrl]
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authService.token ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(payload)

        _ = try? await URLSession.shared.data(for: request)
    }
}

struct UploadUrlResponse: Codable {
    let upload_url: String
    let final_url: String
}

struct SystemConfigResponse: Codable {
    let logo_url: String?
    let color_primary: String
    let color_secondary: String
    let color_tertiary: String
}

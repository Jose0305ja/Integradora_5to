import SwiftUI

class SystemConfigViewModel: ObservableObject {
    @Published var primaryColor: Color = .primaryColor
    @Published var secondaryColor: Color = .secondaryColor
    @Published var tertiaryColor: Color = .tertiaryColor
    @Published var logoImage: UIImage?
    @Published var logoURL: String?
    @Published var isUploading = false
    @Published var showAlert = false
    @Published var alertMessage: String?

    func fetchConfig() {
        guard let url = URL(string: "https://auth.nexusutd.online/auth/config") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error fetching config:", error)
                return
            }
            guard let data = data,
                  let response = try? JSONDecoder().decode(SystemConfigResponse.self, from: data) else {
                print("❌ Invalid response while fetching config")
                return
            }
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

    func saveColors() {
        let payload: [String: String] = [
            "color_primary": hexString(from: primaryColor),
            "color_secondary": hexString(from: secondaryColor),
            "color_tertiary": hexString(from: tertiaryColor)
        ]

        guard let url = URL(string: "https://auth.nexusutd.online/auth/config") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(payload)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error saving colors:", error)
                    self.alertMessage = "backend_error".localized
                } else if let http = response as? HTTPURLResponse,
                          (200..<300).contains(http.statusCode) {
                    print("✅ Colors saved")
                    self.alertMessage = "config_saved".localized
                } else {
                    let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                    print("⚠️ Unexpected status when saving colors:", code)
                    self.alertMessage = "backend_error".localized
                }
                self.showAlert = true
            }
        }.resume()
    }

    func updateLogo() {
        isUploading = true

        // 1. Obtener URL firmada
        guard let signedUrlRequest = URL(string: "https://auth.nexusutd.online/auth/config/upload-url?type=logo&ext=png") else { return }

        URLSession.shared.dataTask(with: signedUrlRequest) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.isUploading = false
                    print("❌ Error getting signed URL:", error)
                    self.alertMessage = "backend_error".localized
                    self.showAlert = true
                }
                return
            }
            guard let data = data,
                  let response = try? JSONDecoder().decode(UploadUrlResponse.self, from: data),
                  let imageData = self.logoImage?.pngData() else {
                DispatchQueue.main.async {
                    self.isUploading = false
                    print("❌ Invalid data when requesting signed URL")
                    self.alertMessage = "backend_error".localized
                    self.showAlert = true
                }
                return
            }

            // 2. Subir imagen a S3
            var putRequest = URLRequest(url: URL(string: response.upload_url)!)
            putRequest.httpMethod = "PUT"
            putRequest.httpBody = imageData
            putRequest.setValue("image/png", forHTTPHeaderField: "Content-Type")

            URLSession.shared.uploadTask(with: putRequest, from: imageData) { _, uploadResponse, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.isUploading = false
                        print("❌ Error uploading logo:", error)
                        self.alertMessage = "logo_error".localized
                        self.showAlert = true
                    }
                    return
                }

                guard let http = uploadResponse as? HTTPURLResponse,
                      (200..<300).contains(http.statusCode) else {
                    DispatchQueue.main.async {
                        self.isUploading = false
                        let code = (uploadResponse as? HTTPURLResponse)?.statusCode ?? -1
                        print("⚠️ Unexpected status when uploading logo:", code)
                        self.alertMessage = "logo_error".localized
                        self.showAlert = true
                    }
                    return
                }

                // 3. Enviar final_url al backend
                self.sendLogoUrlToBackend(finalUrl: response.final_url)
            }.resume()
        }.resume()
    }

    private func sendLogoUrlToBackend(finalUrl: String) {
        guard let url = URL(string: "https://auth.nexusutd.online/auth/config") else { return }

        let payload = ["logo_url": finalUrl]
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(payload)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                self.isUploading = false
                if let error = error {
                    print("❌ Error sending logo URL:", error)
                    self.alertMessage = "logo_error".localized
                } else if let http = response as? HTTPURLResponse,
                          (200..<300).contains(http.statusCode) {
                    print("✅ Logo URL sent to backend")
                    self.alertMessage = "logo_updated".localized
                } else {
                    let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                    print("⚠️ Unexpected status when sending logo URL:", code)
                    self.alertMessage = "logo_error".localized
                }
                self.showAlert = true
            }
        }.resume()
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

import SwiftUI

class SystemConfigViewModel: ObservableObject {
    @Published var primaryColor: Color = .primaryColor
    @Published var secondaryColor: Color = .secondaryColor
    @Published var backgroundColor: Color = .backColor
    @Published var textColor: Color = .fourthColor
    @Published var logoImage: UIImage?
    @Published var isUploading = false

    // Convierte Color → Hex
    private func hexString(from color: Color) -> String {
        UIColor(color).toHex ?? "#000000"
    }

    func saveColors() {
        let payload: [String: String] = [
            "color_primary": hexString(from: primaryColor),
            "color_secondary": hexString(from: secondaryColor),
            "color_tertiary": hexString(from: textColor)
        ]

        guard let url = URL(string: "https://auth.nexusutd.online/auth/config") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(payload)

        URLSession.shared.dataTask(with: request).resume()
    }

    func updateLogo() {
        isUploading = true

        // 1. Obtener URL firmada
        guard let signedUrlRequest = URL(string: "https://auth.nexusutd.online/auth/config/upload-url?type=logo&ext=png") else { return }

        URLSession.shared.dataTask(with: signedUrlRequest) { data, _, _ in
            guard let data = data,
                  let response = try? JSONDecoder().decode(UploadUrlResponse.self, from: data),
                  let imageData = logoImage?.pngData() else { return }

            // 2. Subir imagen a S3
            var putRequest = URLRequest(url: URL(string: response.upload_url)!)
            putRequest.httpMethod = "PUT"
            putRequest.httpBody = imageData
            putRequest.setValue("image/png", forHTTPHeaderField: "Content-Type")

            URLSession.shared.uploadTask(with: putRequest, from: imageData) { _, _, _ in
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

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.isUploading = false
            }
        }.resume()
    }
}

struct UploadUrlResponse: Codable {
    let upload_url: String
    let final_url: String
}
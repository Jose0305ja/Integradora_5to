import SwiftUI

class SystemConfigViewModel: ObservableObject {
    @Published var primaryColor: Color = .primaryColor
    @Published var secondaryColor: Color = .secondaryColor
    @Published var tertiaryColor: Color = .tertiaryColor
    @Published var logoImage: UIImage?
    @Published var logoURL: String?
    @Published var isSaving = false
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false

    func fetchConfig() {
        guard let url = URL(string: "https://auth.nexusutd.online/auth/config") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
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

    func saveChanges() {
        Task { await performSave() }
    }

    @MainActor
    private func performSave() async {
        isSaving = true
        let colorResult = await saveColors()
        var logoResult = true
        if logoImage != nil {
            logoResult = await updateLogo()
        }
        isSaving = false

        if colorResult && logoResult {
            showSuccessAlert = true
        } else {
            showErrorAlert = true
        }
    }

    private func saveColors() async -> Bool {
        let payload: [String: String] = [
            "color_primary": hexString(from: primaryColor),
            "color_secondary": hexString(from: secondaryColor),
            "color_tertiary": hexString(from: tertiaryColor)
        ]

        guard let url = URL(string: "https://auth.nexusutd.online/auth/config") else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(payload)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) {
                return true
            }
        } catch {
            print("Error saving colors:", error)
        }
        return false
    }

    private func updateLogo() async -> Bool {
        guard let signedUrlRequest = URL(string: "https://auth.nexusutd.online/auth/config/upload-url?type=logo&ext=png"),
              let imageData = logoImage?.pngData() else { return false }

        do {
            let (data, _) = try await URLSession.shared.data(from: signedUrlRequest)
            let response = try JSONDecoder().decode(UploadUrlResponse.self, from: data)

            var putRequest = URLRequest(url: URL(string: response.upload_url)!)
            putRequest.httpMethod = "PUT"
            putRequest.httpBody = imageData
            putRequest.setValue("image/png", forHTTPHeaderField: "Content-Type")

            let (_, putRes) = try await URLSession.shared.data(for: putRequest)
            guard let httpPut = putRes as? HTTPURLResponse, httpPut.statusCode == 200 else {
                return false
            }

            return await sendLogoUrlToBackend(finalUrl: response.final_url)
        } catch {
            print("Error updating logo:", error)
            return false
        }
    }

    private func sendLogoUrlToBackend(finalUrl: String) async -> Bool {
        guard let url = URL(string: "https://auth.nexusutd.online/auth/config") else { return false }

        let payload = ["logo_url": finalUrl]
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(payload)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) {
                return true
            }
        } catch {
            print("Error sending logo url:", error)
        }
        return false
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

import Foundation

class AlertService {
    static let shared = AlertService()
    private let baseURL = "https://monitoring.nexusutd.online/monitoring"

    func fetchNotifications(limit: Int = 20, completion: @escaping ([AlertNotification]) -> Void) {
        guard let url = URL(string: "\(baseURL)/notifications?sensor_type=all&read_status=all&page=1&limit=\(limit)") else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(AuthService.shared.token ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(AlertNotificationResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(decoded.notifications)
                    }
                } catch {
                    print("❌ Decoding error: \(error)")
                    completion([])
                }
            } else {
                completion([])
            }
        }.resume()
    }
}

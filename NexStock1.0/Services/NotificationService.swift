import Foundation

class NotificationService {
    static let shared = NotificationService()

    func fetchNotifications(limit: Int = 20, page: Int = 1, completion: @escaping ([AlertNotification]) -> Void) {
        var components = URLComponents(string: "https://monitoring.nexusutd.online/monitoring/notifications")!
        components.queryItems = [
            URLQueryItem(name: "sensor_type", value: "all"),
            URLQueryItem(name: "read_status", value: "all"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]

        guard let url = components.url else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(AuthService.shared.token ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(NotificationResponse.self, from: data) {
                    DispatchQueue.main.async {
                        completion(decoded.notifications)
                    }
                } else {
                    completion([])
                }
            } else {
                completion([])
            }
        }.resume()
    }
}

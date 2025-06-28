import Foundation

class NotificationService {
    static let shared = NotificationService()

    func fetchNotifications(limit: Int = 20, completion: @escaping ([NotificationModel]) -> Void) {
        guard let url = URL(string: "https://monitoring.nexusutd.online/monitoring/notifications?sensor_type=all&read_status=all&page=1&limit=\(limit)") else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(AuthService.shared.token ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(NotificationsResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(decoded.notifications)
                    }
                } catch {
                    print("❌ Error decoding: \(error)")
                    completion([])
                }
            } else {
                completion([])
            }
        }.resume()
    }
}

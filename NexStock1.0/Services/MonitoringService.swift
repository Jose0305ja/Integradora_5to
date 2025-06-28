import Foundation

class MonitoringService {
    static let shared = MonitoringService()
    private let baseURL = "https://monitoring.nexusutd.online/monitoring"

    private func customDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let isoWithFractional = ISO8601DateFormatter()
            isoWithFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let date = isoWithFractional.date(from: dateString) {
                return date
            }

            let iso = ISO8601DateFormatter()
            if let date = iso.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ISO8601 date format")
        }
        return decoder
    }

    // MARK: - Home
    func fetchHome(completion: @escaping (Result<MonitoringHomeResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/home") else { return }
        guard let token = AuthService.shared.token else {
            completion(.failure(NSError(domain: "MonitoringService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "MonitoringService", code: 0, userInfo: nil)))
                return
            }

            print("📦 JSON recibido:")
            print(String(data: data, encoding: .utf8) ?? "No data")

            if httpResponse.statusCode == 401 {
                completion(.failure(NSError(domain: "MonitoringService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No autorizado. Verifica tu sesión."])))
                return
            }

            do {
                let decoded = try self.customDecoder().decode(MonitoringHomeResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                print("❌ Decode error:", error)
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Temperature
    func fetchTemperature(filter: String, completion: @escaping (Result<TemperatureGraphResponse, Error>) -> Void) {
        guard let token = AuthService.shared.token else {
            completion(.failure(NSError(domain: "MonitoringService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }

        var components = URLComponents(string: "\(baseURL)/temperature-graph")
        components?.queryItems = [URLQueryItem(name: "filter", value: filter)]
        guard let url = components?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "MonitoringService", code: 0, userInfo: nil)))
                return
            }

            print("📦 JSON recibido:")
            print(String(data: data, encoding: .utf8) ?? "No data")

            if httpResponse.statusCode == 401 {
                completion(.failure(NSError(domain: "MonitoringService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No autorizado."])))
                return
            }

            do {
                let decoded = try self.customDecoder().decode(TemperatureGraphResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                print("❌ Decode error:", error)
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Humidity
    func fetchHumidity(filter: String, completion: @escaping (Result<HumidityGraphResponse, Error>) -> Void) {
        guard let token = AuthService.shared.token else {
            completion(.failure(NSError(domain: "MonitoringService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }

        var components = URLComponents(string: "\(baseURL)/humidity-graph")
        components?.queryItems = [URLQueryItem(name: "filter", value: filter)]
        guard let url = components?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "MonitoringService", code: 0, userInfo: nil)))
                return
            }

            print("📦 JSON recibido:")
            print(String(data: data, encoding: .utf8) ?? "No data")

            if httpResponse.statusCode == 401 {
                completion(.failure(NSError(domain: "MonitoringService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No autorizado."])))
                return
            }

            do {
                let decoded = try self.customDecoder().decode(HumidityGraphResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                print("❌ Decode error:", error)
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Notifications
    func fetchNotifications(sensorType: String = "all", readStatus: String = "all", page: Int = 1, limit: Int = 20, completion: @escaping ([NotificationModel]) -> Void) {
        var components = URLComponents(string: "\(baseURL)/notifications")!
        components.queryItems = [
            URLQueryItem(name: "sensor_type", value: sensorType),
            URLQueryItem(name: "read_status", value: readStatus),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]

        guard let url = components.url else { return }
        guard let token = AuthService.shared.token else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let decoded = try? JSONDecoder().decode(NotificationResponse.self, from: data) else {
                completion([])
                return
            }
            DispatchQueue.main.async {
                completion(decoded.notifications)
            }
        }.resume()
    }
}

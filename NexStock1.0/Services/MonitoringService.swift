import Foundation

class MonitoringService {
    static let shared = MonitoringService()
    private let baseURL = "https://monitoring.nexusutd.online/monitoring"

    func fetchHome(completion: @escaping (Result<MonitoringHomeResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/home") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "MonitoringService", code: 0, userInfo: nil)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(MonitoringHomeResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchTemperature(filter: String, completion: @escaping (Result<TemperatureGraphResponse, Error>) -> Void) {
        var components = URLComponents(string: "\(baseURL)/temperature-graph")
        components?.queryItems = [URLQueryItem(name: "filter", value: filter)]
        guard let url = components?.url else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "MonitoringService", code: 0, userInfo: nil)))
                return
            }

            if httpResponse.statusCode == 400 {
                if let backend = try? JSONDecoder().decode([String: String].self, from: data), let message = backend["message"] {
                    completion(.failure(NSError(domain: "MonitoringService", code: 400, userInfo: [NSLocalizedDescriptionKey: message])))
                } else {
                    completion(.failure(NSError(domain: "MonitoringService", code: 400, userInfo: nil)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(TemperatureGraphResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchHumidity(filter: String, completion: @escaping (Result<HumidityGraphResponse, Error>) -> Void) {
        var components = URLComponents(string: "\(baseURL)/humidity-graph")
        components?.queryItems = [URLQueryItem(name: "filter", value: filter)]
        guard let url = components?.url else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "MonitoringService", code: 0, userInfo: nil)))
                return
            }

            if httpResponse.statusCode == 400 {
                if let backend = try? JSONDecoder().decode([String: String].self, from: data), let message = backend["message"] {
                    completion(.failure(NSError(domain: "MonitoringService", code: 400, userInfo: [NSLocalizedDescriptionKey: message])))
                } else {
                    completion(.failure(NSError(domain: "MonitoringService", code: 400, userInfo: nil)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(HumidityGraphResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

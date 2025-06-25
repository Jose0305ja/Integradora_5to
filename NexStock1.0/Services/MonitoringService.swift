import Foundation

class MonitoringService {
    static let shared = MonitoringService()
    private let baseURL = NetworkConfig.monitoringBaseURL + "/monitoring"

    func fetchHome(completion: @escaping (Result<MonitoringHomeResponse, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/home") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decoded = try decoder.decode(MonitoringHomeResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchTemperatureGraph(filter: String, completion: @escaping (Result<MonitoringGraphResponse, Error>) -> Void) {
        requestGraph(path: "/temperature-graph", filter: filter, completion: completion)
    }

    func fetchHumidityGraph(filter: String, completion: @escaping (Result<MonitoringGraphResponse, Error>) -> Void) {
        requestGraph(path: "/humidity-graph", filter: filter, completion: completion)
    }

    private func requestGraph(path: String, filter: String, completion: @escaping (Result<MonitoringGraphResponse, Error>) -> Void) {
        guard var components = URLComponents(string: baseURL + path) else { return }
        components.queryItems = [URLQueryItem(name: "filter", value: filter)]
        guard let url = components.url else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decoded = try decoder.decode(MonitoringGraphResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    if let http = response as? HTTPURLResponse, http.statusCode == 400 {
                        completion(.failure(NSError(domain: "MonitoringService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid filter"])))
                    } else {
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

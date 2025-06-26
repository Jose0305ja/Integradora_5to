import Foundation

class InventoryService {
    static let shared = InventoryService()
    private let baseURL = NetworkConfig.inventoryBaseURL

    func fetchHomeSummary(limit: Int = 5, completion: @escaping (Result<InventoryHomeResponse, Error>) -> Void) {
        guard let token = AuthService.shared.token else {
            completion(.failure(NSError(domain: "InventoryService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }
        guard let url = URL(string: "\(baseURL)/inventory/home?limit=\(limit)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let http = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "InventoryService", code: 0, userInfo: nil)))
                return
            }

            if http.statusCode != 200 {
                if let msg = try? JSONDecoder().decode([String: String].self, from: data)["message"] {
                    completion(.failure(NSError(domain: "InventoryService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])))
                } else {
                    completion(.failure(NSError(domain: "InventoryService", code: http.statusCode, userInfo: nil)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(InventoryHomeResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchDetails(for name: String, completion: @escaping (Result<InventoryProduct, Error>) -> Void) {
        guard let token = AuthService.shared.token else {
            completion(.failure(NSError(domain: "InventoryService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }
        guard let url = URL(string: "\(baseURL)/inventory/home") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let http = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "InventoryService", code: 0, userInfo: nil)))
                return
            }

            if http.statusCode != 200 {
                if let msg = try? JSONDecoder().decode([String: String].self, from: data)["message"] {
                    completion(.failure(NSError(domain: "InventoryService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])))
                } else {
                    completion(.failure(NSError(domain: "InventoryService", code: http.statusCode, userInfo: nil)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(InventoryHomeResponse.self, from: data)
                let expiring = decoded.expiring ?? []
                let outOfStock = decoded.out_of_stock ?? []
                let lowStock = decoded.low_stock ?? []
                let nearMinimum = decoded.near_minimum ?? []
                let overstock = decoded.overstock ?? []
                let allItems = decoded.all ?? []

                let all = expiring + outOfStock + lowStock + nearMinimum + overstock + allItems
                if let found = all.first(where: { $0.name.lowercased() == name.lowercased() }) {
                    completion(.success(found))
                } else {
                    completion(.failure(NSError(domain: "InventoryService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Producto no encontrado"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

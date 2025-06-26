import Foundation

class InventoryService {
    static let shared = InventoryService()
    private let baseURL = NetworkConfig.inventoryBaseURL

    private func authorizedRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(AuthService.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }

    func fetchHomeSummary(limit: Int = 5, completion: @escaping (Result<InventoryHomeResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/inventory/home?limit=\(limit)") else { return }
        let request = authorizedRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(InventoryHomeResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchDetails(for name: String, completion: @escaping (Result<InventoryProduct, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/inventory/home") else { return }
        let request = authorizedRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
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
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

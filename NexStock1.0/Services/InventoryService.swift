import Foundation

class InventoryService {
    static let shared = InventoryService()
    private let baseURL = NetworkConfig.inventoryBaseURL

    func fetchHomeSummary(limit: Int = 5, completion: @escaping (Result<InventoryHomeResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/inventory/home?limit=\(limit)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
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

}

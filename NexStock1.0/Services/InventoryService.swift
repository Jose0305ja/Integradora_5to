import Foundation

class InventoryService {
    static let shared = InventoryService()
    private let baseURL = "https://inventory.nexusutd.online"

    func fetchSummary(completion: @escaping (Result<InventorySummary, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/inventory/home") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(InventorySummary.self, from: data)
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

import Foundation

class InventoryService {
    static let shared = InventoryService()
    private let baseURL = "https://inventory.nexusutd.online"

    func fetchDetails(for name: String, completion: @escaping (Result<InventoryProduct, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/inventory/home") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(InventoryHomeResponse.self, from: data)
                    let all = (decoded.expiring ?? []) +
                              (decoded.out_of_stock ?? []) +
                              (decoded.low_stock ?? []) +
                              (decoded.near_minimum ?? []) +
                              (decoded.overstock ?? []) +
                              (decoded.all ?? [])
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

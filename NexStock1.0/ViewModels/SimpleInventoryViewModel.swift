import Foundation

class SimpleInventoryViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var productsByCategory: [String: [ProductModel]] = [:]

    func fetchProducts() {
        guard let url = URL(string: "https://inventory.nexusutd.online/inventory/products/general") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.products = decoded.products
                        self.groupByCategory()
                    }
                } catch {
                    print("Failed to decode products", error)
                }
            } else if let error = error {
                print("Network error", error)
            }
        }.resume()
    }

    private func groupByCategory() {
        let grouped = Dictionary(grouping: products, by: { $0.category })
        productsByCategory = grouped
    }
}

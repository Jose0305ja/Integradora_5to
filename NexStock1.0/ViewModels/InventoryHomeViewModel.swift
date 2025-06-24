// InventoryHomeViewModel.swift
import Foundation

class InventoryHomeViewModel: ObservableObject {
    @Published var allProducts: [ProductModel] = []
    @Published var categorizedProducts: [Int: [ProductModel]] = [:]
    @Published var isLoading = false

    private let pageSize = 20
    private var currentPage = 0
    private var isLastPage = false

    func fetchProducts(reset: Bool = false) async {
        guard !isLoading, !isLastPage else { return }
        isLoading = true

        if reset {
            currentPage = 0
            isLastPage = false
            allProducts = []
            categorizedProducts = [:]
        }

        let urlString = "https://inventory.nexusutd.online/inventory/products/general?page=\(currentPage)"
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            DispatchQueue.main.async { self.isLoading = false }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🧾 JSON recibido: \(jsonString)")
            }
            let products = try JSONDecoder().decode([ProductModel].self, from: data)

            DispatchQueue.main.async {
                if products.count < self.pageSize {
                    self.isLastPage = true
                } else {
                    self.currentPage += 1
                }

                self.allProducts += products
                self.groupProductsByCategory()
                self.isLoading = false
            }
        } catch {
            print("Error al obtener productos: \(error)")
            DispatchQueue.main.async { self.isLoading = false }
        }
    }

    private func groupProductsByCategory() {
        var grouped: [Int: [ProductModel]] = [:]
        for product in allProducts {
            let categoryId = product.category_id
            grouped[categoryId, default: []].append(product)
        }
        categorizedProducts = grouped
    }
}

import Foundation

class SimpleInventoryViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var productsByCategory: [String: [ProductModel]] = [:]

    func fetchProducts() {
        let categories: [Int] = [1, 2, 3, 4]
        var tempProducts: [ProductModel] = []
        let group = DispatchGroup()

        for id in categories {
            group.enter()
            ProductService.shared.fetchGeneralProducts(categoryID: id) { result in
                if case .success(let prods) = result {
                    tempProducts.append(contentsOf: prods)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.products = tempProducts
            self.groupByCategory()
        }
    }

    private func groupByCategory() {
        let grouped = Dictionary(grouping: products, by: { $0.category })
        productsByCategory = grouped
    }
}

import Foundation

class PaginatedInventoryViewModel: ObservableObject {
    @Published var productsByCategory: [String: [ProductModel]] = [:]

    let categories = ["Alimentos", "Bebidas", "Insumos", "Productos de limpieza"]
    private let categoryIDs: [String: Int] = [
        "Alimentos": 1,
        "Bebidas": 2,
        "Insumos": 3,
        "Productos de limpieza": 4
    ]
    private let limit = 20
    private var pages: [String: Int] = [:]
    private var reachedEnd: [String: Bool] = [:]

    init() {
        for cat in categories {
            productsByCategory[cat] = []
            pages[cat] = 1
            reachedEnd[cat] = false
        }
    }

    func fetchInitial() {
        for cat in categories {
            fetchMore(for: cat)
        }
    }

    func loadMoreIfNeeded(currentItem: ProductModel, category: String) {
        guard let items = productsByCategory[category], let last = items.last else { return }
        if currentItem.id == last.id {
            fetchMore(for: category)
        }
    }

    private func fetchMore(for category: String) {
        guard reachedEnd[category] != true else { return }
        let page = pages[category] ?? 1
        let categoryID = categoryIDs[category]
        ProductService.shared.fetchGeneralProducts(categoryID: categoryID, page: page, limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let newItems):
                    if newItems.count < self.limit { self.reachedEnd[category] = true } else { self.pages[category] = page + 1 }
                    self.productsByCategory[category, default: []].append(contentsOf: newItems)
                case .failure(let error):
                    print("Failed to load products for \(category):", error)
                }
            }
        }
    }
}


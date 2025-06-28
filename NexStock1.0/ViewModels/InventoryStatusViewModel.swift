import Foundation

class InventoryStatusViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var isLoading = false

    private let status: String?
    private var page = 1
    private let limit = 10
    private var reachedEnd = false

    init(status: String?) {
        self.status = status
    }

    func fetchInitial() {
        page = 1
        reachedEnd = false
        products = []
        fetchMore()
    }

    func loadMoreIfNeeded(currentItem: ProductModel) {
        guard !isLoading, !reachedEnd, let last = products.last else { return }
        if currentItem.id == last.id {
            fetchMore()
        }
    }

    private func fetchMore() {
        isLoading = true
        ProductService.shared.fetchInventoryProducts(status: status, page: page, limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let newItems):
                    if newItems.count < self.limit { self.reachedEnd = true } else { self.page += 1 }
                    self.products.append(contentsOf: newItems)
                case .failure(let error):
                    print("Failed to load products for status \(self.status ?? "all"):", error)
                }
            }
        }
    }
}

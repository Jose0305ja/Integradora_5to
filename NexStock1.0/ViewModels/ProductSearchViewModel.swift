import Foundation
import Combine

class ProductSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [ProductModel] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        $query
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.performSearch(for: text)
            }
            .store(in: &cancellables)
    }

    private func performSearch(for text: String) {
        guard text.count >= 2 else {
            results = []
            return
        }

        isLoading = true
        ProductService.shared.searchProducts(name: text) { [weak self] products in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.results = products
            }
        }
    }
}

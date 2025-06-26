import Foundation
import Combine

class ProductSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [SearchProduct] = []
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
        ProductService.shared.searchProducts(query: text) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let product):
                    self?.results = [product]
                case .failure:
                    self?.results = []
                }
            }
        }
    }
}

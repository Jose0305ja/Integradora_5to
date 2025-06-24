import Foundation

class ProductDetailViewModel: ObservableObject {
    @Published var detail: ProductDetailInfo?
    @Published var movements: [ProductMovement] = []
    @Published var isLoading = false

    func fetch(id: String) {
        guard !isLoading else { return }
        isLoading = true
        ProductService.shared.fetchProductDetail(id: id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.detail = response.product
                    self.movements = response.movements
                case .failure(let error):
                    print("Failed to load detail", error)
                }
            }
        }
    }
}

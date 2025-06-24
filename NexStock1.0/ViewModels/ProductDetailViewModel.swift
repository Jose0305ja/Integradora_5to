import Foundation

class ProductDetailViewModel: ObservableObject {
    @Published var detail: ProductDetailInfo?
    @Published var movements: [ProductMovement] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

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
                    // If the backend doesn't provide movements we default to an empty list
                    self.movements = response.movements ?? []
                    print("Product detail loaded", response)
                case .failure(let error):
                    print("Failed to load detail", error)
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

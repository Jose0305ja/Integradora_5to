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

                switch result {
                case .success(let response):
                    if let product = response.product {
                        self.detail = product
                        self.fetchMovements(id: id)
                        print("Product detail loaded", response)
                    } else {
                        self.isLoading = false
                        self.errorMessage = response.message ?? "Producto no disponible"
                    }
                case .failure(let error):
                    self.isLoading = false
                    print("Failed to load detail", error)
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func fetchMovements(id: String) {
        ProductService.shared.fetchProductMovements(id: id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .success(let movements):
                    self.movements = movements
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

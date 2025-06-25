import Foundation

class ProductDetailViewModel: ObservableObject {
    @Published var detail: ProductDetailInfo?
    @Published var movements: [ProductMovement] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetch(id: Int) {
        guard !isLoading else { return }
        isLoading = true

        ProductService.shared.fetchProductDetail(id: id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    self.detail = response.product
                    self.fetchMovements(id: id)
                    print("Product detail loaded", response)
                case .failure:
                    self.isLoading = false
                    self.errorMessage = "Producto no disponible"
                }
            }
        }
    }

    private func fetchMovements(id: Int) {
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

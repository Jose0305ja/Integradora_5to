import Foundation

class ProductDetailViewModel: ObservableObject {
    @Published var detail: ProductDetailInfo?
    @Published var product: ProductModel?
    @Published var movements: [ProductMovement] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetch(product: ProductModel) {
        let idToUse = product.realId ?? product.id
        ProductService.shared.fetchProductDetail(id: idToUse) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let detail):
                    self.detail = detail.product
                    self.product = ProductModel(from: detail.product)
                    self.fetchMovements(id: idToUse)
                case .failure(let error):
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

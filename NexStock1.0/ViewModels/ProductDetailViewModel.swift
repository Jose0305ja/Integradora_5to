import Foundation

class ProductDetailViewModel: ObservableObject {
    @Published var detail: ProductDetailInfo?
    @Published var movements: [ProductMovement] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetch(product: ProductModel) {
        guard let _ = AuthService.shared.token else {
            self.errorMessage = "No token disponible"
            return
        }

        guard let idToUse = product.backendID else {
            self.errorMessage = "No se encontraron detalles"
            return
        }
        ProductService.shared.fetchProductDetail(id: idToUse) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let detail):
                    self.detail = detail
                    self.fetchMovements(for: idToUse)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func fetchMovements(for id: String) {
        guard AuthService.shared.token != nil else {
            self.errorMessage = "No token disponible"
            return
        }

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

import SwiftUI

class ProductDetailPresenter: ObservableObject {
    static let shared = ProductDetailPresenter()
    @Published var selectedProduct: ProductModel?

    func present(product: ProductModel) {
        selectedProduct = product
    }
}

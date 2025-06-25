import Foundation
import SwiftUI

/// Simple identifier used to present product details from any view.
struct ProductIdentifier: Identifiable, Equatable {
    /// Backend identifier of the product
    let id: Int
    let name: String
}

/// Global presenter for the product detail sheet.
final class ProductDetailPresenter: ObservableObject {
    @Published var selectedProduct: ProductIdentifier?

    /// Convenience method to present a product by id and name
    func present(id: Int, name: String) {
        selectedProduct = ProductIdentifier(id: id, name: name)
    }
}

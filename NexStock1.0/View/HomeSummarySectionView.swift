import SwiftUI

struct HomeSummarySectionView: View {
    let title: String
    let products: [ProductModel]

    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.primary)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(products) { product in
                        InventoryCardView(product: product) {
                            openDetail(for: product)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
                .environmentObject(localization)
        }
    }

    @State private var selectedProduct: ProductModel? = nil

    private func openDetail(for product: ProductModel) {
        ProductService.shared.fetchProductDetail(by: product.id) { result in
            switch result {
            case .success(let fullProduct):
                selectedProduct = fullProduct
            case .failure(let error):
                print("\u{274C} Error al obtener detalles: \(error)")
            }
        }
    }
}

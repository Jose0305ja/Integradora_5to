import SwiftUI

struct HomeSummarySectionView: View {
    let title: String
    let products: [ProductModel]
    var onSeeAll: (() -> Void)? = nil

    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.primary)

                Spacer()

                if let onSeeAll = onSeeAll {
                    Button("see_more".localized) { onSeeAll() }
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
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

    @State private var selectedProduct: ProductDetailInfo? = nil

    private func openDetail(for product: ProductModel) {
        let idToUse = product.realId ?? product.id
        ProductService.shared.fetchProductDetail(id: idToUse) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    selectedProduct = detail
                    print("\u{1F4E6} Producto seleccionado:", detail)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

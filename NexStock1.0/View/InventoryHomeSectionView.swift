import SwiftUI

struct InventoryHomeSectionView: View {
    let title: String
    /// Products to display within the section
    let products: [DetailedProductModel]
    /// Optional action triggered when the "Ver más" button is pressed
    var loadMore: (() -> Void)? = nil
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager
    @State private var selectedProduct: ProductModel? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                Spacer()
                if let loadMore = loadMore {
                    Button("Ver más", action: loadMore)
                        .font(.caption)
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(products) { product in
                        InventoryCardView(product: product)
                            .onTapGesture {
                                selectedProduct = ProductModel(from: product)
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
}

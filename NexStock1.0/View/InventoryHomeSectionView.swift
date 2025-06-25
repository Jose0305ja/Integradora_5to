import SwiftUI

struct InventoryHomeSectionView: View {
    let title: String
    /// Products to display within the section
    let products: [ProductModel]
    @State private var selectedProduct: ProductModel? = nil
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
                        InventoryCardView(product: product)
                            .onTapGesture {
                                selectedProduct = product
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

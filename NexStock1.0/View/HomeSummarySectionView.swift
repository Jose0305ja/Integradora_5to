import SwiftUI

struct HomeSummarySectionView: View {
    let title: String
    let products: [InventoryProduct]
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


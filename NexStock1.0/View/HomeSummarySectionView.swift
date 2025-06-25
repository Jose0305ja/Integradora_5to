import SwiftUI

struct HomeSummarySectionView: View {
    let title: String
    let products: [InventoryProduct]
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager
    @State private var selectedProduct: ProductModel? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.primary)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(products) { item in
                        let product = ProductModel(from: item)
                        InventoryCardView(product: product)
                            .onTapGesture { selectedProduct = product }
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


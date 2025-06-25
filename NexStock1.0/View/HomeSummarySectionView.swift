import SwiftUI

struct HomeSummarySectionView: View {
    let title: String
    let products: [InventoryProduct]
    var onProductTap: (ProductModel) -> Void = { _ in }
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
                        HomeInventoryCardView(product: product) {
                            onProductTap(ProductModel(from: product))
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}


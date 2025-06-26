import SwiftUI

struct HomeSummarySectionView: View {
    let title: String
    let products: [ProductModel]
    let onProductTap: (ProductModel) -> Void
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
                                onProductTap(product)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

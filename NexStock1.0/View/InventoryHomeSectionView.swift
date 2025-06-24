import SwiftUI

struct InventoryHomeSectionView: View {
    let title: String
    let products: [InventoryProduct]
    var loadMore: (() -> Void)? = nil
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

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
                        HomeInventoryCardView(product: product)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

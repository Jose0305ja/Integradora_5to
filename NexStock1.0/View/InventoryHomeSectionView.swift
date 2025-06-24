import SwiftUI

struct InventoryHomeSectionView: View {
    let title: String
    /// Products to display within the section
    let products: [ProductModel]
    /// Optional action triggered when the "Ver más" button is pressed
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
                        InventoryCardView(product: product)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

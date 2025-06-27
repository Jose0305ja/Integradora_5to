import SwiftUI

/// Wrapper around InventoryCardView used in the Home screens.
/// Allows reusing the same style in other places like search results.
struct HomeInventoryCardView: View {
    let product: ProductModel
    var onTap: (() -> Void)? = nil

    var body: some View {
        InventoryCardView(product: product, onTap: onTap)
    }
}

#Preview {
    HomeInventoryCardView(product: ProductModel(id: "1", name: "Demo", image_url: "", stock_actual: 10, category: "", sensor_type: ""))
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}

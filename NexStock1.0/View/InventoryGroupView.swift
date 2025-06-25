import SwiftUI

struct InventoryGroupView: View {
    @StateObject private var viewModel = PaginatedInventoryViewModel()
    @State private var selectedProduct: ProductModel? = nil
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(viewModel.categories, id: \.self) { category in
                    if let items = viewModel.productsByCategory[category], !items.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(category.localized)
                                .font(.title3.bold())
                                .padding(.horizontal)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(items) { product in
                                        InventoryCardView(product: product)
                                            .onTapGesture {
                                                selectedProduct = product
                                            }
                                            .onAppear {
                                                viewModel.loadMoreIfNeeded(currentItem: product, category: category)
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchInitial()
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
                .environmentObject(localization)
        }
    }
}

struct InventoryGroupView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryGroupView()
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
    }
}

import SwiftUI

struct InventoryGroupView: View {
    @StateObject private var viewModel = PaginatedInventoryViewModel()
    var onProductTap: (ProductModel) -> Void = { _ in }

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
                                        HomeInventoryCardView(product: product, onTap: { onProductTap(product) })
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
    }
}

struct InventoryGroupView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryGroupView()
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
    }
}

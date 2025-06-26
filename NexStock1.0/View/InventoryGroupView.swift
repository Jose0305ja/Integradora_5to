import SwiftUI

struct InventoryGroupView: View {
    var onProductTap: (ProductModel) -> Void

    @StateObject private var viewModel = PaginatedInventoryViewModel()
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.categories, id: \.self) { category in
                    if let items = viewModel.productsByCategory[category] {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(category.localized)
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(items) { product in
                                        InventoryCardView(product: product) {
                                            onProductTap(product)
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
            .padding(.top)
        }
        .onAppear {
            viewModel.fetchInitial()
        }
    }
}

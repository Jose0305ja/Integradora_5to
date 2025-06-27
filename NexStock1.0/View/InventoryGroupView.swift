import SwiftUI

struct InventoryGroupView: View {
    @StateObject private var viewModel = PaginatedInventoryViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @State private var selectedProduct: ProductModel? = nil

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
                                            openDetail(for: product)
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
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
                .environmentObject(localization)
        }
    }

    private func openDetail(for product: ProductModel) {
        ProductService.shared.fetchProductDetail(by: product.id) { result in
            switch result {
            case .success(let fullProduct):
                selectedProduct = fullProduct
            case .failure(let error):
                print("\u{274C} Error al obtener detalles: \(error)")
            }
        }
    }
}

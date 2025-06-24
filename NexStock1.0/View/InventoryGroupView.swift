import SwiftUI

struct InventoryGroupView: View {
    @StateObject private var viewModel = PaginatedInventoryViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(viewModel.categories, id: \.self) { category in
                    if let items = viewModel.productsByCategory[category], !items.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(category)
                                .font(.title3.bold())
                                .padding(.horizontal)
                            ForEach(items) { product in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\u{2022}")
                                    Text(product.name)
                                }
                                .padding(.horizontal)
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(currentItem: product, category: category)
                                }
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

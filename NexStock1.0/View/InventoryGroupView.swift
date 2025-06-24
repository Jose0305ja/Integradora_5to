import SwiftUI

struct InventoryGroupView: View {
    @StateObject private var viewModel = SimpleInventoryViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(viewModel.productsByCategory.keys.sorted(), id: \.self) { category in
                    if let items = viewModel.productsByCategory[category] {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(category)
                                .font(.title3.bold())
                                .padding(.horizontal)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(items) { product in
                                        ProductCard(product: product)
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
            viewModel.fetchProducts()
        }
    }
}

struct ProductCard: View {
    let product: ProductModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let url = URL(string: product.image_url) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                .cornerRadius(8)
            }
            Text(product.name)
                .font(.headline)
            Text("Stock: \(product.stock_actual)")
                .font(.caption)
            Text("Sensor: \(product.sensor_type)")
                .font(.caption)
        }
        .padding()
        .background(Color.secondaryColor)
        .cornerRadius(12)
    }
}

struct InventoryGroupView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryGroupView()
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
    }
}

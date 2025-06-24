import SwiftUI

// MARK: - Models
struct ProductModel: Identifiable, Codable {
    let id: String
    let name: String
    let image_url: String
    let stock_actual: Int
    let category: String
    let sensor_type: String
}

struct ProductResponse: Codable {
    let products: [ProductModel]
}

// MARK: - ViewModel
class ProductsViewModel: ObservableObject {
    @Published var products: [ProductModel] = []

    func fetchProducts() {
        guard let url = URL(string: "https://example.com/products") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.products = decoded.products
                    }
                } catch {
                    print("Decoding error:", error)
                }
            } else if let error = error {
                print("Request error:", error)
            }
        }.resume()
    }
}

// MARK: - View
struct GroupedProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()

    private var grouped: [String: [ProductModel]] {
        Dictionary(grouping: viewModel.products, by: { $0.category })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(grouped.keys.sorted(), id: \.self) { category in
                    if let items = grouped[category] {
                        Text(category)
                            .font(.title2.bold())
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(items) { product in
                                    VStack(alignment: .leading, spacing: 8) {
                                        AsyncImage(url: URL(string: product.image_url)) { image in
                                            image.resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            Color.gray.opacity(0.3)
                                        }
                                        .frame(width: 120, height: 120)
                                        .clipped()
                                        Text(product.name)
                                            .font(.headline)
                                        Text("Stock: \(product.stock_actual)")
                                            .font(.subheadline)
                                        Text("Sensor: \(product.sensor_type)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .frame(width: 160)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
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

#Preview {
    GroupedProductsView()
}

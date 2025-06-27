import SwiftUI

struct HomeSummarySectionView: View {
    let title: String
    let products: [ProductModel]

    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager
    @State private var showIdAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.primary)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(products) { product in
                        InventoryCardView(product: product) {
                            openDetail(for: product)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
                .environmentObject(localization)
        }
        .alert("Detalles no disponibles", isPresented: $showIdAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    @State private var selectedProduct: ProductDetailInfo? = nil

    private func openDetail(for product: ProductModel) {
        guard let idToUse = product.backendID else {
            showIdAlert = true
            return
        }
        ProductService.shared.fetchProductDetail(id: idToUse) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    selectedProduct = detail
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

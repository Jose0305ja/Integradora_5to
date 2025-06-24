import SwiftUI

struct ProductDetailSheet: View {
    let product: ProductModel
    @State private var details: DetailedProductModel?
    @State private var inventoryInfo: InventoryProduct?
    @State private var movements: [ProductMovement] = []
    @State private var isLoading = true
    @State private var isLoadingMovements = true
    @State private var errorMessage: String?
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView()
            } else {
                TabView {
                    infoView
                        .tabItem { Text("information".localized) }
                    movementsView
                        .tabItem { Text("movements".localized) }
                }
            }
        }
        .navigationTitle(product.name)
        .onAppear(perform: fetchData)
    }

    private var infoView: some View {
        Group {
            if let details = details {
                ScrollView {
                    VStack(spacing: 12) {
                        if let url = URL(string: details.image_url) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 150, height: 150)
                            .cornerRadius(12)
                        }
                        Text(details.name)
                            .font(.title2.bold())
                        if let stock = inventoryInfo?.stock_actual ?? details.stock_actual {
                            Text("\("current_stock".localized): \(stock)")
                        }
                        Text("\("minimum_stock".localized): \(details.stock_min)")
                        Text("\("maximum_stock".localized): \(details.stock_max)")
                        Text("\("brand".localized): \(details.brand)")
                        if let updated = details.updated_at {
                            Text("\("last_updated".localized): \(updated)")
                        }
                        Text("\("description".localized): \(details.description)")
                    }
                    .padding()
                }
            } else if let message = errorMessage {
                Text(message).foregroundColor(.red)
            }
        }
    }

    private var movementsView: some View {
        Group {
            if isLoadingMovements {
                ProgressView()
            } else if movements.isEmpty {
                Text("no_movements".localized)
            } else {
                List(movements) { move in
                    VStack(alignment: .leading) {
                        Text(move.timestamp)
                        Text(move.type)
                        Text("\(move.quantity)")
                        if let user = move.user {
                            Text(user)
                        }
                    }
                }
            }
        }
    }

    private func fetchData() {
        ProductService.shared.fetchProductDetail(id: product.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self.details = detail
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }

        InventoryService.shared.fetchDetails(for: product.name) { result in
            DispatchQueue.main.async {
                if case .success(let info) = result {
                    self.inventoryInfo = info
                }
            }
        }

        ProductService.shared.fetchMovements(for: product.id) { result in
            DispatchQueue.main.async {
                self.isLoadingMovements = false
                switch result {
                case .success(let moves):
                    self.movements = moves
                case .failure:
                    self.movements = []
                }
            }
        }
    }
}

import SwiftUI

struct ProductDetailSheet: View {
    let product: ProductModel
    @State private var detail: InventoryProduct?
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let detail = detail {
                    if let urlString = detail.image_url, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 120)
                    }

                    Text(detail.name)
                        .font(.title2)
                        .bold()

                    if let stock = detail.stock_actual {
                        Text("Stock actual: \(stock)")
                    }
                    if let expiration = detail.expiration_date {
                        Text("Expira: \(expiration)")
                    }
                    if let min = detail.stock_minimum {
                        Text("Mínimo: \(min)")
                    }
                    if let max = detail.stock_maximum {
                        Text("Máximo: \(max)")
                    }
                    if let sensor = detail.sensor_type {
                        Text("Sensor: \(sensor)")
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
            .navigationTitle("Detalle")
            .onAppear(perform: loadDetail)
        }
    }

    func loadDetail() {
        InventoryService.shared.fetchSummary { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let summary):
                    let items = summary.expiring + summary.out_of_stock + summary.low_stock + summary.near_minimum + summary.overstock + summary.all
                    self.detail = items.first { $0.name == product.name }
                case .failure(let error):
                    print("Error fetching product detail:", error)
                }
            }
        }
    }
}

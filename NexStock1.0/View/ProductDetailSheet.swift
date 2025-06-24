import SwiftUI

struct ProductDetailSheet: View {
    let product: DetailedProductModel
    @State private var details: InventoryProduct?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let details = details {
                    VStack(spacing: 12) {
                        if let imageURL = details.image_url, let url = URL(string: imageURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 150, height: 150)
                            .cornerRadius(12)
                        } else {
                            Image(product.image_url)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(12)
                        }

                        Text(details.name)
                            .font(.title2.bold())

                        if let stock = details.stock_actual {
                            Text("\("current_stock".localized): \(stock)")
                        }
                        if let date = details.expiration_date {
                            Text("Expira: \(date)")
                        }
                        if let min = details.stock_minimum {
                            Text("\("minimum_stock".localized): \(min)")
                        }
                        if let max = details.stock_maximum {
                            Text("\("maximum_stock".localized): \(max)")
                        }
                        if let sensor = details.sensor_type {
                            Text("Sensor: \(sensor.localized)")
                        }
                    }
                    .padding()
                } else if let message = errorMessage {
                    Text(message)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("information".localized)
            .onAppear(perform: fetchDetails)
        }
    }

    private func fetchDetails() {
        InventoryService.shared.fetchDetails(for: product.name) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.details = data
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

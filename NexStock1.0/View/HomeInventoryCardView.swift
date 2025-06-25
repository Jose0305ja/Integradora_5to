import SwiftUI

struct HomeInventoryCardView: View {
    let product: InventoryProduct
    var onTap: () -> Void = {}
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let urlString = product.image_url,
               let url = URL(string: urlString) {
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
                .foregroundColor(.tertiaryColor)

            if let stock = product.stock_actual {
                Text("Stock: \(stock)")
                    .font(.caption)
                    .foregroundColor(.tertiaryColor)
            }

            if let sensor = product.sensor_type {
                Text("Sensor: \(sensor.localized)")
                    .font(.caption)
                    .foregroundColor(.tertiaryColor)
            }
        }
        .padding()
        .background(Color.secondaryColor)
        .cornerRadius(12)
        .shadow(radius: 2)
        .onTapGesture { onTap() }
    }
}

import SwiftUI

struct SearchProductCardView: View {
    let product: SearchProduct
    var onTap: () -> Void = {}
    @EnvironmentObject var detailPresenter: ProductDetailPresenter

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

            Text(product.name.localized)
                .font(.headline)
                .foregroundColor(.tertiaryColor)

            Text(product.category.localized)
                .font(.subheadline)
                .foregroundColor(.tertiaryColor)

            Text("Stock: \(product.stock_actual)")
                .font(.caption)
                .foregroundColor(.tertiaryColor)

            Text("Sensor: \(product.sensor_type.localized)")
                .font(.caption)
                .foregroundColor(.tertiaryColor)
        }
        .padding()
        .background(Color.secondaryColor)
        .cornerRadius(12)
        .onTapGesture {
            detailPresenter.present(id: product.id, name: product.name)
            onTap()
        }
    }
}

#Preview {
    SearchProductCardView(product: SearchProduct(id: 0, name: "Ejemplo", image_url: "", stock_actual: 0, category: "", sensor_type: "manual"))
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
        .environmentObject(ProductDetailPresenter())
}

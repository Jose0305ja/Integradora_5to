import SwiftUI

struct HomeInventoryCardView: View {
    let product: InventoryProduct
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var detailPresenter: ProductDetailPresenter

    var body: some View {
        VStack(spacing: 8) {
            if let urlString = product.image_url, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            }

            Text(product.name)
                .font(.headline)
                .foregroundColor(.tertiaryColor)
        }
        .padding()
        .background(Color.secondaryColor)
        .cornerRadius(12)
        .shadow(radius: 2)
        .onTapGesture {
            detailPresenter.present(id: product.id, name: product.name)
        }
    }
}

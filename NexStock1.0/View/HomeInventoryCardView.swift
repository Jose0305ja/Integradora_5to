import SwiftUI

struct HomeInventoryCardView: View {
    let product: ProductModel
    var onTap: ((ProductModel) -> Void)? = nil
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(spacing: 8) {
            if let url = URL(string: product.image_url) {
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
        .onTapGesture { onTap?(product) }
    }
}

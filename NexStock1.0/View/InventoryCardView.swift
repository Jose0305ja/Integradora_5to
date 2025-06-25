//
//  InventoryCardView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 14/06/25.
//

import SwiftUI

struct InventoryCardView: View {
    let product: DetailedProductModel
    var onTap: (() -> Void)? = nil
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var detailPresenter: ProductDetailPresenter

    var body: some View {
        VStack(spacing: 8) {
            if let url = URL(string: product.image_url), product.image_url.hasPrefix("http") {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            } else {
                Image(product.image_url)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            }

            Text(product.name)
                .font(.headline)
                .foregroundColor(.tertiaryColor)

            //Text(product.quantity)
              //  .font(.caption)
                //.foregroundColor(.fourthColor.opacity(0.6))
        }
        .padding()
        .background(Color.secondaryColor)
        .cornerRadius(12)
        .shadow(radius: 2)
        .onTapGesture {
            onTap?()
            detailPresenter.present(product: product.asProductModel)
        }
    }
}

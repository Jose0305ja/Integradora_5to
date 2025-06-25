//
//  InventoryCardView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 14/06/25.
//

import SwiftUI

/// Simple representation used by ``InventoryCardView``.
/// Any model that wishes to be displayed using this card can
/// provide a ``cardData`` property returning this struct.
struct InventoryCardData {
    let name: String
    let imageURL: String
}

protocol InventoryCardConvertible {
    var cardData: InventoryCardData { get }
}

struct InventoryCardView: View {
    let data: InventoryCardData
    var onTap: (() -> Void)? = nil
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(spacing: 8) {
            if let url = URL(string: data.imageURL), data.imageURL.hasPrefix("http") {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            } else {
                Image(data.imageURL)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            }

            Text(data.name)
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
        }
    }
}

extension InventoryCardView {
    init(product: DetailedProductModel, onTap: (() -> Void)? = nil) {
        self.data = InventoryCardData(name: product.name, imageURL: product.image_url)
        self.onTap = onTap
    }

    init(product: ProductModel, onTap: (() -> Void)? = nil) {
        self.data = InventoryCardData(name: product.name, imageURL: product.image_url)
        self.onTap = onTap
    }

    init(product: SearchProduct, onTap: (() -> Void)? = nil) {
        self.data = InventoryCardData(name: product.name, imageURL: product.image_url)
        self.onTap = onTap
    }

    init(product: InventoryProduct, onTap: (() -> Void)? = nil) {
        self.data = InventoryCardData(name: product.name, imageURL: product.image_url ?? "")
        self.onTap = onTap
    }
}

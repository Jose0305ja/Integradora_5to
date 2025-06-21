//
//  InventoryCardView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 14/06/25.
//

import SwiftUI

struct InventoryCardView: View {
    let product: ProductModel

    var body: some View {
        VStack(spacing: 8) {
            Image(product.image_url)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(10)

            Text(product.name)
                .font(.headline)
                .foregroundColor(.fourthColor)

            //Text(product.quantity)
              //  .font(.caption)
                //.foregroundColor(.fourthColor.opacity(0.6))
        }
        .padding()
        .background(Color.secondaryColor)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

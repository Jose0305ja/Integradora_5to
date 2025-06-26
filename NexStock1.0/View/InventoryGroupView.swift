//
//  InventoryGroupView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 25/06/25.
//


import SwiftUI

struct InventoryGroupView: View {
    let onProductTap: (ProductModel) -> Void
    @StateObject private var viewModel = SimpleInventoryViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(viewModel.productsByCategory.keys.sorted(), id: .self) { category in
                    let categoryProducts = viewModel.productsByCategory[category] ?? []
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category.localized)
                            .font(.title3.bold())
                            .foregroundColor(.tertiaryColor)
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)], spacing: 16) {
                            ForEach(categoryProducts) { product in
                                InventoryCardView(product: product) {
                                    onProductTap(product)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            if viewModel.products.isEmpty {
                viewModel.fetchProducts()
            }
        }
    }
}

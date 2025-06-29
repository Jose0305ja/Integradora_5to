//
//  InventoryScreenView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 14/06/25.
//

import SwiftUI
import Combine

struct InventoryScreenView: View {
    @State private var wasMenuOpenBeforeSheet = false
    @Environment(\.showMenuBinding) var showMenu
    @Binding var path: NavigationPath
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var theme: ThemeManager

    @State private var visibleLetterByCategory: [String: String] = [:]
    @StateObject private var searchVM = ProductSearchViewModel()
    @FocusState private var isSearchFocused: Bool
    @State private var showAddProductSheet = false
    @State private var selectedProduct: ProductDetailInfo? = nil

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()
            content
        }
        .overlay(addButton, alignment: .bottomTrailing)
        // Removed dimming overlay when search bar is focused so that only the
        // search bar highlights without darkening the rest of the screen
        .sheet(isPresented: $showAddProductSheet) {
            AddProductSheet { _ in
                showAddProductSheet = false
            }
            .environmentObject(authService)
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
                .environmentObject(localization)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: showAddProductSheet) { isPresented in
            if !isPresented {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showMenu.wrappedValue = false
                }
            }
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            HeaderView(showMenu: showMenu, path: $path)
            searchBar
            productList
        }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.tertiaryColor.opacity(0.7))
            TextField("Buscar producto", text: $searchVM.query)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isSearchFocused)
        }
        .padding()
        .background(isSearchFocused ? Color.tertiaryColor : Color.secondaryColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primaryColor.opacity(isSearchFocused ? 0.8 : 0), lineWidth: 2)
        )
        .shadow(radius: isSearchFocused ? 8 : 0)
        .padding(.horizontal)
        .onChange(of: searchVM.query) { text in
            if text.isEmpty { isSearchFocused = false }
        }
    }

    private var productList: some View {
        Group {
            if searchVM.query.isEmpty {
                InventoryGroupView()
            } else {
                ScrollView {
                    if searchVM.isLoading {
                        ProgressView()
                            .padding()
                    } else if searchVM.results.isEmpty {
                        Text("No se encontraron productos")
                            .foregroundColor(.tertiaryColor)
                            .padding()
                    } else {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                            spacing: 16
                        ) {
                            ForEach(searchVM.results) { product in
                                InventoryCardView(product: product) {
                                    openDetail(for: product)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var addButton: some View {
        Button(action: {
            showAddProductSheet = true
        }) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
                .padding()
                .background(Circle().fill(Color.primaryColor))
                .shadow(radius: 5)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
    }

    private func openDetail(for product: ProductModel) {
        let idToUse = product.realId ?? product.id
        ProductService.shared.fetchProductDetail(id: idToUse) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    selectedProduct = detail
                    print("\u{1F4E6} Producto seleccionado:", detail)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

}

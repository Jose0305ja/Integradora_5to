//
//  InventoryScreenView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 14/06/25.
//

import SwiftUI

struct InventoryScreenView: View {
    @State private var wasMenuOpenBeforeSheet = false
    @Environment(\.showMenuBinding) var showMenu
    @Binding var path: NavigationPath
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var theme: ThemeManager

    @State private var visibleLetterByCategory: [String: String] = [:]
    @State private var searchText: String = ""
    @State private var showAddProductSheet = false
    @State private var products: [ProductModel] = []
    @State private var selectedProduct: ProductModel? = nil

    // Categories provided by the backend
    let categories: [Category] = [
        Category(id: 1, name: "Alimentos"),
        Category(id: 2, name: "Bebidas"),
        Category(id: 3, name: "Insumos"),
        Category(id: 4, name: "Productos de limpieza")
    ]

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()
            content
        }
        .overlay(addButton, alignment: .bottomTrailing)
        .sheet(isPresented: $showAddProductSheet) {
            AddProductSheet { nuevoProducto in
                products.append(nuevoProducto)
                showAddProductSheet = false
            }
            .environmentObject(authService)
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailSheet(product: product)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: showAddProductSheet) { isPresented in
            if !isPresented {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showMenu.wrappedValue = false
                }
            }
        }
        .onAppear(perform: fetchProducts)
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
                .foregroundColor(.gray)
            TextField("Buscar producto", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal)
    }

    private var productList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                ForEach(categories, id: \.id) { category in
                    let filtered = products
                        .filter { $0.category_id == category.id }
                        .filter {
                            searchText.isEmpty ||
                            $0.name.folding(options: .diacriticInsensitive, locale: .current)
                                .localizedCaseInsensitiveContains(
                                    searchText.folding(options: .diacriticInsensitive, locale: .current)
                                )
                        }

                    if !filtered.isEmpty {
                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(.title3.bold())
                                .foregroundColor(.primary)

                            ForEach(filtered, id: \.id) { product in
                                InventoryCardView(product: product) {
                                    selectedProduct = product
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

    private func fetchProducts() {
        ProductService.shared.fetchProducts { result in
            DispatchQueue.main.async {
                if case .success(let data) = result {
                    self.products = data
                }
            }
        }
    }
}
    

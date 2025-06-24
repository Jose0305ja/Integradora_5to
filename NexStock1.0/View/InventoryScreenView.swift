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
    @State private var selectedProduct: ProductModel? = nil

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()
            content
        }
        .overlay(addButton, alignment: .bottomTrailing)
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
                .foregroundColor(.gray)
            TextField("Buscar producto", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal)
    }

    private var productList: some View {
        InventoryGroupView { product in
            selectedProduct = product
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

}

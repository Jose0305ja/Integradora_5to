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
    @EnvironmentObject var detailPresenter: ProductDetailPresenter

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()
            content
        }
        .overlay(addButton, alignment: .bottomTrailing)
        .overlay(
            Group {
                if isSearchFocused {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture { isSearchFocused = false }
                }
            }
        )
        .sheet(isPresented: $showAddProductSheet) {
            AddProductSheet { _ in
                showAddProductSheet = false
            }
            .environmentObject(authService)
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
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(searchVM.results) { product in
                                SearchProductCardView(product: product) {
                                    isSearchFocused = false
                                }
                                .onTapGesture {
                                    detailPresenter.present(id: product.name, name: product.name)
                                }
                            }
                        }
                        .padding()
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

}

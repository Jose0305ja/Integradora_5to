import SwiftUI

struct InventoryStatusListView: View {
    @Binding var path: NavigationPath
    let title: String
    let status: String?

    @State private var showMenu = false
    @StateObject private var viewModel: InventoryStatusViewModel
    @State private var selectedProduct: ProductDetailInfo? = nil
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    init(title: String, status: String?, path: Binding<NavigationPath>) {
        self._path = path
        self.title = title
        self.status = status
        _viewModel = StateObject(wrappedValue: InventoryStatusViewModel(status: status))
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()

            VStack(spacing: 16) {
                HeaderView(showMenu: $showMenu, path: $path)

                Text(title.localized)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                        ForEach(viewModel.products) { product in
                            InventoryCardView(product: product) {
                                openDetail(for: product)
                            }
                            .onAppear { viewModel.loadMoreIfNeeded(currentItem: product) }
                        }
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            if showMenu {
                SideMenuView(isOpen: $showMenu, path: $path)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: showMenu)
        .navigationBarBackButtonHidden(true)
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
                .environmentObject(localization)
        }
        .onAppear { viewModel.fetchInitial() }
    }

    private func openDetail(for product: ProductModel) {
        let idToUse = product.realId ?? product.id
        ProductService.shared.fetchProductDetail(id: idToUse) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    selectedProduct = detail
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

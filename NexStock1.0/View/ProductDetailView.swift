import SwiftUI

struct ProductDetailView: View {
    let product: ProductModel
    @StateObject private var viewModel = ProductDetailViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("information".localized).tag(0)
                    Text("movements".localized).tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else if selectedTab == 0 {
                    infoView
                } else {
                    movementsView
                }
            }
            .navigationTitle(product.name.localized)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { viewModel.fetch(id: product.id) }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Close", action: { dismiss() }) }
            }
        }
    }

    private var infoView: some View {
        ScrollView {
            if let detail = viewModel.detail {
                VStack(spacing: 12) {
                    if let urlString = detail.image_url, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 150, height: 150)
                        .cornerRadius(8)
                    }

                    Text(detail.name.localized)
                        .font(.title2.bold())
                    Text("\("current_stock".localized): \(detail.stock_actual ?? 0)")
                    Text("\("minimum_stock".localized): \(detail.stock_min ?? 0)")
                    Text("\("maximum_stock".localized): \(detail.stock_max ?? 0)")
                    Text("\("brand".localized): \(detail.brand ?? "N/A")")
                    Text("\("last_updated".localized): \(detail.updated_at ?? "N/A")")
                    Text("\("description".localized): \(detail.description ?? "Sin descripción")")
                }
                .padding()
            }
        }
    }

    private var movementsView: some View {
        ScrollView {
            if viewModel.movements.isEmpty {
                Text("no_movements".localized)
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.movements) { move in
                        VStack(alignment: .leading, spacing: 4) {
                            if let date = move.date, let time = move.time {
                                Text("\(date) \(time)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            } else if let created = move.created_at {
                                Text(created)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Text("\(move.type.localized) - \(move.quantity)")
                                .font(.subheadline.bold())

                            if let comment = move.comment, !comment.isEmpty {
                                Text(comment)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            if let user = move.user {
                                Text(user)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.secondaryColor)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: ProductModel(id: "1", name: "Apple", image_url: "", stock_actual: 0, category: "Alimentos", sensor_type: "temperature"))
            .environmentObject(LocalizationManager())
    }
}

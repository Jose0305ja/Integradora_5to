import SwiftUI

struct ProductDetailView: View {
    let product: ProductModel
    @StateObject private var viewModel = ProductDetailViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backColor.ignoresSafeArea()
                VStack(spacing: 16) {
                    Picker("", selection: $selectedTab) {
                        Text("information".localized).tag(0)
                        Text("movements".localized).tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

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
                .padding(.top)
            }
            .navigationTitle(product.name.localized)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { viewModel.fetch(id: product.id) }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("close".localized) { dismiss() }
                }
            }
        }
    }

    private var infoView: some View {
        ScrollView {
            if let detail = viewModel.detail {
                VStack(alignment: .leading, spacing: 12) {
                    if let urlString = detail.image_url, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .cornerRadius(12)
                    }

                    Text(detail.name.localized)
                        .font(.title3.bold())

                    let critical = (detail.stock_actual ?? 0) <= (detail.stock_min ?? Int.min)
                    Text("\("current_stock".localized): \(detail.stock_actual.map(String.init) ?? "no_information".localized)")
                        .font(.body)
                        .fontWeight(critical ? .bold : .regular)
                        .foregroundColor(critical ? .red : .primary)

                    Text("\("minimum_stock".localized): \(detail.stock_min.map(String.init) ?? "no_information".localized)")
                        .font(.body)
                    Text("\("maximum_stock".localized): \(detail.stock_max.map(String.init) ?? "no_information".localized)")
                        .font(.body)
                    Text("\("brand".localized): \(detail.brand?.isEmpty == false ? detail.brand! : "no_information".localized)")
                        .font(.body)
                    Text("\("last_updated".localized): \(formattedDate(detail.updated_at))")
                        .font(.footnote)
                    Text("\("description".localized): \((detail.description?.isEmpty == false ? detail.description! : "no_information".localized))")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.secondaryColor)
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
            }
        }
    }

    private var movementsView: some View {
        ScrollView {
            if viewModel.movements.isEmpty {
                Text("no_movements".localized)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondaryColor)
                    .cornerRadius(12)
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.movements) { move in
                        MovementRow(move: move)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func formattedDate(_ string: String?) -> String {
        guard let string = string else { return "no_information".localized }
        if let date = ISO8601DateFormatter().date(from: string) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return string
    }

    private struct MovementRow: View {
        let move: ProductMovement

        private var diff: Int {
            if let after = move.stock_after, let before = move.stock_before {
                return after - before
            }
            return move.quantity
        }

        private var isDecrease: Bool { diff < 0 }

        private func formattedDate() -> String {
            if let date = move.date, let time = move.time { return "\(date) \(time)" }
            if let created = move.created_at { return created }
            return ""
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(formattedDate())
                    .font(.footnote)
                    .foregroundColor(.gray)

                HStack {
                    Text(move.type.localized)
                        .font(.body.bold())
                        .foregroundColor(isDecrease ? .red : .green)
                    Spacer()
                    Text("\(diff > 0 ? "+" : "")\(move.quantity)")
                        .font(.body.bold())
                }

                HStack {
                    Text("\("before".localized): \(move.stock_before.map(String.init) ?? "no_information".localized)")
                    Spacer()
                    Text("\("after".localized): \(move.stock_after.map(String.init) ?? "no_information".localized)")
                }
                .font(.footnote)

                if let comment = move.comment, !comment.isEmpty {
                    Text(comment)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                if let user = move.user {
                    Text(user)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.secondaryColor)
            .cornerRadius(12)
            .shadow(radius: 1)
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: ProductModel(id: "1", name: "Apple", image_url: "", stock_actual: 0, category: "Alimentos", sensor_type: "temperature"))
            .environmentObject(LocalizationManager())
    }
}

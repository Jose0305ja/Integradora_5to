import Foundation

class InventoryHomeViewModel: ObservableObject {
    @Published var summary: InventoryHomeResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var limit = 5

    func fetchInitial() {
        fetchSummary(limit: limit)
    }

    func loadMore() {
        limit += 5
        fetchSummary(limit: limit)
    }

    private func fetchSummary(limit: Int) {
        isLoading = true
        InventoryService.shared.fetchHomeSummary(limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.summary = data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

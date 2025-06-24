import Foundation

class HomeSummaryViewModel: ObservableObject {
    @Published var summary: InventoryHomeResponse?
    @Published var isLoading = false

    func fetchSummary(limit: Int = 5) {
        guard !isLoading else { return }
        isLoading = true
        InventoryService.shared.fetchHomeSummary(limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.summary = response
                case .failure(let error):
                    print("Failed to fetch home summary", error)
                }
            }
        }
    }
}


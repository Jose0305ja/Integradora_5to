import Foundation

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1
    private let limit = 20
    private var isLoading = false

    func fetch(page: Int = 1) {
        guard !isLoading else { return }
        isLoading = true
        MonitoringService.shared.fetchNotifications(limit: limit, page: page) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.notifications = response.notifications
                    self.currentPage = response.pagination.current_page
                    self.totalPages = response.pagination.total_pages
                case .failure(let error):
                    print("❌ Error fetching notifications:", error.localizedDescription)
                    self.notifications = []
                }
            }
        }
    }

    func loadNext() {
        guard currentPage < totalPages else { return }
        fetch(page: currentPage + 1)
    }

    func loadPrev() {
        guard currentPage > 1 else { return }
        fetch(page: currentPage - 1)
    }
}

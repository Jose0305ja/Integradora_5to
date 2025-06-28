import Foundation

class MonitoringHomeViewModel: ObservableObject {
    @Published var temperature: Double = 0
    @Published var humidity: Double = 0
    @Published var notifications: [NotificationModel] = []
    @Published var errorMessage: String? = nil

    func fetch() {
        MonitoringService.shared.fetchHome { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    print("🏠 Home data received:", response)
                    self.temperature = response.temperature
                    self.humidity = response.humidity
                    self.errorMessage = nil

                case .failure(let error):
                    print("❌ Error loading home data:", error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                }
            }
        }

        MonitoringService.shared.fetchNotifications(limit: 3, page: 1) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    self.notifications = response.notifications
                case .failure(let error):
                    print("❌ Error fetching notifications:", error.localizedDescription)
                    self.notifications = []
                }
            }
        }
    }

    var hasNotifications: Bool {
        !notifications.isEmpty
    }
}

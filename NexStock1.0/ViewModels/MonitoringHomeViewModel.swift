import Foundation

class MonitoringHomeViewModel: ObservableObject {
    @Published var temperature: Double = 0
    @Published var humidity: Double = 0
    @Published var notifications: [MonitoringNotification] = []
    @Published var errorMessage: String? = nil

    func fetch() {
        MonitoringService.shared.fetchHome { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.temperature = response.temperature
                    self.humidity = response.humidity
                    self.notifications = response.unread_notifications
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.notifications = []
                }
            }
        }
    }
}

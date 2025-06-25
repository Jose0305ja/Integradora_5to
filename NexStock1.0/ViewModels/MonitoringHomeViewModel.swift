import Foundation

class MonitoringHomeViewModel: ObservableObject {
    @Published var temperature: Double = 0
    @Published var humidity: Double = 0
    @Published var notifications: [MonitoringNotification] = []
    @Published var errorMessage: String?

    func fetch() {
        MonitoringService.shared.fetchHome { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.temperature = data.temperature
                    self?.humidity = data.humidity
                    self?.notifications = data.unread_notifications
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

import Foundation

class AlertViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []

    func fetchAll() {
        MonitoringService.shared.fetchNotifications(limit: 100) { [weak self] result in
            DispatchQueue.main.async {
                self?.notifications = result
            }
        }
    }
}

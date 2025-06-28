import Foundation

class SensorsStatusViewModel: ObservableObject {
    @Published var sensors: [SensorStatus] = []
    @Published var errorMessage: String? = nil

    func fetch() {
        MonitoringService.shared.fetchSensorsStatus { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sensors):
                    self?.sensors = sensors
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.sensors = []
                }
            }
        }
    }
}

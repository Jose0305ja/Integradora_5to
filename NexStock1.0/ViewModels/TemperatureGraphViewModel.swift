import Foundation

class TemperatureGraphViewModel: ObservableObject {
    @Published var selectedFilter: String = "last_5min" {
        didSet { fetch() }
    }
    @Published var points: [MonitoringPoint] = []
    @Published var current: Double = 0
    @Published var average: Double = 0
    @Published var min: Double = 0
    @Published var max: Double = 0
    @Published var errorMessage: String?

    let filters = ["last_5min", "24h", "last_week", "last_month", "last_3months"]

    init() { fetch() }

    func fetch() {
        MonitoringService.shared.fetchTemperatureGraph(filter: selectedFilter) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.points = data.points
                    self?.current = data.current
                    self?.average = data.average
                    self?.min = data.min
                    self?.max = data.max
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    var chartValues: [Double] { points.map { $0.value } }

    var xAxisLabels: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return points.map { formatter.string(from: $0.time) }
    }
}

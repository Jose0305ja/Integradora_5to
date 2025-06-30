//
//  HumidityViewModel.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//

import Foundation

class HumidityViewModel: ObservableObject {
    @Published var selectedTimeRange: TimeRange = .day
    @Published var humidityData: [MonitoringPoint] = []
    @Published var current: Double = 0
    @Published var average: Double = 0
    @Published var min: Double = 0
    @Published var max: Double = 0
    @Published var errorMessage: String? = nil

    let timeRanges = TimeRange.allCases

    init() {
        fetch(for: selectedTimeRange)
    }

    func fetch(for range: TimeRange) {
        MonitoringService.shared.fetchHumidity(filter: range.rawValue) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    print("✅ Humidity data received: \(response)")
                    print("💧 Data points: \(response.humidity)")

                    self.humidityData = response.humidity
                    self.current = response.current
                    self.average = response.average
                    self.min = response.min
                    self.max = response.max
                    self.errorMessage = nil

                case .failure(let error):
                    print("❌ Error loading humidity:", error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    self.humidityData = []
                }
            }
        }
    }

    // Datos para el gráfico
    var chartValues: [Double] {
        humidityData.map { $0.value }
    }

    var xAxisLabels: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha" // Ej: 1PM, 2PM
        return humidityData.map { formatter.string(from: $0.time) }
    }

    // Data for the Swift Charts based view
    var sensorPoints: [SensorDataPoint] {
        humidityData.map { SensorDataPoint(timestamp: $0.time, value: $0.value) }
    }

    var chartMode: ChartRangeMode {
        switch selectedTimeRange {
        case .last5min: return .last5min
        case .week: return .week
        case .month: return .month
        case .months3: return .months3
        default: return .day
        }
    }

    var optimalMax: Double {
        70.0
    }
}

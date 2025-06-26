//
//  TemperatureViewModel.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//

import Foundation

class TemperatureViewModel: ObservableObject {
    @Published var selectedTimeRange: String = "24h"
    @Published var temperatureData: [MonitoringPoint] = []
    @Published var current: Double = 0
    @Published var average: Double = 0
    @Published var min: Double = 0
    @Published var max: Double = 0
    @Published var errorMessage: String? = nil

    let timeRanges = ["24h", "last_5min", "last_week", "last_month", "last_3months"]

    init() {
        fetch(for: selectedTimeRange)
    }

    func fetch(for filter: String) {
        MonitoringService.shared.fetchTemperature(filter: filter) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    print("🌡️ Temperature data received:", response)
                    self.temperatureData = response.temperature
                    self.current = response.current
                    self.average = response.average
                    self.min = response.min
                    self.max = response.max
                    self.errorMessage = nil

                case .failure(let error):
                    print("❌ Error loading temperature:", error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    self.temperatureData = []
                }
            }
        }
    }

    var chartValues: [Double] {
        temperatureData.map { $0.value }
    }

    var xAxisLabels: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha" // 1PM, 2PM
        return temperatureData.map { formatter.string(from: $0.time) }
    }

    var optimalMax: Double {
        27.0
    }
}

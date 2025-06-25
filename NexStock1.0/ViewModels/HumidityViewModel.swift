//
//  HumidityViewModel.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//

import Foundation

class HumidityViewModel: ObservableObject {
    @Published var selectedTimeRange: String = "24h"
    @Published var humidityData: [MonitoringPoint] = []
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
        MonitoringService.shared.fetchHumidity(filter: filter) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.humidityData = response.humidity
                    self.current = response.current
                    self.average = response.average
                    self.min = response.min
                    self.max = response.max
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.humidityData = []
                }
            }
        }
    }

    var chartValues: [Double] {
        humidityData.map { $0.value }
    }

    var xAxisLabels: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return humidityData.map { formatter.string(from: $0.time) }
    }

    var optimalMax: Double {
        70.0
    }
}

//
//  TemperatureViewModel.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//

import Foundation

class TemperatureViewModel: ObservableObject {
    @Published var selectedTimeRange: String = "Ahora"
    @Published var temperatureData: [MonitoringPoint] = []
    @Published var current: Double = 0
    @Published var average: Double = 0
    @Published var min: Double = 0
    @Published var max: Double = 0

    let timeRanges = ["Ahora", "24h", "last_week", "last_month", "last_3months"]

    init() {
        simulateFetch(for: selectedTimeRange)
    }

    func simulateFetch(for filter: String) {
        let now = Date()
        let calendar = Calendar.current

        temperatureData = (0..<7).map { i in
            let time = calendar.date(byAdding: .hour, value: i * 2, to: now)!
            let value = Double.random(in: 23.0...28.0)
            return MonitoringPoint(time: time, value: value)
        }

        let values = temperatureData.map { $0.value }
        current = values.last ?? 0
        average = values.reduce(0, +) / Double(values.count)
        min = values.min() ?? 0
        max = values.max() ?? 0
    }

    var chartValues: [Double] {
        temperatureData.map { $0.value }
    }

    var xAxisLabels: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return temperatureData.map { formatter.string(from: $0.time) }
    }

    var optimalMax: Double {
        27.0
    }
}

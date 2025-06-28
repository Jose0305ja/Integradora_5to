import SwiftUI

/// Chart view that adapts axis labels and ranges depending on the selected range
/// and the type of sensor displayed.
struct SensorChartView: View {
    let data: [SensorDataPoint]
    let mode: ChartRangeMode
    let type: SensorType

    var body: some View {
        VStack(spacing: 16) {
            Chart {
                ForEach(data) { point in
                    LineMark(
                        x: .value("Tiempo", point.timestamp),
                        y: .value("Valor", point.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(type == .temperature ? .red : .blue)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: axisLabelCount)) { value in
                    AxisValueLabel() {
                        if let date = value.as(Date.self) {
                            Text(axisLabelFormatter.string(from: date))
                                .font(.caption2)
                                .rotationEffect(.degrees(-45))
                        }
                    }
                }
            }
            .chartYScale(domain: yAxisRange)
            .frame(height: 200)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.secondaryColor)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Helpers

    var axisLabelCount: Int {
        switch mode {
        case .last5min: return 8
        case .day: return 12
        case .week: return 7
        case .month: return 10
        case .months3: return 9
        }
    }

    var axisLabelFormatter: DateFormatter {
        let formatter = DateFormatter()
        switch mode {
        case .last5min: formatter.dateFormat = "HH:mm:ss"
        case .day: formatter.dateFormat = "HH:mm"
        case .week: formatter.dateFormat = "E ha"
        case .month: formatter.dateFormat = "d MMM"
        case .months3: formatter.dateFormat = "MMM"
        }
        return formatter
    }

    var yAxisRange: ClosedRange<Double> {
        let values = data.map(\.value)
        guard let min = values.min(), let max = values.max() else {
            return 0...1
        }
        let padding = (max - min) * 0.1
        return (min - padding)...(max + padding)
    }
}

enum ChartRangeMode {
    case last5min, day, week, month, months3
}

enum SensorType {
    case temperature, humidity
}

struct SensorDataPoint: Identifiable {
    let id = UUID()
    let timestamp: Date
    let value: Double
}


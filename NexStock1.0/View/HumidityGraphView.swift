import SwiftUI

struct HumidityGraphView: View {
    @StateObject private var viewModel = HumidityViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $viewModel.selectedTimeRange) {
                ForEach(viewModel.timeRanges, id: \.self) { range in
                    Text(range).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: viewModel.selectedTimeRange) { newValue in
                viewModel.fetch(for: newValue)
            }

            SectionContainer(title: "") {
                if viewModel.humidityData.isEmpty {
                    Text("Sin datos")
                        .foregroundColor(.tertiaryColor)
                        .frame(maxWidth: .infinity)
                } else {
                    LineChartView(data: viewModel.chartValues, labels: viewModel.xAxisLabels)
                }
            }

            SectionContainer(title: "") {
                if viewModel.humidityData.isEmpty {
                    Text("Sin datos")
                        .foregroundColor(.tertiaryColor)
                        .frame(maxWidth: .infinity)
                } else {
                    HStack {
                        infoBox(title: "current_humidity".localized, value: "\(String(format: "%.1f", viewModel.current))%", color: .blue)
                        infoBox(title: "average".localized, value: "\(String(format: "%.1f", viewModel.average))%")
                        infoBox(title: "minimum".localized, value: "\(String(format: "%.1f", viewModel.min))%")
                        infoBox(title: "maximum".localized, value: "\(String(format: "%.1f", viewModel.max))%")
                    }
                }
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .onAppear {
            if viewModel.humidityData.isEmpty {
                viewModel.fetch(for: viewModel.selectedTimeRange)
            }
        }
    }

    private func infoBox(title: String, value: String, color: Color = .tertiaryColor) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.tertiaryColor)
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.secondaryColor)
        .cornerRadius(10)
    }
}

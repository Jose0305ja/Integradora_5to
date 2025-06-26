import SwiftUI

struct HumidityGraphView: View {
    @StateObject private var viewModel = HumidityViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        VStack(spacing: 16) {
            Picker("Rango", selection: $viewModel.selectedTimeRange) {
                ForEach(viewModel.timeRanges, id: \.self) { range in
                    Text(range).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            SectionContainer(title: "") {
                if viewModel.humidityData.isEmpty {
                    Text("Sin datos")
                        .foregroundColor(.tertiaryColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    LineChartView(data: viewModel.chartValues, labels: viewModel.xAxisLabels)
                }
            }

            SectionContainer(title: "") {
                HStack {
                    infoBox(title: "current_humidity".localized, value: "\(Int(viewModel.current))%", color: .blue)
                    infoBox(title: "average".localized, value: "\(Int(viewModel.average))%")
                    infoBox(title: "minimum".localized, value: "\(Int(viewModel.min))%")
                    infoBox(title: "maximum".localized, value: "\(Int(viewModel.max))%")
                }
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .onChange(of: viewModel.selectedTimeRange) { range in
            viewModel.fetch(for: range)
        }
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

import SwiftUI

struct TemperatureGraphView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = TemperatureGraphViewModel()
    @State private var showMenu = false
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()

            VStack(spacing: 16) {
                HeaderView(showMenu: $showMenu, path: $path)

                ScrollView {
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.filters, id: \..self) { filter in
                                Button(action: { viewModel.selectedFilter = filter }) {
                                    Text(filter)
                                        .font(.subheadline)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 6)
                                        .background(viewModel.selectedFilter == filter ? Color.secondaryColor : Color.secondaryColor.opacity(0.3))
                                        .cornerRadius(8)
                                        .foregroundColor(.tertiaryColor)
                                }
                            }
                        }

                        SectionContainer(title: "") {
                            LineChartView(
                                data: viewModel.chartValues,
                                labels: viewModel.xAxisLabels
                            )
                        }

                        SectionContainer(title: "") {
                            HStack {
                                infoBox(title: "current_temperature".localized, value: String(format: "%.1f°C", viewModel.current))
                                infoBox(title: "average".localized, value: String(format: "%.1f°C", viewModel.average))
                                infoBox(title: "minimum".localized, value: String(format: "%.1f°C", viewModel.min))
                                infoBox(title: "maximum".localized, value: String(format: "%.1f°C", viewModel.max))
                            }
                        }
                    }
                    .padding()
                }
            }

            if showMenu {
                SideMenuView(isOpen: $showMenu, path: $path)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: showMenu)
        .navigationBarBackButtonHidden(true)
    }

    private func infoBox(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.tertiaryColor)
            Text(value)
                .font(.headline)
                .foregroundColor(.tertiaryColor)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.secondaryColor)
        .cornerRadius(10)
    }
}

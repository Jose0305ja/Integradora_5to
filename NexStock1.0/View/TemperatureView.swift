//
//  TemperatureView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//

import SwiftUI

struct TemperatureView: View {
    @Binding var path: NavigationPath
    @State private var showMenu = false
    @StateObject private var viewModel = TemperatureViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()

            VStack(spacing: 16) {
                HeaderView(showMenu: $showMenu, path: $path)

                ScrollView {
                    VStack(spacing: 16) {
                        // Selector de tiempo
                        SectionContainer(title: "time_range".localized) {
                            TimeRangeDropdown(selection: $viewModel.selectedTimeRange,
                                             ranges: viewModel.timeRanges) { newValue in
                                viewModel.fetch(for: newValue)
                            }
                        }

                        Text("temperature".localized)
                            .font(.title3.bold())
                            .padding(.bottom, 4)

                        // Gráfica
                        SectionContainer(title: "") {
                            if viewModel.temperatureData.isEmpty {
                                Text("no_data".localized)
                                    .foregroundColor(.tertiaryColor)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                SensorChartView(
                                    data: viewModel.sensorPoints,
                                    mode: viewModel.chartMode,
                                    type: .temperature
                                )
                            }
                        }

                        // Valores clave
                        SectionContainer(title: "") {
                            if viewModel.temperatureData.isEmpty {
                                Text("no_data".localized)
                                    .foregroundColor(.tertiaryColor)
                                    .frame(maxWidth: .infinity)
                            } else {
                                HStack {
                                    SensorStatView(label: "current_temperature".localized,
                                                   value: "\(String(format: "%.1f", viewModel.current))°C",
                                                   highlight: true)
                                    SensorStatView(label: "average".localized,
                                                   value: "\(String(format: "%.1f", viewModel.average))°C")
                                    SensorStatView(label: "minimum".localized,
                                                   value: "\(String(format: "%.1f", viewModel.min))°C")
                                    SensorStatView(label: "maximum".localized,
                                                   value: "\(String(format: "%.1f", viewModel.max))°C")
                                }
                            }
                        }

                        // Alerta visual
                        if viewModel.current > viewModel.optimalMax {
                            Text("temperature_alert".localized)
                                .font(.callout)
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(10)
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
        .task { viewModel.fetch(for: viewModel.selectedTimeRange) }
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("error".localized), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("ok".localized)) {
                viewModel.errorMessage = nil
            })
        }
    }

}

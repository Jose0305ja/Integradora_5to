//
//  HumidityView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//

import SwiftUI

struct HumidityView: View {
    @Binding var path: NavigationPath
    @State private var showMenu = false
    @StateObject private var viewModel = HumidityViewModel()
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
                            Picker("time_range".localized, selection: $viewModel.selectedTimeRange) {
                                ForEach(viewModel.timeRanges, id: \.self) { range in
                                    Text(range.labelKey.localized).tag(range)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: viewModel.selectedTimeRange) { newValue in
                                viewModel.fetch(for: newValue)
                            }
                        }

                        // Gráfica
                        SectionContainer(title: "") {
                            if viewModel.humidityData.isEmpty {
                                Text("no_data".localized)
                                    .foregroundColor(.tertiaryColor)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                SensorChartView(
                                    data: viewModel.sensorPoints,
                                    mode: viewModel.chartMode,
                                    type: .humidity
                                )
                            }
                        }

                        // Valores
                        SectionContainer(title: "") {
                            if viewModel.humidityData.isEmpty {
                                Text("no_data".localized)
                                    .foregroundColor(.tertiaryColor)
                                    .frame(maxWidth: .infinity)
                            } else {
                                HStack {
                                    infoBox(title: "current_humidity".localized, value: "\(viewModel.current)%", color: .blue)
                                    infoBox(title: "average".localized, value: "\(viewModel.average)%")
                                    infoBox(title: "minimum".localized, value: "\(viewModel.min)%")
                                    infoBox(title: "maximum".localized, value: "\(viewModel.max)%")
                                }
                            }
                        }

                        if viewModel.current > viewModel.optimalMax {
                            Text("humidity_alert".localized)
                                .font(.callout)
                                .foregroundColor(.orange)
                                .padding()
                                .background(Color.orange.opacity(0.1))
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

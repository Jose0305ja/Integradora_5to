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
                        HStack(spacing: 12) {
                            ForEach(viewModel.timeRanges, id: \.self) { range in
                                Button(action: {
                                    viewModel.selectedTimeRange = range
                                }) {
                                    Text(range)
                                        .font(.subheadline)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 6)
                                        .background(viewModel.selectedTimeRange == range ? Color.secondaryColor : Color.secondaryColor.opacity(0.3))
                                        .cornerRadius(8)
                                        .foregroundColor(.tertiaryColor)
                                }
                            }
                        }

                        // Gráfica
                        SectionContainer(title: "") {
                            LineChartView(
                                data: viewModel.chartValues,
                                labels: viewModel.xAxisLabels
                            )
                        }

                        // Valores clave
                        SectionContainer(title: "") {
                            HStack {
                                infoBox(title: "average".localized, value: "\(String(format: "%.1f", viewModel.current))°C", color: .red)
                                infoBox(title: "current_temperature".localized, value: "\(String(format: "%.1f", viewModel.average))°C")
                                infoBox(title: "minimum".localized, value: "\(String(format: "%.1f", viewModel.min))°C")
                                infoBox(title: "maximum".localized, value: "\(String(format: "%.1f", viewModel.max))°C")
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

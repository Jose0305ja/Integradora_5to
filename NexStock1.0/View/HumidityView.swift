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
                        HStack(spacing: 12) {
                            ForEach(viewModel.timeRanges, id: \.self) { range in
                                Button(action: {
                                    viewModel.selectedTimeRange = range
                                    viewModel.fetch(for: range)
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
                            if viewModel.humidityData.isEmpty {
                                Text("Sin datos")
                                    .foregroundColor(.tertiaryColor)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                LineChartView(
                                    data: viewModel.chartValues,
                                    labels: viewModel.xAxisLabels
                                )
                            }
                        }

                        // Valores
                        SectionContainer(title: "") {
                            if viewModel.humidityData.isEmpty {
                                Text("Sin datos")
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
                            Text("⚠️ Alerta: Humedad superior al rango óptimo")
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
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")) {
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

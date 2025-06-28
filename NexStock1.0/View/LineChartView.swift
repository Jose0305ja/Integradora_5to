//
//  LineChartView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//

import SwiftUI

struct LineChartView: View {
    let data: [Double]
    let labels: [String] // Ej: ["8AM", "10AM", "12PM", ...]
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let maxY = data.max() ?? 1
                let minY = data.min() ?? 0
                let range = max(maxY - minY, 1)
                let chartHeight = geometry.size.height
                let scaleY = chartHeight / CGFloat(range)
                let stepX = (geometry.size.width - 30) / CGFloat(data.count - 1)

                HStack(spacing: 4) {
                    // Eje Y (valores a la izquierda)
                    VStack {
                        ForEach((0..<5).reversed(), id: \.self) { i in
                            Spacer()
                            let value = minY + (Double(i) * range / 4)
                            Text(String(format: "%.0f", value))
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .frame(height: chartHeight / 5, alignment: .top)
                        }
                    }

                    // Gráfica + líneas horizontales
                    ZStack {
                        // Líneas de fondo
                        ForEach(0..<5) { i in
                            let y = CGFloat(i) * chartHeight / 4
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: geometry.size.width - 30, y: y))
                            }
                            .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [4]))
                        }

                        // Línea de datos
                        Path { path in
                            guard data.count > 1 else { return }
                            let firstY = chartHeight - CGFloat(data[0] - minY) * scaleY
                            path.move(to: CGPoint(x: 0, y: firstY))

                            for index in 1..<data.count {
                                let x = CGFloat(index) * stepX
                                let y = chartHeight - CGFloat(data[index] - minY) * scaleY
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                        .stroke(Color.accentColor, lineWidth: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 200)

            // Eje X (etiquetas debajo)
            HStack {
                Spacer().frame(width: 32) // espacio para el eje Y
                let stride = max(labels.count / 6, 1)
                ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                    if index % stride == 0 {
                        Text(label)
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .rotationEffect(.degrees(-45))
                            .frame(maxWidth: .infinity)
                    } else {
                        Spacer().frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 4)
            .frame(height: 20)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.secondaryColor)
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}

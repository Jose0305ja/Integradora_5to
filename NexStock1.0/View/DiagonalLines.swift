//
//  DiagonalLines.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 20/06/25.
//

import SwiftUI

struct DiagonalLines: View {
    var colorScheme: ColorScheme

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let diag = sqrt(width * width + height * height)
            let baseColor = colorScheme == .dark ? Color.gray.opacity(0.4) : Color.gray

            ZStack {
                // Top-left corner
                DiagonalLine(opacity: 1.0, color: baseColor)
                    .frame(width: diag, height: 30)
                    .offset(x: -width / 2, y: -height / 2)

                // Top-right corner
                DiagonalLine(opacity: 0.7, color: baseColor)
                    .frame(width: diag, height: 30)
                    .offset(x: width / 2, y: -height / 2)

                // Bottom-left corner
                DiagonalLine(opacity: 1.0, color: baseColor)
                    .frame(width: diag, height: 30)
                    .offset(x: -width / 2, y: height / 2)

                // Bottom-right corner
                DiagonalLine(opacity: 0.7, color: baseColor)
                    .frame(width: diag, height: 30)
                    .offset(x: width / 2, y: height / 2)
            }
        }
        .allowsHitTesting(false) // para que no interfiera con toques
    }
}

struct DiagonalLine: View {
    var opacity: Double = 1.0
    var color: Color = Color.gray

    var body: some View {
        Rectangle()
            .fill(color.opacity(opacity))
            .rotationEffect(.degrees(45))
            .shadow(color: color.opacity(0.3), radius: 6, x: 4, y: 4)
    }
}

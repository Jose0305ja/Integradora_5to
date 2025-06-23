//
//  HeaderView 2.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 11/06/25.
//


import SwiftUI

struct HeaderModeView: View {
    var title: String
    var showRedDot: Bool = false
    var onBack: (() -> Void)? = nil
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        HStack {
            // 🔙 Botón de regreso
            Button(action: {
                onBack?()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.tertiaryColor)
            }

            Spacer()

            Text(title)
                .font(.headline)
                .foregroundColor(.tertiaryColor)

            Spacer()

            if showRedDot {
                Circle()
                    .fill(Color.red)
                    .frame(width: 16, height: 16)
            } else {
                Spacer().frame(width: 24)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 4)
        .background(Color.primaryColor)
    }
}

//
//  AlertSectionView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 07/06/25.
//


import SwiftUI

struct AlertSectionView: View {
    let alerts: [AlertModel]
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("alerts".localized)
                .font(.headline)
                .foregroundColor(.primary)

            ForEach(alerts) { alert in
                VStack(spacing: 8) {
                    Image(systemName: alert.icon)
                        .foregroundColor(.yellow)
                        .font(.title2)

                    Text(alert.message)
                        .font(.subheadline)
                        .foregroundColor(.fourthColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .minimumScaleFactor(0.8)

                    Text(alert.time)
                        .font(.caption2)
                        .foregroundColor(.fourthColor)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.tertiaryColor)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
}

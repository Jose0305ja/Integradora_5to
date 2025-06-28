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
                AlertCardView(alert: alert)
            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
}

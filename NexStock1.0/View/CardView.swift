//
//  CardView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 07/06/25.
//

import SwiftUI

struct CardView: View {
    let model: CardModel
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(spacing: 12) {
            Text(model.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.tertiaryColor)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            Text(model.subtitle)
                .font(.headline)
                .foregroundColor(.tertiaryColor.opacity(0.6))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        
        .frame(width: 160, height: 160)
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
        .background(Color.secondaryColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.tertiaryColor.opacity(0.2), lineWidth: 1)
        )
        .shadow(radius: 3)
    }
}

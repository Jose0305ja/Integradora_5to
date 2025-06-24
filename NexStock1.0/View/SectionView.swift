//
//  SectionView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 07/06/25.
//


import SwiftUI

struct SectionView: View {
    let title: String
    let cards: [CardModel]
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            // 🔹 Título centrado y más grande
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)

            // 🔄 Tarjetas centradas si solo hay una, scroll si hay varias
            if cards.count == 1 {
                HStack {
                    Spacer()
                    CardView(model: cards[0])
                    Spacer()
                }
                .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(cards) { card in
                            CardView(model: card)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

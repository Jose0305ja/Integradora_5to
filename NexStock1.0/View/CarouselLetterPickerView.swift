//
//  CarouselLetterPickerView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 14/06/25.
//

import SwiftUI

struct CarouselLetterPickerView: View {
    let letters: [String]
    let proxy: ScrollViewProxy
    let category: String

    @Binding var selectedLetter: String
    @State private var lastCenteredLetter: String?
    @State private var debounceTimer: Timer?
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        GeometryReader { outerGeo in
            let itemWidth: CGFloat = 50
            let screenCenter = outerGeo.frame(in: .global).midX

            ScrollViewReader { scrollReader in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(letters, id: \.self) { letter in
                            GeometryReader { geo in
                                let centerX = geo.frame(in: .global).midX
                                let distance = abs(centerX - screenCenter)
                                let scale = max(1.0 - distance / 200, 0.75)
                                let isCentered = distance < 25

                                Color.clear
                                    .frame(width: itemWidth, height: 40)
                                    .onChange(of: distance) { _ in
                                        if isCentered {
                                            debounceScrollTo(letter: letter)
                                        }
                                    }
                                    .overlay(
                                        Text(letter)
                                            .font(.system(size: 20 + scale * 10, weight: scale > 0.8 ? .bold : .regular))
                                            .foregroundColor(letter == selectedLetter ? .primary : .gray)
                                            .frame(width: itemWidth, height: 40)
                                            .scaleEffect(scale)
                                            .id(letter)
                                    )
                            }
                            .frame(width: itemWidth)
                        }
                    }
                    .padding(.horizontal, (outerGeo.size.width - itemWidth) / 2)
                }
                .onChange(of: selectedLetter) { newLetter in
                    withAnimation(.easeOut(duration: 0.15)) {
                        scrollReader.scrollTo(newLetter, anchor: .center)
                    }
                }
            }
        }
        .frame(height: 60)
    }

    private func debounceScrollTo(letter: String) {
        guard lastCenteredLetter != letter else { return }

        // Detener el timer anterior
        debounceTimer?.invalidate()

        // Iniciar uno nuevo (delay breve para no saturar)
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            lastCenteredLetter = letter
            selectedLetter = letter

            withAnimation(.easeOut(duration: 0.15)) {
                proxy.scrollTo("\(letter)_\(category)", anchor: .top)
            }
        }
    }
}

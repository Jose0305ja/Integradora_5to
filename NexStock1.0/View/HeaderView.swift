//
//  HeaderView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 07/06/25.
//

import SwiftUI

struct HeaderView: View {
    @Binding var showMenu: Bool
    @Binding var path: NavigationPath
    @State private var showUsername = true
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var authService: AuthService

    var body: some View {
        HStack {
            // Botón de menú hamburguesa
            Button(action: {
                withAnimation {
                    showMenu.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(iconFont)
                    .foregroundColor(.fourthColor)
            }

            Spacer()

            // Título dinámico
            ZStack {
                if showUsername {
                    VStack(spacing: 2) {
                        Text("welcome".localized)
                            .font(.caption)
                            .foregroundColor(.fourthColor)
                        Text("Jose Rodriguez")
                            .font(.caption2)
                            .foregroundColor(.fourthColor)
                    }
                    .transition(.opacity)
                } else {
                    Text("NexStock")
                        .font(.headline)
                        .foregroundColor(.fourthColor)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showUsername)

            Spacer()

            // Menú con logo dinámico
            Menu {
                Button("logout".localized) {
                    authService.logout()
                    path.removeLast(path.count)
                }
            } label: {
                if let urlString = authService.logoURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        if let img = phase.image {
                            img.resizable()
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: iconSize, height: iconSize)
                    .clipShape(Circle())
                    .shadow(radius: 1)
                } else {
                    Circle()
                        .fill(Color.red)
                        .frame(width: iconSize, height: iconSize)
                        .shadow(radius: 1)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 6)
        .background(Color.secondaryColor)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    showUsername = false
                }
            }
        }
    }

    // Escalado del tamaño del icono según accesibilidad
    private var iconSize: CGFloat {
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge: return 40
        case .accessibilityExtraExtraLarge: return 36
        case .accessibilityExtraLarge: return 32
        case .accessibilityLarge: return 28
        default: return 24
        }
    }

    private var iconFont: Font {
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge: return .title
        case .accessibilityExtraExtraLarge: return .title2
        case .accessibilityExtraLarge: return .title3
        case .accessibilityLarge: return .headline
        default: return .body
        }
    }
}

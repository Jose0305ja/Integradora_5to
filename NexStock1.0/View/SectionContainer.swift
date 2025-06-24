//
//  SectionContainer.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 11/06/25.
//


import SwiftUI

// 🔹 Contenedor general para secciones como Cuenta, Preferencias, etc.
struct SectionContainer<Content: View>: View {
    let title: String
    let content: Content
    @EnvironmentObject var theme: ThemeManager

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !title.trimmingCharacters(in: .whitespaces).isEmpty {
                Text(title.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.tertiaryColor)
                    .padding(.horizontal, 8)
                    .padding(.top, 4)
                    .multilineTextAlignment(.leading)
            }

            VStack(spacing: 10) {
                content
            }
            .padding()
            .background(Color.secondaryColor)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.tertiaryColor.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

// 🔹 Fila para datos de usuario u opciones simples
struct SettingRow: View {
    var icon: String
    var title: String
    var subtitle: String? = nil
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.tertiaryColor)
                    .font(.body)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.tertiaryColor)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.tertiaryColor.opacity(0.7))
                            .lineLimit(nil)
                    }
                }

                Spacer()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(title + (subtitle != nil ? ": \(subtitle!)" : "")))
    }
}

// 🔹 Fila con interruptor Toggle
struct ToggleRow: View {
    var icon: String
    var title: String
    @Binding var isOn: Bool
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.tertiaryColor)
                    .font(.body)

                Text(title)
                    .font(.body)
                    .foregroundColor(.tertiaryColor)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)

                Spacer()

                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .accessibilityLabel(Text(title))
            }
        }
        .accessibilityElement(children: .combine)
    }
}
// 🔹 Tile tipo botón con ícono y texto
struct SettingsTile: View {
    var iconName: String
    var title: String
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.tertiaryColor)

            Text(title)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.tertiaryColor)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity) // más alto para texto largo
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
        .background(Color.secondaryColor)
        .cornerRadius(15)
        .shadow(color: Color.tertiaryColor.opacity(0.05), radius: 5, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(title))
        .accessibilityHint("Presiona para acceder a \(title.lowercased())")
    }
}

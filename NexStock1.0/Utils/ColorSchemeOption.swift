//
//  ColorSchemeOption.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 08/06/25.
//


enum ColorSchemeOption: String, CaseIterable, Identifiable {
    case light = "Claro"
    case dark = "Oscuro"
    case system = "Automático"

    var id: String { rawValue }
}
//
//  Color+Theme.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 02/06/25.
//


import SwiftUI

extension Color {
    static var primaryColor: Color { ThemeManager.shared.primaryColor }
    static let backColor = Color("appBackColor")
    static var secondaryColor: Color { ThemeManager.shared.secondaryColor }
    static var tertiaryColor: Color { ThemeManager.shared.tertiaryColor }
    static let fourthColor = Color("appFourthColor")
}

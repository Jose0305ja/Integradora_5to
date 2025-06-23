import SwiftUI

struct ColorPalette: Identifiable {
    let id = UUID()
    let name: String
    let primary: Color
    let secondary: Color
    let tertiary: Color

    static let predefined: [ColorPalette] = [
        ColorPalette(name: "Midnight Blue",
                     primary: Color(hex: "#1E3A5F")!,
                     secondary: Color(hex: "#274B74")!,
                     tertiary: Color(hex: "#F0F4FA")!),

        ColorPalette(name: "Ash Plum",
                     primary: Color(hex: "#4B3B47")!,
                     secondary: Color(hex: "#7D5A6E")!,
                     tertiary: Color(hex: "#F5F1F3")!),

        ColorPalette(name: "Graphite",
                     primary: Color(hex: "#2F2F2F")!,
                     secondary: Color(hex: "#4E4E4E")!,
                     tertiary: Color(hex: "#FFFFFF")!),

        ColorPalette(name: "Olive Night",
                     primary: Color(hex: "#3B3A26")!,
                     secondary: Color(hex: "#6B6A4E")!,
                     tertiary: Color(hex: "#F4F4E1")!),

        ColorPalette(name: "Rust Clay",
                     primary: Color(hex: "#6A3E3E")!,
                     secondary: Color(hex: "#A05252")!,
                     tertiary: Color(hex: "#FDEEEE")!),

        ColorPalette(name: "Indigo Gray",
                     primary: Color(hex: "#373F51")!,
                     secondary: Color(hex: "#58616E")!,
                     tertiary: Color(hex: "#ECEFF4")!),

        ColorPalette(name: "Teal Mist",
                     primary: Color(hex: "#1C4E4E")!,
                     secondary: Color(hex: "#3F8E8E")!,
                     tertiary: Color(hex: "#E9F7F7")!),

        ColorPalette(name: "Cocoa Cream",
                     primary: Color(hex: "#5C3D2E")!,
                     secondary: Color(hex: "#937D64")!,
                     tertiary: Color(hex: "#FDF8F2")!),

        ColorPalette(name: "Deep Violet",
                     primary: Color(hex: "#4A285A")!,
                     secondary: Color(hex: "#7C4D8F")!,
                     tertiary: Color(hex: "#FAF3FB")!),

        ColorPalette(name: "Slate Ocean",
                     primary: Color(hex: "#2B2D42")!,
                     secondary: Color(hex: "#4F5D75")!,
                     tertiary: Color(hex: "#F8F9FA")!),

        ColorPalette(name: "Mocha Frost",
                     primary: Color(hex: "#503C3C")!,
                     secondary: Color(hex: "#8D6E63")!,
                     tertiary: Color(hex: "#F4EDEB")!),

        ColorPalette(name: "Sage Smoke",
                     primary: Color(hex: "#3E4939")!,
                     secondary: Color(hex: "#7B8C69")!,
                     tertiary: Color(hex: "#F5F9F1")!),

        ColorPalette(name: "Storm Gray",
                     primary: Color(hex: "#37474F")!,
                     secondary: Color(hex: "#607D8B")!,
                     tertiary: Color(hex: "#ECEFF1")!),

        ColorPalette(name: "Royal Ash",
                     primary: Color(hex: "#2C3E50")!,
                     secondary: Color(hex: "#34495E")!,
                     tertiary: Color(hex: "#ECF0F1")!),

        ColorPalette(name: "Burgundy Gold",
                     primary: Color(hex: "#581845")!,
                     secondary: Color(hex: "#900C3F")!,
                     tertiary: Color(hex: "#FCE4EC")!)
    ]
}

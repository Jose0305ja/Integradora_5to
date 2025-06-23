import SwiftUI

struct ColorPalette: Identifiable {
    let id = UUID()
    let name: String
    let primary: Color
    let secondary: Color
    let tertiary: Color

    static let predefined: [ColorPalette] = [
        ColorPalette(name: "Sunset", primary: Color(hex: "#FF5733")!, secondary: Color(hex: "#FF8D1A")!, tertiary: Color(hex: "#FFC300")!),
        ColorPalette(name: "Ocean", primary: Color(hex: "#0077B6")!, secondary: Color(hex: "#0096C7")!, tertiary: Color(hex: "#00B4D8")!),
        ColorPalette(name: "Forest", primary: Color(hex: "#2E7D32")!, secondary: Color(hex: "#4CAF50")!, tertiary: Color(hex: "#81C784")!),
        ColorPalette(name: "Pastel", primary: Color(hex: "#FADCD9")!, secondary: Color(hex: "#D4E09B")!, tertiary: Color(hex: "#A9DEF9")!),
        ColorPalette(name: "Candy", primary: Color(hex: "#FF70A6")!, secondary: Color(hex: "#FF9770")!, tertiary: Color(hex: "#FFD670")!),
        ColorPalette(name: "Fire", primary: Color(hex: "#D62828")!, secondary: Color(hex: "#F77F00")!, tertiary: Color(hex: "#FCBF49")!),
        ColorPalette(name: "Ice", primary: Color(hex: "#48CAE4")!, secondary: Color(hex: "#ADE8F4")!, tertiary: Color(hex: "#CAF0F8")!),
        ColorPalette(name: "Earth", primary: Color(hex: "#8D6E63")!, secondary: Color(hex: "#A1887F")!, tertiary: Color(hex: "#D7CCC8")!),
        ColorPalette(name: "Lavender", primary: Color(hex: "#B388EB")!, secondary: Color(hex: "#D3ABF5")!, tertiary: Color(hex: "#F7C9FF")!),
        ColorPalette(name: "Peach", primary: Color(hex: "#FFAD69")!, secondary: Color(hex: "#FFD0A1")!, tertiary: Color(hex: "#FFE1C6")!),
        ColorPalette(name: "Mint", primary: Color(hex: "#06D6A0")!, secondary: Color(hex: "#96F7D2")!, tertiary: Color(hex: "#C4FCEF")!),
        ColorPalette(name: "Royal", primary: Color(hex: "#4361EE")!, secondary: Color(hex: "#4895EF")!, tertiary: Color(hex: "#4CC9F0")!),
        ColorPalette(name: "Vintage", primary: Color(hex: "#706677")!, secondary: Color(hex: "#A59093")!, tertiary: Color(hex: "#DEC9C3")!),
        ColorPalette(name: "Tropical", primary: Color(hex: "#FF7F51")!, secondary: Color(hex: "#FFB347")!, tertiary: Color(hex: "#FFD56F")!),
        ColorPalette(name: "Mono", primary: Color(hex: "#555555")!, secondary: Color(hex: "#888888")!, tertiary: Color(hex: "#CCCCCC")!)
    ]
}

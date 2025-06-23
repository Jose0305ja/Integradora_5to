import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.primaryColor,
                Color.secondaryColor,
                Color.tertiaryColor,
                Color.primaryColor
            ]),
            startPoint: animate ? .topLeading : .bottomTrailing,
            endPoint: animate ? .bottomTrailing : .topLeading
        )
        .animation(.linear(duration: 8).repeatForever(autoreverses: true), value: animate)
        .onAppear { animate = true }
    }
}

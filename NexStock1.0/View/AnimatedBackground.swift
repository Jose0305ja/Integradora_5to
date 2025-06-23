import SwiftUI

struct AnimatedBackground: View {
    @State private var angle: Angle = .zero

    var body: some View {
        AngularGradient(
            gradient: Gradient(colors: [
                Color.primaryColor,
                Color.secondaryColor,
                Color.tertiaryColor,
                Color.primaryColor
            ]),
            center: .center,
            angle: angle
        )
        .animation(
            .linear(duration: 10)
                .repeatForever(autoreverses: false),
            value: angle
        )
        .onAppear { angle = .degrees(360) }
    }
}

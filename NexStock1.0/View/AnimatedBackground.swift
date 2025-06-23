import SwiftUI

struct AnimatedBackground: View {
    @State private var startPoint = UnitPoint.topLeading
    @State private var endPoint = UnitPoint.bottomTrailing

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.primaryColor,
                Color.secondaryColor,
                Color.tertiaryColor,
                Color.primaryColor
            ]),
            startPoint: startPoint,
            endPoint: endPoint
        )
        .animation(
            .linear(duration: 8)
                .repeatForever(autoreverses: true),
            value: startPoint
        )
        .onAppear {
            startPoint = .bottomTrailing
            endPoint = .topLeading
        }
    }
}

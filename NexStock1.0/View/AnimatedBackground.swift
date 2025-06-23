import SwiftUI

struct AnimatedBackground: View {
    @State private var offset: CGFloat = -1.2

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            ZStack {
                // 🎨 Fondo estático con tus colores
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.primaryColor.opacity(0.95),
                        Color.secondaryColor.opacity(0.9),
                        Color.tertiaryColor.opacity(0.95)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // ✨ Línea de luz diagonal
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.0),
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.6),
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: screenWidth * 0.25, height: screenHeight * 1.5)
                .rotationEffect(.degrees(45))
                .offset(
                    x: offset * screenWidth,
                    y: offset * screenHeight
                )
                .blur(radius: 40)
                .blendMode(.overlay)
                .onAppear {
                    withAnimation(
                        .linear(duration: 6).repeatForever(autoreverses: true)
                    ) {
                        offset = 1.2
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

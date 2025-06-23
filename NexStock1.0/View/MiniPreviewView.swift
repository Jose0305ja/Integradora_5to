import SwiftUI

struct MiniPreviewView: View {
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("NexStock")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.tertiaryColor)
                Spacer()
            }
            .padding(6)
            .frame(maxWidth: .infinity)
            .background(Color.primaryColor)

            Spacer()

            VStack(spacing: 4) {
                Text("Card")
                    .font(.caption)
                    .foregroundColor(.tertiaryColor)
                Text("Preview")
                    .font(.caption2)
                    .foregroundColor(.tertiaryColor.opacity(0.7))
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color.secondaryColor)
            .cornerRadius(8)

            Spacer()
        }
        .frame(height: 130)
        .background(Color.backColor)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

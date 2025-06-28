import SwiftUI

struct AlertCardView: View {
    var icon: String
    var title: String
    var message: String
    var date: String
    var highlight: Color = .red
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(highlight)
                .font(.system(size: 18))
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(date)
                        .foregroundColor(.gray)
                        .font(.caption)
                }

                Text(message)
                    .font(.body)
            }
            .padding(12)
            .background(
                LinearGradient(
                    colors: [highlight.opacity(0.2), Color.secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(10)
        }
    }
}

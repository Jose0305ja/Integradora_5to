import SwiftUI

/// Dropdown button styled consistently with the app theme to pick a time range.
struct TimeRangeDropdown: View {
    @Binding var selection: TimeRange
    let ranges: [TimeRange]
    var onChange: (TimeRange) -> Void

    var body: some View {
        Menu {
            ForEach(ranges, id: \.self) { range in
                Button(action: {
                    selection = range
                    onChange(range)
                }) {
                    Text(range.labelKey.localized)
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selection.labelKey.localized)
                Image(systemName: "chevron.down")
            }
            .font(.caption.bold())
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                LinearGradient(
                    colors: [Color.secondaryColor, Color.primaryColor.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(.tertiaryColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.tertiaryColor.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: Color.primaryColor.opacity(0.2), radius: 2, x: 0, y: 1)
        }
        .animation(.easeInOut, value: selection)
    }
}

#Preview {
    TimeRangeDropdown(selection: .constant(.day), ranges: TimeRange.allCases, onChange: { _ in })
        .environmentObject(ThemeManager.shared)
        .environmentObject(LocalizationManager.shared)
}

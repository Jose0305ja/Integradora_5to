import SwiftUI

struct SensorsStatusView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SensorsStatusViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        VStack(spacing: 0) {
            HeaderModeView(title: "\u{1F4E1} Estado de sensores", onBack: { dismiss() })
                .environmentObject(theme)
                .environmentObject(localization)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.sensors) { sensor in
                        SensorStatusRow(sensor: sensor)
                            .environmentObject(theme)
                            .environmentObject(localization)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
        }
        .background(Color.primaryColor.ignoresSafeArea())
        .onAppear { viewModel.fetch() }
    }
}

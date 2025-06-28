import SwiftUI

struct SensorsStatusView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SensorsStatusViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    var body: some View {
        NavigationView {
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
            .navigationTitle("Estado de sensores")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
            .background(Color.backColor.ignoresSafeArea())
        }
        .onAppear { viewModel.fetch() }
    }
}

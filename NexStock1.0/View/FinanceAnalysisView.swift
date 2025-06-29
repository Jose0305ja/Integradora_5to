import SwiftUI

struct FinanceAnalysisView: View {
    @Binding var path: NavigationPath
    @State private var showMenu = false
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()

            VStack(spacing: 16) {
                HeaderView(showMenu: $showMenu, path: $path)

                Text("analysis".localized)
                    .font(.title)
                    .foregroundColor(.primary)

                Spacer()
            }

            if showMenu {
                SideMenuView(isOpen: $showMenu, path: $path)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: showMenu)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FinanceAnalysisView(path: .constant(NavigationPath()))
        .environmentObject(LocalizationManager.shared)
        .environmentObject(ThemeManager.shared)
}

//
//  AlertView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//

import SwiftUI

struct AlertView: View {
    @Binding var path: NavigationPath
    @State private var showMenu = false
    @StateObject private var viewModel = AlertViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    private var grouped: [String: [NotificationModel]] {
        Dictionary(grouping: viewModel.notifications) { String($0.timestamp.prefix(10)) }
    }

    private func formatted(_ dateString: String) -> String {
        let input = ISO8601DateFormatter()
        let output = DateFormatter()
        output.dateStyle = .medium
        return output.string(from: input.date(from: dateString) ?? Date())
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Color.backColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HeaderView(showMenu: $showMenu, path: $path)

                Text("alerts".localized)
                    .font(.title.bold())
                    .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(grouped.sorted(by: { $0.key > $1.key }), id: \.key) { date, notifs in
                            Section(header:
                                        Text(formatted(date))
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal)) {
                                ForEach(notifs) { notif in
                                    AlertCardView(notification: notif)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }

            if showMenu {
                SideMenuView(isOpen: $showMenu, path: $path)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: showMenu)
        .navigationBarBackButtonHidden(true)
        .task { viewModel.fetchAll() }
    }
}

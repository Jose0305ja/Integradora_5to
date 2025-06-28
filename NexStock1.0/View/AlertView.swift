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
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager
    @StateObject private var viewModel = NotificationsViewModel()

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
                        ForEach(viewModel.notifications) { notif in
                            HStack(alignment: .top, spacing: 12) {
                                Circle()
                                    .fill(sensorColor(for: notif.sensor))
                                    .frame(width: 10, height: 10)
                                    .padding(.top, 6)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(notif.sensor)
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Text(formatNotificationDate(notif.timestamp))
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }

                                    Text(notif.message)
                                        .font(.body)
                                }
                                .padding(12)
                                .background(Color.secondaryColor)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }

                HStack {
                    Button(action: { viewModel.loadPrev() }) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(viewModel.currentPage <= 1)

                    Spacer()

                    Text("\(viewModel.currentPage)/\(viewModel.totalPages)")
                        .font(.caption)

                    Spacer()

                    Button(action: { viewModel.loadNext() }) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(viewModel.currentPage >= viewModel.totalPages)
                }
                .padding(.horizontal)
            }

            if showMenu {
                SideMenuView(isOpen: $showMenu, path: $path)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: showMenu)
        .navigationBarBackButtonHidden(true)
        .task { viewModel.fetch() }
    }
}

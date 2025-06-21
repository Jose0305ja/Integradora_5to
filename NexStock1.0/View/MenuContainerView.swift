//
//  MenuContainerView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 17/06/25.
//


import SwiftUI

struct MenuContainerView<Content: View>: View {
    @ViewBuilder var content: () -> Content
    @Binding var path: NavigationPath
    @Binding var showMenu: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            content()
                .disabled(showMenu)
                .environment(\.showMenuBinding, $showMenu)

            SideMenuView(isOpen: $showMenu, path: $path)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 && !showMenu {
                        withAnimation { showMenu = true }
                    }
                    if value.translation.width < -100 && showMenu {
                        withAnimation { showMenu = false }
                    }
                }
        )
        .animation(.easeInOut, value: showMenu)
    }
}

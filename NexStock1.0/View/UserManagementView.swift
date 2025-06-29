//
//  UserManagementView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 09/06/25.
//


import SwiftUI

struct UserManagementView: View {
    @StateObject private var viewModel = UserManagementViewModel()
    @EnvironmentObject var authService: AuthService
    @State private var showAddUserSheet = false
    @State private var editingUser: UserDetailsResponse? = nil
    @State private var userToDelete: UserTableModel? = nil
    @State private var showDeleteAlert = false

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var theme: ThemeManager

    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView()
                    .padding(20)
                    .background(.regularMaterial)
                    .cornerRadius(12)
            }
        }
    }
    private var addButton: some View {
        Button(action: { showAddUserSheet = true }) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
                .padding()
                .background(Circle().fill(Color.primaryColor))
                .shadow(radius: 5)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
    }


    var body: some View {
        ZStack {
            Color.backColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                // 🔙 Botón y título
                HStack(spacing: 12) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .accessibilityLabel("Volver")
                    }

                    Text("users".localized)
                        .font(.title.bold())
                        .foregroundColor(.primary)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.users) { user in
                            UserRowView(user: user,
                                        onEdit: {
                                            print("[UserManagementView] edit tapped for \(user.id)")
                                            viewModel.fetchUserDetails(id: user.id) { details in
                                                if let details = details {
                                                    print("[UserManagementView] setting editingUser for \(details.user.id)")
                                                    editingUser = details
                                                } else {
                                                    print("[UserManagementView] no details returned")
                                                }
                                            }
                                        },
                                        onDelete: {
                                            userToDelete = user
                                            showDeleteAlert = true
                                        })
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { viewModel.fetchUsers() }
        .onChange(of: viewModel.users) { users in
            if users.isEmpty {
                print("[UserManagementView] user list empty")
            }
        }
        .overlay(addButton, alignment: .bottomTrailing)
        .sheet(isPresented: $showAddUserSheet) {
            AddUserSheet {
                viewModel.fetchUsers()
                showAddUserSheet = false
            }
            .environmentObject(authService)
        }
        .sheet(item: $editingUser, onDismiss: { editingUser = nil }) { details in
            EditUserSheet(details: details) {
                viewModel.fetchUsers()
            }
            .environmentObject(authService)
        }
        .alert("¿Eliminar usuario?", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Eliminar", role: .destructive) {
                if let user = userToDelete {
                    viewModel.deleteUser(id: user.id)
                }
            }
        }
        .overlay(loadingOverlay)
    }
}

struct UserRowView: View {
    let user: UserTableModel
    var onEdit: () -> Void
    var onDelete: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(alignment: .center) {
            Circle()
                .fill(user.isActive ? Color.green : Color.red)
                .frame(width: 12, height: 12)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.headline)
                    .foregroundColor(.fourthColor)

                Text(user.username)
                    .font(.subheadline)
                    .foregroundColor(.backColor)

                Text(user.role)
                    .font(.caption)
                    .foregroundColor(.primaryColor)
            }

            Spacer()

            let isDarkMode = colorScheme == .dark
            let activeBackground = isDarkMode ? Color.green.opacity(0.7) : Color.green.opacity(0.2)
            let inactiveBackground = isDarkMode ? Color.red.opacity(0.7) : Color.red.opacity(0.2)
            let activeTextColor = isDarkMode ? Color.white : Color.green
            let inactiveTextColor = isDarkMode ? Color.white : Color.red

            Text(user.isActive ? "Activo" : "Inactivo")
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(user.isActive ? activeBackground : inactiveBackground)
                .foregroundColor(user.isActive ? activeTextColor : inactiveTextColor)
                .cornerRadius(8)

            HStack(spacing: 12) {
                Button(action: onEdit) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.accentColor)
                }

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.secondaryColor.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}


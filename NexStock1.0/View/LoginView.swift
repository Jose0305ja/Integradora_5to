//
//  LoginView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 02/06/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isPasswordVisible = false
    @Environment(\.colorScheme) var colorScheme
    @Binding var path: NavigationPath

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 🟢 Fondo dinámico
                (colorScheme == .dark ? Color(.systemGray6) : Color.white)
                    .ignoresSafeArea()

                DiagonalLines(colorScheme: colorScheme)

                ScrollView {
                    let spacing = max(geometry.size.height * 0.08, 20)
                    VStack(spacing: 30) {
                        Spacer(minLength: spacing)

                        // Logo
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: min(geometry.size.width * 0.4, 140))
                            .cornerRadius(30)

                        // Usuario
                        TextField("Usuario", text: $viewModel.username)
                            .padding()
                            .background(inputBackground)
                            .cornerRadius(10)
                            .padding(.horizontal)

                        // Contraseña
                        ZStack(alignment: .trailing) {
                            if isPasswordVisible {
                                TextField("Contraseña", text: $viewModel.password)
                            } else {
                                SecureField("Contraseña", text: $viewModel.password)
                            }

                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(inputBackground)
                        .cornerRadius(10)
                        .padding(.horizontal)

                        // Mensaje de error
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .transition(.opacity)
                                .animation(.easeInOut, value: viewModel.errorMessage)
                        }

                        // Botón
                        Button(action: {
                            viewModel.login { success in
                                if success {
                                    path.removeLast(path.count)
                                    path.append(AppRoute.home)
                                }
                            }
                        }) {
                            Text("Iniciar sesión")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(inputBackground)
                                .cornerRadius(10)
                        }

                        Spacer(minLength: spacing)
                    }
                    .frame(maxWidth: 500)
                    .padding()
                }
            }
        }
    }

    var inputBackground: Color {
        colorScheme == .dark ? Color(.systemGray4) : Color.gray.opacity(0.3)
    }
}

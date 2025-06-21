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
                // Fondo adaptable
                Color(.systemBackground)
                    .ignoresSafeArea()

                DiagonalLines(colorScheme: colorScheme)

                ScrollView {
                    VStack(spacing: 24) {
                        Spacer(minLength: geometry.size.height * 0.1)

                        // Logo
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: min(geometry.size.width * 0.35, 120))
                            .cornerRadius(24)

                        // Usuario
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            TextField("Usuario", text: $viewModel.username)
                                .textContentType(.username)
                                .autocapitalization(.none)
                        }
                        .padding()
                        .background(fieldBackground)
                        .cornerRadius(12)

                        // Contraseña
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            Group {
                                if isPasswordVisible {
                                    TextField("Contraseña", text: $viewModel.password)
                                } else {
                                    SecureField("Contraseña", text: $viewModel.password)
                                }
                            }
                            .textContentType(.password)

                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(fieldBackground)
                        .cornerRadius(12)

                        // Mensaje de error
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.footnote)
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
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)

                        Spacer(minLength: geometry.size.height * 0.1)
                    }
                    .frame(maxWidth: 400)
                    .padding()
                }
            }
        }
    }

    var inputBackground: Color {
        colorScheme == .dark ? Color(.systemGray4) : Color.gray.opacity(0.3)
    }

    var fieldBackground: Color {
        Color(.secondarySystemBackground)
    }
}

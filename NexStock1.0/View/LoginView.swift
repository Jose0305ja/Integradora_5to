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
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    // Use the system language for this screen regardless of the app's selected language
    private var systemLanguage: String {
        Locale.current.languageCode ?? "es"
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo animado con barrido de colores giratorio
                AnimatedBackground()
                    .ignoresSafeArea()

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
                        TextField("username".localized(in: systemLanguage), text: $viewModel.username)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(12)
                            .padding(.horizontal)

                        // Contraseña
                        ZStack(alignment: .trailing) {
                            if isPasswordVisible {
                                TextField("password".localized(in: systemLanguage), text: $viewModel.password)
                            } else {
                                SecureField("password".localized(in: systemLanguage), text: $viewModel.password)
                            }

                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(12)
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
                            Text("log_in".localized(in: systemLanguage))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primaryColor.opacity(0.9))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                        }
                        .padding(.horizontal)

                        Spacer(minLength: spacing)
                    }
                    .frame(maxWidth: 500)
                    .padding()
                }
            }
            .overlay(
                Group {
                    if viewModel.isLoading {
                        Color.black.opacity(0.4).ignoresSafeArea()
                        ProgressView("verifying".localized(in: systemLanguage))
                            .padding(20)
                            .background(.regularMaterial)
                            .cornerRadius(12)
                    }
                }
            )
        }
    }

}

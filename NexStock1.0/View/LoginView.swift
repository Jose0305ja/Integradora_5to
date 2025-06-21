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
                // 🟢 Fondo dinámico renovado
                LinearGradient(
                    colors: backgroundColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                DiagonalLines(colorScheme: colorScheme)

                ScrollView {
                    VStack(spacing: 30) {
                        Spacer(minLength: geometry.size.height * 0.08)

                        // Logo
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: min(geometry.size.width * 0.4, 140))
                            .cornerRadius(30)

                        // Usuario
                        TextField("Usuario", text: $viewModel.username)
                            .textContentType(.username)
                            .padding()
                            .background(
                                .thinMaterial,
                                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                            )
                            .padding(.horizontal)

                        // Contraseña
                        ZStack(alignment: .trailing) {
                            if isPasswordVisible {
                                TextField("Contraseña", text: $viewModel.password)
                                    .textContentType(.password)
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
                        .background(
                            .thinMaterial,
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                        )
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
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }

                        Spacer(minLength: geometry.size.height * 0.08)
                    }
                    .frame(maxWidth: 500)
                    .padding()
                }
            }
        }
    }

    var backgroundColors: [Color] {
        colorScheme == .dark ? [Color.black, Color.primaryColor.opacity(0.3)] :
            [Color.white, Color.primaryColor.opacity(0.3)]
    }
}

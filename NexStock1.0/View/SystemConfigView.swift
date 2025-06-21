//
//  SystemConfigView.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 11/06/25.
//

import SwiftUI
import UIKit

struct SystemConfigView: View {
    @StateObject private var viewModel = SystemConfigViewModel()
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @EnvironmentObject var localization: LocalizationManager

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.backColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                // 🔙 Header
                HStack(spacing: 12) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .accessibilityLabel("Volver")
                    }

                    Text("system_config".localized)
                        .font(.title.bold())
                        .foregroundColor(.primary)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView {
                    VStack(spacing: 24) {

                        // 🖼️ Logo
                        VStack(alignment: .center, spacing: 10) {
                            Text("logo".localized)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .center)

                            SectionContainer(title: "") {
                                VStack(spacing: 10) {
                                    Group {
                                        if let image = viewModel.logoImage {
                                            Image(uiImage: image)
                                                .resizable()
                                        } else if let urlString = viewModel.logoURL, let url = URL(string: urlString) {
                                            AsyncImage(url: url) { phase in
                                                if let img = phase.image {
                                                    img.resizable()
                                                } else {
                                                    ProgressView()
                                                }
                                            }
                                        } else {
                                            Image("AppLogo")
                                                .resizable()
                                        }
                                    }
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 3)

                                    Text("tap_to_change_logo".localized)
                                        .font(.caption)
                                        .foregroundColor(.fourthColor)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: 240)
                            }
                            .onTapGesture { showImagePicker = true }
                        }
                        .frame(maxWidth: .infinity)

                        // 🎨 Título de colores
                        Text("colors".localized)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .center)

                        // 🎨 Paleta 2x2
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            SectionContainer(title: "primary".localized) {
                                colorSelector(color: $viewModel.primaryColor)
                            }

                            SectionContainer(title: "secondary".localized) {
                                colorSelector(color: $viewModel.secondaryColor)
                            }

                            SectionContainer(title: "tertiary".localized) {
                                colorSelector(color: $viewModel.tertiaryColor)
                            }
                        }
                        .padding(.horizontal)

                        // 💾 Botón guardar
                        Button(action: {
                            viewModel.saveChanges()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.down.fill")
                                Text("save_changes".localized)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.fourthColor)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(Color.primary)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { viewModel.fetchConfig() }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType) { image in
                viewModel.logoImage = image
            }
        }
        .alert("Cambios guardados", isPresented: $viewModel.showSuccessAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("Error al guardar", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) { }
        }
        .overlay(
            Group {
                if viewModel.isSaving {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    ProgressView("Guardando...")
                        .padding(20)
                        .background(.regularMaterial)
                        .cornerRadius(12)
                }
            }
        )
    }

    // 🎨 Selector de color sin título
    @ViewBuilder
    private func colorSelector(color: Binding<Color>) -> some View {
        VStack(spacing: 8) {
            ColorPicker("", selection: color)
                .labelsHidden()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity)
    }
}

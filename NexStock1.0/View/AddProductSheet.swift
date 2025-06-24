//
//  AddProductSheet.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 20/06/25.
//

import SwiftUI
import PhotosUI

import Foundation

struct AddProductSheet: View {
    var onSave: (DetailedProductModel) -> Void
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    @State private var name = ""
    @State private var brand = ""
    @State private var description = ""
    @State private var selectedCategory: Category? = nil
    @State private var selectedUnitType: UnitType? = nil
    @State private var stockMin = 0
    @State private var stockMax = 0
    @State private var inputMethod: InputMethod = .manual
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false

    @State private var selectedImage: UIImage? = nil
    @State private var uploadURL: URL?
    @State private var finalURL: URL?
    @State private var isUploading = false

    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImageSourceOptions = false

    // Categories provided by the backend
    let categories: [Category] = [
        .init(id: 1, name: "Alimentos"),
        .init(id: 2, name: "Bebidas"),
        .init(id: 3, name: "Insumos"),
        .init(id: 4, name: "Productos de limpieza")
    ]

    let unitTypes: [UnitType] = [
        .init(id: 1, name: "kg"),
        .init(id: 2, name: "lt"),
        .init(id: 3, name: "pz")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryColor.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        // Sección 1
                        SectionContainer(title: "information".localized) {
                            TextField("Nombre", text: $name)
                                .textFieldStyle(.roundedBorder)
                            TextField("Marca", text: $brand)
                                .textFieldStyle(.roundedBorder)
                            TextField("Descripción", text: $description)
                                .textFieldStyle(.roundedBorder)
                        }

                        // Sección 2
                        SectionContainer(title: "stock".localized) {
                            HStack {
                                Text("Mínimo:")
                                TextField("0", value: $stockMin, format: .number)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(.roundedBorder)
                                Stepper("", value: $stockMin, in: 0...100)
                                    .labelsHidden()
                            }
                            HStack {
                                Text("Máximo:")
                                TextField("0", value: $stockMax, format: .number)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(.roundedBorder)
                                Stepper("", value: $stockMax, in: 1...200)
                                    .labelsHidden()
                            }
                        }

                        // Sección 3
                        SectionContainer(title: "image".localized) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                            } else if isUploading {
                                ProgressView("Subiendo imagen...")
                            } else {
                                Text("No hay imagen seleccionada")
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }

                            Button("Subir desde galería o cámara") {
                                showImageSourceOptions = true
                            }
                            .confirmationDialog("Selecciona origen de la imagen", isPresented: $showImageSourceOptions) {
                                Button("Tomar foto") {
                                    sourceType = .camera
                                    showImagePicker = true
                                }
                                Button("Seleccionar de galería") {
                                    sourceType = .photoLibrary
                                    showImagePicker = true
                                }
                                Button("Cancelar", role: .cancel) {}
                            }
                        }

                        // Sección 4
                        SectionContainer(title: "category".localized) {
                            Picker("Categoría", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category.name.localized).tag(category as Category?)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        // Sección 5
                        SectionContainer(title: "unit".localized) {
                            Picker("Tipo de unidad", selection: $selectedUnitType) {
                                ForEach(unitTypes, id: \.self) { unit in
                                    Text(unit.name.localized).tag(unit as UnitType?)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        // Sección 6 - Método de entrada
                        SectionContainer(title: "input_method".localized) {
                            Picker("input_method".localized, selection: $inputMethod) {
                                ForEach(InputMethod.allCases, id: \.self) { method in
                                    Text(method.rawValue.localized).tag(method)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    .padding()
                    .foregroundColor(.tertiaryColor)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("new_product".localized)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        if let category = selectedCategory,
                           let unit = selectedUnitType,
                           let finalURL = finalURL {
                            let producto = DetailedProductModel(
                                name: name,
                                brand: brand,
                                description: description,
                                category_id: category.id,
                                unit_type_id: unit.id,
                                image_url: finalURL.absoluteString,
                                stock_min: stockMin,
                                stock_max: stockMax,
                                input_method: inputMethod
                            )

                            ProductService.shared.addProduct(producto) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success:
                                        onSave(producto)
                                        showSuccessAlert = true
                                    case .failure(let error):
                                        print("Error saving product:", error)
                                        showErrorAlert = true
                                    }
                                }
                            }
                        }
                    }
                    .disabled(name.isEmpty || selectedCategory == nil || selectedUnitType == nil || finalURL == nil)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType) { image in
                Task {
                    isUploading = true
                    await obtenerURLFirmada()
                    selectedImage = image
                    if let data = image.pngData(), let uploadURL = uploadURL {
                        await subirImagen(data: data, a: uploadURL)
                    }
                    isUploading = false
                }
            }
        }
        .alert("Producto guardado", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
        .alert("Ocurrió un error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    struct FirmaResponse: Codable {
        let upload_url: String
        let final_url: String
    }

    func obtenerURLFirmada() async {
        guard let url = URL(string: "https://auth.nexusutd.online/auth/config/upload-url?type=logo&ext=png") else { return }

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(authService.token ?? "")", forHTTPHeaderField: "Authorization")

            let (data, _) = try await URLSession.shared.data(for: request)

            let rawResponse = String(data: data, encoding: .utf8)
            print("📩 Respuesta del servidor:", rawResponse ?? "N/A")

            if let decoded = try? JSONDecoder().decode(FirmaResponse.self, from: data) {
                self.uploadURL = URL(string: decoded.upload_url)
                self.finalURL = URL(string: decoded.final_url)
            } else {
                print("⚠️ Error decodificando firma. Respuesta cruda:", rawResponse ?? "N/A")
                showErrorAlert = true
            }
        } catch {
            print("❌ Error al obtener URL firmada:", error)
            showErrorAlert = true
        }
    }

    func subirImagen(data: Data, a url: URL) async {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data
        request.setValue("image/png", forHTTPHeaderField: "Content-Type")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 200 {
                print("✅ Imagen subida")
            }
        } catch {
            print("❌ Error al subir la imagen:", error)
            showErrorAlert = true
        }
    }
}

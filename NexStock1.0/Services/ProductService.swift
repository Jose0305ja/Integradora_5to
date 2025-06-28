//
//  ProductService.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 20/06/25.
//


import Foundation

class ProductService {
    static let shared = ProductService()
    private let baseURL = NetworkConfig.inventoryBaseURL + "/inventory/products"

    // 🔐 Centraliza el uso del token
    private func authorizedRequest(url: URL, method: String = "GET") -> URLRequest? {
        guard let token = AuthService.shared.token else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    // 🔄 Obtener todos los productos detallados
    func fetchProducts(completion: @escaping (Result<[DetailedProductModel], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        guard let request = authorizedRequest(url: url) else {
            completion(.failure(NSError(domain: "ProductService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                print("🧾 JSON recibido:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoded = try JSONDecoder().decode([DetailedProductModel].self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    // 🔄 Obtener productos generales (paginados)
    func fetchGeneralProducts(categoryID: Int? = nil, page: Int = 1, limit: Int = 20, completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        var components = URLComponents(string: baseURL + "/general")
        var queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        if let categoryID = categoryID {
            queryItems.append(URLQueryItem(name: "category", value: String(categoryID)))
        }
        components?.queryItems = queryItems

        guard let url = components?.url else { return }
        guard let request = authorizedRequest(url: url) else {
            completion(.failure(NSError(domain: "ProductService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                print("🧾 JSON recibido:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                    completion(.success(decoded.products))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    // 🔄 Obtener productos por estado (paginados)
    func fetchInventoryProducts(status: String? = nil, page: Int = 1, limit: Int = 10, completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        var components = URLComponents(string: baseURL)
        var queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        if let status = status {
            queryItems.append(URLQueryItem(name: "status", value: status))
        }
        components?.queryItems = queryItems

        guard let url = components?.url else { return }
        guard let request = authorizedRequest(url: url) else {
            completion(.failure(NSError(domain: "ProductService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                print("🧾 JSON recibido:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                    completion(.success(decoded.products))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    // ➕ Agregar producto
    func addProduct(_ product: DetailedProductModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        guard var request = authorizedRequest(url: url, method: "POST") else {
            completion(.failure(NSError(domain: "ProductService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }

        do {
            request.httpBody = try JSONEncoder().encode(product)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }

    // 🔍 Detalle individual de producto
    func fetchProductDetail(id: String, completion: @escaping (Result<ProductDetailInfo, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/" + id) else { return }
        guard let request = authorizedRequest(url: url) else {
            completion(.failure(NSError(domain: "ProductService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let http = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "ProductService", code: 0, userInfo: nil)))
                return
            }

            if http.statusCode != 200 {
                if let msg = try? JSONDecoder().decode([String: String].self, from: data)["message"] {
                    completion(.failure(NSError(domain: "ProductService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])))
                } else {
                    completion(.failure(NSError(domain: "ProductService", code: http.statusCode, userInfo: nil)))
                }
                return
            }

            print("🧾 Detail JSON:", String(data: data, encoding: .utf8) ?? "")
            do {
                let decoded = try JSONDecoder().decode(ProductDetailResponse.self, from: data)
                completion(.success(decoded.product))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // 📦 Historial de movimientos
    func fetchProductMovements(id: String, completion: @escaping (Result<[ProductMovement], Error>) -> Void) {
        guard let url = URL(string: baseURL + "/" + id + "/movements") else { return }
        guard let request = authorizedRequest(url: url) else {
            completion(.failure(NSError(domain: "ProductService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token disponible."])))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let http = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "ProductService", code: 0, userInfo: nil)))
                return
            }

            if http.statusCode != 200 {
                if let msg = try? JSONDecoder().decode([String: String].self, from: data)["message"] {
                    completion(.failure(NSError(domain: "ProductService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])))
                } else {
                    completion(.failure(NSError(domain: "ProductService", code: http.statusCode, userInfo: nil)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ProductMovementsResponse.self, from: data)
                completion(.success(decoded.movements))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // 🔎 Búsqueda por nombre
    func searchProducts(name: String, completion: @escaping ([ProductModel]) -> Void) {
        guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(NetworkConfig.inventoryBaseURL)/inventory/products/search?name=\(encodedName)") else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(AuthService.shared.token ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(SearchProductsResponse.self, from: data)
                    let products = decoded.results.map { ProductModel(from: $0) }
                    DispatchQueue.main.async { completion(products) }
                } catch {
                    print("❌ Decoding failed: \(error)")
                    DispatchQueue.main.async { completion([]) }
                }
            } else {
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
}

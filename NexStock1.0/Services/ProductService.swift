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
    private func authorizedRequest(url: URL, method: String = "GET") -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(AuthService.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }

    // 🔄 Obtener todos los productos detallados
    func fetchProducts(completion: @escaping (Result<[DetailedProductModel], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        let request = authorizedRequest(url: url)

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
        let request = authorizedRequest(url: url)

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
        var request = authorizedRequest(url: url, method: "POST")

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
    func fetchProductDetail(id: String, completion: @escaping (Result<ProductDetailResponse, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/" + id) else { return }
        let request = authorizedRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                print("🧾 Detail JSON:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoded = try JSONDecoder().decode(ProductDetailResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    // 📦 Historial de movimientos
    func fetchProductMovements(id: String, completion: @escaping (Result<[ProductMovement], Error>) -> Void) {
        guard let url = URL(string: baseURL + "/" + id + "/movements") else { return }
        let request = authorizedRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(ProductMovementsResponse.self, from: data)
                    completion(.success(decoded.movements))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    // 🔎 Búsqueda por nombre
    func searchProducts(name: String, limit: Int = 20, offset: Int = 0, completion: @escaping (Result<[SearchProduct], Error>) -> Void) {
        var components = URLComponents(string: baseURL + "/search")
        components?.queryItems = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]

        guard let url = components?.url else { return }
        let request = authorizedRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                print("🧾 Search JSON:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoded = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    completion(.success(decoded.results))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

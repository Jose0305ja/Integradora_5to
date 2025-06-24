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

    func fetchProducts(completion: @escaping (Result<[DetailedProductModel], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🧾 JSON recibido: \(jsonString)")
                }
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

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🧾 JSON recibido: \(jsonString)")
                }
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

    func addProduct(_ product: DetailedProductModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(product)
            request.httpBody = jsonData
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

    func fetchProductDetail(id: String, completion: @escaping (Result<ProductDetailResponse, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/" + id) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🧾 Detail JSON: \(jsonString)")
                }
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

    /// Fetch only the movement history for a product
    func fetchProductMovements(id: String, completion: @escaping (Result<[ProductMovement], Error>) -> Void) {
        guard let url = URL(string: baseURL + "/" + id + "/movements") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
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
}

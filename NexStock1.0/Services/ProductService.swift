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

    func fetchProducts(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode([ProductModel].self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    func addProduct(_ product: ProductModel, completion: @escaping (Result<Void, Error>) -> Void) {
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
}

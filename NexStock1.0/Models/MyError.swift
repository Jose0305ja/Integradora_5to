import Foundation

enum MyError: LocalizedError {
    case invalidData
    case missingProductsKey

    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Datos inválidos"
        case .missingProductsKey:
            return "Respuesta sin productos"
        }
    }
}

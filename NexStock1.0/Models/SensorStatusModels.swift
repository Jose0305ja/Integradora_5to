import Foundation

struct SensorStatus: Identifiable, Decodable {
    let sensor: String
    let status: String
    var id: String { sensor }
}

struct SensorsStatusResponse: Decodable {
    let sensors: [SensorStatus]
}

//
//  MonitoringPoint.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//


import Foundation

struct MonitoringPoint: Identifiable, Decodable {
    let id = UUID()
    let time: Date
    let value: Double

    enum CodingKeys: String, CodingKey {
        case time, value
    }

    init(time: Date, value: Double) {
        self.time = time
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timeString = try container.decode(String.self, forKey: .time)
        let value = try container.decode(Double.self, forKey: .value)

        // Try to decode ISO8601 with or without fractional seconds
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: timeString) {
            self.time = date
        } else if let date = ISO8601DateFormatter().date(from: timeString) {
            self.time = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .time, in: container, debugDescription: "Invalid date string")
        }

        self.value = value
    }
}

//
//  MonitoringPoint.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//


import Foundation

struct MonitoringPoint: Identifiable, Codable {
    let id = UUID()
    let time: Date
    let value: Double
}

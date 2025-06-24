//
//  AlertModel.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//


import Foundation
import SwiftUI

/// Level of importance for an alert. Each level defines its visual color.
enum AlertSeverity {
    case low, medium, high

    /// Base color associated to each severity level
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
}

struct AlertModel: Identifiable {
    let id = UUID()
    let sensor: String
    let message: String
    let time: String
    let icon: String
    let severity: AlertSeverity
}

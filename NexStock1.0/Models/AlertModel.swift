//
//  AlertModel.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 18/06/25.
//


import Foundation

struct AlertModel: Identifiable {
    let id = UUID()
    let sensor: String
    let message: String
    let time: String
    let icon: String
}

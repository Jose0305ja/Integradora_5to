//
//  CardModel.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 07/06/25.
//


import Foundation

struct CardModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String?

    init(title: String, subtitle: String, icon: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
}


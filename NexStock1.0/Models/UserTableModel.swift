//
//  UserTableModel.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 09/06/25.
//

import Foundation

struct UserTableModel: Identifiable, Equatable {
    let id = UUID()
    let username: String
    let firstName: String
    let lastName: String
    let role: String
    let isActive: Bool
}

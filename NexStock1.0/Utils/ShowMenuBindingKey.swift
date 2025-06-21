//
//  ShowMenuBindingKey.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 20/06/25.
//


import SwiftUI

private struct ShowMenuBindingKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var showMenuBinding: Binding<Bool> {
        get { self[ShowMenuBindingKey.self] }
        set { self[ShowMenuBindingKey.self] = newValue }
    }
}
//
//  CenteredProductKey.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 15/06/25.
//


import SwiftUI

struct CenteredProductKey: PreferenceKey {
    static var defaultValue: String? = nil

    static func reduce(value: inout String?, nextValue: () -> String?) {
        if let next = nextValue() {
            value = next
        }
    }
}
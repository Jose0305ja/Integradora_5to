//
//  String+Localization.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 19/06/25.
//

import Foundation

extension String {
    var localized: String {
        LocalizationManager.shared.localizedString(forKey: self)
    }
}

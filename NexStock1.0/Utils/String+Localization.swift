//
//  String+Localization.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 19/06/25.
//

import Foundation

extension String {
    /// Returns the localized string using the application's selected language.
    var localized: String {
        LocalizationManager.shared.localizedString(forKey: self)
    }

    /// Allows requesting a translation in a specific language without altering
    /// the global selection.
    func localized(in language: String) -> String {
        LocalizationManager.shared.localizedString(forKey: self, language: language)
    }
}

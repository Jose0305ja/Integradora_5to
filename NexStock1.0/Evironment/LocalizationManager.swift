//
//  LocalizationManager.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 19/06/25.
//


import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    // Defaults to the device language when the app is first launched. The value
    // is stored in AppStorage so the user's selection persists across launches.
    @AppStorage("selectedLanguage") var selectedLanguage: String = Locale.current.languageCode ?? "es" {
        didSet {
            objectWillChange.send()
        }
    }

    func setLanguage(_ language: String) {
        selectedLanguage = language
    }

    func localizedString(forKey key: String, language override: String? = nil) -> String {
        let language = override ?? selectedLanguage
        guard let path = Bundle.main.path(forResource: language, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let dictionary = try? JSONDecoder().decode([String: String].self, from: data)
        else {
            return key
        }

        return dictionary[key] ?? key
    }
}

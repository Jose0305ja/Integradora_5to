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

    @AppStorage("selectedLanguage") var selectedLanguage: String = "es" {
        didSet {
            objectWillChange.send()
        }
    }

    func localizedString(forKey key: String) -> String {
        let language = selectedLanguage
        guard let path = Bundle.main.path(forResource: language, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let dictionary = try? JSONDecoder().decode([String: String].self, from: data)
        else {
            return key
        }

        return dictionary[key] ?? key
    }
}
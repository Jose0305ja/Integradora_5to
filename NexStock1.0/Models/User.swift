//
//  User.swift
//  NexStock1.0
//
//  Created by Jose Antonio Rivera on 02/06/25.
//


import Foundation

struct User: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let user: UserInfo
    let settings: Settings
}

struct UserInfo: Codable {
    let id: String
    let username: String
    let role: String
    let language: String
    let theme: String
}

struct Settings: Codable {
    let logo_url: String
    let color_primary: String
    let color_secondary: String
    let color_tertiary: String
}

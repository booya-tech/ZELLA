//
//  AppColors.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/7/25.
//

import Foundation
import SwiftUI

struct AppColors {
    // 3 main app colors
    static let blackSecondaryColor = UIColor(named: "BlackSecondary")
    static let whiteCloudyColor = UIColor(named: "WhiteCloudy")
    static let textFieldBorderColor = UIColor(named: "TextFieldBorder")
    // SwiftUI Color versions
    static let textFieldBorder = Color(uiColor: textFieldBorderColor ?? .clear)
    static let blackSecondary = Color(uiColor: blackSecondaryColor ?? .black)
    static let whiteCloudy = Color(uiColor: whiteCloudyColor ?? .white)
    // MARK: - Semantic Colors
    // Primary
    static let primaryBlack = Color.black
    static let primaryWhite = Color.white
    static let primaryClear = Color.clear
    
    // Background
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    
    // Text
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let tertiaryText = Color(.tertiaryLabel)
    
    // Borders & Dividers
    static let border = Color(.systemGray4)
    static let divider = Color(.separator)
    
    // States
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
    
    // Button
    static let buttonPrimary = Color.black
    static let buttonSecondary = Color(.systemGray6)
    static let buttonDestructive = Color.red
    static let blackStroke = Color.black
    
    // Interactive
    static let link = Color.blue
    static let selected = Color.black
    static let disabled = Color(.systemGray3)
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

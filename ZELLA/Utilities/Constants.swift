//
//  Constants.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import Foundation

struct Constants {
    // Padding
    static let mainPadding: CGFloat = 16
    static let searchRowPadding: CGFloat = 12
    static let secondaryPadding: CGFloat = 8
    static let thirdPadding: CGFloat = 6
    static let fourthPadding: CGFloat = 4
    
    // Radius
    static let buttonRadius: CGFloat = 8
    static let shadowButtonRadius: CGFloat = 4
    
    // Section
    static let sectionSpacing: CGFloat = 8
    
    // Home
    static let bannerHeight: CGFloat = 380

    // User Defaults
    static let recentSearchesKey = "recentSearches"

    // Card's Width
    static let productCardMinWidth: CGFloat = 110  // Text readability threshold
    static let productCardMinWidthTwo: CGFloat = 120  // Text readability threshold for two cards
    static let productCardMaxWidth: CGFloat = 160  // Aesthetic preference
}

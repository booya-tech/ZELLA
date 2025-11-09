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
    // Button
    static let blackStroke = Color.black
}

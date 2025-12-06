//
//  FontAwesome.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/15/25.
//

import SwiftUI
import UIKit

/// Description - Example Usage
// Text("Search")
// FontAwesomeIcon(FontAwesome.Icon.search, size: 20)

// FontAwesomeIcon(FontAwesome.Icon.heart, style: .solid, size: 24)
//     .foregroundStyle(.red)

// FontAwesomeIcon(FontAwesome.Icon.heart, style: .regular, size: 24)
//     .foregroundStyle(.red)

// FontAwesomeIcon(FontAwesome.Icon.facebook, style: .brands, size: 24)
//     .foregroundStyle(.blue)

// Button(action: { /* action */ }) {
//     HStack {
//         FontAwesomeIcon(FontAwesome.Icon.bagShopping, size: 18)
//         Text("Add to Cart")
//     }
// }

enum FontAwesome {
    // Font PostScript names (actual font names used by iOS)
    enum FontName {
        static let solid = "FontAwesome7Free-Solid"
        static let regular = "FontAwesome7Free-Regular"
        static let brands = "FontAwesome7Brands-Regular"
    }
    
    // Common icons (Unicode values)
    // Add more as needed: https://fontawesome.com/icons
    enum Icon {
        // Solid icons
        static let heart = "\u{f004}"
        static let star = "\u{f005}"
        static let user = "\u{f007}"
        static let home = "\u{f015}"
        static let search = "\u{f002}"
        static let bell = "\u{f0f3}"
        static let message = "\u{f075}"
        static let plus = "\u{2b}"
        static let check = "\u{f00c}"
        static let xmark = "\u{f00d}"
        static let eye = "\u{f06e}"
        static let eyeSlash = "\u{f070}"
        static let lock = "\u{f023}"
        static let envelope = "\u{f0e0}"
        static let camera = "\u{f030}"
        static let image = "\u{f03e}"
        static let trash = "\u{f1f8}"
        static let edit = "\u{f044}"
        static let settings = "\u{f013}"
        static let arrowRight = "\u{f061}"
        static let arrowLeft = "\u{f060}"
        static let arrowsRotate = "\u{f021}"
        static let bagShopping = "\u{f290}"
        static let chevronRight = "\u{f054}"
        static let chevronLeft = "\u{f053}"
        
        // Brand icons
        static let facebook = "\u{f09a}"
        static let google = "\u{f1a0}"
        static let apple = "\u{f179}"
    }
}

// MARK: - Font Awesome Icon View
struct FontAwesomeIcon: View {
    let icon: String
    let style: FontAwesomeStyle
    let size: CGFloat
    
    enum FontAwesomeStyle: Equatable {
        case solid
        case regular
        case brands
        
        var fontName: String {
            switch self {
            case .solid: return FontAwesome.FontName.solid
            case .regular: return FontAwesome.FontName.regular
            case .brands: return FontAwesome.FontName.brands
            }
        }
    }
    
    init(_ icon: String, style: FontAwesomeStyle = .solid, size: CGFloat = 16) {
        self.icon = icon
        self.style = style
        self.size = size
    }
    
    var body: some View {
        Text(icon)
            .font(.custom(style.fontName, size: size))
            .fixedSize()
    }
}

extension FontAwesome {
    /// Create a UIImage from Font Awesome icon for TabView
    static func image(_ icon: String, size: CGFloat = 20, style: String = FontAwesome.FontName.solid) -> UIImage {
        let font = UIFont(name: style, size: size) ?? UIFont.systemFont(ofSize: size)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (icon as NSString).size(withAttributes: attributes)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        icon.draw(at: .zero, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}

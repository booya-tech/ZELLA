//
//  FontManager.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/4/25.
//

/// Description - Example Usage
//  Text(title)
//    .font(.roboto(.h4Bold))

import SwiftUI
import CoreText

// MARK: - Font Description
struct FontDescription {
    let font: FontManager.FontFamily
    let size: CGFloat
}

// MARK: - Font Manager
public class FontManager {
    
    // Font Family Enum
    public enum FontFamily: String {
        case regular = "Roboto-Regular"      // weight 400
        case medium = "Roboto-Medium"        // weight 500
        case semibold = "Roboto-SemiBold"    // weight 600
        case bold = "Roboto-Bold"            // weight 700
        case extrabold = "Roboto-ExtraBold"  // weight 800
        
        var name: String {
            return self.rawValue
        }
    }
    
    // Register fonts (if needed for dynamic loading)
    public static func registerFonts() {
        let fonts = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil)
        fonts?.forEach { url in
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

// MARK: - Roboto Preset Fonts
public enum RobotoFont {
    
    // Buttons
    case buttonLarge
    case buttonMedium
    case buttonSmall
    
    // Headlines (H1-H4)
    case h1Regular, h1Medium, h1Bold
    case h2Regular, h2Medium, h2Bold
    case h3Regular, h3Medium, h3Bold
    case h4Regular, h4Medium, h4Bold
    
    // Subtitle
    case subtitleRegular, subtitleMedium, subtitleBold
    
    // Body
    case bodyRegular, bodyMedium, bodyBold
    case body2Regular, body2Medium, body2Bold
    
    // Caption
    case captionRegular, captionMedium, captionBold
    case caption2Regular, caption2Medium, caption2Bold
    
    // Small
    case smallRegular, smallMedium, smallBold
    
    // SwiftUI Font
    public var font: Font {
        return Font.custom(fontDescription.font.name, size: fontDescription.size)
    }
    
    private var fontDescription: FontDescription {
        switch self {
        // Buttons
        case .buttonLarge:
            return FontDescription(font: .bold, size: 18)
        case .buttonMedium:
            return FontDescription(font: .bold, size: 16)
        case .buttonSmall:
            return FontDescription(font: .bold, size: 14)
            
        // H1 - 34pt
        case .h1Regular:
            return FontDescription(font: .regular, size: 34)
        case .h1Medium:
            return FontDescription(font: .medium, size: 34)
        case .h1Bold:
            return FontDescription(font: .bold, size: 34)
            
        // H2 - 28pt
        case .h2Regular:
            return FontDescription(font: .regular, size: 28)
        case .h2Medium:
            return FontDescription(font: .medium, size: 28)
        case .h2Bold:
            return FontDescription(font: .bold, size: 28)
            
        // H3 - 22pt
        case .h3Regular:
            return FontDescription(font: .regular, size: 22)
        case .h3Medium:
            return FontDescription(font: .medium, size: 22)
        case .h3Bold:
            return FontDescription(font: .bold, size: 22)
            
        // H4 - 18pt
        case .h4Regular:
            return FontDescription(font: .regular, size: 18)
        case .h4Medium:
            return FontDescription(font: .medium, size: 18)
        case .h4Bold:
            return FontDescription(font: .bold, size: 18)
            
        // Subtitle - 16pt
        case .subtitleRegular:
            return FontDescription(font: .regular, size: 16)
        case .subtitleMedium:
            return FontDescription(font: .medium, size: 16)
        case .subtitleBold:
            return FontDescription(font: .bold, size: 16)
            
        // Body - 15pt
        case .bodyRegular:
            return FontDescription(font: .regular, size: 15)
        case .bodyMedium:
            return FontDescription(font: .medium, size: 15)
        case .bodyBold:
            return FontDescription(font: .bold, size: 15)
            
        // Body2 - 14pt
        case .body2Regular:
            return FontDescription(font: .regular, size: 14)
        case .body2Medium:
            return FontDescription(font: .medium, size: 14)
        case .body2Bold:
            return FontDescription(font: .bold, size: 14)
            
        // Caption - 12pt
        case .captionRegular:
            return FontDescription(font: .regular, size: 12)
        case .captionMedium:
            return FontDescription(font: .medium, size: 12)
        case .captionBold:
            return FontDescription(font: .bold, size: 12)
            
        // Caption2 - 11pt
        case .caption2Regular:
            return FontDescription(font: .regular, size: 11)
        case .caption2Medium:
            return FontDescription(font: .medium, size: 11)
        case .caption2Bold:
            return FontDescription(font: .bold, size: 11)
            
        // Small - 10pt
        case .smallRegular:
            return FontDescription(font: .regular, size: 10)
        case .smallMedium:
            return FontDescription(font: .medium, size: 10)
        case .smallBold:
            return FontDescription(font: .bold, size: 10)
        }
    }
}

// MARK: - Font Extension (Optional: For cleaner syntax)
extension Font {
    static func roboto(_ preset: RobotoFont) -> Font {
        return preset.font
    }
}

//
//  FontManager.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/4/25.
//

/// Description - Example Usage
//  Text(title)
//    .font(.syne(.h4Bold))

import SwiftUI
import CoreText

// MARK: - Font Description
struct FontDescription {
    let fontName: String
    let size: CGFloat
}

// MARK: - Font Manager
public class FontManager {
    // Roboto Font Family
    public enum RobotoFamily: String {
        case regular = "Roboto-Regular"      // weight 400
        case medium = "Roboto-Medium"        // weight 500
        case semibold = "Roboto-SemiBold"    // weight 600
        case bold = "Roboto-Bold"            // weight 700
        case extrabold = "Roboto-ExtraBold"  // weight 800
    }

    // Syne Font Family
    public enum SyneFamily: String {
        case regular = "Syne-Regular"      // weight 400
        case medium = "Syne-Medium"        // weight 500
        case semibold = "Syne-SemiBold"    // weight 600
        case bold = "Syne-Bold"            // weight 700
        case extrabold = "Syne-ExtraBold"  // weight 800
    }
    
    // Register fonts (if needed for dynamic loading)
    public static func registerFonts() {
        let fonts = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil)
        fonts?.forEach { url in
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

protocol FontPreset {
    var fontDescription: FontDescription { get }
    var font: Font { get }
}

extension FontPreset {
    var font: Font {
        return Font.custom(fontDescription.fontName, size: fontDescription.size)
    }
}

// MARK: - Roboto Preset Fonts
public enum RobotoFont: FontPreset {
    
    // Buttons
    case buttonLarge, buttonMedium, buttonSmall
    
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
    
    var fontDescription: FontDescription {
        switch self {
        // Buttons
        case .buttonLarge: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 18)
        case .buttonMedium: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 16)
        case .buttonSmall: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 14)
            
        // H1 - 34pt
        case .h1Regular: return FontDescription(fontName: FontManager.RobotoFamily.regular.rawValue, size: 34)
        case .h1Medium: return FontDescription(fontName: FontManager.RobotoFamily.medium.rawValue, size: 34)
        case .h1Bold: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 34)
            
        // H2 - 28pt
        case .h2Regular: return FontDescription(fontName: FontManager.RobotoFamily.regular.rawValue, size: 28)
        case .h2Medium: return FontDescription(fontName: FontManager.RobotoFamily.medium.rawValue, size: 28)
        case .h2Bold: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 28)
            
        // H3 - 22pt
        case .h3Regular: return FontDescription(fontName: FontManager.RobotoFamily.regular.rawValue, size: 22)
        case .h3Medium: return FontDescription(fontName: FontManager.RobotoFamily.medium.rawValue, size: 22)
        case .h3Bold: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 22)
            
        // H4 - 18pt
        case .h4Regular: return FontDescription(fontName: FontManager.RobotoFamily.regular.rawValue, size: 18)
        case .h4Medium: return FontDescription(fontName: FontManager.RobotoFamily.medium.rawValue, size: 18)
        case .h4Bold: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 18)
            
        // Subtitle - 16pt
        case .subtitleRegular: return FontDescription(fontName: FontManager.RobotoFamily.regular.rawValue, size: 16)
        case .subtitleMedium: return FontDescription(fontName: FontManager.RobotoFamily.medium.rawValue, size: 16)
        case .subtitleBold: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 16)
            
        // Body - 15pt
        case .bodyRegular: return FontDescription(fontName: FontManager.RobotoFamily.regular.rawValue, size: 15)
        case .bodyMedium: return FontDescription(fontName: FontManager.RobotoFamily.medium.rawValue, size: 15)
        case .bodyBold: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 15)
            
        // Body2 - 14pt
        case .body2Regular: return FontDescription(fontName: FontManager.RobotoFamily.regular.rawValue, size: 14)
        case .body2Medium: return FontDescription(fontName: FontManager.RobotoFamily.medium.rawValue, size: 14)
        case .body2Bold: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 14)
            
        // Caption - 12pt
        case .captionRegular: return FontDescription(fontName: FontManager.RobotoFamily.regular.rawValue, size: 12)
        case .captionMedium: return FontDescription(fontName: FontManager.RobotoFamily.medium.rawValue, size: 12)
        case .captionBold: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 12)
            
        // Caption2 - 11pt
        case .caption2Regular: return FontDescription(fontName: FontManager.RobotoFamily.regular.rawValue, size: 11)
        case .caption2Medium: return FontDescription(fontName: FontManager.RobotoFamily.medium.rawValue, size: 11)
        case .caption2Bold: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 11)
            
        // Small - 10pt
        case .smallRegular: return FontDescription(fontName: FontManager.RobotoFamily.regular.rawValue, size: 10)
        case .smallMedium: return FontDescription(fontName: FontManager.RobotoFamily.medium.rawValue, size: 10)
        case .smallBold: return FontDescription(fontName: FontManager.RobotoFamily.bold.rawValue, size: 10)
        }
    }
}

public enum SyneFont: FontPreset {
    
    // Buttons
    case buttonLarge, buttonMedium, buttonSmall
    
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
    
    var fontDescription: FontDescription {
        switch self {
        // Buttons
        case .buttonLarge: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 18)
        case .buttonMedium: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 16)
        case .buttonSmall: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 14)
            
        // H1 - 34pt
        case .h1Regular: return FontDescription(fontName: FontManager.SyneFamily.regular.rawValue, size: 34)
        case .h1Medium: return FontDescription(fontName: FontManager.SyneFamily.medium.rawValue, size: 34)
        case .h1Bold: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 34)
            
        // H2 - 28pt
        case .h2Regular: return FontDescription(fontName: FontManager.SyneFamily.regular.rawValue, size: 28)
        case .h2Medium: return FontDescription(fontName: FontManager.SyneFamily.medium.rawValue, size: 28)
        case .h2Bold: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 28)
            
        // H3 - 22pt
        case .h3Regular: return FontDescription(fontName: FontManager.SyneFamily.regular.rawValue, size: 22)
        case .h3Medium: return FontDescription(fontName: FontManager.SyneFamily.medium.rawValue, size: 22)
        case .h3Bold: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 22)
            
        // H4 - 18pt
        case .h4Regular: return FontDescription(fontName: FontManager.SyneFamily.regular.rawValue, size: 18)
        case .h4Medium: return FontDescription(fontName: FontManager.SyneFamily.medium.rawValue, size: 18)
        case .h4Bold: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 18)
            
        // Subtitle - 16pt
        case .subtitleRegular: return FontDescription(fontName: FontManager.SyneFamily.regular.rawValue, size: 16)
        case .subtitleMedium: return FontDescription(fontName: FontManager.SyneFamily.medium.rawValue, size: 16)
        case .subtitleBold: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 16)
            
        // Body - 15pt
        case .bodyRegular: return FontDescription(fontName: FontManager.SyneFamily.regular.rawValue, size: 15)
        case .bodyMedium: return FontDescription(fontName: FontManager.SyneFamily.medium.rawValue, size: 15)
        case .bodyBold: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 15)
            
        // Body2 - 14pt
        case .body2Regular: return FontDescription(fontName: FontManager.SyneFamily.regular.rawValue, size: 14)
        case .body2Medium: return FontDescription(fontName: FontManager.SyneFamily.medium.rawValue, size: 14)
        case .body2Bold: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 14)
            
        // Caption - 12pt
        case .captionRegular: return FontDescription(fontName: FontManager.SyneFamily.regular.rawValue, size: 12)
        case .captionMedium: return FontDescription(fontName: FontManager.SyneFamily.medium.rawValue, size: 12)
        case .captionBold: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 12)
            
        // Caption2 - 11pt
        case .caption2Regular: return FontDescription(fontName: FontManager.SyneFamily.regular.rawValue, size: 11)
        case .caption2Medium: return FontDescription(fontName: FontManager.SyneFamily.medium.rawValue, size: 11)
        case .caption2Bold: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 11)
            
        // Small - 10pt
        case .smallRegular: return FontDescription(fontName: FontManager.SyneFamily.regular.rawValue, size: 10)
        case .smallMedium: return FontDescription(fontName: FontManager.SyneFamily.medium.rawValue, size: 10)
        case .smallBold: return FontDescription(fontName: FontManager.SyneFamily.bold.rawValue, size: 10)
        }
    }
}

// MARK: - Font Extension
extension Font {
    static func roboto(_ preset: SyneFont) -> Font {
        return preset.font
    }

    static func syne(_ preset: RobotoFont) -> Font {
        return preset.font
    }
}

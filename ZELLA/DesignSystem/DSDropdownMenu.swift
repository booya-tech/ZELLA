//
//  DSDropdownMenu.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/29/25.
//

import SwiftUI

struct DSDropdownMenu: View {
    let title: String?
    let placeholder: String
    @Binding var selectedValue: String?
    let options: [String]
    var errorMessage: String? = nil
    var showClearButton: Bool = true
    var disabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title (optional)
            if let title = title {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.primaryText)
            }
            
            // Dropdown Menu
            Menu {
                // Clear button
                if showClearButton {
                    Button(AppString.clear) {
                        selectedValue = nil
                    }
                    
                    Divider()
                }
                
                // Options
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selectedValue = option
                    }
                }
            } label: {
                HStack {
                    Text(selectedValue ?? placeholder)
                        .foregroundStyle(selectedValue == nil ? AppColors.secondaryText : AppColors.primaryText)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundStyle(AppColors.secondaryText)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(disabled ? Color(.systemGray5) : Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(errorMessage != nil ? AppColors.error : AppColors.primaryClear, lineWidth: 1)
                )
            }
            .disabled(disabled)
            .opacity(disabled ? 0.6 : 1.0)
            
            // Error Message
            if let errorMessage = errorMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                    Text(errorMessage)
                        .font(.system(size: 12))
                }
                .foregroundStyle(AppColors.error)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Compact Dropdown (No Title)
struct DSCompactDropdown: View {
    let placeholder: String
    @Binding var selectedValue: String?
    let options: [String]
    var showClearButton: Bool = true
    
    var body: some View {
        DSDropdownMenu(
            title: nil,
            placeholder: placeholder,
            selectedValue: $selectedValue,
            options: options,
            showClearButton: showClearButton
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 24) {
        // Standard dropdown with title
        DSDropdownMenu(
            title: "Select Size",
            placeholder: "Choose your size",
            selectedValue: .constant(nil),
            options: ["XS", "S", "M", "L", "XL", "XXL"]
        )
        
        // Dropdown with selected value
        DSDropdownMenu(
            title: "Top Size",
            placeholder: "Select top size",
            selectedValue: .constant("M"),
            options: ["XS", "S", "M", "L", "XL", "XXL"]
        )
        
        // Dropdown with error
        DSDropdownMenu(
            title: "Bottom Size",
            placeholder: "Select bottom size",
            selectedValue: .constant(nil),
            options: ["28", "30", "32", "34", "36"],
            errorMessage: "This field is required"
        )
        
        // Disabled dropdown
        DSDropdownMenu(
            title: "Shoe Size",
            placeholder: "Select shoe size",
            selectedValue: .constant("EU 42 (US 10.5)"),
            options: ["EU 40", "EU 41", "EU 42", "EU 43"],
            disabled: true
        )
        
        // Compact dropdown (no title)
        DSCompactDropdown(
            placeholder: "Quick select",
            selectedValue: .constant(nil),
            options: ["Option 1", "Option 2", "Option 3"]
        )
    }
    .padding()
}

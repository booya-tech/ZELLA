//
//  DSTextField.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import SwiftUI

struct DSTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil

    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        HStack {
            Group {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .frame(height: 40)
            .autocapitalization(.none)
            .disableAutocorrection(true)

            if isSecure {
                Button(action: { isPasswordVisible.toggle() }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(AppColors.textFieldBorder)
                        .frame(width: 16, height: 16)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color(.clear))
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(AppColors.textFieldBorder, lineWidth: 1)
        )
    }
}

#Preview {
    DSTextField(
        placeholder: "Enter your email",
        text: .constant("test@gmail.com"),
        isSecure: false
    )
    DSTextField(
        placeholder: "Enter your email",
        text: .constant("test@gmail.com"),
        isSecure: true
    )
}

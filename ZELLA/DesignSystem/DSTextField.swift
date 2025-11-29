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
    var autocapitalization: TextInputAutocapitalization = .never
    var disabled: Bool = false

    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        HStack {
            Group {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                        .textInputAutocapitalization(autocapitalization)
                }
            }
            .frame(height: 40)
            .disableAutocorrection(true)
            .disabled(disabled)

            if isSecure {
                Button(action: { isPasswordVisible.toggle() }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(AppColors.textFieldBorder)
                        .frame(width: 16, height: 16)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(disabled ? Color(.systemGray6) : Color(.clear))
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(AppColors.textFieldBorder, lineWidth: 1)
        )
        .opacity(disabled ? 0.6 : 1.0)
    }
}

// MARK: - Text Area (Multi-line)
struct DSTextArea: View {
    let placeholder: String
    @Binding var text: String
    var minHeight: CGFloat = 100
    var maxHeight: CGFloat = 200
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
            
            TextEditor(text: $text)
                .frame(minHeight: minHeight, maxHeight: maxHeight)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .scrollContentBackground(.hidden)
        }
        .background(Color(.clear))
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(AppColors.textFieldBorder, lineWidth: 1)
        )
    }
}

// MARK: - Search Field
struct DSSearchField: View {
    @Binding var text: String
    var placeholder: String = "Search..."
    var onSearch: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onSubmit {
                    onSearch()
                }
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 20) {
        DSTextField(
            placeholder: "Enter your email",
            text: .constant("test@gmail.com"),
            isSecure: false,
        )
        
        DSTextField(
            placeholder: "Enter password",
            text: .constant("password123"),
            isSecure: true
        )
        
        DSTextArea(
            placeholder: "Write a description...",
            text: .constant("")
        )
        
        DSSearchField(text: .constant(""))
    }
    .padding()
}

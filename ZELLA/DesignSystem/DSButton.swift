//
//  DSButton.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import SwiftUI

// MARK: - Primary Button
struct DSPrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(4)
        }
        .disabled(isLoading)
    }
}

// MARK: - Social Button
struct DSSocialButton: View {
    let title: String
    let icon: String
    let iconType: IconType
    let action: () -> Void
    
    enum IconType {
        case system
        case image
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                if iconType == .system {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                } else {
                    Image(icon)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                
                Text(title)
                    .fontWeight(.medium)
                    .font(.system(size: 16))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(AppColors.textFieldBorder, lineWidth: 0.5)
            )
        }
    }
}

// MARK: - Text Button
struct DSTextButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

//MARK: - Resend Button
struct DSResendButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.black)
                .cornerRadius(4)
        }
    }
}

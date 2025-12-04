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
    let type: DSButtonType
    let action: () -> Void
    var isLoading: Bool = false
    
    enum DSButtonType {
        case normal
        case destructive
    }
    
    var body: some View {
        Button(action: action) {
            if type == .normal {
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
                .frame(height: 50)
                .background(AppColors.primaryBlack)
                .foregroundColor(.white)
                .cornerRadius(8)
            } else if type == .destructive {
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
                .frame(height: 50)
                .foregroundStyle(.red)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
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
    
    enum IconType: Equatable {
        case system
        case image
        case fontAwesome(FontAwesomeIcon.FontAwesomeStyle)
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                
                Group {
                    switch iconType {
                    case .system:
                        Image(systemName: icon)
                            .font(.system(size: 16))
                    case .image:
                        Image(icon)
                            .resizable()
                            .frame(width: 16, height: 16)
                    case .fontAwesome(let style):
                        FontAwesomeIcon(icon, style: style, size: 16)
                    }
                }
                
                Text(title)
                    .fontWeight(.medium)
                    .font(.system(size: 16))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(AppColors.primaryWhite)
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

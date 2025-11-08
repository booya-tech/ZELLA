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
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(8)
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
            HStack(spacing: 12) {
                if iconType == .system {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                } else {
                    Image(icon)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                Text(title)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
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

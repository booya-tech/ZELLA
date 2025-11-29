//
//  DSDivider.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import SwiftUI

struct DSDivider: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1)
        }
    }
}

// MARK: - Section Divider (with padding)
struct DSSectionDivider: View {
    var padding: CGFloat = 16
    var color: Color = Color(.systemGray4)
    var thickness: CGFloat = 1
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: thickness)
            .padding(.horizontal, padding)
    }
}

// MARK: - Thick Divider (for major sections)
struct DSThickDivider: View {
    var color: Color = Color(.systemGray5)
    var height: CGFloat = 4
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Text Divider")
        DSDivider(text: "OR")
        
        Text("Section Divider")
        DSSectionDivider()
        
        Text("Thick Divider")
        DSThickDivider()
    }
    .padding()
}
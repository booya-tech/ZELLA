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

#Preview {
    DSDivider(text: "OR")
}

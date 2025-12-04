//
//  DSHeaderTextSection.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/4/25.
//

import SwiftUI

struct DSHeaderTextSection: View {
    let title: String
    let icon: String = "chevron.right"
    let onSeeAllTap: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            

            Spacer()

            Button(action: onSeeAllTap) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    DSHeaderTextSection(title: "Trending", onSeeAllTap: {})
}

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
                .font(.syne(.h2Regular))
            

            Spacer()

            Button(action: onSeeAllTap) {
                FontAwesomeIcon(FontAwesome.Icon.chevronRight, size: 16)
                    .foregroundStyle(AppColors.primaryBlack)
            }
        }
        .padding(.vertical, Constants.thirdPadding)
        .padding(.horizontal, Constants.mainPadding)
    }
}

#Preview {
    DSHeaderTextSection(title: "Trending", onSeeAllTap: {})
}

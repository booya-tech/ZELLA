//
//  ProfileImageSkeleton.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/13/25.
//

import SwiftUI

struct ProfileImageSkeleton: View {
    let size: CGFloat
    let title: String
    
    var body: some View {
        Circle()
            .fill(AppColors.secondaryBackground)
            .frame(width: size, height: size)
            .overlay {
                Text(title.prefix(1))
                    .font(.roboto(.h3Bold))
                    .foregroundStyle(AppColors.primaryBlack)
            }
    }
}

#Preview {
    ProfileImageSkeleton(size: 48, title: "ZELLA")
}

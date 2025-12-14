//
//  SellerInfoView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/13/25.
//

import SwiftUI
import FirebaseFirestore

struct SellerInfoView: View {
    let seller: Seller
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Constants.secondaryPadding) {
                // Profile Image
                if let imageName = seller.localImageName, let image = UIImage(named: imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                } else {
                    ProfileImageSkeleton(
                        size: 48,
                        title: seller.name
                    )
                }

                // Seller Info
                VStack(alignment: .leading, spacing: Constants.fourthPadding) {
                    // Name
                    Text(seller.name.uppercased())
                        .font(.roboto(.subtitleRegular))
                        .foregroundStyle(AppColors.primaryBlack)

                    // Display ID
                    HStack(spacing: Constants.fourthPadding) {
                        Text("ID:")
                            .font(.roboto(.body2Regular))
                            .foregroundStyle(AppColors.primaryBlack)

                        Text(seller.displayID)
                            .font(.roboto(.body2Regular))
                            .foregroundStyle(AppColors.primaryBlack)
                    }

                    // Active Status
                    Text(seller.activeStatus)
                        .font(.roboto(.captionRegular))
                        .foregroundStyle(seller.isActive ? AppColors.success : AppColors.primaryGrey)
                }

                Spacer()

                // Rating
                HStack(spacing: Constants.fourthPadding) {
                    // Rating Star
                    FontAwesomeIcon(FontAwesome.Icon.star, size: 16)
                        .foregroundStyle(AppColors.primaryYellow)
                    // Rating Count
                    Text(String(format: "%.1f", seller.rating))
                        .font(.roboto(.subtitleRegular))
                        .foregroundStyle(AppColors.primaryBlack)
                }
            }
            .padding(Constants.mainPadding)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SellerInfoView(
        seller: Seller(
            id: "11111",
            name: "ZELLA SELLER",
            profileImageURL: nil,
            rating: 5.0,
            isActive: true,
            joinedDate: Timestamp(date: Date()),
            localImageName: nil
        ),
        onTap: {}
    )
    
    SellerInfoView(
        seller: Seller(
            id: "11111",
            name: "ZELLA SELLER",
            profileImageURL: nil,
            rating: 5.0,
            isActive: false,
            joinedDate: Timestamp(date: Date()),
            localImageName: nil
        ),
        onTap: {}
    )

}

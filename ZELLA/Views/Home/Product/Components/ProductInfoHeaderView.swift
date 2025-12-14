//
//  ProductInfoHeaderView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/13/25.
//

import SwiftUI
import FirebaseFirestore

struct ProductInfoHeaderView: View {
    let item: Item
    @Binding var isFavorite: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.secondaryPadding) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Constants.secondaryPadding) {
                    // Brand
                    Text(item.brand.uppercased())
                        .font(.syne(.h3Regular))
                        .foregroundStyle(AppColors.primaryBlack)

                    // Title
                    Text(item.title)
                        .font(.roboto(.subtitleRegular))
                        .foregroundStyle(AppColors.primaryBlack)
                }

                Spacer()

                // Favorite Button
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundStyle(isFavorite ? AppColors.primaryRed : AppColors.primaryBlack)
                }
            }

            // Price Section
            HStack(spacing: Constants.secondaryPadding) {
                // Full Price
                Text("฿\(String(format: "%.0f", item.price))")
                    .font(.roboto(.subtitleRegular))
                    .foregroundStyle(AppColors.primaryBlack)

                // Discounted Price
                if let originalPrice = item.originalPrice, item.hasDiscount {
                    Text("฿\(String(format: "%.0f", originalPrice))")
                        .font(.roboto(.subtitleRegular))
                    .foregroundStyle(AppColors.primaryBlack)

                    if let discount = item.discountPercentage {
                        Text("-\(discount)%")
                            .font(.roboto(.subtitleRegular))
                            .foregroundStyle(AppColors.primaryRed)
                    }
                } 
            }
        }
        .padding(.horizontal, Constants.mainPadding)
        .padding(.vertical, Constants.secondaryPadding)
    }
}

#Preview {
    ProductInfoHeaderView(
        item: Item(
            id: "1",
            sellerID: "seller1",
            title: "Soft Henley Neck Round Long Sleeve Knit [Gray]",
            price: 1000,
            condition: .newWithTags,
            category: .top,
            brand: "NODU",
            size: "M",
            description: "Beautiful shirt in excellent condition",
            imageURLs: [],
            status: .available,
            postedDate: Timestamp(date: Date()),
            originalPrice: 999,
            localImageNames: ["black_shirt_01"]
        ),
        isFavorite: .constant(false)
    )
}

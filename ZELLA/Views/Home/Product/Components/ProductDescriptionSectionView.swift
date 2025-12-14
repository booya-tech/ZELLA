//
//  ProductDescriptionSectionView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/13/25.
//

import SwiftUI
import FirebaseFirestore

struct ProductDescriptionSectionView: View {
    let item: Item
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Constants.mainPadding) {
                // Header
                Text(AppString.productDescriptionSectionTitle)
                    .font(.roboto(.h4Medium))
                    .foregroundStyle(AppColors.primaryBlack)
                // Item's Title
                Text(item.title)
                    .font(.roboto(.body2Regular))
                    .foregroundStyle(AppColors.primaryBlack)
                // Item's Description
                Text(item.description)
                    .font(.roboto(.body2Regular))
                    .foregroundStyle(AppColors.primaryBlack)
                // Item's Price
                Text("฿\(String(format: "%.0f", item.price))")
                    .font(.roboto(.body2Regular))
                    .foregroundStyle(AppColors.primaryBlack)

                Divider()

                // Details Grid
                VStack(spacing: Constants.secondaryPadding) {
                    DetailRow(label: AppString.productDescriptionSectionSize, value: item.size)
                    DetailRow(label: AppString.productDescriptionSectionCategory, value: item.category.displayName)
                    DetailRow(label: AppString.productDescriptionSectionBrand, value: item.brand)
                    DetailRow(label: AppString.productDescriptionSectionCondition, value: item.condition.rawValue)
                }

                Divider()

                // Product Details
                VStack(alignment: .leading, spacing: Constants.secondaryPadding) {
                    Text(AppString.productDetailsSectionTitle)
                        .font(.roboto(.h4Medium))
                        .foregroundStyle(AppColors.primaryBlack)

                    Text(
                        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters."
                    )
                    .font(.roboto(.body2Regular))
                    .foregroundStyle(AppColors.primaryBlack)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Constants.mainPadding)
        }
        .buttonStyle(.plain)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.roboto(.body2Regular))
                .foregroundStyle(AppColors.primaryBlack)
            
            Spacer()
            
            Text(value)
                .font(.roboto(.body2Regular))
                .foregroundStyle(AppColors.primaryBlack)
        }
    }
}

#Preview {
    ProductDescriptionSectionView(
        item: Item(
            id: "1",
            sellerID: "seller1",
            title: "NODU",
            price: 1000,
            condition: .likeNew,
            category: .top,
            brand: "Balenciaga",
            size: "M",
            description: "Soft Henley Neck Round Long Sleeve Knit [Gray]",
            imageURLs: [],
            status: .available,
            postedDate: Timestamp(date: Date()),
            originalPrice: nil,
            localImageName: "black_shirt_01",
            localImageNames: ["black_shirt_01"]
        ),
        onTap: {}
    )
}

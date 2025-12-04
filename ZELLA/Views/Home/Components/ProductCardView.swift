//
//  ProductCardView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/3/25.
//

import SwiftUI
import FirebaseCore

struct ProductCardView: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product Image
            ZStack(alignment: .topTrailing) {
                if let imageName = item.localImageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .aspectRatio(1, contentMode: .fill)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundStyle(.gray)
                        }
                }
                
                // Condition Badge
                if item.condition == .newWithTags {
                    Text("NEW")
                        .font(.syne(.smallRegular))
                        .foregroundStyle(AppColors.primaryWhite)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(AppColors.primaryBlack)
                        .cornerRadius(3)
                        .padding(6)
                }
            }
            .cornerRadius(4)
            
            // Product Info
            VStack(alignment: .leading) {
                // Brand
                Text(item.brand.uppercased())
                    .font(.roboto(.smallMedium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                // Title
                Text(item.title)
                    .font(.roboto(.smallRegular))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                // Price
                Text("฿\(String(format: "%.0f", item.price))")
                    .font(.roboto(.smallMedium))
                    .foregroundStyle(.black)
            }
        }
    }
}

struct CompactProductCardView: View {
    let item: Item
    let width: CGFloat = 140
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.secondaryPadding) {
            // Product Image
            ZStack(alignment: .topTrailing) {
                if let imageName = item.localImageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .aspectRatio(1, contentMode: .fill)
                        .overlay {
                            FontAwesomeIcon(FontAwesome.Icon.camera)
                        }
                }
                
                // Condition Badge
                if item.condition == .newWithTags {
                    Text("NEW")
                        .font(.syne(.smallBold))
                        .foregroundStyle(AppColors.primaryWhite)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(AppColors.primaryBlack)
                        .cornerRadius(3)
                        .padding(6)
                }
            }
            .cornerRadius(4)
            
            // Product Info
            VStack(alignment: .leading) {
                // Brand
                Text(item.brand.uppercased())
                    .font(.syne(.smallMedium))
                    .foregroundStyle(AppColors.primaryBlack)
                    .lineLimit(1)
                
                // Title
                Text(item.title)
                    .font(.syne(.body2Medium))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                // Price
                Text("฿\(String(format: "%.0f", item.price))")
                    .font(.syne(.body2Medium))
                    .foregroundStyle(.black)
            }
            .frame(width: width)
        }
        .frame(width: width)
    }
}

#Preview {
    let mockItem = Item(
        id: "1",
        sellerID: "seller1",
        title: "Black Shirt One",
        price: 1990,
        condition: .newWithTags,
        category: .top,
        brand: "ZARA",
        size: "M",
        description: "Sample description",
        imageURLs: [],
        status: .available,
        postedDate: Timestamp(date: Date()),
        localImageName: "black_shirt_01"
    )
    
    HStack(spacing: 20) {
        ProductCardView(item: mockItem)
            .frame(width: 120)
        
        CompactProductCardView(item: mockItem)
    }
    .padding()
}

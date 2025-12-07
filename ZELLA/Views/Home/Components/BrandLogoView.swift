//
//  BrandLogoView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/4/25.
//

import SwiftUI

struct BrandLogoView: View {
    let brand: Brand
    let size: CGFloat = 80

    var body: some View {
        VStack(spacing: Constants.secondaryPadding) {
            // Brand Logo
            if let imageName = brand.localImageName {
                ZStack {
                    Rectangle()
                        .fill(AppColors.primaryWhite)
                        .frame(width: size, height: size)
                        .cornerRadius(Constants.buttonRadius)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        // 0.7 means 30% padding around the image
                        .frame(width: size * 0.7, height: size * 0.7)
                }
            } else {
                // Placeholder with brand name
                ZStack {
                    Rectangle()
                        .fill(AppColors.primaryClear)
                        .frame(width: size, height: size)
                        .cornerRadius(Constants.secondaryPadding)

                    Text(brand.name.prefix(2))
                        .font(.roboto(.h3Bold))
                        .foregroundStyle(AppColors.primaryBlack)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.buttonRadius)
                            .stroke(AppColors.primaryWhite, lineWidth: 0.1)
                }
            }
        }
    }
}

// MARK: - Brand Horizontal Section
struct BrandSectionView: View {
    let brands: [Brand]
    let onSeeAllTap: () -> Void
    let onTapBrand: (Brand) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            DSHeaderTextSection(title: "Brands", onSeeAllTap: onSeeAllTap)

            // Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Constants.secondaryPadding) {
                    ForEach(brands) { brand in
                        Button(action: { onTapBrand(brand) }) {
                            BrandLogoView(brand: brand)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, Constants.thirdPadding)
                .padding(.horizontal, Constants.mainPadding)
            }
        }
    }
}

#Preview {
    let mockBrands = MockDataService.shared.getBrands()

    VStack(spacing: 20) {
        BrandLogoView(brand: mockBrands[0])

        BrandSectionView(brands: mockBrands, onSeeAllTap: {}, onTapBrand: { _ in })
    }
    .padding()
}

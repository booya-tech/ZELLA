//
//  ProductImageGalleryView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/13/25.
//

import SwiftUI

struct ProductImageGalleryView: View {
    let imageNames: [String]
    @State private var currentIndex = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 420)
                        .clipped()
                        .tag(index)
                }
            }
            .frame(height: 420)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom Page Indicators
            if imageNames.count > 1 {
                HStack(spacing: 6) {
                    ForEach(0..<imageNames.count, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? AppColors.primaryWhite : AppColors.primaryWhite.opacity(0.5))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.bottom, Constants.mainPadding)
            }
        }
    }
}

#Preview {
    ProductImageGalleryView(imageNames: ["dress_01", "dress_02", "dress_03"])
}

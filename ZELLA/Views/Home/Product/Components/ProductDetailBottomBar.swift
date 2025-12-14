//
//  ProductDetailBottomBar.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/13/25.
//

import SwiftUI

struct ProductDetailBottomBar: View {
    let onChatTap: () -> Void
    let onAddToBag: () -> Void
    
    var body: some View {
        HStack(spacing: Constants.secondaryPadding) {
            // Chat Button
            Button(action: onChatTap) {
                FontAwesomeIcon(FontAwesome.Icon.message, style: .regular, size: 24)
                    .foregroundStyle(AppColors.primaryBlack)
            }
            .frame(width: 56, height: 56)
            .cornerRadius(Constants.buttonRadius)
            
            // Add to Bag Button
            DSPrimaryButton(
                title: "ADD TO BAG",
                type: .normal,
                action: onAddToBag
            )
        }
        .padding(.horizontal, Constants.mainPadding)
        .padding(.vertical, Constants.secondaryPadding)
        .background(AppColors.background)
        .shadow(color: Color.black.opacity(0.1), radius: 8, y: -2)
    }
}

#Preview {
    VStack {
        Spacer()
        ProductDetailBottomBar(
            onChatTap: {},
            onAddToBag: {}
        )
    }
}

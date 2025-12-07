//
//  HorizontalSectionView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/3/25.
//

import SwiftUI

struct HorizontalSectionView: View {
    let title: String
    let items: [Item]
    let onTapItem: (Item) -> Void
    let onSeeAllTap: () -> Void

    // Dynamic card width based on screen size
    private var cardWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding = Constants.mainPadding * 2
        let spacing = Constants.secondaryPadding
        /// Description
        /// Show 2.5 cards on screen for better UX
        /// 2.5 = 2 cards + 0.5 card spacing
        return (screenWidth - padding - spacing * 2) / 2.5
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Section Header
            DSHeaderTextSection(
                title: title,
                onSeeAllTap: onSeeAllTap
            )

            // Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Constants.secondaryPadding) {
                    ForEach(items) { item in
                        Button(action: { onTapItem(item) }) {
                            CompactProductCardView(item: item, width: cardWidth)
                        }
                    }
                }
                .padding(.horizontal, Constants.mainPadding)
            }
        }    
    }
}

#Preview {
    let mockItems = MockDataService.shared.getTrending()
    
    HorizontalSectionView(
        title: "Trending",
        items: mockItems,
        onTapItem: { _ in },
        onSeeAllTap: {}
    )
}

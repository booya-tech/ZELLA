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
    
    var body: some View {
        VStack(alignment: .leading) {
            // Section Header
            DSHeaderTextSection(title: title, onSeeAllTap: onSeeAllTap)

            // Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Constants.itemPadding) {
                    ForEach(items) { item in
                        Button(action: { onTapItem(item) }) {
                            CompactProductCardView(item: item)
                        }
                    }
                }
                .padding(.horizontal, Constants.sectionPadding)
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

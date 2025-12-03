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
        VStack(alignment: .leading, spacing: 12) {
            // Section Header
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                

                Spacer()

                Button(action: onSeeAllTap) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal, 16)

            // Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(items) { item in
                        Button(action: { onTapItem(item) }) {
                            CompactProductCardView(item: item)
                        }
                    }
                }
                .padding(.horizontal, 16)
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

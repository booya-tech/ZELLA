//
//  CategoryTabBar.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/4/25.
//

import SwiftUI

struct CategoryTabBar: View {
    @Binding var selectedCategory: ItemCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.mainPadding) {
                ForEach(ItemCategory.allCases, id: \.self) { category in
                    // Category Tab Filter
                    CategoryTab(
                        title: category.displayName,
                        isSelected: selectedCategory == category) {
                            selectedCategory = category
                        }
                }
            }
            .padding(.horizontal, Constants.mainPadding)
            .padding(.vertical, Constants.secondaryPadding)
        }
    }
}

struct CategoryTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.roboto(isSelected ? .body2Medium : .body2Regular))
                    .foregroundStyle(isSelected ? AppColors.primaryBlack : AppColors.primaryGrey)
                
                Rectangle()
                    .fill(isSelected ? AppColors.primaryBlack : AppColors.primaryClear)
                    .frame(height: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        CategoryTabBar(selectedCategory: .constant(.all))
        CategoryTabBar(selectedCategory: .constant(.top))
        CategoryTabBar(selectedCategory: .constant(.pants))
    }
}

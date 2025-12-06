//
//  HomeView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//
import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var selectedItem: Item?
    
    var body: some View {
        NavigationStack {
            VStack {
                headerView
                
                ScrollView {
                    VStack(spacing: Constants.sectionSpacing) {
                        if !viewModel.heroBanners.isEmpty {
                            HeroCarouselView(
                                banners: viewModel.heroBanners,
                                currentIndex: $viewModel.currentHeroIndex
                            )
                        }
                        
                        if !viewModel.recentlyViewedItems.isEmpty {
                            HorizontalSectionView(
                                title: AppString.recentlyViewed,
                                items: viewModel.recentlyViewedItems,
                                onTapItem: { selectedItem = $0 },
                                onSeeAllTap: {}
                            )
                        }
                        
                        if !viewModel.trendingItems.isEmpty {
                            HorizontalSectionView(
                                title: AppString.trending,
                                items: viewModel.trendingItems,
                                onTapItem: { selectedItem = $0 },
                                onSeeAllTap: {}
                            )
                        }
                        
                        if !viewModel.suggestedStore.isEmpty {
                            HorizontalSectionView(
                                title: AppString.suggestedStore,
                                items: Array(viewModel.trendingItems.prefix(10)),
                                onTapItem: { selectedItem = $0 },
                                onSeeAllTap: {}
                            )
                        }
                        
                        if !viewModel.suggestedBrands.isEmpty {
                            BrandSectionView(
                                brands: viewModel.suggestedBrands,
                                onSeeAllTap: {},
                                onTapBrand: { _ in }
                            )
                        }
                        
                        DSHeaderTextSection(
                            title: AppString.myFeed,
                            onSeeAllTap: {}
                        )
                    }
                }
                //                CategoryTabBar(selectedCategory: $viewModel.selectedCategoty)
                //
                //                MyFeedView(selectedCategory: $viewModel.selectedCategoty) { item in
                //                    selectedItem = item
                //                }
            }
        }
//        .navigationDestination(item: $selectedItem, {})
        .task {
            viewModel.loadMockData()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundStyle(AppColors.primaryBlack)
            }
            
            Spacer()
            
            Text(AppString.appName)
                .font(.syne(.h2Regular) )
                .foregroundStyle(AppColors.primaryBlack)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bag")
                    .font(.system(size: 20))
                    .foregroundStyle(AppColors.primaryBlack)
            }
        }
        .padding(.horizontal, Constants.mainPadding)
        .padding(.vertical, Constants.secondaryPadding)
        .background(AppColors.primaryClear)
    }
}

#Preview {
    HomeView()
}

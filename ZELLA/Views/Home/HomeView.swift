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
                        // Banner
                        if !viewModel.heroBanners.isEmpty {
                            HeroCarouselView(
                                banners: viewModel.heroBanners,
                                bannerHeight: Constants.bannerHeight,
                                currentIndex: $viewModel.currentHeroIndex
                            )
                        }
                        // Recently Viewed
                        if !viewModel.recentlyViewedItems.isEmpty {
                            HorizontalSectionView(
                                title: AppString.recentlyViewed,
                                items: viewModel.recentlyViewedItems,
                                onTapItem: { selectedItem = $0 },
                                onSeeAllTap: {}
                            )
                        }
                        // Trending
                        if !viewModel.trendingItems.isEmpty {
                            HorizontalSectionView(
                                title: AppString.trending,
                                items: viewModel.trendingItems,
                                onTapItem: { selectedItem = $0 },
                                onSeeAllTap: {}
                            )
                        }
                        // Brands
                        if !viewModel.suggestedBrands.isEmpty {
                            BrandSectionView(
                                brands: viewModel.suggestedBrands,
                                onSeeAllTap: {},
                                onTapBrand: { _ in }
                            )
                        }
                        // Suggested Store
                        if !viewModel.suggestedStore.isEmpty {
                            HorizontalSectionView(
                                title: AppString.suggestedStore,
                                items: Array(viewModel.trendingItems.prefix(10)),
                                onTapItem: { selectedItem = $0 },
                                onSeeAllTap: {}
                            )
                        }
                        
                        // My Feed
                        DSHeaderTextSection(
                            title: AppString.myFeed,
                            onSeeAllTap: {}
                        )
                        CategoryTabBar(selectedCategory: $viewModel.selectedCategory)
                        myFeedGridSection
                    }
                }
            }
        }
//        .navigationDestination(item: $selectedItem, {})
        .task {
            viewModel.loadMockData()
            viewModel.loadMyFeed()
        }
    }
    
    private var myFeedGridSection: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ],
            spacing: 8
        ) {
            ForEach(Array(viewModel.myFeeditems.enumerated()), id: \.element.id) { index, item in
                Button {
                    selectedItem = item
                } label: {
                    ProductCardView(item: item)
                }
                .buttonStyle(.plain)
                .onAppear {
                    // Load more
                    if index >= viewModel.myFeeditems.count - 5 {
                        viewModel.loadMyFeed()
                    }
                }
            }

            // Loading indicator
            if viewModel.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .gridCellColumns(3)
                .padding()
            }
        }
        .padding(.horizontal, Constants.mainPadding)
    }

    private var headerView: some View {
        HStack {
            Button(action: {}) {
                FontAwesomeIcon(FontAwesome.Icon.magnifyingGlass, size: 20)
                    .foregroundStyle(AppColors.primaryBlack)
            }
            
            Spacer()
            
            Text(AppString.appName)
                .font(.syne(.h2Regular) )
                .foregroundStyle(AppColors.primaryBlack)
            
            Spacer()
            
            Button(action: {}) {
                FontAwesomeIcon(FontAwesome.Icon.shoppingBag, size: 20)
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

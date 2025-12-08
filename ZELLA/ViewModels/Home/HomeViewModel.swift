//
//  HomeViewModel.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/5/25.
//

import Foundation
import Observation

@Observable
class HomeViewModel {
    // My Feed pagination
    var myFeeditems: [Item] = []
    var selectedCategory: ItemCategory = .all {
        didSet {
            if selectedCategory != oldValue {
                resetFeed()
            }
        }
    }

    var currentPage = 0
    var isLoadingMore = false
    var hasMoreItems = true
    
    var heroBanners: [HeroBanner] = []
    var recentlyViewedItems: [Item] = []
    var trendingItems: [Item] = []
    var suggestedStore: [Store] = []
    var suggestedBrands: [Brand] = []
    var currentHeroIndex: Int = 0
    var isLoading: Bool = false
    
    private let mockDataService: MockDataService
    
    init(mockDataService: MockDataService = .shared) {
        self.mockDataService = mockDataService
    }
    
    func loadMockData() {
        isLoading = true
        heroBanners = mockDataService.getHeroBanner()
        recentlyViewedItems = mockDataService.getRecentlyViewed()
        trendingItems = mockDataService.getTrending()
        suggestedStore = mockDataService.getStores()
        suggestedBrands = mockDataService.getBrands()
        isLoading = false
        Logger.log("🟢 Home mock data loaded successfully")
    }

    func loadMyFeed() {
        guard !isLoadingMore && hasMoreItems else { return }

        isLoadingMore = true

        Task {
            let newItems = MockDataService.shared.getItems(
                page: currentPage,
                pageSize: 20,
                category: selectedCategory
            )

            await MainActor.run {
                if newItems.isEmpty {
                    hasMoreItems = false
                } else {
                    myFeeditems.append(contentsOf: newItems)
                    currentPage += 1
                }
                isLoadingMore = false
            }
        }
    }

    private func resetFeed() {
        myFeeditems = []
        currentPage = 0
        hasMoreItems = true
        loadMyFeed()
    }
}

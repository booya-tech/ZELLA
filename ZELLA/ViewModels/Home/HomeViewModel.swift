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
    var heroBanners: [HeroBanner] = []
    var recentlyViewedItems: [Item] = []
    var trendingItems: [Item] = []
    var suggestedStore: [Store] = []
    var suggestedBrands: [Brand] = []
    var selectedCategoty: ItemCategory = .all
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
}

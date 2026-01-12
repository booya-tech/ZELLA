//
//  SearchViewModel.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 1/6/26.
//

import Foundation
import Observation

@Observable
class SearchViewModel {
    // MARK: - Properties
    var searchText: String = "" {
        didSet { performDebouncedSearch() }
    }
    var selectedCategory: ItemCategory = .all {
        didSet { performDebouncedSearch() }
    }

    var filteredItems: [Item] = []
    var recentSearches: [String] = []
    var isSearching: Bool = false
    var isLoadingMore: Bool = false
    var hasSearched: Bool = false
    var hasMoreResults: Bool = false
    var errorMessage: String?
    var totalResultsCount: Int = 0

    // MARK: - Private Properties
    private let searchService: SearchServiceProtocol
    private var searchTask: Task<Void, Never>?
    private let debounceDelay: Duration = .milliseconds(300)
    private var currentPage: Int = 0

    // MARK: - Computed Properties
    var showEmptyState: Bool {
        hasSearched && filteredItems.isEmpty && !searchText.isEmpty && errorMessage == nil
    }

    var showRecentSearches: Bool {
        searchText.isEmpty && !recentSearches.isEmpty
    }
    
    var showError: Bool {
        errorMessage != nil
    }

    // MARK: - Init
    init(searchService: SearchServiceProtocol = MockDataService.shared) {
        self.searchService = searchService
        loadRecentSearches()
    }

    deinit {
        searchTask?.cancel()
    }

    // MARK: - Search Methods
    private func performDebouncedSearch() {
        searchTask?.cancel()
        errorMessage = nil

        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            resetSearch()
            return
        }

        isSearching = true

        searchTask = Task { @MainActor in
            do {
                try await Task.sleep(for: debounceDelay)
                guard !Task.isCancelled else {
                    isSearching = false
                    return
                }
                await performSearch(resetResults: true)
            } catch {
                isSearching = false
            }
        }
    }

    @MainActor
    private func performSearch(resetResults: Bool) async {
        let query = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            resetSearch()
            return
        }

        if resetResults {
            currentPage = 0
            filteredItems = []
        }

        do {
            let result = try await searchService.searchItems(
                query: query,
                category: selectedCategory,
                page: currentPage,
                pageSize: Constants.searchPageSize
            )
            
            if resetResults {
                filteredItems = result.items
            } else {
                filteredItems.append(contentsOf: result.items)
            }
            
            totalResultsCount = result.totalCount
            hasMoreResults = result.hasMore
            errorMessage = nil
        } catch {
            errorMessage = (error as? SearchError)?.errorDescription ?? error.localizedDescription
        }

        isSearching = false
        isLoadingMore = false
        hasSearched = true
    }
    
    // MARK: - Pagination
    func loadMoreIfNeeded(currentItem: Item) {
        guard let lastItem = filteredItems.last,
              lastItem.id == currentItem.id,
              hasMoreResults,
              !isLoadingMore else { return }
        
        loadMore()
    }
    
    func loadMore() {
        guard hasMoreResults, !isLoadingMore, !isSearching else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        Task { @MainActor in
            await performSearch(resetResults: false)
        }
    }
    
    private func resetSearch() {
        filteredItems = []
        hasSearched = false
        isSearching = false
        currentPage = 0
        hasMoreResults = false
        totalResultsCount = 0
        errorMessage = nil
    }
    
    // MARK: - Error Handling
    func retrySearch() {
        errorMessage = nil
        isSearching = true
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            await performSearch(resetResults: true)
        }
    }

    func saveToRecentSearches() {
        guard !searchText.isEmpty else { return }
        addToRecentSearches(searchText)
    }

    // MARK: - Recent Searches
    private func addToRecentSearches(_ search: String) {
        let trimmed = search.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        recentSearches.removeAll { $0.lowercased() == trimmed.lowercased() }
        recentSearches.insert(trimmed, at: 0)

        if recentSearches.count > Constants.recentSearchesMaxCount {
            recentSearches = Array(recentSearches.prefix(Constants.recentSearchesMaxCount))
        }

        saveRecentSearches()
    }

    func removeRecentSearch(_ search: String) {
        recentSearches.removeAll { $0 == search }
        saveRecentSearches()
    }

    func clearRecentSearches() {
        recentSearches = []
        saveRecentSearches()
    }

    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: Constants.recentSearchesKey)
    }

    private func loadRecentSearches() {
        if let savedRecentSearches = UserDefaults.standard.stringArray(forKey: Constants.recentSearchesKey) {
            recentSearches = savedRecentSearches
        }
    }

    // Cancel Search
    func cancelSearch() {
        searchTask?.cancel()
        isSearching = false
        isLoadingMore = false
    }
}

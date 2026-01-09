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
    var hasSearched: Bool = false

    // MARK: - Private Properties
    private var searchTask: Task<Void, Never>?
    private let debounceDelay: UInt64 = 300_000_000 // 300ms in nanoseconds

    // MARK: - Computed Properties
    var showEmptyState: Bool {
        hasSearched && filteredItems.isEmpty && !searchText.isEmpty
    }

    var showRecentSearches: Bool {
        searchText.isEmpty && !recentSearches.isEmpty
    }

    // MARK: - Init
    init() {
        loadRecentSearches()
    }

    deinit {
        searchTask?.cancel()
    }

    // MARK: - Search Methods
    private func performDebouncedSearch() {
        searchTask?.cancel()

        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            filteredItems = []
            hasSearched = false
            isSearching = false
            return
        }

        guard !searchText.isEmpty else { 
            filteredItems = []
            hasSearched = false    
            return
        }

        isSearching = true

        searchTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: debounceDelay)

                // Check if cancelled
                guard !Task.isCancelled else {
                    isSearching = false
                    return
                }

                performSearch()
            } catch {
                isSearching = false
            }
        }
    }

    @MainActor
    private func performSearch() {
        guard !searchText.isEmpty else {
            filteredItems = []
            isSearching = false
            return
        }

        defer {
            isSearching = false
            hasSearched = true
        }

        let query = searchText.lowercased().trimmingCharacters(in: .whitespaces)

        // Search in MockDataService
        filteredItems = MockDataService.shared.searchItems(
            query: query,
            category: selectedCategory
        )
    }

    func submitSearch() {
        guard !searchText.isEmpty else { return }

        // Add to recent searches
        addToRecentSearches(searchText)
    }

    private func addToRecentSearches(_ search: String) {
        let trimmed = search.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        // Remove if already exists, add to front
        recentSearches.removeAll { $0.lowercased() == trimmed.lowercased() }
        recentSearches.insert(trimmed, at: 0)

        // Keep only last 10
        if recentSearches.count > 10 {
            recentSearches = Array(recentSearches.prefix(10))
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

    // MARK: - Recent Searches
    private func loadRecentSearches() {
        if let savedRecentSearches = UserDefaults.standard.stringArray(forKey: Constants.recentSearchesKey) {
            recentSearches = savedRecentSearches
        }
    }

    // Cancel Search
    func cancelSearch() {
        searchTask?.cancel()
        isSearching = false
    }
}

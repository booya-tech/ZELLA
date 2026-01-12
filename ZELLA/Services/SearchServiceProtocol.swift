//
//  SearchServiceProtocol.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 1/9/26.
//

import Foundation

/// Protocol for search functionality - enables dependency injection and testability
protocol SearchServiceProtocol {
    func searchItems(
        query: String,
        category: ItemCategory,
        page: Int,
        pageSize: Int
    ) async throws -> SearchResult
}

/// Search result with pagination metadata
struct SearchResult {
    let items: [Item]
    let totalCount: Int
    let hasMore: Bool
}

/// Search-specific errors
enum SearchError: LocalizedError {
    case networkError
    case invalidQuery
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return Constants.searchErrorNetworkError
        case .invalidQuery:
            return Constants.searchErrorInvalidQuery
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - MockDataService Conformance
extension MockDataService: SearchServiceProtocol {
    func searchItems(
        query: String,
        category: ItemCategory,
        page: Int,
        pageSize: Int
    ) async throws -> SearchResult {
        // Simulate network delay for realistic behavior
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        let allResults = searchItems(query: query, category: category)
        let startIndex = page * pageSize
        let endIndex = min(startIndex + pageSize, allResults.count)
        
        guard startIndex < allResults.count else {
            return SearchResult(items: [], totalCount: allResults.count, hasMore: false)
        }
        
        let pageItems = Array(allResults[startIndex..<endIndex])
        return SearchResult(
            items: pageItems,
            totalCount: allResults.count,
            hasMore: endIndex < allResults.count
        )
    }
}

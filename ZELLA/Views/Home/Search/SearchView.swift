//
//  SearchView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 1/6/26.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    @State private var selectedItem: Item?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            searchHeader

            // Category Tabs
            CategoryTabBar(selectedCategory: $viewModel.selectedCategory)
                .padding(.vertical, Constants.secondaryPadding)

            // Results(Recent Searches, Search Results) or Empty State
            if viewModel.isSearching {
                loadingView
            } else if viewModel.showRecentSearches {
                recentSearchesView
            } else if viewModel.showEmptyState {
                emptyStateView
            } else if !viewModel.filteredItems.isEmpty {
                searchResultsView
            } else {
                initialStateView
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(item: $selectedItem) { 
            ProductDetailView(item: $0)
        }
    }

    private var searchHeader: some View {
        HStack {
            // Magnifying Glass
            Button {
                dismiss()
            } label: {
                FontAwesomeIcon(FontAwesome.Icon.chevronLeft, size: 18)
                    .foregroundStyle(AppColors.primaryBlack)
            }
            // Search Field
            DSSearchField(
                text: $viewModel.searchText,
                placeholder: AppString.searchPlaceholder,
                onSearch: { viewModel.submitSearch() }
            )
        }
        .padding(.horizontal, Constants.mainPadding)
        .padding(.vertical, Constants.secondaryPadding)
        .background(AppColors.primaryClear)
    }

    private var recentSearchesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                // Title
                Text(AppString.recentSearches)
                    .font(.roboto(.bodyMedium))
                    .foregroundStyle(AppColors.primaryBlack)

                Spacer()

                // Clear All
                Button {
                    viewModel.clearRecentSearches()
                } label: {
                    Text(AppString.clearAll)
                        .font(.roboto(.captionRegular))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .padding(.horizontal, Constants.mainPadding)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.recentSearches, id: \.self) { search in
                        recentSearchRow(search)
                    }
                }
            }

            Spacer()
        }
        .padding(.top, Constants.secondaryPadding)
    }

    private func recentSearchRow(_ search: String) -> some View {
        HStack {
            // Icon
            FontAwesomeIcon(FontAwesome.Icon.clockRotateLeft, size: 14)
                .foregroundStyle(AppColors.textSecondary)
            // Recent Search Text
            Text(search)
                .font(.roboto(.bodyRegular))
                .foregroundStyle(AppColors.primaryBlack)

            Spacer()

            // Clear Button
            Button {
                viewModel.removeRecentSearch(search)
            } label: {
                FontAwesomeIcon(FontAwesome.Icon.xmark, size: 14)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(.horizontal, Constants.mainPadding)
        .padding(.vertical, Constants.searchRowPadding)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.searchText = search
            viewModel.submitSearch()
        }
    }

    private var searchResultsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Results count
            Text("\(viewModel.filteredItems.count) \(AppString.searchResults)")
                .font(.roboto(.captionRegular))
                .foregroundStyle(AppColors.primaryBlack)
                .padding(.horizontal, Constants.mainPadding)
            // Search Results
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: Constants.secondaryPadding),
                        GridItem(.flexible(), spacing: Constants.secondaryPadding),
                        GridItem(.flexible(), spacing: Constants.secondaryPadding)
                    ],
                    spacing: Constants.secondaryPadding
                ) {
                    ForEach(viewModel.filteredItems) { item in
                        Button {
                            selectedItem = item
                        } label: {
                            ProductCardView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Constants.mainPadding)
            }
            .frame(maxHeight: .infinity)
            .scrollDismissesKeyboard(.interactively)
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Spacer()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            // Icon
            FontAwesomeIcon(FontAwesome.Icon.magnifyingGlass, size: 48)
                .foregroundStyle(AppColors.textSecondary)
            // Title
            Text(AppString.noSearchResults)
                .font(.roboto(.bodyMedium))
                .foregroundStyle(AppColors.primaryBlack)
            // Description
            Text(AppString.tryDifferentKeywords)
                .font(.roboto(.captionRegular))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, Constants.mainPadding)
    }

    private var initialStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            // Icon
            FontAwesomeIcon(FontAwesome.Icon.magnifyingGlass, size: 48)
                .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            // Title
            Text(AppString.searchInitialHint)
                .font(.roboto(.bodyRegular))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, Constants.mainPadding)
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}

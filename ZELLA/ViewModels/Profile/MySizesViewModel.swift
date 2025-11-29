//
//  MySizesViewModel.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/26/25.
//

import Foundation
import Observation

@Observable
class MySizesViewModel {
    // MARK: - Published Properties
    var selectedSizingSystem: SizingSystem = .international
    var selectedTopSize: String?
    var selectedBottomSize: String?
    var selectedShoeSize: String?
    var isSaving: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?
    var showError: Bool = false
    var showSuccessMessage: Bool = false
    
    // Validation errors
    var topSizeError: String?
    var bottomSizeError: String?
    var shoeSizeError: String?

    // MARK: - Dependencies
    private let authService: AuthService
    private let sizesService: SizesService

    // MARK: - Initialization
    init(authService: AuthService = .shared, sizesService: SizesService = SizesService()) {
        self.authService = authService
        self.sizesService = sizesService
    }

    // MARK: Computed Properties

    /// Returns available top sizes based on selected sizing system
    var availableTopSizes: [String] {
        switch selectedSizingSystem {
        case .international:
            return InternationalTopSize.allCases.map { $0.rawValue }
        case .thai:
            return ThaiTopSize.allCases.map { $0.rawValue }
        }
    }

    // Returns available bottom sizes
    var availableBottomSizes: [String] {
        return BottomSize.allCases.map { $0.rawValue }
    }
    
    /// Returns available shoe sizes
    var availableShoeSizes: [String] {
        return ShoeSize.allCases.map { $0.rawValue }
    }
    
    /// Check if any size has been selected
    var hasChanges: Bool {
        return selectedTopSize != nil || selectedBottomSize != nil || selectedShoeSize != nil
    }

    var isSelectedAllSizes: Bool {
        return selectedTopSize != nil && selectedBottomSize != nil && selectedShoeSize != nil
    }

    // MARK: - Methods
    
    /// Loads user's saved size preferences
    func loadUserSizes() async {
        guard let uid = authService.currentUserID else {
            Logger.log("⚠️ No user ID available to load sizes")
            return
        }
        
        isLoading = true
        
        do {
            let sizes = try await sizesService.fetchUserSizes(uid: uid)
            
            await MainActor.run {
                self.selectedTopSize = sizes?.tops
                self.selectedBottomSize = sizes?.bottoms
                self.selectedShoeSize = sizes?.shoes
                self.isLoading = false
            }
            
            Logger.log("🟢 Sizes loaded for user")
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load your sizes: \(error.localizedDescription)"
                self.showError = true
                self.isLoading = false
            }
            Logger.log("🔴 Error loading sizes: \(error.localizedDescription)")
        }
    }

    /// Validates that all size fields are selected
    func validateSizes() -> Bool {
        var isValid = true
        
        // Clear previous errors
        topSizeError = nil
        bottomSizeError = nil
        shoeSizeError = nil
        
        // Validate top size
        if selectedTopSize == nil {
            topSizeError = AppString.sizeRequired
            isValid = false
        }
        
        // Validate bottom size
        if selectedBottomSize == nil {
            bottomSizeError = AppString.sizeRequired
            isValid = false
        }
        
        // Validate shoe size
        if selectedShoeSize == nil {
            shoeSizeError = AppString.sizeRequired
            isValid = false
        }
        
        return isValid
    }
    
    /// Saves user's size preferences to Firestore
    func saveUserSizes() async {
        guard let uid = authService.currentUserID else {
            await MainActor.run {
                self.errorMessage = "You must be signed in to save sizes"
                self.showError = true
            }
            return
        }
        
        // Validate before saving
        guard validateSizes() else {
            Logger.log("⚠️ Validation failed: Please select all sizes")
            return
        }
        
        isSaving = true
        
        let sizes = UserSizes(
            tops: selectedTopSize,
            bottoms: selectedBottomSize,
            shoes: selectedShoeSize
        )
        
        do {
            try await sizesService.updateUserSizes(uid: uid, sizes: sizes)
            
            await MainActor.run {
                self.isSaving = false
                self.showSuccessMessage = true
            }
            
            Logger.log("🟢 Sizes saved successfully")
            
            // Hide success message after 2 seconds
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await MainActor.run {
                self.showSuccessMessage = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to save sizes: \(error.localizedDescription)"
                self.showError = true
                self.isSaving = false
            }
            Logger.log("🔴 Error saving sizes: \(error.localizedDescription)")
        }
    }
    
    /// Clears all selected sizes
    func clearAllSizes() {
        selectedTopSize = nil
        selectedBottomSize = nil
        selectedShoeSize = nil
    }
    
    /// Handles sizing system change and clears top size if needed
    func handleSizingSystemChange() {
        // Clear top size when switching systems since options are different
        selectedTopSize = nil
    }
}

//
//  MySizesView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/17/25.
//

import SwiftUI

struct MySizesView: View {
    @State private var viewModel = MySizesViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                loadingView
            } else {
                mainContent
            }
            
            // Success message overlay
            if viewModel.showSuccessMessage {
                successOverlay
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(AppString.mySizes)
                    .font(.system(size: 18, weight: .semibold))
            }
        }
        .alert(AppString.errorTitle, isPresented: $viewModel.showError) {
            Button(AppString.ok, role: .cancel) {}
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .task {
            await viewModel.loadUserSizes()
        }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        VStack() {
            ScrollView {
                VStack(spacing: 24) {
                    // Description
                    descriptionSection
                    
                    // Sizing System Picker
                    sizingSystemSection
                    
                    Divider()
                    
                    // Size Selections
                    sizeSelectionsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 100) // Space for save button
            }
            
            Spacer()
            
            // Save Button (Fixed at bottom)
            saveButtonSection
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(AppString.mySizesDescriptionSectionTitle)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Sizing System Section
    private var sizingSystemSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(AppString.sizingSystemSectionTitle)
                .font(.system(size: 16, weight: .semibold))
            
            Picker(AppString.sizingSystemSectionTitle, selection: $viewModel.selectedSizingSystem) {
                ForEach(SizingSystem.allCases, id: \.self) { system in
                    Text(system.rawValue).tag(system)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.selectedSizingSystem) { _, _ in
                viewModel.handleSizingSystemChange()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Size Selections Section
    private var sizeSelectionsSection: some View {
        VStack(spacing: 24) {
            // Tops
            sizeSelectionRow(
                title: AppString.topSize,
                selectedSize: $viewModel.selectedTopSize,
                availableSizes: viewModel.availableTopSizes,
                placeholder: AppString.selectTopSize
            )
            
            Divider()
            
            // Bottoms
            sizeSelectionRow(
                title: AppString.bottomSize,
                selectedSize: $viewModel.selectedBottomSize,
                availableSizes: viewModel.availableBottomSizes,
                placeholder: AppString.selectBottomSize
            )
            
            Divider()
            
            // Shoes
            sizeSelectionRow(
                title: AppString.shoeSize,
                selectedSize: $viewModel.selectedShoeSize,
                availableSizes: viewModel.availableShoeSizes,
                placeholder: AppString.selectShoeSize
            )
        }
    }
    
    // MARK: - Size Selection Row
    private func sizeSelectionRow(
        title: String,
        selectedSize: Binding<String?>,
        availableSizes: [String],
        placeholder: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
            
            Menu {
                Button(AppString.clear) {
                    selectedSize.wrappedValue = nil
                }
                
                Divider()
                
                ForEach(availableSizes, id: \.self) { size in
                    Button(size) {
                        selectedSize.wrappedValue = size
                    }
                }
            } label: {
                HStack {
                    Text(selectedSize.wrappedValue ?? placeholder)
                        .foregroundStyle(selectedSize.wrappedValue == nil ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Save Button Section
    private var saveButtonSection: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Clear All Button
                DSPrimaryButton(title: AppString.clearAll, type: .destructive) {
                    viewModel.clearAllSizes()
                }
                .disabled(viewModel.isSaving || !viewModel.hasChanges)
                .opacity(viewModel.hasChanges ? 1.0 : 0.5)
                
                // Save Button
                DSPrimaryButton(title: AppString.save, type: .normal, isLoading: viewModel.isSaving) {
                    Task {
                        await viewModel.saveUserSizes()
                    }
                }
                .disabled(viewModel.isSaving)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Text(AppString.mySizesLoadingView)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .padding(.top, 8)
        }
    }
    
    // MARK: - Success Overlay
    private var successOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.white)
                Text(AppString.sizesSavedSuccessfully)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.green)
            .cornerRadius(8)
            .shadow(radius: 4)
            .padding(.bottom, 100)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(response: 0.3), value: viewModel.showSuccessMessage)
    }
}

#Preview {
    NavigationStack {
        MySizesView()
    }
}


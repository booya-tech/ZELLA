//
//  ProductDetailView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/10/25.
//

import SwiftUI
import FirebaseFirestore

struct ProductDetailView: View {
    let item: Item
    @State private var isFavorite = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    // Mock seller data
    private var mockSeller: Seller {
        Seller(
            id: item.sellerID,
            name: "ZELLA SELLER",
            profileImageURL: nil,
            rating: 5.0,
            isActive: true,
            joinedDate: Timestamp(date: Date()),
            localImageName: nil
        )
    }
    
    // Mock related items
    private var relatedItems: [Item] {
        MockDataService.shared.getTrending().prefix(5).map { $0 }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Image Gallery
                    ProductImageGalleryView(
                        imageNames: item.localImageNames ?? [item.localImageName].compactMap { $0 }
                    )
                    
                    // Product Info Header
                    ProductInfoHeaderView(item: item, isFavorite: $isFavorite)
                    
                    // Seller Info
                    SellerInfoView(seller: mockSeller, onTap: {})
                    
                    // Description Section
                    ProductDescriptionSectionView(item: item, onTap: {})
                    
                    // You May Also Like
                    HorizontalSectionView(
                        title: AppString.productDescriptionSectionMayAlsoLike,
                        items: relatedItems,
                        onTapItem: { _ in
                            alertMessage = "Navigate to product"
                            showAlert = true
                        },
                        onSeeAllTap: {
                            alertMessage = "See all related items"
                            showAlert = true
                        }
                    )
                    
                    // Bottom padding for sticky bar
                    Spacer()
                        .frame(height: 100)
                }
            }
            
            // Sticky Bottom Bar
            ProductDetailBottomBar(
                onChatTap: {
                    alertMessage = "Open chat with seller"
                    showAlert = true
                },
                onAddToBag: {
                    alertMessage = "Added to bag!"
                    showAlert = true
                }
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: Constants.mainPadding) {
                    Button(action: { dismiss() }) {
                        FontAwesomeIcon(FontAwesome.Icon.chevronLeft, size: 20)
                            .foregroundStyle(AppColors.primaryBlack)
                    }
                    
                    Button(action: {}) {
                        FontAwesomeIcon(FontAwesome.Icon.magnifyingGlass, size: 20)
                            .foregroundStyle(AppColors.primaryBlack)
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(AppString.appName)
                    .font(.roboto(.h2Regular))
                    .foregroundStyle(AppColors.primaryBlack)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: Constants.mainPadding) {
                    Button(action: {}) {
                        FontAwesomeIcon(FontAwesome.Icon.home, size: 20)
                            .foregroundStyle(AppColors.primaryBlack)
                    }
                    
                    Button(action: {}) {
                        FontAwesomeIcon(FontAwesome.Icon.shoppingBag, size: 20)
                            .foregroundStyle(AppColors.primaryBlack)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .alert("Action", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(
            item: Item(
                id: "1",
                sellerID: "seller1",
                title: "Black Shirt One",
                price: 1000,
                condition: .newWithTags,
                category: .top,
                brand: "NODU",
                size: "M",
                description: "Soft Henley Neck Round Long Sleeve Knit [Gray]",
                imageURLs: [],
                status: .available,
                postedDate: Timestamp(date: Date()),
                originalPrice: 999,
                localImageName: "shirt_01",
                localImageNames: ["shirt_01", "shirt_02", "shirt_03"]
            )
        )
    }
}

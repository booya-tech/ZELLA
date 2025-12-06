//
//  MockDataService.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/2/25.
//

import Foundation
import FirebaseFirestore

class MockDataService {
    static let shared = MockDataService()

    private init() {}

    private lazy var allMockItems: [Item] = generateMockItems()

    // MARK: - Hero Banner
    func getHeroBanner() -> [HeroBanner] {
        return [
            HeroBanner(
                id: "hero1",
                imageURL: nil,
                localImageName: "mock_hero_01"
            ),
            HeroBanner(
                id: "hero2",
                imageURL: nil,
                localImageName: "mock_hero_02"
            ),
            HeroBanner(
                id: "hero3",
                imageURL: nil,
                localImageName: "mock_hero_03"
            )
        ]
    }

    // MARK: - Brands
    func getBrands() -> [Brand] {
        return [
            Brand(id: "brand1", name: "ZARA", logoURL: nil, localImageName: "brand_zara"),
            Brand(id: "brand2", name: "CPS CHAPS", logoURL: nil, localImageName: "brand_balenciaga"),
            Brand(id: "brand3", name: "Jaspal", logoURL: nil, localImageName: "brand_lululemon"),
            Brand(id: "brand4", name: "CC-OO", logoURL: nil, localImageName: "brand_ccoo"),
            Brand(id: "brand5", name: "Pomelo", logoURL: nil, localImageName: "brand_pomelo"),
            Brand(id: "brand6", name: "alo", logoURL: nil, localImageName: "brand_alo"),
            Brand(id: "brand7", name: "After You", logoURL: nil, localImageName: "brand_cartier"),
            Brand(id: "brand8", name: "H&M", logoURL: nil, localImageName: "brand_hm"),
            Brand(id: "brand9", name: "Uniqlo", logoURL: nil, localImageName: "brand_uniqlo"),
            Brand(id: "brand10", name: "COS", logoURL: nil, localImageName: "brand_cos")
        ]
    }

    // MARK: - Stores
    func getStores() -> [Store] {
        return [
            Store(id: "store1", name: "Vintage Closet Bangkok", bannerURL: nil, sellerID: "seller1", localImageName: "store_vintage"),
            Store(id: "store2", name: "Designer Finds Thailand", bannerURL: nil, sellerID: "seller2", localImageName: "store_designer"),
            Store(id: "store3", name: "Thai Street Fashion", bannerURL: nil, sellerID: "seller3", localImageName: "store_street"),
            Store(id: "store4", name: "Luxury Pre-Loved", bannerURL: nil, sellerID: "seller4", localImageName: "store_luxury"),
            Store(id: "store5", name: "Closet Cleanout BKK", bannerURL: nil, sellerID: "seller5", localImageName: "store_cleanout")
        ]
    }
    // MARK: - Items with Pagination
    func getItems(page: Int, pageSize: Int = 20, category: ItemCategory = .all) -> [Item] {
        let filteredItems = category == .all ? allMockItems : allMockItems.filter { $0.category == category }
        let startIndex = page * pageSize
        let endIndex = min(startIndex + pageSize, filteredItems.count)

        guard startIndex < filteredItems.count else { return [] }

        return Array(filteredItems[startIndex..<endIndex])
    }

    func getTotalItemsCount(category: ItemCategory = .all) -> Int {
        if category == .all {
            return allMockItems.count
        } else {
            return allMockItems.filter { $0.category == category }.count
        }
    }

    func getRecentlyViewed() -> [Item] {
        return Array(allMockItems.prefix(10))
    }

    func getTrending() -> [Item] {
        return Array(allMockItems.shuffled().prefix(10))
    }

    // MARK: - Generate Mock Items
    func generateMockItems() -> [Item] {
        var items: [Item] = []
        let brands = ["ZARA", "CPS CHAPS", "Jaspal", "CC-OO", "Pomelo", "Mirror Mirror", "H&M", "Uniqlo", "COS"]
        let conditions: [ItemCondition] = [.newWithTags, .likeNew, .good, .fair]
        let sizes = ["XS", "S", "M", "L", "XL", "XXL"]
        
        // Generate Tops
        for i in 1...25 {
            items.append(
                Item(
                    id: "item_top_\(i)",
                    sellerID: "seller\((i % 5) + 1)",
                    title: "Black Shirt One",
                    price: Double.random(in: 890...4900),
                    condition: conditions.randomElement()!,
                    category: .top,
                    brand: brands.randomElement()!,
                    size: sizes.randomElement()!,
                    description: "Women's oversized casual 100% cotton blouse",
                    imageURLs: [],
                    status: .available,
                    postedDate: Timestamp(
                        date: Date().addingTimeInterval(-Double.random(in: 0...2592000))),
                    localImageName: "shirt_\(String(format: "%02d", (i % 10) + 1))"
                )
            )
        }

        // Generate Pants
        for i in 1...20 {
            items.append(
                Item(
                    id: "item_pants_\(i)",
                    sellerID: "seller\((i % 5) + 1)",
                    title: "White Pants",
                    price: Double.random(in: 990...3900),
                    condition: conditions.randomElement()!,
                    category: .pants,
                    brand: brands.randomElement()!,
                    size: sizes.randomElement()!,
                    description: "Comfortable white pants, barely worn",
                    imageURLs: [],
                    status: .available,
                    postedDate: Timestamp(
                        date: Date().addingTimeInterval(-Double.random(in: 0...2592000))),
                    localImageName: "pants_\(String(format: "%02d", (i % 5) + 1))"
                )
            )
        }

        // Generate Outerwear
        for i in 1...20 {
            items.append(
                Item(
                    id: "item_outerwear_\(i)",
                    sellerID: "seller\((i % 5) + 1)",
                    title: "Black Jacket",
                    price: Double.random(in: 1890...8900),
                    condition: conditions.randomElement()!,
                    category: .outerwear,
                    brand: brands.randomElement()!,
                    size: sizes.randomElement()!,
                    description: "Stylish black jacket perfect for Thai weather",
                    imageURLs: [],
                    status: .available,
                    postedDate: Timestamp(
                        date: Date().addingTimeInterval(-Double.random(in: 0...2592000))),
                    localImageName: "shirt_\(String(format: "%02d", (i % 10) + 1))"
                )
            )
        }

        // Generate Dresses & Skirts
        for i in 1...20 {
            items.append(
                Item(
                    id: "item_dress_\(i)",
                    sellerID: "seller\((i % 5) + 1)",
                    title: "Summer Dress",
                    price: Double.random(in: 1290...5900),
                    condition: conditions.randomElement()!,
                    category: .dresses,
                    brand: brands.randomElement()!,
                    size: sizes.randomElement()!,
                    description: "Beautiful summer dress, perfect condition",
                    imageURLs: [],
                    status: .available,
                    postedDate: Timestamp(
                        date: Date().addingTimeInterval(-Double.random(in: 0...2592000))),
                    localImageName: "dress_\(String(format: "%02d", (i % 5) + 1))"
                )
            )
        }

        // Generate Shoes
        for i in 1...20 {
            items.append(
                Item(
                    id: "item_shoe_\(i)",
                    sellerID: "seller\((i % 5) + 1)",
                    title: "White Sneakers",
                    price: Double.random(in: 1990...7900),
                    condition: conditions.randomElement()!,
                    category: .shoes,
                    brand: brands.randomElement()!,
                    size: sizes.randomElement()!,
                    description: "Comfortable white sneakers, barely worn",
                    imageURLs: [],
                    status: .available,
                    postedDate: Timestamp(
                        date: Date().addingTimeInterval(-Double.random(in: 0...2592000))),
                    localImageName: "shoes_\(String(format: "%02d", (i % 5) + 1))"
                )
            )
        }

        // Generate Accessories
        for i in 1...15 {
            items.append(
                Item(
                    id: "item_accessories_\(i)",
                    sellerID: "seller\((i % 5) + 1)",
                    title: "Fashion Accessories",
                    price: Double.random(in: 390...2900),
                    condition: conditions.randomElement()!,
                    category: .accessories,
                    brand: brands.randomElement()!,
                    size: "One Size",
                    description: "Trendy accessories to complete your look",
                    imageURLs: [],
                    status: .available,
                    postedDate: Timestamp(
                        date: Date().addingTimeInterval(-Double.random(in: 0...2592000))),
                    localImageName: "accessories_\(String(format: "%02d", (i % 5) + 1))"
                )
            )
        }

        // Generate Bags
        for i in 1...15 {
            items.append(
                Item(
                    id: "item_bags_\(i)",
                    sellerID: "seller\((i % 5) + 1)",
                    title: "Designer Bag",
                    price: Double.random(in: 2900...15900),
                    condition: conditions.randomElement()!,
                    category: .bags,
                    brand: brands.randomElement()!,
                    size: "One Size",
                    description: "Authentic designer bag, gently used",
                    imageURLs: [],
                    status: .available,
                    postedDate: Timestamp(
                        date: Date().addingTimeInterval(-Double.random(in: 0...2592000))),
                    localImageName: "bag_\(String(format: "%02d", (i % 5) + 1))"
                )
            )
        }

        return items.shuffled()
    }
}

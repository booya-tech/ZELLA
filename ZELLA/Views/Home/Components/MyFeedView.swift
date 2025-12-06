//
//  MyFeedView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/4/25.
//

import SwiftUI

struct MyFeedView: UIViewControllerRepresentable {
    @Binding var selectedCategory: ItemCategory
    let onProductTap: (Item) -> Void
    
    func makeUIViewController(context: Context) -> MyFeedCollectionViewController {
        let controller = MyFeedCollectionViewController()
        controller.selectedCategory = selectedCategory
        controller.onItemTap = onProductTap
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MyFeedCollectionViewController, context: Context) {
        if uiViewController.selectedCategory != selectedCategory {
            uiViewController.selectedCategory = selectedCategory
        }
    }
}

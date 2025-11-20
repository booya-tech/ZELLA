//
//  MyOrdersView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/17/25.
//

import SwiftUI

struct MyOrdersView: View {
    var body: some View {
        VStack {
            Text("My Orders")
                .font(.title)
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MyOrdersView()
    }
}


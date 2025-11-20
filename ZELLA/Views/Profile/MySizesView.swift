//
//  MySizesView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/17/25.
//

import SwiftUI

struct MySizesView: View {
    var body: some View {
        VStack {
            Text("My Sizes")
                .font(.title)
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MySizesView()
    }
}


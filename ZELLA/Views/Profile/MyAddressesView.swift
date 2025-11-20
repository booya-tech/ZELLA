//
//  MyAddressesView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/17/25.
//

import SwiftUI

struct MyAddressesView: View {
    var body: some View {
        VStack {
            Text("My Addresses")
                .font(.title)
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MyAddressesView()
    }
}


//
//  HeroCarouselView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/3/25.
//

import SwiftUI

struct HeroCarouselView: View {
    let banners: [HeroBanner]
    @Binding var currentIndex: Int
    @State private var timer: Timer?
    let bannerHeight: CGFloat = 500
//    @StateObject var viewModel = HeroCarouselViewModel()
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(banners.enumerated()), id: \.element.id) { index, banner in
                ZStack(alignment: .bottom) {
                    // Banner Image
                    if let imageName = banner.localImageName {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: bannerHeight)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: bannerHeight)
                            .overlay {
                                Text("Banner is not available")
                            }
                    }
                }
                .tag(index)
            }
        }
        .frame(height: 280)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onAppear {
            startAutoScroll()
        }
        .onDisappear {
            stopAutoScroll()
        }
    }
    
        private func startAutoScroll() {
            timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % banners.count
                }
            })
        }
    
        private func stopAutoScroll() {
            timer?.invalidate()
            timer = nil
        }
}

#Preview {
    let mockBanners = [
        HeroBanner(id: "1", imageURL: nil, localImageName: "mock_hero_01"),
        HeroBanner(id: "2", imageURL: nil, localImageName: "mock_hero_02"),
        HeroBanner(id: "3", imageURL: nil, localImageName: "mock_hero_03"),
    ]
    
    HeroCarouselView(banners: mockBanners, currentIndex: .constant(0))
}

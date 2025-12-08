//
//  MainTabView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        if #available(iOS 26, *) {
            TabView {
                // MARK: 1. Home
                HomeView()
                    .tabItem {
                        Label {
                            Text("Home")
                        } icon: {
                            Image(uiImage: FontAwesome.image(FontAwesome.Icon.home, size: 16, style: FontAwesome.FontName.regular))
                        }
                    }
                
                // MARK: 2. Swipe
                SwipeView()
                    .tabItem {
                        Label {
                            Text("Swipe")
                        } icon: {
                            Image(uiImage: FontAwesome.image(FontAwesome.Icon.arrowsRotate, size: 16, style: FontAwesome.FontName.solid))
                        }
                    }
                
                // MARK: 3. Sell
                SellView()
                    .tabItem {
                        Label {
                            Text("Sell")
                        } icon: {
                            Image(uiImage: FontAwesome.image(FontAwesome.Icon.plus, size: 16, style: FontAwesome.FontName.solid))
                        }
                    }
                
                // MARK: 4. Profile
                 ProfileView()
                     .tabItem {
                         Label {
                             Text("Profile")
                         } icon: {
                             Image(uiImage: FontAwesome.image(FontAwesome.Icon.user, size: 16, style: FontAwesome.FontName.regular))
                         }
                     }
            }
            .tint(.black)
            .tabBarMinimizeBehavior(.onScrollDown)
        } else {
            TabView {
                // MARK: 1. Home
                HomeView()
                    .tabItem {
                        Label {
                            Text("Home")
                        } icon: {
                            Image(uiImage: FontAwesome.image(FontAwesome.Icon.home, size: 16, style: FontAwesome.FontName.regular))
                        }
                    }
                
                // MARK: 2. Swipe
                SwipeView()
                    .tabItem {
                        Label {
                            Text("Swipe")
                        } icon: {
                            Image(uiImage: FontAwesome.image(FontAwesome.Icon.arrowsRotate, size: 16, style: FontAwesome.FontName.solid))
                        }
                    }
                
                // MARK: 3. Sell
                SellView()
                    .tabItem {
                        Label {
                            Text("Sell")
                        } icon: {
                            Image(uiImage: FontAwesome.image(FontAwesome.Icon.plus, size: 16, style: FontAwesome.FontName.solid))
                        }
                    }
                
                // MARK: 4. Profile
                 ProfileView()
                     .tabItem {
                         Label {
                             Text("Profile")
                         } icon: {
                             Image(uiImage: FontAwesome.image(FontAwesome.Icon.user, size: 16, style: FontAwesome.FontName.regular))
                         }
                     }
            }
            .tint(.black)
        }
    }
}

#Preview {
    MainTabView()
}

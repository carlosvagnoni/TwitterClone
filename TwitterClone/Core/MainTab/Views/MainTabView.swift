//
//  MainTabView.swift
//  TwitterClone
//
//  Created by user239477 on 6/1/23.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedIndex = 0
    
    @ObservedObject var mainTabViewModel = MainTabViewModel()
    
    @EnvironmentObject var notificationsViewModel: NotificationsViewModel
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    
    
    var unreadNotificationsCount: Int {
            return notificationsViewModel.notifications.filter { !$0.read }.count
        }
    
    var unreadRecentMessagesCount: Int {
            return messagesViewModel.recentMessages.filter { !$0.read }.count
        }
    
    var body: some View {
        
        TabView(selection: $selectedIndex) {

            FeedView()
                .tabItem {
                    
                    Image(systemName: selectedIndex == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)

            ExploreView()
                .tabItem {

                    Image(systemName: selectedIndex == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                        .environment(\.symbolVariants, .none)

                }
                .tag(1)

            NotificationsView()
                .badge(unreadNotificationsCount)
                .tabItem {
                    Image(systemName: selectedIndex == 2 ? "bell.fill" : "bell")
                        .environment(\.symbolVariants, .none)
                }
                .tag(2)

            MessagesView()
                .badge(unreadRecentMessagesCount)
                .tabItem {
                    Image(systemName: selectedIndex == 3 ? "envelope.fill" : "envelope")
                        .environment(\.symbolVariants, .none)
                }
                .tag(3)

        }
        .tint(.primary)
        .onAppear() {

            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.primary)
            let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(mainTabViewModel.titleForSelectedIndex(selectedIndex))
        .toolbarBackground(.visible)
        

        
        
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MainTabView()
        
    }
}

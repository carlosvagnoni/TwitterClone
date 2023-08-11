//
//  TwitterCloneApp.swift
//  TwitterClone
//
//  Created by user239477 on 5/31/23.
//

import SwiftUI
import Firebase

@main
struct TwitterCloneApp: App {
    
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var feedViewModel = FeedViewModel()
    @StateObject var notificationViewModel = NotificationsViewModel()
    @StateObject var messagesViewModel = MessagesViewModel()
    
    init() {
        FirebaseApp.configure()
    }
        
    var body: some Scene {
        
        WindowGroup {
            NavigationView {
                ContentView()                        
            }
            .environmentObject(authViewModel)
            .environmentObject(feedViewModel)
            .environmentObject(notificationViewModel)
            .environmentObject(messagesViewModel)
            .navigationViewStyle(StackNavigationViewStyle())
                   
        }
    }
}

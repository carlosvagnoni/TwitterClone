//
//  NotificationsViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/17/23.
//

import Foundation

class NotificationsViewModel: ObservableObject {
    @Published var notifications = [Notification]()
    @Published var isLoading = false
    
    let notificationService = NotificationService()
    let userService = UserService()
    let tweetService = TweetService()
    
    init() {
        fetchNotifications()
    }    
    
    func fetchNotifications() {
        isLoading = true
        notifications.removeAll()
        
        notificationService.fetchNotifications { notifications in
            self.userService.fetchAndAssignFullnameToNotifications(notifications: notifications) { updatedNotifications in
                self.tweetService.fetchAndAssignTweetsToNotifications(notifications: updatedNotifications) { fullNotifications in
                    DispatchQueue.main.async {
                        self.notifications = fullNotifications
                        self.isLoading = false
                    }
                }
                
            }
            
        }
    }
}

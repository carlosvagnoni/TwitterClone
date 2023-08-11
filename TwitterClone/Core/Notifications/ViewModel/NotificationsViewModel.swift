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
    
    init() {
        fetchNotifications()
    }    
    
    func fetchNotifications() {
        isLoading = true
        
        notificationService.fetchNotifications { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
                self.isLoading = false
            }
        }
    }
}

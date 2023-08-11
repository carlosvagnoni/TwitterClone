//
//  NotificationRowViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/17/23.
//

import Foundation

class NotificationRowViewModel: ObservableObject {
    @Published var notification: Notification

    private let notificationService = NotificationService()
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    func readNotification() {
        guard let notificationId = notification.id else {return}
        notificationService.readNotification(notificationId: notificationId)
    }
    
}

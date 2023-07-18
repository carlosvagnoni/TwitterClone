//
//  NotificationRowViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/17/23.
//

import Foundation

class NotificationRowViewModel: ObservableObject {
    @Published var senderFullname = ""
    @Published var notification: Notification
    @Published var tweet: Tweet?
    
    private let tweetService = TweetService()
    private let userService = UserService()
    
    init(notification: Notification) {
        self.notification = notification
        userService.fetchUser(withUid: notification.senderId) { senderUser in
            self.senderFullname = senderUser.fullname
        }
        tweetService.fetchTweet(withId: notification.tweetId) { tweet in
            self.tweet = tweet
        }
    }   
    
}

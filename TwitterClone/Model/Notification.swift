//
//  Notification.swift
//  TwitterClone
//
//  Created by user239477 on 7/17/23.
//

import FirebaseFirestoreSwift
import Firebase
import SwiftUI

struct Notification: Identifiable, Decodable {
    
    @DocumentID var id: String?
    
    let senderId: String
    let receiverId: String
    let notificationType: NotificationType
    let tweetId: String
    let read: Bool
    let timestamp: Timestamp
    var tweet: Tweet?
    var senderFullname: String?
}

extension Notification {
    static let MOCK_NOTIFICATION = Notification(senderId: "7EeGLcXRW0XyRlZ6amZUeZjmfav2", receiverId: "Mpkv6Jxr0odghQj9oh58FKZSuXj1", notificationType: .like, tweetId: "aodHpKPkuOfRuioQzAdI", read: false, timestamp: Timestamp(date: Date()), tweet: Tweet.MOCK_TWEET ,senderFullname: User.MOCK_USER.fullname)
}


enum NotificationType: String, Decodable {
    case comment
    case retweet
    case like
    case bookmark
    
    var imageName: String {
        switch self {
        case .comment:
            return "bubble.left.fill"
        case .retweet:
            return "arrow.2.squarepath"
        case .like:
            return "heart.fill"
        case .bookmark:
            return "bookmark.fill"
        }
    }
    
    var imageColor: Color {
        switch self {
        case .comment:
            return .gray
        case .retweet:
            return .green
        case .like:
            return .red
        case .bookmark:
            return Color(.systemBlue)
        }
    }
    
    var message: String {
        switch self {
        case .comment:
            return "has commented on your tweet."
        case .retweet:
            return "has retweeted your tweet."
        case .like:
            return "has liked your tweet"
        case .bookmark:
            return "has bookmarked your tweet."
        }
    }
}


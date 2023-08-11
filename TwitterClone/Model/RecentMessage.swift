//
//  RecentMessage.swift
//  TwitterClone
//
//  Created by user239477 on 8/2/23.
//

import FirebaseFirestoreSwift
import Firebase

struct RecentMessage: Identifiable, Decodable, Hashable {
    
    var id: String?
    let senderId: String
    let text: String
    let read: Bool
    let timestamp: Timestamp    
    var receiverUser: User?
    
    func hash(into hasher: inout Hasher) {
        if let id = id {
            hasher.combine(id)
        }
    }
}

extension RecentMessage {
    static let MOCK_RECENTMESSAGE = RecentMessage(senderId: "Mpkv6Jxr0odghQj9oh58FKZSuXj1", text: "Prueba", read: false, timestamp: Timestamp(date: Date()), receiverUser: User.MOCK_USER)
}

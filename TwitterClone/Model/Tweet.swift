//
//  Tweet.swift
//  TwitterClone
//
//  Created by user239477 on 6/19/23.
//

import FirebaseFirestoreSwift
import Firebase

struct Tweet: Identifiable, Decodable {
    
    @DocumentID var id: String?
    
    let caption: String
    let timestamp: Timestamp
    let uid: String
    var commentCount: Int
    var likes: Int
    var bookmarkCount: Int
    var retweetCount: Int
    
    var user: User?
    var didLike: Bool? = false
    var didRetweet: Bool? = false
    var didBookmark: Bool? = false
    
}

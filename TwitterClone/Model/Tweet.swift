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
    var mediaURL: String?
    var mediaType: MediaType?    
}

enum MediaType: String, Decodable {
    case image
    case video
}

extension Tweet {
    static let MOCK_TWEET = Tweet(caption: "Prueba", timestamp: Timestamp(date: Date()), uid: "VBEo4qsxtTaYBgc4BK4wkh0mvAh1", commentCount: 0, likes: 0, bookmarkCount: 0, retweetCount: 0, user: User.MOCK_USER)
}

//
//  Comment.swift
//  TwitterClone
//
//  Created by user239477 on 7/4/23.
//

import FirebaseFirestoreSwift
import Firebase

struct Comment: Identifiable, Decodable {
    
    @DocumentID var id: String?
    
    let comment: String
    let timestamp: Timestamp
    let uid: String
    var user: User?    
}

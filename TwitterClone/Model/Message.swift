//
//  Message.swift
//  TwitterClone
//
//  Created by user239477 on 7/20/23.
//

import FirebaseFirestoreSwift
import Firebase

struct Message: Decodable, Identifiable {
    
    var id: String?
    
    let text: String
    let senderId: String
    let timestamp: Timestamp
    
    var mediaURL: String?
    var mediaType: MediaType?

}

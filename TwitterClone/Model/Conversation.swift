//
//  Conversation.swift
//  TwitterClone
//
//  Created by user239477 on 7/20/23.
//

import FirebaseFirestoreSwift
import Firebase

struct Conversation: Identifiable, Decodable {
    
    @DocumentID var id: String?
    
    let participantsIDs: [String]
    let messages: [Message]
}

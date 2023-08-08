//
//  User.swift
//  TwitterClone
//
//  Created by user239477 on 6/13/23.
//

import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Decodable, Hashable {
    
    @DocumentID var id: String?
    
    let username: String
    let fullname: String
    let profilePhotoUrl: String
    let email: String
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id }
    
    func hash(into hasher: inout Hasher) {
        if let id = id {
            hasher.combine(id)
        }
    }
}

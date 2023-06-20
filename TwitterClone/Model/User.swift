//
//  User.swift
//  TwitterClone
//
//  Created by user239477 on 6/13/23.
//

import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Decodable {
    
    @DocumentID var id: String?
    
    let username: String
    let fullname: String
    let profilePhotoUrl: String
    let email: String
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id }
}

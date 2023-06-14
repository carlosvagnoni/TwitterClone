//
//  User.swift
//  TwitterClone
//
//  Created by user239477 on 6/13/23.
//

import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
    
    @DocumentID var id: String?
    
    let username: String
    let fullname: String
    let profilePhotoUrl: String
    let email: String
}

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

extension User {
    static let MOCK_USER = User(id: "Mpkv6Jxr0odghQj9oh58FKZSuXj1",username: "charles_leclerc", fullname: "Charles Leclerc", profilePhotoUrl: "https://firebasestorage.googleapis.com:443/v0/b/twitterclone-39f99.appspot.com/o/profile_image%2FFDD2CFDA-BAF3-4CE7-8930-70F22E90B369?alt=media&token=4deeecea-34a8-4857-a23d-88db16ce8801", email: "charlesleclerc@mail.com")
}

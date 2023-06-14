//
//  UserService.swift
//  TwitterClone
//
//  Created by user239477 on 6/13/23.
//

import Firebase
import FirebaseFirestoreSwift

class UserService {
    
    func fecthUser(withUid uid: String, completion: @escaping(User) -> Void) {
        
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                
                guard let snapshot = snapshot else { return }
                
                guard let user = try? snapshot.data(as: User.self) else { return }
                
                completion(user)

            }
        
    }
    
}

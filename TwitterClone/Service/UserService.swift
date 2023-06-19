//
//  UserService.swift
//  TwitterClone
//
//  Created by user239477 on 6/13/23.
//

import Firebase
import FirebaseFirestoreSwift

class UserService {
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                
                guard let snapshot = snapshot else { return }
                
                guard let user = try? snapshot.data(as: User.self) else { return }
                
                completion(user)

            }
        
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        
        Firestore.firestore().collection("users")
            .getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                
                documents.forEach { document in
                    
                    guard let user = try? document.data(as: User.self) else { return }
                    
                    let users = documents.compactMap({ try? $0.data(as: User.self) })
                    
                    completion(users)
                }
                
                
                
            }
    }
    
}

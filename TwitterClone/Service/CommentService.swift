//
//  CommentService.swift
//  TwitterClone
//
//  Created by user239477 on 7/4/23.
//

import Firebase

class CommentService {
    
    func uploadComment(tweetId: String, comment: String, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let data = ["uid": uid, "comment": comment, "timestamp": Timestamp(date: Date())] as [String : Any]
        
        Firestore.firestore().collection("tweets").document(tweetId).collection("comments").addDocument(data: data) { error in
            if let error = error {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    
}

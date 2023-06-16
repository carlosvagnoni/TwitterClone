//
//  TweetService.swift
//  TwitterClone
//
//  Created by user239477 on 6/16/23.
//

import Firebase

class TweetService {
    
    func uploadTweet(caption: String, completion: @escaping(Bool) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid, "caption": caption, "likes": 0, "timestamp": Timestamp(date: Date())] as [String : Any]
        
        Firestore.firestore().collection("tweets").document()
            .setData(data) { error in
                
                if let error = error {
                    
                    completion(false)
                    return
                    
                }
                
                completion(true)
                
            }
        
    }
    
}


//
//  CommentService.swift
//  TwitterClone
//
//  Created by user239477 on 7/4/23.
//

import Firebase

class CommentService {
    
    func uploadComment(tweetId: String, comment: String, completion: @escaping((Bool, Int)) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let data = ["uid": uid, "comment": comment, "timestamp": Timestamp(date: Date())] as [String : Any]
        let tweetRef = Firestore.firestore().collection("tweets").document(tweetId)

        tweetRef.collection("comments").addDocument(data: data) { error in
            if let error = error {
                completion((false, 0))
                return
            }

            tweetRef.updateData(["commentCount": FieldValue.increment(Int64(1))]) { _ in
                tweetRef.getDocument { (document, _) in
                    if let document = document, document.exists {
                        let dataDescription = document.data()
                        let updatedCommentCount = dataDescription?["commentCount"] as? Int ?? 0
                        completion((true, updatedCommentCount))
                    } else {
                        completion((false, 0))
                    }
                }
            }
        }
    }

    
    func fetchComments(tweetId: String, completion: @escaping([Comment]) -> Void) {
        
        let tweetRef = Firestore.firestore().collection("tweets").document(tweetId)

        tweetRef.collection("comments")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in

            guard let documents = snapshot?.documents else { return }

            let comments = documents.compactMap({ try? $0.data(as: Comment.self) })

            completion(comments)

        }

    }
}

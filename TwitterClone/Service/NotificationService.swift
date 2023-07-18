//
//  NotificationService.swift
//  TwitterClone
//
//  Created by user239477 on 7/17/23.
//

import Firebase

class NotificationService {
    func uploadNotification(tweet: Tweet, notificationType: NotificationType, completion: @escaping(Bool) -> Void) {
        guard let senderId = Auth.auth().currentUser?.uid else { return }
        let receiverId = tweet.uid
        
        if senderId == receiverId {
            return
        }
        
        let data: [String: Any] = ["senderId": senderId,
                                   "receiverId": receiverId,
                                   "notificationType": notificationType.rawValue,
                                   "tweetId": tweet.id,
                                   "timestamp": Timestamp(date: Date())]
        
        Firestore.firestore().collection("notifications").document()
            .setData(data) { error in
                
                if let error = error {
                    print("Failed to upload notification with error \(error.localizedDescription)")
                    completion(false)
                    return
                    
                }
                
                completion(true)
            }
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("notifications")
            .whereField("receiverId", isEqualTo: currentUid)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                
                if documents.isEmpty {
                    completion([])
                    return
                }
                
                let notifications = documents.compactMap({ try? $0.data(as: Notification.self) })
                
                completion(notifications)
                
            }
    }
    
    
}

//
//  NotificationService.swift
//  TwitterClone
//
//  Created by user239477 on 7/17/23.
//

import Firebase

class NotificationService {
    var notificationsListener: ListenerRegistration?
    
    func uploadNotification(tweet: Tweet, notificationType: NotificationType, completion: @escaping(Bool) -> Void) {
        guard let senderId = Auth.auth().currentUser?.uid else { return }
        let receiverId = tweet.uid
        
        if senderId == receiverId {
            completion(false)
            return
        }
        
        let data: [String: Any] = ["senderId": senderId,
                                   "receiverId": receiverId,
                                   "notificationType": notificationType.rawValue,
                                   "tweetId": tweet.id,
                                   "read": false,
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
    
    func readNotification(notificationId: String) {
        let notificationRef = Firestore.firestore().collection("notifications").document(notificationId)
        
        notificationRef.getDocument { (document, error) in
            if let error = error {
                print("Failed to fetch notification with error \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Notification not found")
                return
            }
            
            if let read = document.data()?["read"] as? Bool, !read {
                notificationRef.updateData(["read": true]) { error in
                    if let error = error {
                        print("Failed to update notification with error \(error.localizedDescription)")
                    }
                }
            } else {
                print("Notification is already read or read field not found")
            }
        }
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        notificationsListener?.remove()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }        
        
        notificationsListener = Firestore.firestore().collection("notifications")
            .whereField("receiverId", isEqualTo: currentUid)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, _ in
                
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

//
//  MessageService.swift
//  TwitterClone
//
//  Created by user239477 on 7/20/23.
//

import Firebase

class MessageService {
    
    func sendMessage(receiverId: String, text: String, mediaUrl: String?, mediaType: MediaType?) {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        
        var message: [String: Any] = [
            "senderId": fromId,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]
        
        if let mediaURL = mediaUrl, let mediaType = mediaType {
            message["mediaURL"] = mediaURL
            message["mediaType"] = mediaType.rawValue
        }
        
        let messagesRef = Firestore.firestore().collection("messages").document(fromId).collection(receiverId)
        
        messagesRef.document()
            .setData(message) { error in
                
                if let error = error {
                    print("Failed to upload message with error \(error.localizedDescription)")
                    return
                    
                }

            }
        
        let recipientMessagesRef = Firestore.firestore().collection("messages").document(receiverId).collection(fromId)
          
        recipientMessagesRef.document()
            .setData(message) { error in
                
                if let error = error {
                    print("Failed to upload message with error \(error.localizedDescription)")
                    return
                    
                }

            }
        
        let persistRecentMessagesRef = Firestore.firestore().collection("recent_messages").document(fromId).collection("messages").document(receiverId)
        
        var data: [String: Any] = [
            "senderId": fromId,
            "text": text,
            "read": true,
            "timestamp": Timestamp(date: Date())
        ]
        
        if let mediaType = mediaType {
            data["text"] = mediaType.rawValue
        }
        
        persistRecentMessagesRef.setData(data) { error in
            
            if let error = error {
                print("Failed to upload persist recent message with error \(error.localizedDescription)")
                return
                
            }

        }
        
        let recipientPersistRecentMessagesRef = Firestore.firestore().collection("recent_messages").document(receiverId).collection("messages").document(fromId)
        
        data["read"] = false
        
        recipientPersistRecentMessagesRef.setData(data) { error in
            
            if let error = error {
                print("Failed to upload persist recent message with error \(error.localizedDescription)")
                return
                
            }

        }
    }
    
    func fetchMessages(receiverId: String, completion: @escaping ([Message]) -> Void) {
        guard let fromId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("messages").document(fromId).collection(receiverId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                
                if let error = error {
                    print("Failed to fetch messages with error \(error.localizedDescription)")
                    completion([])
                    return
                }

                var messages = [Message]()

                querySnapshot?.documentChanges.forEach { change in
                    if change.type == .added {
                        do {
                            var message = try Firestore.Decoder().decode(Message.self, from: change.document.data())
                            message.id = change.document.documentID
                            messages.append(message)
                        } catch {
                            print("Failed to decode message: \(error)")
                        }
                    }
                }

                completion(messages)
            }
    }
    
    func fetchRecentMessages(completion: @escaping ([RecentMessage]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("recent_messages").document(uid).collection("messages")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { querySnapshot, error in

                if let error = error {
                    print("Failed to fetch messages with error \(error.localizedDescription)")
                    completion([])
                    return
                }

                var recentMessages = [RecentMessage]()

                querySnapshot?.documents.forEach { document in
                    do {
                        var recentMessage = try Firestore.Decoder().decode(RecentMessage.self, from: document.data())
                        recentMessage.id = document.documentID
                        recentMessages.append(recentMessage)
                    } catch {
                        print("Failed to decode recent message: \(error)")
                    }
                }

                completion(recentMessages)
            }
    }
    
    func readConversation(receiverId: String) {
        guard let fromId = Auth.auth().currentUser?.uid else { return }

        let recentMessageRef = Firestore.firestore().collection("recent_messages").document(fromId).collection("messages").document(receiverId)

        recentMessageRef.getDocument { (document, error) in
            if let error = error {
                print("Failed to fetch recent message with error \(error.localizedDescription)")
                return
            }

            guard let document = document, document.exists else {
                print("Recent message not found")
                return
            }

            if let read = document.data()?["read"] as? Bool, !read {
                recentMessageRef.updateData(["read": true]) { error in
                    if let error = error {
                        print("Failed to update recent message with error \(error.localizedDescription)")
                    } else {
                        print("Recent message marked as read successfully!")
                    }
                }
            } else {
                print("Recent message is already read or read field not found")
            }
        }
    }

       
    func deleteConversation(receiverId: String, completion: @escaping (Bool) -> Void) {
        guard let fromId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        let group = DispatchGroup()

        // Delete the sender's messages
        let senderMessagesRef = Firestore.firestore().collection("messages").document(fromId).collection(receiverId)
        group.enter()
        senderMessagesRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Failed to fetch messages with error \(error.localizedDescription)")
                group.leave()
                return
            }

            snapshot?.documents.forEach({ (documentSnapshot) in
                group.enter()
                senderMessagesRef.document(documentSnapshot.documentID).delete { (error) in
                    if let error = error {
                        print("Failed to delete message with error \(error.localizedDescription)")
                    }
                    group.leave()
                }
            })
            group.leave()
        }

        // Delete the sender's recent messages
        let senderRecentMessagesRef = Firestore.firestore().collection("recent_messages").document(fromId).collection("messages").document(receiverId)
        group.enter()
        senderRecentMessagesRef.delete { (error) in
            if let error = error {
                print("Failed to delete recent message with error \(error.localizedDescription)")
            }
            group.leave()
        }

        group.notify(queue: .main) {
            completion(true)
        }
    }



}

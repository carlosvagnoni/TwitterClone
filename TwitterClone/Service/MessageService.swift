//
//  MessageService.swift
//  TwitterClone
//
//  Created by user239477 on 7/20/23.
//

import Firebase

class MessageService {
    func sendMessage(conversationId: String, text: String, mediaUrl: String?, mediaType: MediaType?, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var message: [String: Any] = [
            "senderId": uid,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]
        
        if let mediaURL = mediaUrl, let mediaType = mediaType {
            message["mediaURL"] = mediaURL
            message["mediaType"] = mediaType.rawValue
        }
        
        let conversationRef = Firestore.firestore().collection("conversations").document(conversationId)
        
        conversationRef.getDocument { (document, error) in
            if let document = document, document.exists, let conversation = try? document.data(as: Conversation.self) {
                if conversation.participantsIDs.contains(uid) {
                    conversationRef.updateData([
                        "messages": FieldValue.arrayUnion([message])
                    ]) { error in
                        if let error = error {
                            print("Failed to send message with error \(error.localizedDescription)")
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    print("User is not a participant in this conversation")
                    completion(false)
                }
            } else {
                print("Could not find conversation with id \(conversationId)")
                completion(false)
            }
        }
    }
    
    func fetchMessages(conversationId: String, completion: @escaping ([Message]) -> Void) {
        Firestore.firestore().collection("conversations").document(conversationId).collection("messages")
            .order(by: "timestamp", descending: true)
            .getDocuments { (snapshot, error) in
                
                if let error = error {
                    print("Failed to fetch messages with error \(error.localizedDescription)")
                    completion([])
                } else {
                    let messages = snapshot?.documents.compactMap({ try? $0.data(as: Message.self) }) ?? []
                    completion(messages)
                }
            }
    }


}

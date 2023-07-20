//
//  ConversationService.swift
//  TwitterClone
//
//  Created by user239477 on 7/20/23.
//

import Firebase

class ConversationService {
    func createConversation(receiverId: String, completion: @escaping(Bool) -> Void) {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            var data: [String: Any] = ["participantsIDs": [receiverId, uid],
                                       "messages": []]
                                                                                 
            Firestore.firestore().collection("conversations").document()
                .setData(data) { error in
                    
                    if let error = error {
                        print("Failed to create conversation with error \(error.localizedDescription)")
                        completion(false)
                        return
                        
                    }
                    
                    completion(true)
                }
            
        }
    
    func deleteConversation(conversationId: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("conversations").document(conversationId).delete() { error in
            if let error = error {
                print("Failed to delete conversation with error \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func fetchConversations(completion: @escaping ([Conversation]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("conversations")
            .whereField("participantsIDs", arrayContains: uid)
            .getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                
                let conversations = documents.compactMap({ try? $0.data(as: Conversation.self) })
                
                if conversations.isEmpty {
                    completion([])
                    return
                }
                
                let sortedConversations = conversations.sorted {
                    guard let timestamp1 = $0.messages.last?.timestamp.dateValue(),
                          let timestamp2 = $1.messages.last?.timestamp.dateValue() else {
                        return false
                    }
                    return timestamp1 > timestamp2
                }
                
                completion(sortedConversations)
            }
    }


}

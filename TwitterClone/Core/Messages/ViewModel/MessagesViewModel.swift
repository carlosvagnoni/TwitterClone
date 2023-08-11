//
//  MessagesViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/20/23.
//

import Foundation
import Firebase

class MessagesViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var recentMessages = [RecentMessage]()
    
    var currentConversationUserId: String?
    
    let messageService = MessageService()
    let userService = UserService()
    
    init() {
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        isLoading = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        recentMessages.removeAll()
        
        messageService.fetchRecentMessages { recentMessages in
            self.userService.fetchAndAssignUsersToRecentMessages(recentMessages: recentMessages) { updatedRecentMessages in
                DispatchQueue.main.async {
                    
                    for recentMessage in updatedRecentMessages {
                        if let user = recentMessage.receiverUser {
                            if user.id == self.currentConversationUserId {
                                
                                self.messageService.readConversation(receiverId: user.id!)
                            }
                        }
                    }
                    self.recentMessages = updatedRecentMessages
                    self.isLoading = false
                }
            }
        }
    }
    
    func readConversation(receiverID: String) {
        messageService.readConversation(receiverId: receiverID)
    }    
}

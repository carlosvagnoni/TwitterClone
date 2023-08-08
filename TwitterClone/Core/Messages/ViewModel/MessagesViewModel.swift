//
//  MessagesViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/20/23.
//

import Foundation

class MessagesViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var recentMessages = [RecentMessage]()
    
    let messageService = MessageService()
    let userService = UserService()
    
    init() {
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        isLoading = true
        
        messageService.fetchRecentMessages { recentMessages in
            self.userService.fetchAndAssignUsersToRecentMessages(recentMessages: recentMessages) { updatedRecentMessages in
                DispatchQueue.main.async {
                    
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

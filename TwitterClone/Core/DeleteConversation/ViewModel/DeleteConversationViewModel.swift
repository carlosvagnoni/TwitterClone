//
//  DeleteConversationViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 8/5/23.
//

import Foundation

class DeleteConversationViewModel: ObservableObject {
    @Published var receiverId: String
    @Published var didDeletedConversation = false
    
    let messageService = MessageService()
    
    init(receiverId: String) {
        self.receiverId = receiverId
    }
    
    func deleteConversation() {
        
        messageService.deleteConversation(receiverId: receiverId) { success in
            
            
            if success {
                self.didDeletedConversation = true
            } else {
                
                // Show error message...
                
            }
        }
    }
}

//
//  ConversationViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/21/23.
//

import Foundation
import UIKit

class ConversationViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var isLoading = false
    
    let messageService = MessageService()
    let receiverUser: User

    init(receiverUser: User) {
        self.receiverUser = receiverUser
        fetchMessages()
    }

    func fetchMessages() {
        self.isLoading = true
        guard let receiverId = receiverUser.id else { return }
        
        messageService.fetchMessages(receiverId: receiverId) { newMessages in
            DispatchQueue.main.async {
                self.messages += newMessages
                self.isLoading = false
                
            }
        }
    }
    
    func sendMessage(receiverId: String, text: String, image: UIImage? = nil, videoData: Data? = nil, completion: @escaping () -> Void) {
        
        if let image = image {
            MediaUploader.uploadImage(image: image, mediaPath: .messageMedia) { mediaUrl in
                self.messageService.sendMessage(receiverId: receiverId, text: text, mediaUrl: mediaUrl, mediaType: .image)
                completion()
                
            }
        } else if let videoData = videoData {
            MediaUploader.uploadVideo(videoData: videoData, mediaPath: .messageMedia) { mediaUrl in
                self.messageService.sendMessage(receiverId: receiverId, text: text, mediaUrl: mediaUrl, mediaType: .video)
                completion()
                
            }
        } else {
            messageService.sendMessage(receiverId: receiverId, text: text, mediaUrl: nil, mediaType: nil)
            completion()
        }
        
    }
    
    
}



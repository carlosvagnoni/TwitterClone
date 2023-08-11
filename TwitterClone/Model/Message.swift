//
//  Message.swift
//  TwitterClone
//
//  Created by user239477 on 7/20/23.
//

import FirebaseFirestoreSwift
import Firebase

struct Message: Decodable, Identifiable {
    
    var id: String?
    let text: String
    let senderId: String
    let timestamp: Timestamp
    var mediaURL: String?
    var mediaType: MediaType?
}

extension Message {
    static let MOCK_MESSAGE = Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec non mi viverra, pellentesque enim sit amet, viverra sapien. Phasellus nec ultricies odio. Donec sit amet lorem nulla.", senderId: "VBEo4qsxtTaYBgc4BK4wkh0mvAh1", timestamp: Timestamp(date: Date()))
}

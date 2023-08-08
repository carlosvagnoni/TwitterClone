//
//  ConversationRowViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/20/23.
//

import Foundation

class ConversationRowViewModel: ObservableObject {
    @Published var recentMessage: RecentMessage
    
    init(recentMessage: RecentMessage) {
        self.recentMessage = recentMessage
    }
}

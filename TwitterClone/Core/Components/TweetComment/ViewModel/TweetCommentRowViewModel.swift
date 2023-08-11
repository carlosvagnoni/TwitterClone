//
//  TweetCommentRowViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/4/23.
//

import Foundation

class TweetCommentRowViewModel: ObservableObject {
    private let userService = UserService()
    
    @Published var comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
        fetchUserforComment()
    }
    
    func fetchUserforComment() {
        userService.fetchUser(withUid: comment.uid) { user in
            
            DispatchQueue.main.async {
                self.comment.user = user                
            }
        }
    }
}

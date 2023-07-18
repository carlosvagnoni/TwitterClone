//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/4/23.
//

import Foundation

class TweetViewModel: ObservableObject {
    @Published var tweet: Tweet
    @Published var comments = [Comment]()
    @Published var isLoading = false
    @Published var didUploadComment = false
    
    let commentService = CommentService()
    let notificationService = NotificationService()
    
    init(tweet: Tweet) {
        self.tweet = tweet
        fetchComments()
    }
    
    func uploadComment(comment: String) {
        guard let tweetId = tweet.id else { return }
        
        commentService.uploadComment(tweetId: tweetId, comment: comment) { success, updatedCommentCount in
            if success {
                
                self.tweet.commentCount = updatedCommentCount
                self.didUploadComment = true
                self.notificationService.uploadNotification(tweet: self.tweet, notificationType: .comment) { success in
                    if success {
                        print("The notification was generated successfully")
                    } else {
                        print("Error generating the notification")
                    }
                }
                
            } else {
                
                // Show error message...
                
            }
        }
    }
    
    func fetchComments() {
        isLoading = true
        
        guard let tweetId = tweet.id else { return }
        
        commentService.fetchComments(tweetId: tweetId) { comments in
            DispatchQueue.main.async {
                self.comments = comments
                self.isLoading = false
            }
        }
    }
    
}

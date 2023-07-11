//
//  DeleteTweetConfirmationViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/9/23.
//

import Foundation

class DeleteTweetConfirmationViewModel: ObservableObject {
    @Published var tweet: Tweet
    @Published var didDeletedTweet = false
    
    let tweetService = TweetService()
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
    func deleteTweet() {
        guard let tweetId = tweet.id else { return }
        
        tweetService.deleteTweet(tweetId: tweetId) { success in
            if success {
                
                self.didDeletedTweet = true
                
            } else {
                
                // Show error message...
                
            }
        }
    }
}
